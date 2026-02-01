import 'package:flutter/material.dart';
import 'package:not/account/login.dart';
import 'package:not/auth.dart';
import 'package:not/details/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/appButton.dart';
import '../widgets/appSnackBar.dart';
import '../widgets/sizedbox.dart';

class LogOutDialog extends StatelessWidget {
  LogOutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/login_illus.png',
              height: 100,
            ),
            sbh(10),
            Text(
              'Çıkmak istediğinize emin misiniz?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            sbh(25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: mainColorLight),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Hayır',
                        style: TextStyle(
                          letterSpacing: 0.6,
                          fontSize: 12,
                          height: 1,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                sbw(20),
                Expanded(
                  child: AppButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('userid');
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => AuthWidget(),
                        ),
                        (route) => false,
                      );
                      appSnackBar(
                        context: context,
                        msg: 'Başarıyla Çıkış Yapıldı',
                        isError: false,
                      );
                    },
                    label: 'Evet',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> dialogBoxLogout(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return LogOutDialog();
    },
  );
}
