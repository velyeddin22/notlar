import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:not/screens/mainScreen.dart';
import 'package:not/services/prefs.dart';
import 'package:provider/provider.dart';

import 'services/provider.dart';
import 'widgets/bottomNavBar.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  girisKontrol() async {
    var userid = await Storage.getInt("userid");
    print(userid);
    if (userid == "yok" || userid == 0) {
      await Future.delayed(const Duration(seconds: 2)).then((val) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return bottomNavBar();
          },
        ));
      });
    } else {
      await Provider.of<UserProvider>(context, listen: false).fetchUserData();
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return bottomNavBar();
        },
      ));
    }
  }

  @override
  void initState() {
    girisKontrol();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                width: 120, child: Lottie.asset("assets/json/loading.json"))));
  }
}
