import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:not/services/internettenVeriler.dart';
import 'package:not/screens/notDetaylari.dart';
import 'package:not/details/fakulteler.dart';

import '../widgets/fakulteler.dart';

class AramaSayfasi extends StatefulWidget {
  const AramaSayfasi({super.key});

  @override
  State<AramaSayfasi> createState() => _AramaSayfasiState();
}

class _AramaSayfasiState extends State<AramaSayfasi> {
  final TextEditingController _searchController = TextEditingController();
  String searchValue = '';
  String filterKategori = '';
  bool filtreVisible = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: Column(
          children: [
            // 1. ÜST ARAMA ÇUBUĞU (Geri Dönme Düğmesi Burada)
            _buildSearchHeader(context),

            // 2. AKTİF FİLTRE GÖSTERGESİ (Chip)
            if (filtreVisible) _buildFilterChip(),

            // 3. SONUÇLAR
            Expanded(
              child: FutureBuilder(
                future: getCustomAllData(tabloAdi: "notlar"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Lottie.asset(
                        "assets/json/loading.json",
                        width: 120,
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    var tumVeriler =
                        snapshot.data as List<Map<String, dynamic>>;

                    // --- GELİŞMİŞ FİLTRELEME MANTIĞI ---
                    var filtrelenmisListe = tumVeriler.where((not) {
                      final s = searchValue.toLowerCase();

                      final name = (not["not_ad"] ?? "")
                          .toString()
                          .toLowerCase();
                      final uploader = (not["yukleyen_ad"] ?? "")
                          .toString()
                          .toLowerCase();
                      final uni = (not["universite_ad"] ?? "")
                          .toString()
                          .toLowerCase();
                      final dept = (not["bolum_ad"] ?? "")
                          .toString()
                          .toLowerCase();
                      final teacher = (not["dersin_hocasi"] ?? "")
                          .toString()
                          .toLowerCase();
                      final category = (not["not_kategori"] ?? "")
                          .toString()
                          .toLowerCase();

                      bool matchesSearch =
                          name.contains(s) ||
                          uploader.contains(s) ||
                          uni.contains(s) ||
                          dept.contains(s) ||
                          teacher.contains(s);

                      bool matchesCategory =
                          filterKategori.isEmpty ||
                          category == filterKategori.toLowerCase();

                      return matchesSearch && matchesCategory;
                    }).toList();

                    if (filtrelenmisListe.isEmpty) return _buildEmptyState();

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
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
                          child: AramaSonucKarti(
                            data: filtrelenmisListe[index],
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text("Hata oluştu."));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // GÜNCELLENMİŞ HEADER: Geri Dön Düğmesi Eklendi
  Widget _buildSearchHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          // GERİ DÖN DÜĞMESİ
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          // ARAMA ALANI
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F4FF),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (v) => setState(() => searchValue = v),
                decoration: InputDecoration(
                  hintText: "Ders, okul, yazar ara...",
                  hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF6C63FF),
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  suffixIcon: searchValue.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => searchValue = "");
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // FİLTRELEME DÜĞMESİ
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (c) => const Categories()),
        ).then((v) {
          if (v != null)
            setState(() {
              filterKategori = v;
              filtreVisible = true;
            });
        });
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: filtreVisible ? const Color(0xFF6C63FF) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(
          Icons.tune,
          color: filtreVisible ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildFilterChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Chip(
            label: Text(
              filterKategori,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFF6C63FF),
            onDeleted: () => setState(() {
              filterKategori = "";
              filtreVisible = false;
            }),
            deleteIconColor: Colors.white,
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
          Lottie.asset("assets/json/empty.json", width: 200),
          const Text(
            "Sonuç bulunamadı",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            "Arama terimini değiştirmeyi deneyin.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class AramaSonucKarti extends StatelessWidget {
  final Map<String, dynamic> data;
  const AramaSonucKarti({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              data["ornek_foto"] ?? "",
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.image),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextScroll(
                  data["not_ad"] ?? "Başlıksız",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${data["universite_ad"] ?? "Okul Belirtilmemiş"}",
                  style: const TextStyle(
                    color: Color(0xFF6C63FF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "${data["bolum_ad"] ?? "Bölüm Belirtilmemiş"}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: double.tryParse(data["puan"].toString()) ?? 0,
                      itemBuilder: (context, index) =>
                          const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 12,
                    ),
                    const Spacer(),
                    Text(
                      "₺${data["fiyat"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.green,
                        fontSize: 16,
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
