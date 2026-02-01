import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Yıldızlar için
import 'package:provider/provider.dart';
import 'package:not/details/colors.dart';
import '../services/internettenVeriler.dart';
import '../widgets/sizedbox.dart';
import '../services/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isEditing = false;
  bool _isDataLoaded = false;

  // Yorumları tutacak Future değişkeni
  late Future<List<dynamic>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    // Kullanıcı verisini çek
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provider = Provider.of<UserProvider>(context, listen: false);
      provider.fetchUserData();

      // Kullanıcı ID'si hazır olunca yorumları çek
      if (provider.user != null) {
        setState(() {
          _commentsFuture = _fetchUserComments(provider.user!.id!);
        });
      }
    });
  }

  // Yorumları Veritabanından Çeken Fonksiyon
  Future<List<dynamic>> _fetchUserComments(String userId) async {
    // "yorumlar" tablosundan "kullanici_id"si bu profil olanları getir
    try {
      var data = await getCustomAllData(tabloAdi: "yorumlar");

      // İstemci tarafında filtreleme (API desteğine göre server-side da yapılabilir)
      // Burada tüm yorumları çekip ilgili kullanıcıya ait olanları filtreliyoruz
      if (data is List) {
        return data!
            .where((element) => element['kullanici_id'].toString() == userId)
            .toList();
      }
      return [];
    } catch (e) {
      print("Yorum hatası: $e");
      return [];
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(UserProvider userProvider) async {
    final userId = userProvider.user!.id;

    try {
      final response = await updateVeri(
        tabloAdi: 'hesaplar',
        tabloIsimleri: 'ad, telefon',
        degerler: '${_nameController.text}, ${_phoneController.text}',
        whereColumnName: 'id',
        whereColumnValue: userId!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Bilgiler başarıyla güncellendi"),
          backgroundColor: Colors.green,
        ),
      );
      if (userProvider.user != null) {
        userProvider.user!.ad = _nameController.text;
        userProvider.user!.telefon = _phoneController.text;

        // Değişikliği arayüze bildirmek için setUser'ı tekrar tetikliyoruz
        userProvider.setUser(userProvider.user!);
      }
      await userProvider.fetchUserData();
      setState(() {
        _isEditing = false;
      });
    } catch (e) {
      print("Güncelleme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // Veri geldiğinde controller'ları doldur ve yorumları tetikle (eğer boşsa)
    if (user != null && !_isDataLoaded) {
      _nameController.text = user.ad ?? "";
      _emailController.text = user.eposta ?? "";
      _phoneController.text = user.telefon == "null"
          ? ""
          : (user.telefon ?? "");

      // Yorumları başlat (Eğer initState'de yetişmediyse)
      _commentsFuture = _fetchUserComments(user.id!);

      _isDataLoaded = true;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. APP BAR
                SliverAppBar(
                  backgroundColor: const Color(0xFFF5F7FA),
                  expandedHeight: 80.0,
                  floating: true,
                  pinned: true,
                  elevation: 0,
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
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isEditing = !_isEditing;
                            if (!_isEditing) _isDataLoaded = false;
                          });
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _isEditing ? Colors.black87 : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5),
                            ],
                          ),
                          child: Icon(
                            _isEditing ? Icons.close : Icons.edit,
                            size: 20,
                            color: _isEditing ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
                    title: const Text(
                      "Profilim",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),

                // 2. KİŞİSEL BİLGİLER FORMU
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        _buildModernField(
                          controller: _nameController,
                          label: "İsim Soyisim",
                          icon: Icons.person_outline,
                          enabled: _isEditing,
                        ),
                        sbh(15),
                        _buildModernField(
                          controller: _emailController,
                          label: "E-Posta Adresi",
                          icon: Icons.email_outlined,
                          enabled: false,
                        ),
                        sbh(15),
                        _buildModernField(
                          controller: _phoneController,
                          label: "Telefon Numarası",
                          icon: Icons.phone_outlined,
                          enabled: _isEditing,
                          inputType: TextInputType.phone,
                        ),
                        sbh(30),

                        // Kaydet Butonu (Sadece Düzenleme Modunda)
                        AnimatedOpacity(
                          opacity: _isEditing ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: _isEditing
                              ? SizedBox(
                                  width: double.infinity,
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: () => _saveProfile(userProvider),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      foregroundColor: Colors.white,
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Text(
                                      "Değişiklikleri Kaydet",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. YORUMLAR BAŞLIĞI
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        sbh(10),
                        const Text(
                          "Değerlendirmeler",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        sbh(5),
                        Text(
                          "Hakkınızda yapılan son yorumlar",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 4. YORUMLAR LİSTESİ
                FutureBuilder<List<dynamic>>(
                  future: _commentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text(
                            "Yorumlar yüklenemedi: ${snapshot.error}",
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildNoCommentsState();
                    } else {
                      var comments = snapshot.data!;
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            var yorum = comments[index];
                            return _buildCommentCard(yorum);
                          }, childCount: comments.length),
                        ),
                      );
                    }
                  },
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 50)),
              ],
            ),
    );
  }

  // --- WIDGET'LAR ---

  // Yorum Kartı Tasarımı
  Widget _buildCommentCard(Map<String, dynamic> yorum) {
    // Puanı double'a çevir (String gelme ihtimaline karşı)
    double rating = double.tryParse(yorum["puan"].toString()) ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üst Kısım: İsim ve Tarih
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    yorum["yotumu_yapan"] ?? "Anonim",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Text(
                yorum["yorum_tarihi"] ?? "",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Yıldızlar
          RatingBarIndicator(
            rating: rating,
            itemBuilder: (context, index) =>
                const Icon(Icons.star_rounded, color: Colors.amber),
            itemCount: 5,
            itemSize: 16.0,
            direction: Axis.horizontal,
          ),

          const SizedBox(height: 8),

          // Yorum Metni
          Text(
            yorum["yorum_metni"] ?? "",
            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.4,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCommentsState() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Icon(
                Icons.chat_bubble_outline_rounded,
                size: 40,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 10),
              Text(
                "Henüz yorum yapılmamış",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: enabled ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: inputType,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: enabled ? Colors.black87 : Colors.grey.shade600,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(
            icon,
            color: enabled ? Colors.blueAccent : Colors.grey.shade400,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}
