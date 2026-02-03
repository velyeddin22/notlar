import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:not/services/internettenVeriler.dart';
import 'package:not/screens/notDetaylari.dart';
import '../services/prefs.dart';

class not extends StatefulWidget {
  const not({super.key});

  @override
  State<not> createState() => _notState();
}

class _notState extends State<not> {
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Sayfa açılır açılmaz ID'yi alıyoruz
  }

  Future<void> _loadUserId() async {
    var id = await Storage.getInt("userid");
    setState(() {
      currentUserId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ID yüklenene kadar boş dönmesin, yükleme animasyonu gösterelim
    if (currentUserId == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FD),
        body: Center(
          child: Lottie.asset("assets/json/loading.json", width: 150),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: const Color(0xFFF8F9FD),
                expandedHeight: 120,
                floating: true,
                pinned: true,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsetsDirectional.only(
                    start: 0,
                    top: 10,
                    bottom: 0,
                  ),
                  title: const Center(
                    child: Text(
                      "Kütüphanem",
                      style: TextStyle(
                        color: Color(0xFF1A1D1E),
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(64),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      labelColor: const Color(0xFF6C63FF),
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      dividerColor: Colors.transparent,
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
              _BuildNoteList(
                filterType: "purchased",
                currentUserId: currentUserId!,
              ),
              _BuildNoteList(
                filterType: "my_notes",
                currentUserId: currentUserId!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildNoteList extends StatelessWidget {
  final String filterType;
  final int currentUserId;
  const _BuildNoteList({required this.filterType, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCustomAllData(tabloAdi: "notlar"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List allData = snapshot.data as List;
          List filteredData = [];

          if (filterType == "purchased") {
            // Şimdilik test için hepsini gösteriyoruz.
            // Satın alma tablon hazır olduğunda oradan JOIN ile çekmelisin.
            filteredData = allData;
          } else {
            // Kendi notlarını filtreleme mantığı (ID kontrolü burada yapılıyor)
            filteredData = allData
                .where(
                  (e) =>
                      e['yukleyen_id'].toString() == currentUserId.toString(),
                )
                .toList();
          }

          if (filteredData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/json/empty.json", width: 200),
                  const Text(
                    "Henüz bir not bulunamadı.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
            itemCount: filteredData.length,
            itemBuilder: (context, index) {
              return ModernNotKarti(
                data: filteredData[index],
                index: index,
                fullList: filteredData,
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Veriler yüklenirken bir hata oluştu."),
          );
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

class ModernNotKarti extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;
  final List fullList;

  const ModernNotKarti({
    super.key,
    required this.data,
    required this.index,
    required this.fullList,
  });

  @override
  Widget build(BuildContext context) {
    String ad = data["not_ad"]?.toString() ?? "İsimsiz Not";
    String uni = data["universite_ad"]?.toString() ?? "Genel Kategori";
    String fiyat = data["fiyat"]?.toString() ?? "0.00";
    String sayfa = data["sayfa_sayisi"]?.toString() ?? "0";
    String foto =
        data["ornek_foto"]?.toString() ?? "https://via.placeholder.com/150";
    String uzanti = data["dosya_uzantisi"]?.toString() ?? "PDF";
    int onay = int.tryParse(data["onay_durumu"]?.toString() ?? "0") ?? 0;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              liste: fullList.cast<Map<String, dynamic>>(),
              index: index,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 100,
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        image: DecorationImage(
                          image: NetworkImage(foto),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 15,
                      left: 15,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          uzanti.toUpperCase() == "PDF"
                              ? Icons.picture_as_pdf
                              : Icons.image,
                          size: 14,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextScroll(
                          ad,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.school_outlined,
                              size: 14,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                uni,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildSmallBadge(
                              Icons.pages_outlined,
                              "$sayfa Sayfa",
                              Colors.orange.shade50,
                              Colors.orange.shade700,
                            ),
                            const SizedBox(width: 8),
                            if (onay == 1)
                              _buildSmallBadge(
                                Icons.verified_user_outlined,
                                "Onaylı",
                                Colors.green.shade50,
                                Colors.green.shade700,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 85,
                  color: const Color(0xFFF1F4FF),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Fiyat",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                      Text(
                        "₺$fiyat",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xFF6C63FF),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallBadge(
    IconData icon,
    String text,
    Color bgColor,
    Color textColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: textColor),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
