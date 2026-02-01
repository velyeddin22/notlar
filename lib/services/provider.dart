import 'package:flutter/material.dart';
import 'package:not/services/internettenVeriler.dart';
import 'package:not/services/prefs.dart';
import '../webModels/userModel.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
//

  Future<void> fetchUserData() async {
    if (_user != null) {
      // Veri zaten yüklü, internetten çekmeye gerek yok
      return;
    }
    var userId = await Storage.getInt("userid");
    List<Map<String, dynamic>>? HesaplarData = await getCustomData(
        tabloAdi: "hesaplar",
        whereColumnName: "id",
        whereColumnValue: "$userId");
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    User fetchedUser = User(
        id: "${HesaplarData!.first["id"]}",
        ad: "${HesaplarData!.first["ad"]}",
        eposta: "${HesaplarData!.first["eposta"]}",
        sifre: "${HesaplarData!.first["sifre"]}",
        durum: "${HesaplarData!.first["durum"]}",
        notlar: HesaplarData!.first["notlar"],
        adGizli: HesaplarData!.first["ad_gizli"],
        telefon: "${HesaplarData!.first["telefon"]}",
        bakiye: HesaplarData!.first["bakiye"],
        tarih: HesaplarData!.first["tarih"]);
    setUser(fetchedUser);
  }
}
