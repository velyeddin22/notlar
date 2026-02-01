import 'package:flutter/material.dart';
import 'package:not/account/login.dart';
import 'package:not/details/colors.dart';
import 'package:not/screens/mainScreen.dart';
import 'package:not/services/prefs.dart';
import 'package:not/widgets/sizedbox.dart';
import 'package:provider/provider.dart';

import '../account/logout_dialog.dart';
import '../screens/aramaSayfasi.dart';
import '../screens/notEklemeSayfasi.dart';
import '../screens/notlarim.dart';
import '../services/provider.dart';

class bottomNavBar extends StatefulWidget {
  bottomNavBar({super.key});

  @override
  State<bottomNavBar> createState() => _bottomNavBarState();
}

class _bottomNavBarState extends State<bottomNavBar> {
  int _selectedIndex = 0;
  Future<void> _onItemTapped(int index) async {
    _selectedIndex = index;
    if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotEkleSayfasi(),
          ));
    } else if (index == 2) {
      var userid = await Storage.getInt("userid");

      if (userid == "yok" || userid == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => login(),
            ));
      } else {
        print("Giriş olunub");
      }
    }
    _selectedIndex = 0;
    setState(() {});
  }

  List<BottomNavigationBarItem> bottomList = [
    BottomNavigationBarItem(
        backgroundColor: mainColorLight,
        label: "Ana sayfa",
        icon: Icon(Icons.home)),
    BottomNavigationBarItem(
        backgroundColor: mainColorLight,
        label: "Not ekle",
        icon: Icon(Icons.add)),
    BottomNavigationBarItem(
        backgroundColor: mainColorLight,
        label: "Hesabım",
        icon: Icon(Icons.person_outline))
  ];

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(color: mainColorLight),
        items: bottomList,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
          child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1511367461989-f85a21fda167?q=80&w=1931&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
            ),
            accountEmail: Text('${userProvider.user?.eposta ?? ""}'),
            accountName: Text(
              '${userProvider.user?.ad ?? ""}',
              style: TextStyle(fontSize: 24.0),
            ),
            decoration: BoxDecoration(
              color: Colors.black87,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_a_photo_outlined),
            title: const Text(
              'Not ekle',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotEkleSayfasi(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text(
              'Not satın al',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AramaSayfasi(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.sticky_note_2),
            title: const Text(
              'Notlarım',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => not(),
                  ));
            },
          ),
          Expanded(child: SizedBox()),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              'Çıkış yap',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.pop(context);
              dialogBoxLogout(context);
            },
          ),
        ],
      )),
      body: MainPage(),
    );
  }
}
