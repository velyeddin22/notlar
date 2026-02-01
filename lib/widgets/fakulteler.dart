import 'package:flutter/material.dart';
import 'package:not/details/fakulteler.dart';
import 'package:not/widgets/bolumler.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    // Verileri değişkenlere alıyoruz
    final List<dynamic> liste = fakulteler.fakulteleriGetir();
    final List<dynamic> ikonlar = fakulteler.fakultelerIcon();
    // Burası List<List> veya List<dynamic> dönüyor
    final List<dynamic> bolumData = fakulteler.bolumSayisi();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Modern zemin
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. MODERN APP BAR
          SliverAppBar(
            backgroundColor: const Color(0xFFF5F7FA),
            expandedHeight: 100.0,
            floating: true,
            pinned: true,
            elevation: 0,
            centerTitle: false,
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
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                "Fakülteler",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
            ),
          ),

          // 2. IZGARA LİSTESİ (GRID)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Yan yana 2 kutu
                mainAxisSpacing: 15, // Dikey boşluk
                crossAxisSpacing: 15, // Yatay boşluk
                childAspectRatio: 0.85, // Kart oranı
              ),
              delegate: SliverChildBuilderDelegate((
                BuildContext context,
                int index,
              ) {
                // Her kart için dinamik renk
                final Color itemColor = _generateColor(index);

                // HATA DÜZELTME:
                // Gelen veri zaten liste olduğu için direkt uzunluğunu alıyoruz.
                // Eğer veri null ise 0 kabul ediyoruz.
                int sayi = 0;
                if (bolumData[index] is List) {
                  sayi = (bolumData[index] as List).length;
                }

                return _buildFacultyCard(
                  context: context,
                  index: index,
                  title: liste[index],
                  iconWidget: ikonlar[index],
                  bolumSayisi: sayi, // Düzeltilmiş sayı gönderiliyor
                  color: itemColor,
                );
              }, childCount: liste.length),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // --- KART TASARIMI WIDGET'I ---
  Widget _buildFacultyCard({
    required BuildContext context,
    required int index,
    required String title,
    required Widget iconWidget,
    required int bolumSayisi, // String değil int alıyor
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => bolumlerList(id: index)),
        );
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Üst: İkon ve Ok
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      // İkon rengini temaya göre ayarlıyoruz
                      child: Theme(
                        data: ThemeData(iconTheme: IconThemeData(color: color)),
                        child: iconWidget,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_outward_rounded,
                    color: Colors.grey.shade300,
                    size: 20,
                  ),
                ],
              ),

              // Alt: Başlık ve Bilgi
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "$bolumSayisi Bölüm",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Renk Üreteci
  Color _generateColor(int index) {
    List<Color> colors = [
      const Color(0xFF5C6BC0), // İndigo
      const Color(0xFFEF5350), // Kırmızı
      const Color(0xFF66BB6A), // Yeşil
      const Color(0xFFFFA726), // Turuncu
      const Color(0xFF29B6F6), // Açık Mavi
      const Color(0xFFAB47BC), // Mor
      const Color(0xFFEC407A), // Pembe
      const Color(0xFF26A69A), // Teal
    ];
    return colors[index % colors.length];
  }
}
