import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:not/screens/notDetaylari.dart';
import 'package:not/services/internettenVeriler.dart'; // Bu dosyanızın var olduğunu varsayıyorum
import 'package:not/details/fakulteler.dart'; // Categories sayfanızın importu
import 'package:text_scroll/text_scroll.dart';
import '../widgets/fakulteler.dart'; // Eğer Categories widget'ı buradaysa

class AramaSayfasi extends StatefulWidget {
  const AramaSayfasi({super.key});

  @override
  State<AramaSayfasi> createState() => _AramaSayfasiState();
}

class _AramaSayfasiState extends State<AramaSayfasi> {
  // Controller ile text alanını yönetmek daha sağlıklıdır
  final TextEditingController _searchController = TextEditingController();

  String searchValue = '';
  String filterString = '';
  bool filtreVisible = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Modern zemin rengi
      body: SafeArea(
        child: Column(
          children: [
            // 1. ARAMA VE FİLTRE ALANI (Header)
            _buildSearchHeader(context),

            // 2. AKTİF FİLTRELER (Chips)
            if (filtreVisible)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Text(
                      "Filtrelenen:",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    InputChip(
                      label: Text(
                        filterString,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: Colors.black87,
                      deleteIcon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                      onDeleted: () {
                        setState(() {
                          filterString = '';
                          filtreVisible = false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                    ),
                  ],
                ),
              ),

            // 3. SONUÇ LİSTESİ
            Expanded(
              child: FutureBuilder(
                future: getCustomAllData(tabloAdi: "notlar"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        width: 100,
                        child: Lottie.asset("assets/json/loading.json"),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    var tumVeriler =
                        snapshot.data as List<Map<String, dynamic>>;

                    // --- FİLTRELEME MANTIĞI (Burada yapıyoruz) ---
                    var filtrelenmisListe = tumVeriler.where((not) {
                      final notAd = not["not_ad"].toString().toLowerCase();
                      final kategori = not["not_kategori"]
                          .toString()
                          .toLowerCase();
                      final searchLower = searchValue.toLowerCase();
                      final filterLower = filterString.toLowerCase();

                      bool matchesSearch = notAd.contains(searchLower);
                      bool matchesFilter =
                          filterString.isEmpty ||
                          kategori.contains(filterLower);

                      return matchesSearch && matchesFilter;
                    }).toList();

                    // --- BOŞ SONUÇ KONTROLÜ ---
                    if (filtrelenmisListe.isEmpty) {
                      return _buildEmptyState();
                    }

                    // --- LİSTELEME ---
                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: filtrelenmisListe.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsPage(
                                  liste: filtrelenmisListe,
                                  index: index,
                                ),
                              ),
                            );
                          },
                          // Eski kart yerine modern kartı kullanıyoruz
                          child: AramaSonucKarti(
                            index: index,
                            data: filtrelenmisListe[index],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("Veri alınamadı"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PARÇALARI ---

  Widget _buildSearchHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          // Geri Dön Butonu (Opsiyonel, ana sayfadan geliyorsa gerekebilir)
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: Colors.grey,
              ),
            ),
          ),

          // Arama Kutusu
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => searchValue = value),
                decoration: InputDecoration(
                  hintText: "Ders veya konu ara...",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade600,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  suffixIcon: searchValue.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => searchValue = '');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Filtre Butonu
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Categories(),
                ), // Categories sayfanızın adı
              ).then((value) {
                if (value != null) {
                  setState(() {
                    filterString = value;
                    filtreVisible = true;
                  });
                }
              });
            },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: filtreVisible ? Colors.black87 : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  if (!filtreVisible)
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                    ),
                ],
              ),
              child: Icon(
                Icons.tune_rounded, // Modern filtre ikonu
                color: filtreVisible ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Text(
            "Sonuç Bulunamadı",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Farklı anahtar kelimelerle\ntekrar deneyin.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

// MODERN ARAMA SONUÇ KARTI (Önceki tasarımlarla uyumlu)
class AramaSonucKarti extends StatelessWidget {
  final int index;
  final Map<String, dynamic> data;

  const AramaSonucKarti({super.key, required this.index, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Resim
          Hero(
            tag: "search_$index", // Unique tag için
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                "${data["ornek_foto"]}",
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                errorBuilder: (c, o, s) =>
                    Container(color: Colors.grey, height: 80, width: 80),
              ),
            ),
          ),
          const SizedBox(width: 15),

          // Bilgiler
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextScroll(
                  "${data["not_ad"]}",
                  mode: TextScrollMode.endless,
                  velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                  pauseBetween: const Duration(seconds: 2),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "${data["yukleyen_ad"]}",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: double.tryParse(data["puan"].toString()) ?? 0.0,
                      itemBuilder: (context, index) =>
                          const Icon(Icons.star_rounded, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 14.0,
                      direction: Axis.horizontal,
                    ),
                    const Spacer(),
                    Text(
                      "₺${data["fiyat"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
