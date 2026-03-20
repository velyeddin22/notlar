import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:not/details/colors.dart';
import 'package:not/details/fakulteler.dart';
import 'package:not/details/universiteler.dart';
import 'package:not/services/internettenVeriler.dart';
import 'package:not/services/prefs.dart';
import 'package:not/widgets/appSnackBar.dart';
import 'package:not/widgets/sizedbox.dart';

import '../services/httpsUpload.dart';

class NotEkleSayfasi extends StatefulWidget {
  const NotEkleSayfasi({super.key});

  @override
  State<NotEkleSayfasi> createState() => _NotEkleSayfasiState();
}

class _NotEkleSayfasiState extends State<NotEkleSayfasi> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sayfaSayisiController = TextEditingController();

  // Seçim değişkenleri
  int? _selectedFakulteIndex;
  String? _selectedFakulteAd;
  String? _selectedBolum;
  String? _selectedUniversite;

  // Dosya değişkenleri
  FilePickerResult? _kapakResult;
  FilePickerResult? _notDosyasiResult;
  String? _kapakDosyaAdi;
  String? _notDosyaAdi;

  bool _isUploading = false;
  String _uploadDurum = "";

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _teacherController.dispose();
    _priceController.dispose();
    _sayfaSayisiController.dispose();
    super.dispose();
  }

  // Kapak görseli seç
  Future<void> _pickKapakGorseli() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        setState(() {
          _kapakResult = result;
          _kapakDosyaAdi = result.files.single.name;
        });
      }
    } catch (e) {
      appSnackBar(context: context, msg: "Dosya seçilemedi: $e", isError: true);
    }
  }

  // Not dosyası seç (PDF/Word)
  Future<void> _pickNotDosyasi() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );
      if (result != null) {
        setState(() {
          _notDosyasiResult = result;
          _notDosyaAdi = result.files.single.name;
        });
      }
    } catch (e) {
      appSnackBar(context: context, msg: "Dosya seçilemedi: $e", isError: true);
    }
  }

  // Notu yayınla
  Future<void> _notYayinla() async {
    // --- VALİDASYONLAR ---
    if (_selectedUniversite == null) {
      appSnackBar(
        context: context,
        msg: "Lütfen üniversite seçiniz.",
        isError: true,
      );
      return;
    }
    if (_selectedFakulteIndex == null || _selectedBolum == null) {
      appSnackBar(
        context: context,
        msg: "Lütfen fakülte ve bölüm seçiniz.",
        isError: true,
      );
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      appSnackBar(
        context: context,
        msg: "Lütfen not başlığı giriniz.",
        isError: true,
      );
      return;
    }
    if (_notDosyasiResult == null) {
      appSnackBar(
        context: context,
        msg: "Lütfen not dosyası yükleyiniz.",
        isError: true,
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _uploadDurum = "Giriş kontrol ediliyor...";
    });

    try {
      // 1. Kullanıcı kontrolü
      var userId = await Storage.getInt("userid");
      if (userId == 0) {
        appSnackBar(
          context: context,
          msg: "Lütfen giriş yapınız.",
          isError: true,
        );
        setState(() {
          _isUploading = false;
          _uploadDurum = "";
        });
        return;
      }

      // ✅ Kullanıcı adını al
      String yukleyenAd = await Storage.getString("username") ?? "Anonim";

      // 2. Kapak görseli yükle (opsiyonel)
      String? kapakUrl;
      if (_kapakResult != null) {
        setState(() => _uploadDurum = "Kapak görseli yükleniyor...");
        kapakUrl = await uploadImage(result: _kapakResult);
        if (kapakUrl == null) {
          print("⚠️ Kapak yüklenemedi, varsayılan kullanılacak.");
        }
      }

      // 3. Not dosyasını yükle (zorunlu)
      setState(() => _uploadDurum = "Not dosyası yükleniyor...");
      String? notUrl = await uploadDocument(result: _notDosyasiResult);

      if (notUrl == null) {
        appSnackBar(
          context: context,
          msg: "Dosya yüklenirken hata oluştu. Lütfen tekrar deneyin.",
          isError: true,
        );
        setState(() {
          _isUploading = false;
          _uploadDurum = "";
        });
        return;
      }

      // 4. Veritabanına kaydet
      setState(() => _uploadDurum = "Veritabanına kaydediliyor...");

      String uzanti = _notDosyaAdi?.split('.').last.toUpperCase() ?? "PDF";

      // Değerleri tek tek hazırla (satır sonu ve fazla boşluk sorunu için)
      String notAd = _titleController.text.trim();
      String aciklama = _descController.text.trim().isNotEmpty
          ? _descController.text.trim()
          : 'Açıklama yok';
      String hoca = _teacherController.text.trim().isNotEmpty
          ? _teacherController.text.trim()
          : 'Belirtilmemiş';
      String fiyat = _priceController.text.trim().isNotEmpty
          ? _priceController.text.trim()
          : '0';
      String sayfaSayisi = _sayfaSayisiController.text.trim().isNotEmpty
          ? _sayfaSayisiController.text.trim()
          : '0';
      String kategori = _selectedFakulteAd ?? 'Genel';

      // ✅ Tek satırda birleştir, newline ve fazla boşluk temizle
      String degerler =
          "$notAd,$aciklama,$_selectedUniversite,$_selectedBolum,$hoca,$fiyat,$sayfaSayisi,$notUrl,${kapakUrl ?? 'https://via.placeholder.com/400'},$userId,$yukleyenAd,$uzanti,$kategori,0,0,0";
      degerler = degerler
          .replaceAll('\n', ' ')
          .replaceAll('\r', ' ')
          .replaceAll(RegExp(r'\s{2,}'), ' ');

      bool sonuc = await postVeri(
        tabloAdi: "notlar",
        tabloIsimleri:
            "not_ad,aciklama,universite_ad,bolum_ad,dersin_hocasi,fiyat,sayfa_sayisi,link,ornek_foto,yukleyen_id,yukleyen_ad,dosya_uzantisi,not_kategori,onay_durumu,puan,goruntulenme_sayisi",
        degerler: degerler,
      );

      if (sonuc) {
        appSnackBar(
          context: context,
          msg: "Not başarıyla yüklendi!",
          isError: false,
        );
        if (mounted) Navigator.pop(context);
      } else {
        appSnackBar(
          context: context,
          msg: "Kayıt sırasında hata oluştu.",
          isError: true,
        );
      }
    } catch (e) {
      print("❌ Upload hatası: $e");
      appSnackBar(context: context, msg: "Bir hata oluştu: $e", isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadDurum = "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. APP BAR
              SliverAppBar(
                backgroundColor: const Color(0xFFF5F7FA),
                expandedHeight: 80.0,
                floating: true,
                pinned: true,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    onPressed: _isUploading
                        ? null
                        : () => Navigator.pop(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
                  title: const Text(
                    "Not Ekle",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),

              // 2. FORM
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Okul Bilgileri"),
                      sbh(10),

                      _buildSelectorField(
                        label: "Üniversite",
                        value: _selectedUniversite,
                        hint: "Üniversite seçiniz...",
                        icon: Icons.account_balance_outlined,
                        onTap: _showUniversiteSecimi,
                      ),
                      sbh(15),

                      _buildSelectorField(
                        label: "Fakülte",
                        value: _selectedFakulteAd,
                        hint: "Fakülte seçiniz...",
                        icon: Icons.school_outlined,
                        onTap: _showFakulteSecimListesi,
                      ),
                      sbh(15),

                      Opacity(
                        opacity: _selectedFakulteIndex == null ? 0.5 : 1.0,
                        child: _buildSelectorField(
                          label: "Bölüm",
                          value: _selectedBolum,
                          hint: _selectedFakulteIndex == null
                              ? "Önce fakülte seçiniz"
                              : "Bölüm seçiniz...",
                          icon: Icons.class_outlined,
                          onTap: () {
                            if (_selectedFakulteIndex != null) {
                              _showBolumSecimListesi();
                            } else {
                              appSnackBar(
                                context: context,
                                msg: "Lütfen önce bir fakülte seçin.",
                                isError: true,
                              );
                            }
                          },
                        ),
                      ),

                      sbh(25),
                      _buildSectionTitle("Not Bilgileri"),
                      sbh(10),

                      _buildModernTextField(
                        controller: _titleController,
                        label: "Not Başlığı",
                        hint: "Örn: Matematik 101 Vize Notları",
                        icon: Icons.title_rounded,
                      ),
                      sbh(15),

                      _buildModernTextField(
                        controller: _descController,
                        label: "Açıklama",
                        hint: "Not içeriği hakkında kısa bilgi...",
                        icon: Icons.description_outlined,
                        maxLines: 3,
                      ),
                      sbh(15),

                      Row(
                        children: [
                          Expanded(
                            child: _buildModernTextField(
                              controller: _teacherController,
                              label: "Dersin Hocası",
                              hint: "Ad Soyad",
                              icon: Icons.person_outline_rounded,
                            ),
                          ),
                          sbw(15),
                          Expanded(
                            child: _buildModernTextField(
                              controller: _priceController,
                              label: "Fiyat",
                              hint: "0.00",
                              icon: Icons.attach_money_rounded,
                              isPrice: true,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      sbh(15),

                      _buildModernTextField(
                        controller: _sayfaSayisiController,
                        label: "Sayfa Sayısı",
                        hint: "0",
                        icon: Icons.pages_outlined,
                        keyboardType: TextInputType.number,
                      ),

                      sbh(25),
                      _buildSectionTitle("Dosya Yükle"),
                      sbh(10),

                      Row(
                        children: [
                          Expanded(
                            child: _buildUploadCard(
                              title: _kapakDosyaAdi ?? "Kapak Görseli",
                              subtitle: _kapakDosyaAdi != null
                                  ? "Seçildi ✓"
                                  : "Yalnızca Fotoğraf",
                              icon: _kapakDosyaAdi != null
                                  ? Icons.check_circle_rounded
                                  : Icons.add_photo_alternate_rounded,
                              color: _kapakDosyaAdi != null
                                  ? Colors.green
                                  : Colors.purpleAccent,
                              onTap: _pickKapakGorseli,
                            ),
                          ),
                          sbw(15),
                          Expanded(
                            child: _buildUploadCard(
                              title: _notDosyaAdi ?? "Not Dosyası",
                              subtitle: _notDosyaAdi != null
                                  ? "Seçildi ✓"
                                  : "PDF veya Word",
                              icon: _notDosyaAdi != null
                                  ? Icons.check_circle_rounded
                                  : Icons.upload_file_rounded,
                              color: _notDosyaAdi != null
                                  ? Colors.green
                                  : Colors.blueAccent,
                              onTap: _pickNotDosyasi,
                            ),
                          ),
                        ],
                      ),

                      sbh(40),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _notYayinla,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isUploading
                                ? Colors.grey.shade400
                                : Colors.black87,
                            foregroundColor: Colors.white,
                            elevation: _isUploading ? 0 : 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isUploading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      _uploadDurum.isNotEmpty
                                          ? _uploadDurum
                                          : "Yükleniyor...",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                )
                              : const Text(
                                  "Notu Yayınla",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      sbh(30),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_isUploading)
            Positioned.fill(
              child: AbsorbPointer(child: Container(color: Colors.transparent)),
            ),
        ],
      ),
    );
  }

  // --- ÜNİVERSİTE SEÇİM BOTTOM SHEET ---
  void _showUniversiteSecimi() {
    final TextEditingController uniSearchController = TextEditingController();
    List<String> filteredList = Universiteler.tumUniversiteler();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.75,
              maxChildSize: 0.9,
              minChildSize: 0.5,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Üniversite Seçin",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F4FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: uniSearchController,
                          onChanged: (val) {
                            setModalState(() {
                              filteredList = Universiteler.ara(val);
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "Üniversite ara...",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF6C63FF),
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    sbh(8),
                    const Divider(height: 1),
                    Expanded(
                      child: filteredList.isEmpty
                          ? const Center(
                              child: Text(
                                "Sonuç bulunamadı",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                bool isSelected =
                                    filteredList[index] == _selectedUniversite;
                                return ListTile(
                                  title: Text(
                                    filteredList[index],
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? const Color(0xFF6C63FF)
                                          : Colors.black87,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF6C63FF),
                                        )
                                      : const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: Colors.grey,
                                        ),
                                  onTap: () {
                                    setState(() {
                                      _selectedUniversite = filteredList[index];
                                    });
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  void _showFakulteSecimListesi() {
    List<dynamic> list = fakulteler.fakulteleriGetir();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Fakülte Seçin",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(list[index]),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedFakulteIndex = index;
                        _selectedFakulteAd = list[index];
                        _selectedBolum = null;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showBolumSecimListesi() {
    if (_selectedFakulteIndex == null) return;
    var hamVeri = fakulteler.bolumSayisi()[_selectedFakulteIndex!];
    List<String> list = [];
    if (hamVeri is List) {
      list = hamVeri.map((e) => e.toString()).toList();
    } else {
      list = hamVeri
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "")
          .split(",")
          .map((e) => e.trim())
          .toList();
    }
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Bölüm Seçin",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(list[index]),
                    onTap: () {
                      setState(() {
                        _selectedBolum = list[index];
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // --- WIDGET'LAR ---

  Widget _buildSelectorField({
    required String label,
    required String? value,
    required String hint,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: value != null ? Colors.black87 : Colors.grey.shade400,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: value != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: value != null
                          ? Colors.black87
                          : Colors.grey.shade500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    bool isPrice = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          labelStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: isPrice
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "₺",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                )
              : Icon(icon, color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            sbh(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            sbh(4),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
