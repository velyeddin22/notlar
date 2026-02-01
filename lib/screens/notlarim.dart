import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:not/details/colors.dart'; // Renk dosyanızın yolu
import 'package:not/screens/notDetaylari.dart';
import 'package:not/services/internettenVeriler.dart';
import 'package:text_scroll/text_scroll.dart';

class not extends StatefulWidget {
  const not({super.key});

  @override
  State<not> createState() => _notState();
}

class _notState extends State<not> {
  @override
  Widget build(BuildContext context) {
    // Scaffold arka plan rengini modern gri-beyaz yapıyoruz
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: const Color(0xFFF5F7FA),
                title: Container(
                  child: Text(
                    "Kütüphanem", // "Notlarım" yerine daha modern bir tabir
                    style: TextStyle(
                      color: Colors.black87, // mainColorDark kullanabilirsiniz
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                    ),
                  ),
                ),
                centerTitle: false,
                pinned: true,
                floating: true,
                elevation: 0,
                // TabBar'ı SliverAppBar'ın altına ekliyoruz
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Colors.white, // Seçili tab rengi
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      dividerColor: Colors.transparent, // Alt çizgiyi kaldırır
                      tabs: const [
                        Tab(text: "Satın Aldıklarım"),
                        Tab(text: "Kendi Notlarım"),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              // 1. Sekme: Satın Alınanlar (Veri çekme simülasyonu)
              _buildNoteList(tableName: "notlar"),

              // 2. Sekme: Kendi Notlarım (Aynı yapıyı kullanır)
              _buildNoteList(tableName: "kendi_notlarim"),
            ],
          ),
        ),
      ),
    );
  }

  // Veri Çekme ve Listeleme Metodu (Kod tekrarını önlemek için)
  Widget _buildNoteList({required String tableName}) {
    return FutureBuilder(
      future: getCustomAllData(
        tabloAdi: "notlar",
      ), // Burayı tableName ile dinamik yapabilirsiniz
      builder: (context, snapshot) {
        var notlarData = snapshot.data;
        if (snapshot.hasData) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            physics: const BouncingScrollPhysics(), // Yaylanma efekti
            itemCount: 5, // notlarData.length olmalı, test için 5
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsPage(liste: notlarData, index: index),
                    ),
                  );
                },
                child: ModernNotKarti(index: index, liste: notlarData),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Bir hata oluştu"));
        } else {
          return Center(
            child: SizedBox(
              width: 120,
              child: Lottie.asset("assets/json/loading.json"),
            ),
          );
        }
      },
    );
  }
}

// YENİ VE MODERN KART TASARIMI
class ModernNotKarti extends StatelessWidget {
  final int index;
  final List<Map<String, dynamic>>? liste;

  const ModernNotKarti({super.key, required this.index, required this.liste});

  @override
  Widget build(BuildContext context) {
    // Veri güvenliği için varsayılan değerler
    String imageUrl =
        liste?[index]["ornek_foto"] ?? "https://via.placeholder.com/150";
    String title = liste?[index]["not_ad"] ?? "İsimsiz Not";
    String uploader = liste?[index]["yukleyen_ad"] ?? "Anonim";
    String price = liste?[index]["fiyat"]?.toString() ?? "0";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Resim Alanı (Solda)
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Hero(
              tag: "$index",
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Metin ve İçerik Alanı (Ortada)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 14.0,
                horizontal: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Başlık (TextScroll ile)
                  TextScroll(
                    title,
                    mode: TextScrollMode.endless,
                    velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                    pauseBetween: const Duration(seconds: 3),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3142), // Koyu gri
                    ),
                  ),

                  // Yükleyen Kişi
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        uploader,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Alt kısım: Ders veya Kategori (Opsiyonel) veya boşluk
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "PDF Belge", // Burayı dinamik yapabilirsiniz
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Fiyat Alanı (Sağda - Dikey Çizgi ile ayrılmış)
          Container(
            width: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              border: Border(
                left: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "₺$price",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF4CAF50), // Canlı yeşil fiyat
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "SATIN AL",
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
