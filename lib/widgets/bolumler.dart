import 'package:flutter/material.dart';
import 'package:not/details/fakulteler.dart'; // Bu dosyanın yolu projenize göre kalmalı

class bolumlerList extends StatefulWidget {
  final int id;
  const bolumlerList({super.key, required this.id});

  @override
  State<bolumlerList> createState() => _bolumlerListState();
}

class _bolumlerListState extends State<bolumlerList> {
  // Verileri burada tutacağız
  late Future<List<String>> _bolumlerFuture;

  @override
  void initState() {
    super.initState();
    _bolumlerFuture = _bolumleriGetir();
  }

  // Veriyi asenkron olarak hazırlayan metod (String parse işlemlerini temizledik)
  Future<List<String>> _bolumleriGetir() async {
    // Simüle edilmiş gecikme (isteğe bağlı)
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      // Veri kaynağından veriyi alıyoruz
      var hamVeri = fakulteler.bolumSayisi()[widget.id];

      // Eğer veri zaten bir List ise direkt al, String ise parse et
      List<String> temizBolumler = [];

      if (hamVeri is List) {
        temizBolumler = hamVeri.map((e) => e.toString()).toList();
      } else {
        // Eski usül string ise (Yedek plan)
        temizBolumler = hamVeri
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .split(",")
            .map((e) => e.trim()) // Boşlukları temizle
            .toList();
      }

      return temizBolumler;
    } catch (e) {
      return ["Bölümler yüklenemedi"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Modern açık gri zemin
      body: FutureBuilder<List<String>>(
        future: _bolumlerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            var bolumListesi = snapshot.data!;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. MODERN APP BAR
                SliverAppBar(
                  backgroundColor: const Color(0xFFF5F7FA),
                  expandedHeight: 80.0,
                  floating: true,
                  pinned: true,
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context); // İlk pop
                        // İkinci pop (Eğer gerekliyse buradaki mantığı korudum ama
                        // genellikle tek pop yeterlidir. Sizin kodunuzda 2 pop vardı.)
                        // Navigator.pop(context);
                      },
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
                    titlePadding: const EdgeInsets.only(
                      left: 60,
                      bottom: 16,
                    ), // Başlık hizalaması
                    title: const Text(
                      "Bölümler",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),

                // 2. BÖLÜMLER LİSTESİ
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _buildModernListItem(
                        context: context,
                        index: index,
                        bolumAdi: bolumListesi[index],
                      );
                    }, childCount: bolumListesi.length),
                  ),
                ),

                // Alt boşluk
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            );
          } else {
            return const Center(child: Text("Veri bulunamadı"));
          }
        },
      ),
    );
  }

  // --- MODERN LİSTE ELEMANI TASARIMI ---
  Widget _buildModernListItem({
    required BuildContext context,
    required int index,
    required String bolumAdi,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Seçim Mantığı
            Navigator.pop(context); // Sayfayı kapat

            // Eğer veriyi bir önceki sayfaya göndermek istiyorsanız:
            // Navigator.pop(context, "${fakulteler.fakulteleriGetir()[widget.id]}/$bolumAdi");

            // Sizin orijinal kodunuzdaki mantık (2 kere pop ve veri gönderme):
            // Bu kısım Navigasyon yapınıza göre hata verebilir,
            // tek pop ve veri döndürmek genellikle daha sağlıklıdır.
            Navigator.pop(
              context,
              "${fakulteler.fakulteleriGetir()[widget.id]}/$bolumAdi",
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                // Sıra Numarası (Badged Style)
                Container(
                  height: 32,
                  width: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                // Bölüm Adı
                Expanded(
                  child: Text(
                    bolumAdi,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // Sağ Ok İkonu
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
