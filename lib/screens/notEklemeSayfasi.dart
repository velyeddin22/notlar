import 'package:flutter/material.dart';
import 'package:not/details/colors.dart';
import 'package:not/details/fakulteler.dart'; // Fakülte verileri için
import 'package:not/widgets/sizedbox.dart';

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

  // --- SEÇİM İÇİN GEREKLİ DEĞİŞKENLER ---
  int? _selectedFakulteIndex; // Hangi fakülte seçildi (ID'si)
  String? _selectedFakulteAd; // Ekranda göstermek için
  String? _selectedBolum; // Seçilen bölüm

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _teacherController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
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
                onPressed: () => Navigator.pop(context),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Kategori Seçimi"),
                  sbh(10),

                  // --- FAKÜLTE SEÇİCİ ---
                  _buildSelectorField(
                    label: "Fakülte",
                    value: _selectedFakulteAd,
                    hint: "Fakülte seçiniz...",
                    icon: Icons.school_outlined,
                    onTap: () {
                      _showFakulteSecimListesi();
                    },
                  ),

                  sbh(15),

                  // --- BÖLÜM SEÇİCİ ---
                  // Sadece fakülte seçiliyse aktif olur
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Lütfen önce bir fakülte seçin."),
                            ),
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

                  sbh(25),
                  _buildSectionTitle("Dosya Yükle"),
                  sbh(10),

                  Row(
                    children: [
                      Expanded(
                        child: _buildUploadCard(
                          title: "Kapak Görseli",
                          subtitle: "Yalnızca Fotoğraf",
                          icon: Icons.add_photo_alternate_rounded,
                          color: Colors.purpleAccent,
                          onTap: () {},
                        ),
                      ),
                      sbw(15),
                      Expanded(
                        child: _buildUploadCard(
                          title: "Not Dosyası",
                          subtitle: "PDF veya Word",
                          icon: Icons.upload_file_rounded,
                          color: Colors.blueAccent,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),

                  sbh(40),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // Seçim Kontrolü
                        if (_selectedFakulteIndex == null ||
                            _selectedBolum == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Lütfen fakülte ve bölüm seçiniz."),
                            ),
                          );
                          return;
                        }
                        // Kaydetme işlemi burada yapılır
                        print(
                          "Kaydediliyor: $_selectedFakulteAd - $_selectedBolum",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
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
    );
  }

  // --- LOGIC: BOTTOM SHEETLER ---

  // 1. Fakülte Listesini Aç
  void _showFakulteSecimListesi() {
    // fakulteler.dart dosyasından listeyi alıyoruz
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
                        _selectedBolum =
                            null; // Fakülte değişirse bölümü sıfırla
                      });
                      Navigator.pop(context); // Listeyi kapat
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

  // 2. Bölüm Listesini Aç
  void _showBolumSecimListesi() {
    if (_selectedFakulteIndex == null) return;

    // Seçilen fakültenin bölümlerini çekiyoruz (Güvenli yöntemle)
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

  // Yeni Seçici Widget (Dropdown görünümlü buton)
  Widget _buildSelectorField({
    required String label,
    required String? value, // Seçili değer
    required String hint, // İpucu metni
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
                    value ?? hint, // Değer varsa onu yaz, yoksa ipucunu
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: value != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: value != null
                          ? Colors.black87
                          : Colors.grey.shade500,
                    ),
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
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
