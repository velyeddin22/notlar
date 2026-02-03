import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_windowmanager_plus/flutter_windowmanager_plus.dart';
import '../services/prefs.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUser();
    FlutterWindowManagerPlus.addFlags(FlutterWindowManagerPlus.FLAG_SECURE);
  }

  @override
  void dispose() {
    FlutterWindowManagerPlus.clearFlags(FlutterWindowManagerPlus.FLAG_SECURE);
    super.dispose();
  }

  void _loadUser() async {
    var id = await Storage.getInt("userid");
    setState(() => currentUserId = id);
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
    final String department = data["bolum_ad"] ?? "Bölüm Belirtilmemiş";
    final String pageCount = data["sayfa_sayisi"]?.toString() ?? "0";
    final String views = data["goruntulenme_sayisi"]?.toString() ?? "0";
    final String noteLink = data["link"] ?? "";
    final String noteId = data["id"]?.toString() ?? widget.index.toString();
    final String yukleyenId = data["yukleyen_id"]?.toString() ?? "";
    final double rating = double.tryParse(data["puan"].toString()) ?? 0.0;

    bool isMyNote = currentUserId.toString() == yukleyenId;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // A. PARALLAX RESİM BAŞLIĞI
              SliverAppBar(
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

              // B. İÇERİK GÖVDESİ
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildChip(data["not_kategori"] ?? "Genel", Colors.blue),
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
                            rating: rating,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 22.0,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "($rating)",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      _buildSchoolCard(university, department),
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
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // C. SABİT ALT BAR
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomAction(isMyNote, price, noteLink, noteId),
          ),
        ],
      ),
    );
  }

  // YARDIMCI METOTLAR (Kısaltılmadan Eklendi)
  Widget _buildBottomAction(
    bool isMyNote,
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
          if (!isMyNote) ...[
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
                if (isMyNote) {
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
                backgroundColor: isMyNote
                    ? Colors.green
                    : const Color(0xFF1A1D1E),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                isMyNote ? "Notu Görüntüle" : "Şimdi Satın Al",
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

  Widget _buildSchoolCard(String uni, String bolum) {
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

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
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
