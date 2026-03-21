import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import '../services/favorite_service.dart';
import '../services/internettenVeriler.dart';
import '../services/prefs.dart';
  bool hasPurchased = false;
int totalSalesCount = 0; 
/// ===============================
/// GÜVENLİ PDF GÖRÜNTÜLEYİCİ (Uygulama İçinde)
/// ===============================
class SecurePdfViewer extends StatefulWidget {
  final String url;
  final String noteId;

  const SecurePdfViewer({super.key, required this.url, required this.noteId});

  @override
  State<SecurePdfViewer> createState() => _SecurePdfViewerState();
}

class _SecurePdfViewerState extends State<SecurePdfViewer> {
  String? localPath;
  bool isLoading = true;
  String progress = "Hazırlanıyor...";
  bool isFav = false; 

  @override
  void initState() {
    super.initState();
    // 🔒 Screenshot + Kayıt Engelle

    FlutterWindowManagerPlus.addFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    _downloadAndCache();
  }

  Future<void> _downloadAndCache() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      // Dosya telefonun genelinde değil, uygulamanın gizli klasöründe saklanır
      final filePath = "${directory.path}/safe_note_${widget.noteId}.pdf";
      final file = File(filePath);

      if (await file.exists()) {
        setState(() {
          localPath = filePath;
          isLoading = false;
        });
      } else {
        Dio dio = Dio();
        await dio.download(
          widget.url,
          filePath,
          onReceiveProgress: (count, total) {
            setState(() {
              progress =
                  "İndiriliyor: %${((count / total) * 100).toStringAsFixed(0)}";
            });
          },
        );
        setState(() {
          localPath = filePath;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        progress = "Hata: Dosya indirilemedi.";
      });
    }
  }

  @override
  void dispose() {
    FlutterWindowManagerPlus.clearFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Notu Oku"),
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.white),
                  const SizedBox(height: 20),
                  Text(progress, style: const TextStyle(color: Colors.white)),
                ],
              ),
            )
          : PDFView(
              filePath: localPath,
              enableSwipe: true,
              autoSpacing: true,
              pageFling: true,
            ),
    );
  }
}

/// ===============================
/// ANA DETAY SAYFASI (Full Tasarım)
/// ===============================
class ProductDetailsPage extends StatefulWidget {
  final List<Map<String, dynamic>>? liste;
  final int index;

  const ProductDetailsPage({
    super.key,
    required this.liste,
    required this.index,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int? currentUserId;
  String currentUserName =
      "Kullanıcı"; // Storage'dan isim gelirse buraya alacağız
  bool isFav = false;
  bool hasPurchased = false;

  // Yorumlar için değişkenler
  List<Map<String, dynamic>> yorumlarListesi = [];
  Map<String, dynamic>?
  currentUserComment; // Kullanıcının mevcut yorumu (varsa)
  bool isLoadingComments = true;
  double averageRating = 0.0;
  int totalReviews = 0;

 @override
  void initState() {
    super.initState();
    _loadUser();
    _checkIfFavorite();
    _incrementViewCount();
  
    FlutterWindowManagerPlus.addFlags(FlutterWindowManagerPlus.FLAG_SECURE);
  }

  @override
  void dispose() {
    FlutterWindowManagerPlus.clearFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    super.dispose();
  }
void _loadUser() async {
    var id = await Storage.getInt("userid");
    var kuallniciBilgisi = await getCustomData(tabloAdi: 'hesaplar', whereColumnName: 'id', whereColumnValue: '$id');
    
    setState(() {
      currentUserId = id;
      currentUserName = kuallniciBilgisi!.first['ad'];
    });
    
    _checkIfPurchased();
    _fetchComments(); 
  }

  // --- YORUMLARI GETİR ---
  Future<void> _fetchComments() async {
    final data = widget.liste![widget.index];
    String noteId = data["id"]?.toString() ?? "";

    if (noteId.isEmpty) {
      if (mounted) setState(() => isLoadingComments = false);
      return;
    }

    try {
      List? allComments = await getCustomAllData(tabloAdi: "yorumlar");
      if (allComments != null) {
        var noteComments = allComments
            .where((yorum) => yorum["not_id"].toString() == noteId)
            .toList();

        double totalScore = 0;
        Map<String, dynamic>? myComment;

        for (var yorum in noteComments) {
          totalScore +=
              double.tryParse(yorum["puan"]?.toString() ?? "0") ?? 0.0;
          // Kendi yorumumuzu bulalım
          if (yorum["yorumu_yapan_id"].toString() == currentUserId.toString()) {
            myComment = Map<String, dynamic>.from(yorum);
          }
        }

        double avg = noteComments.isEmpty
            ? 0.0
            : totalScore / noteComments.length;

        if (mounted) {
          setState(() {
            yorumlarListesi = noteComments.cast<Map<String, dynamic>>();
            averageRating = avg;
            totalReviews = noteComments.length;
            currentUserComment = myComment;
            isLoadingComments = false;
          });
        }
      } else {
        if (mounted) setState(() => isLoadingComments = false);
      }
    } catch (e) {
      debugPrint("Yorumlar çekilirken hata: $e");
      if (mounted) setState(() => isLoadingComments = false);
    }
  }

  // --- YORUM EKLE / GÜNCELLE MODALI ---
  void _showCommentDialog() {
    double selectedRating = currentUserComment != null
        ? (double.tryParse(currentUserComment!["puan"].toString()) ?? 5.0)
        : 5.0;

    TextEditingController commentCtrl = TextEditingController(
      text: currentUserComment != null
          ? currentUserComment!["yorum_metni"]
          : "",
    );

    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUserComment != null
                        ? "Yorumunu Düzenle"
                        : "Değerlendirmeni Yap",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: RatingBar.builder(
                      initialRating: selectedRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star_rounded, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        selectedRating = rating;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: commentCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Bu not hakkında ne düşünüyorsun?",
                      filled: true,
                      fillColor: const Color(0xFFF1F4FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSaving
                          ? null
                          : () async {
                              if (commentCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Lütfen bir yorum yazın."),
                                  ),
                                );
                                return;
                              }

                              setModalState(() => isSaving = true);

                              final noteId = widget.liste![widget.index]["id"]
                                  .toString();
                              String dateNow = DateTime.now()
                                  .toIso8601String()
                                  .substring(0, 10);

                              bool success = false;

                              if (currentUserComment == null) {
                                // YENİ YORUM EKLE (POST)
                                success = await postVeri(
                                  tabloAdi: "yorumlar",
                                  tabloIsimleri:
                                      "yorumu_yapan, yorumu_yapan_id, not_id, kullanici_id, puan, yorum_metni, yorum_tarihi",
                                  degerler:
                                      "$currentUserName, $currentUserId, $noteId, ${widget.liste![widget.index]["yukleyen_id"]}, $selectedRating, ${commentCtrl.text.trim()}, $dateNow",
                                );
                              } else {
                                // MEVCUT YORUMU GÜNCELLE (UPDATE)
                                success = await updateVeri(
                                  tabloAdi: "yorumlar",
                                  tabloIsimleri: "puan, yorum_metni",
                                  degerler:
                                      "$selectedRating, ${commentCtrl.text.trim()}",
                                  whereColumnName: "yorum_id",
                                  whereColumnValue:
                                      currentUserComment!["yorum_id"]
                                          .toString(),
                                );
                              }

                              setModalState(() => isSaving = false);

                              if (success) {
                                Navigator.pop(context); // Modalı kapat
                                _fetchComments(); // Listeyi yenile
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      currentUserComment == null
                                          ? "Yorum eklendi!"
                                          : "Yorum güncellendi!",
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Bir hata oluştu. Tekrar deneyin.",
                                    ),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6C63FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              currentUserComment != null
                                  ? "Güncelle"
                                  : "Gönder",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _incrementViewCount() async {
    final data = widget.liste![widget.index];
    String noteId = data["id"]?.toString() ?? "";

    if (noteId.isEmpty) return;

    int currentViews =
        int.tryParse(data["goruntulenme_sayisi"]?.toString() ?? "0") ?? 0;
    int newViews = currentViews + 1;

    if (mounted) {
      setState(() {
        data["goruntulenme_sayisi"] = newViews.toString();
      });
    }

    try {
      await updateVeri(
        tabloAdi: "notlar",
        tabloIsimleri: "goruntulenme_sayisi",
        degerler: newViews.toString(),
        whereColumnName: "id",
        whereColumnValue: noteId,
      );
    } catch (e) {
      debugPrint("Görüntülenme güncellenirken hata oluştu: $e");
    }
  }

  void _checkIfFavorite() async {
    final data = widget.liste![widget.index];
    bool favorite = await FavoriteService.isFavorite(data['id'].toString());
    setState(() => isFav = favorite);
  }

  Future<void> _checkIfPurchased() async {
    final data = widget.liste![widget.index];
    String noteId = data["id"]?.toString() ?? "";

    try {
      List? allSales = await getCustomAllData(tabloAdi: "satislar");
      if (allSales != null) {
        // 1. Toplam satış sayısını hesapla
        int salesCount = allSales
            .where((satis) => satis['not_id'].toString() == noteId)
            .toList()
            .length;

        // 2. Senin satın alıp almadığını kontrol et (Kullanıcı giriş yaptıysa)
        bool bought = false;
        if (currentUserId != null) {
          bought = allSales.any(
            (satis) =>
                satis['alici_id'].toString() == currentUserId.toString() &&
                satis['not_id'].toString() == noteId,
          );
        }

        if (mounted) {
          setState(() {
            totalSalesCount = salesCount; // Sayacı güncelle
            hasPurchased = bought;
          });
        }
      }
    } catch (e) {
      debugPrint("Satın alma durumu kontrol edilirken hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.liste == null || widget.liste!.isEmpty) {
      return const Scaffold(body: Center(child: Text("Veri bulunamadı.")));
    }

    final data = widget.liste![widget.index];
    final String imageUrl =
        data["ornek_foto"] ?? "https://via.placeholder.com/400";
    final String title = data["not_ad"] ?? "Başlıksız Not";
    final String price = data["fiyat"]?.toString() ?? "0";
    final String description = data["aciklama"] ?? "Açıklama bulunmuyor.";
    final String uploader = data["yukleyen_ad"] ?? "Anonim";
    final String university =
        data["universite_ad"] ?? "Üniversite Belirtilmemiş";
    final String fakulte_adi = data["fakulte_adi"] ?? "Fakülte Belirtilmemiş";
    final String department = data["bolum_ad"] ?? "Bölüm Belirtilmemiş";
    final String pageCount = data["sayfa_sayisi"]?.toString() ?? "0";
    final String views = data["goruntulenme_sayisi"]?.toString() ?? "0";
    final String noteLink = data["link"] ?? "";
    final String noteId = data["id"]?.toString() ?? widget.index.toString();
    final String yukleyenId = data["yukleyen_id"]?.toString() ?? "";

    bool isMyNote = currentUserId.toString() == yukleyenId;
    bool canViewNote = isMyNote || hasPurchased;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.black,
                      ),
                      onPressed: () async {
                        await FavoriteService.toggleFavorite(data);
                        setState(() => isFav = !isFav);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFav
                                  ? "Favorilere eklendi"
                                  : "Favorilerden çıkarıldı",
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
                expandedHeight: 380,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: "${widget.index}",
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                ),
                leading: _buildCircleBackButton(context),
              ),

              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: averageRating,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 22.0,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isLoadingComments
                                ? "(Hesaplanıyor...)"
                                : "(${averageRating.toStringAsFixed(1)}) • $totalReviews Yorum",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      _buildSchoolCard(university, department, fakulte_adi),
                      const SizedBox(height: 30),
                    Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    _buildStatItem(
      Icons.auto_stories_outlined,
      "Sayfa",
      pageCount,
    ),
    _buildStatItem(
      Icons.visibility_outlined,
      "Görünüm",
      views,
    ),
    // YENİ EKLEDİĞİMİZ SATIŞ/İNDİRME SAYACI BURASI
    _buildStatItem(
      Icons.shopping_bag_outlined, // İstersen Icons.download_outlined da yapabilirsin
      "Satış",
      totalSalesCount.toString(),
    ),
    _buildStatItem(
      Icons.person_pin_outlined,
      "Yazar",
      uploader,
    ),
  ],
),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 20),

                      const Text(
                        "Not Hakkında",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 20),

                      // BAŞLIK VE YORUM YAPMA BUTONU
                    Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      "Değerlendirmeler",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    // Buradaki kontrolü sadeleştiriyoruz:
    if (!isMyNote && currentUserId != null)
      TextButton.icon(
        onPressed: () => _showCommentDialog(),
        icon: Icon(
          currentUserComment != null ? Icons.edit : Icons.add_comment,
          size: 18,
          color: const Color(0xFF6C63FF),
        ),
        label: Text(
          currentUserComment != null ? "Düzenle" : "Yorum Yap",
          style: const TextStyle(
            color: Color(0xFF6C63FF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
  ],
),
                      const SizedBox(height: 12),
                     _buildCommentsSection(isMyNote),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomAction(canViewNote, price, noteLink, noteId),
          ),
        ],
      ),
    );
  }

 Widget _buildCommentsSection(bool isMyNote) {
  if (isLoadingComments) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  if (yorumlarListesi.isEmpty) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(Icons.reviews_outlined, color: Colors.grey.shade400, size: 40),
          const SizedBox(height: 15),
          const Text(
            "Henüz Değerlendirme Yok",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),

          // AKILLI KONTROL: Kendi notu mu, başkasının mı?
          if (!isMyNote) ...[
            // Başkasının notuysa tahrik edici metin ve buton gelsin
            Text(
              "Bu notu ilk sen puanla ve arkadaşlarına yol göster!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showCommentDialog(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6C63FF),
                side: const BorderSide(color: Color(0xFF6C63FF)),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Hemen Yorum Yaz"),
            ),
          ] else ...[
            // Kendi notuysa sadece bilgilendirme yapsın
            Text(
              "Notun için henüz bir değerlendirme yapılmamış.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ]
        ],
      ),
    );
  }

  // Yorumlar varsa Liste buraya gelir...
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: yorumlarListesi.length,
    itemBuilder: (context, index) {
      print(yorumlarListesi[index]["yorumu_yapan"]);
      return _buildSingleComment(
        yorumlarListesi[index], 

        yorumlarListesi[index]["yorumu_yapan_id"].toString() == currentUserId.toString()
      );
    },
  );
}

  Widget _buildSingleComment(Map<String, dynamic> yorum, bool isMyComment) {
    String userName = yorum["yorumu_yapan"] ?? "Kullanıcı";
    double score = double.tryParse(yorum["puan"]?.toString() ?? "0") ?? 0.0;
    String text = yorum["yorum_metni"] ?? "";
    String date = yorum["yorum_tarihi"] ?? "";

    if (date.length > 10) date = date.substring(0, 10);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMyComment
            ? const Color(0xFF6C63FF).withOpacity(0.05)
            : const Color(0xFFF1F4FF),
        borderRadius: BorderRadius.circular(16),
        border: isMyComment
            ? Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  isMyComment ? "Sen ($userName)" : userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isMyComment
                        ? const Color(0xFF6C63FF)
                        : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              RatingBarIndicator(
                rating: score,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                itemCount: 5,
                itemSize: 14.0,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildBottomAction(
    bool canViewNote,
    String price,
    String link,
    String id,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 15, 24, 30),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        children: [
          if (!canViewNote) ...[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Fiyat",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  "₺$price",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (canViewNote) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SecurePdfViewer(url: link, noteId: id),
                    ),
                  );
                } else {
                  // Satın al süreci...
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: canViewNote
                    ? Colors.green
                    : const Color(0xFF1A1D1E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                canViewNote ? "Notu Görüntüle" : "Şimdi Satın Al",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolCard(String uni, String bolum, String fakulte) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFF6C63FF),
            child: Icon(
              Icons.account_balance_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  uni,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  fakulte,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  bolum,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF6C63FF), size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }

  Widget _buildCircleBackButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 18,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
