import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:not/services/internettenVeriler.dart';
import 'package:not/screens/notDetaylari.dart';
import 'package:not/details/fakulteler.dart';
import 'package:not/details/Universiteler.dart';
import '../widgets/fakulteler.dart';

class AramaSayfasi extends StatefulWidget {
  final String? initialCategory; // Dışarıdan filtre almak için yeni parametre

  const AramaSayfasi({super.key, this.initialCategory});

  @override
  State<AramaSayfasi> createState() => _AramaSayfasiState();
}

class _AramaSayfasiState extends State<AramaSayfasi> {
  final TextEditingController _searchController = TextEditingController();
  String searchValue = '';

  // Filtre değişkenleri
  String filterKategori = '';
  String filterUniversite = '';
  bool filtreVisible = false;

  @override
  void initState() {
    super.initState();
    // Sayfa açıldığında dışarıdan bir kategori geldiyse onu filtreye uygula
    if (widget.initialCategory != null && widget.initialCategory!.isNotEmpty) {
      filterKategori = widget.initialCategory!;
      filtreVisible = true;
    }
  }

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
            // 1. ÜST ARAMA ÇUBUĞU
            _buildSearchHeader(context),

            // 2. AKTİF FİLTRE GÖSTERGESİ (Chip'ler)
            if (filtreVisible) _buildFilterChips(),

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

                      // Eşleşmeyi daha esnek yaptık (içeriyorsa kabul et)
                      bool matchesCategory =
                          filterKategori.isEmpty ||
                          category.contains(filterKategori.toLowerCase());

                      bool matchesUniversite =
                          filterUniversite.isEmpty ||
                          uni == filterUniversite.toLowerCase();

                      return matchesSearch &&
                          matchesCategory &&
                          matchesUniversite;
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

  // --- HEADER ---
  Widget _buildSearchHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
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
          _buildFilterButton(),
        ],
      ),
    );
  }

  // --- FİLTRE BUTONU ---
  Widget _buildFilterButton() {
    return InkWell(
      onTap: () => _showFilterBottomSheet(),
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

  // --- FİLTRE BOTTOM SHEET (Üniversite + Kategori) ---
  void _showFilterBottomSheet() {
    String tempUniversite = filterUniversite;
    String tempKategori = filterKategori;
    final TextEditingController uniSearchCtrl = TextEditingController();
    List<String> filteredUniList = Universiteler.tumUniversiteler();

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
              initialChildSize: 0.8,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              builder: (context, scrollController) {
                return Column(
                  children: [
                    // Tutma çubuğu
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Filtrele",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                tempUniversite = '';
                                tempKategori = '';
                                uniSearchCtrl.clear();
                                filteredUniList =
                                    Universiteler.tumUniversiteler();
                              });
                            },
                            child: const Text(
                              "Temizle",
                              style: TextStyle(color: Color(0xFF6C63FF)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- KATEGORİ SEÇİMİ ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Kategori (Fakülte)",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () async {
                              var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (c) => const Categories(),
                                ),
                              );
                              if (result != null) {
                                setModalState(() {
                                  tempKategori = result;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F4FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    color: tempKategori.isNotEmpty
                                        ? const Color(0xFF6C63FF)
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      tempKategori.isNotEmpty
                                          ? tempKategori
                                          : "Kategori seçiniz...",
                                      style: TextStyle(
                                        color: tempKategori.isNotEmpty
                                            ? Colors.black87
                                            : Colors.grey,
                                        fontWeight: tempKategori.isNotEmpty
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // --- ÜNİVERSİTE ARAMA VE SEÇİMİ ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Üniversite",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F4FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: uniSearchCtrl,
                              onChanged: (val) {
                                setModalState(() {
                                  filteredUniList = Universiteler.ara(val);
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
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          if (tempUniversite.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Chip(
                                label: Text(
                                  tempUniversite,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                backgroundColor: const Color(0xFF6C63FF),
                                onDeleted: () {
                                  setModalState(() {
                                    tempUniversite = '';
                                  });
                                },
                                deleteIconColor: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),
                    const Divider(),

                    // Üniversite listesi
                    Expanded(
                      child: filteredUniList.isEmpty
                          ? const Center(
                              child: Text(
                                "Sonuç bulunamadı",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              itemCount: filteredUniList.length,
                              itemBuilder: (context, index) {
                                bool isSelected =
                                    filteredUniList[index] == tempUniversite;
                                return ListTile(
                                  dense: true,
                                  title: Text(
                                    filteredUniList[index],
                                    style: TextStyle(
                                      fontSize: 14,
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
                                          size: 20,
                                        )
                                      : null,
                                  onTap: () {
                                    setModalState(() {
                                      tempUniversite = filteredUniList[index];
                                    });
                                  },
                                );
                              },
                            ),
                    ),

                    // UYGULA BUTONU
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              filterUniversite = tempUniversite;
                              filterKategori = tempKategori;
                              filtreVisible =
                                  filterUniversite.isNotEmpty ||
                                  filterKategori.isNotEmpty;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Filtreyi Uygula",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
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

  // --- FİLTRE CHİP'LERİ ---
  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (filterUniversite.isNotEmpty)
            Chip(
              avatar: const Icon(
                Icons.account_balance,
                color: Colors.white,
                size: 16,
              ),
              label: Text(
                filterUniversite,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              backgroundColor: const Color(0xFF6C63FF),
              onDeleted: () => setState(() {
                filterUniversite = "";
                filtreVisible = filterKategori.isNotEmpty;
              }),
              deleteIconColor: Colors.white,
            ),
          if (filterKategori.isNotEmpty)
            Chip(
              avatar: const Icon(Icons.school, color: Colors.white, size: 16),
              label: Text(
                filterKategori, // Eğer string çok uzunsa (Fakülte/Bölüm gibi) buraya sığacaktır.
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              backgroundColor: Colors.deepOrange,
              onDeleted: () => setState(() {
                filterKategori = "";
                filtreVisible = filterUniversite.isNotEmpty;
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
            "Arama terimini değiştirmeyi veya filtreyi temizlemeyi deneyin.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// --- ARAMA SONUÇ KARTI ---
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
                width: 90,
                height: 90,
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
