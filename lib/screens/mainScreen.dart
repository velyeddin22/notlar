import 'package:flutter/material.dart';
import 'package:not/account/profil.dart';
import 'package:not/details/colors.dart'; // Renklerinizin burada olduğunu varsayıyorum
import 'package:not/screens/aramaSayfasi.dart';
import 'package:not/screens/notlarim.dart';
import 'package:not/widgets/fakulteler.dart';
import 'package:not/widgets/hosGeldinSatWidget.dart'; // Mevcut widget'ınızı kullandım ama sarmaladım
import 'package:provider/provider.dart';
import '../account/login.dart';
import '../services/prefs.dart';
import '../services/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    // UserProvider'ı burada tutuyoruz
    final userProvider = Provider.of<UserProvider>(context);

    // Modern UI için arka plan rengi veya hafif gradyan
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Çok hafif gri-mavi arka plan
      drawer: const Drawer(), // Drawer içeriğinizi buraya ekleyebilirsiniz
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(), // iOS tarzı yaylanma efekti
        slivers: [
          // 1. MODERN APP BAR (Sliver)
          _buildSliverAppBar(context),

          // 2. ARAMA ÇUBUĞU
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: _buildModernSearchBar(context),
            ),
          ),

          // 3. BAŞLIK: ÖNE ÇIKANLAR
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "Keşfet & Kazan",
                style: TextStyle(
                  color: mainColorDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          // 4. YATAY KAYDIRILABİLİR KARTLAR (Carousel)
          SliverToBoxAdapter(
            child: SizedBox(
              height: 180, // Kart yüksekliği
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20),
                children: [
                  // Satıcı Kartı
                  _buildPromoCard(
                    context,
                    child: hosGeldinSatWidget(
                      satici: true,
                      image: 'sale.png',
                      metin: 'Notlarını ekleyerek kazanmaya ne dersin?',
                      baslik: "Satıcı Ol!",
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Alıcı Kartı
                  _buildPromoCard(
                    context,
                    child: hosGeldinSatWidget(
                      satici: false,
                      image: 'buyerStudent.png',
                      metin: 'Başarıya giden yolda en iyi notlar burada!',
                      baslik: "Not Bul",
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),

          // 5. BAŞLIK: HIZLI ERİŞİM
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
              child: Text(
                "Kategoriler",
                style: TextStyle(
                  color: mainColorDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),

          // 6. BENTO GRID MENÜ (Izgara Yapısı)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid.count(
              crossAxisCount: 2, // Yan yana 2 kutu
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.1, // Kareye yakın dikdörtgen
              children: [
                _buildMenuCard(
                  title: "Fakülteler",
                  icon: Icons.school_outlined,
                  color: Colors.blueAccent,
                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(builder: (context) => Categories()),
                    );
                  },
                ),
                _buildMenuCard(
                  title: "Notlarım",
                  icon: Icons.book_outlined,
                  color: Colors.orangeAccent,
                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(builder: (context) => not()),
                    );
                  },
                ),
                _buildMenuCard(
                  title: "Favoriler",
                  icon: Icons.favorite_border,
                  color: Colors.pinkAccent,
                  onTap: () {},
                ),
                _buildMenuCard(
                  title: "Profilim",
                  icon: Icons.person_outline,
                  color: Colors.teal,
                  onTap: () {
                    _handleProfileCheck(context);
                  },
                ),
              ],
            ),
          ),

          // Alt boşluk
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
        ],
      ),
    );
  }

  // --- WIDGET YAPICILAR (BUILDERS) ---

  // 1. Modern Sliver App Bar
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFFF5F7FA),
      expandedHeight: 80.0,
      floating: true,
      pinned: false,
      elevation: 0,
      // LEADING (SOL BUTON) AYARI
      leadingWidth: 70, // Sol tarafın genişliğini artırdık ki buton sığsın
      leading: Padding(
        padding: const EdgeInsets.only(left: 15, top: 8, bottom: 8),
        child: InkWell(
          onTap: () async {
            // Profil / Drawer kontrolü
            var userid = await Storage.getInt("userid");
            if (userid == "yok" || userid == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => login()),
              );
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
          borderRadius: BorderRadius.circular(
            50,
          ), // Tıklama efekti yuvarlak olsun
          child: Container(
            // Yükseklik ve genişlik vermezsen padding ile büyür,
            // verirsen sabit kalır. Sabit boyut daha şık durur:
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            // Icon'u tam ortalamak için:
            child: Center(
              child: Icon(Icons.menu_rounded, color: mainColorDark, size: 24),
            ),
          ),
        ),
      ),
      actions: [
        // ACTIONS (SAĞ BUTON) AYARI
        Padding(
          padding: const EdgeInsets.only(right: 20, top: 8, bottom: 8),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width:
                  50, // Sabit genişlik (daha büyük yuvarlak için 55 veya 60 yapın)
              height: 50, // Sabit yükseklik
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: mainColorDark,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          "Ana Sayfa",
          style: TextStyle(
            color: mainColorDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  // 2. Modern Arama Çubuğu
  Widget _buildModernSearchBar(BuildContext context) {
    return Hero(
      tag: 'searchBar',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AramaSayfasi()),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: mainColorLight.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Icon(Icons.search_rounded, color: mainColorLight, size: 28),
                const SizedBox(width: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Not ara...",
                      style: TextStyle(
                        color: mainColorDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Ders, fakülte veya konu girin",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. Tanıtım Kartı Sarmalayıcısı
  Widget _buildPromoCard(BuildContext context, {required Widget child}) {
    return Container(
      width:
          MediaQuery.of(context).size.width * 0.85, // Ekranın %85'ini kaplasın
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: child, // Mevcut widget'ınızı buraya koyuyoruz
      ),
    );
  }

  // 4. Grid Menü Kartı
  Widget _buildMenuCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                color: mainColorDark,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- YARDIMCI METODLAR ---

  // Login kontrolü mantığını buraya taşıdım, kod temizliği için
  Future<void> _handleProfileCheck(BuildContext context) async {
    var userid = await Storage.getInt("userid");
    if (userid == "yok" || userid == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
    } else {
      Navigator.push(
        context,

        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    }
  }
}
