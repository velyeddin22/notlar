import 'package:flutter/material.dart';
import 'package:not/account/register.dart';

import '../details/colors.dart';
import '../widgets/appSnackBar.dart';
import '../widgets/appTextField.dart';
import '../widgets/sizeconfig.dart';

TextEditingController kodController = TextEditingController();
// Örnek olarak bir randomNumber değeri ekledim.

class ActivateEmailDialog extends StatelessWidget {
  ActivateEmailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: b * 15),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(b * 10),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: b * 16,
          vertical: h * 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/activate_email_illus.png',
              height: h * 110,
            ),
            SizedBox(height: h * 20),
            Text(
              "Hesabınızı doğrulayın",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: b * 14,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            SizedBox(height: h * 15),
            AppTextField(
              label: "Doğrulama kodu",
              controller: kodController,
              maxLength: 10,
              isVisibilty: null,
              inputType: TextInputType.number,
            ),
            SizedBox(height: h * 15),
            MaterialButton(
              color: mainColorLight,
              onPressed: () {
                if (kodController.text.isNotEmpty) {
                  if (int.tryParse(kodController.text) == randomNumber) {
                    Navigator.of(context).pop(true);
                  } else {
                    appSnackBar(
                      context: context,
                      msg: "Doğrulama başarısız oldu.",
                      isError: true,
                    );
                  }
                } else {
                  appSnackBar(
                    context: context,
                    msg: "Lütfen doğrulama kodunuz girin",
                    isError: true,
                  );
                }
              },
              child: Text(
                "Onayla",
                style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontWeight: FontWeight.w700,
                  fontSize: b * 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> dialogBoxActivationLinkSent(BuildContext context) async {
  return await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return ActivateEmailDialog();
    },
  ).then((value) {
    return value == true;
  });
}
