import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailsPage extends StatelessWidget {
  final List<Map<String, dynamic>>? liste;
  final int index;

  const ProductDetailsPage({
    super.key,
    required this.liste,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Veri güvenliği (Null Safety)
    final data = liste![index];
    final String imageUrl =
        data["ornek_foto"] ?? "https://via.placeholder.com/400";
    final String title = data["not_ad"] ?? "Başlıksız Not";
    final String price = data["fiyat"]?.toString() ?? "0";
    final String description = data["aciklama"] ?? "Açıklama bulunmuyor.";
    final String uploader = data["yukleyen_ad"] ?? "Anonim";
    final String teacher = data["dersin_hocasi"] ?? "Belirtilmemiş";
    final String date = data["tarih"] ?? "-";
    final double rating = double.tryParse(data["puan"].toString()) ?? 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. KAYDIRILABİLİR İÇERİK (SLIVERS)
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // A. Parallax Resim Başlığı
              SliverAppBar(
                expandedHeight: 350, // Resim yüksekliği
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true, // Yukarıda sabit kalsın mı?
                stretch: true, // Aşağı çekince uzasın mı?
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: "$index",
                        child: Image.network(imageUrl, fit: BoxFit.cover),
                      ),
                      // Resmin altına hafif gölge (yazılar okunsun diye değil, estetik geçiş için)
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black12],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
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
                ),
              ),

              // B. İçerik Gövdesi
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  // SliverAppBar'ın altına hafif girmesi için transform (Opsiyonel)
                  // transform: Matrix4.translationValues(0, -20, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kategori Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data["not_kategori"] ?? "Genel",
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Başlık ve Puan
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        RatingBarIndicator(
                          rating: rating,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),

                        const SizedBox(height: 30),

                        // Bilgi Grid (Hoca, Yükleyen, Tarih)
                        Row(
                          children: [
                            _buildInfoItem(
                              Icons.person_outline,
                              "Yükleyen",
                              uploader,
                            ),
                            _buildVerticalDivider(),
                            _buildInfoItem(
                              Icons.school_outlined,
                              "Hoca",
                              teacher,
                            ),
                            _buildVerticalDivider(),
                            _buildInfoItem(
                              Icons.calendar_today_outlined,
                              "Tarih",
                              date,
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                        const Divider(height: 1),
                        const SizedBox(height: 20),

                        // Açıklama Başlığı
                        const Text(
                          "Not Hakkında",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Açıklama Metni
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        // Alt barın altında kalan boşluk (Scrolling için)
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. SABİT ALT BAR (BOTTOM ACTION BAR)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  // Fiyat Kısmı
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Toplam Fiyat",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "₺$price",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),

                  // Satın Al Butonu
                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // Satın alma veya gösterme işlemi
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black87, // Ana renk yapılabilir
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Notu Göster", // veya "Satın Al"
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Yardımcı Widget: Bilgi Kutucuğu
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.grey.shade700, size: 22),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 2),
          Text(
            value.length > 10
                ? "${value.substring(0, 8)}..."
                : value, // Uzun ismi kısalt
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Yardımcı Widget: Dikey Çizgi
  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey.shade200);
  }
}
