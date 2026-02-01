import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../widgets/appButton.dart';
import '../widgets/appSnackBar.dart';
import '../widgets/appTextField.dart';
import '../widgets/sizedbox.dart';

TextEditingController emailController = TextEditingController();

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

var randomNumber;

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Future<void> sendMail() async {
    Random random = Random();
    int min = 100000; // Minimum 6 haneli sayı
    int max = 999999; // Maximum 6 haneli sayı

    // Rastgele sayıyı oluştur
    randomNumber = min + random.nextInt(max - min);
    var response = await http.post(
      Uri.parse(
          'https://codefellas.com.tr/apps/altuntasyayin/php/mail/mail.php'), // API URL'yi güncelleyin
      body: {
        'to': '${emailController.text}', // Alıcı mail adresi
        'subject': 'AltuntasYayin hesap dogrulama',
        'message':
            'Merhaba, Hesabınızı doğrulamanız için kodunuz: $randomNumber',
      },
    );
  }

  bool isPressed = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var h = MediaQuery.of(context).size.height / 812;
    var b = MediaQuery.of(context).size.width / 375;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: b * 28, vertical: h * 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: b * 7),
                    width: b * 30,
                    height: b * 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffc4c4c4).withOpacity(0.4),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: b * 16,
                    ),
                  ),
                ),
                sbh(15),
                Center(
                  child: Image.asset(
                    'assets/images/login_illus.png',
                    height: h * 151,
                    width: b * 252,
                  ),
                ),
                sbh(50),
                Text(
                  'Şifreyi Değiştir',
                  style: TextStyle(
                    fontSize: b * 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                sbh(30),
               AppTextField(
                  label: 'E-mail Giriniz',
                  controller: emailController,
                  suffix: null,
                  isVisibilty: null,
                  validator: (value) {
                    Pattern emailPattern =
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp regex = new RegExp(emailPattern.toString());
                    if (value!.isEmpty) {
                      return 'Boş Olamaz';
                    } else if ((!regex.hasMatch(value.trim()))) {
                      return 'E-Mail Kontrol Edin';
                    } else
                      return null;
                  },
                ),
                sbh(20),
                Center(
                  child: AppButton(
                    label: 'Eposta gönder',
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isPressed = true;
                        });

                        appSnackBar(
                          context: context,
                          msg: 'E-Posta Gönderildi',
                          isError: false,
                        );
                        sendMail();
                        //registerUser();
                      /*   var result =
                            await dialogBoxActivationLinkSentF(context); */
                       /*  Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChangePasswordForgot(),
                            )); */
                        setState(() {
                          isPressed = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
