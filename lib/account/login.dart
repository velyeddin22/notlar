import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:not/details/colors.dart';
import 'package:not/services/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../auth.dart';
import '../screens/mainScreen.dart';
import '../webModels/hesaplarModel.dart';
import '../widgets/appButton.dart';
import '../widgets/appSnackBar.dart';
import '../widgets/appTextField.dart';
import '../widgets/sizeconfig.dart';
import 'forgotPassword.dart';
import 'kullanimKosullari.dart';
import 'register.dart';

class login extends StatefulWidget {
  final bool? fromRoot;
  login({Key? key, this.fromRoot}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

bool emailValidated = false;

class _loginState extends State<login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  bool isVisibilty = false;
  bool isPressed = false;
  var ids;
  bool isError = false;
  bool terms = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    emailController.text = '';
    pwdController.text = '';
    super.initState();
  }

  Future<void> loginUser() async {
    final response = await http.post(
      Uri.parse(
        'https://codefellas.com.tr/apps/notlarim/api/login.php',
      ), // API URL'yi güncelleyin
      body: {'email': emailController.text, 'password': pwdController.text},
    );

    if (response.statusCode == 200) {
      // Başarılı bir şekilde API'ye ulaşıldı
      // Yanıtın içeriğini kontrol edin ve isteğe bağlı olarak kullanıcıyı giriş yapmış sayabilirsiniz

      if (!response.body.contains("Giriş başarısız")) {
        List hamList = [];
        hamList = json.decode(response.body).cast<String>().toList();
        await Storage.setInt("userid", int.parse("${hamList[0]}"));

        appSnackBar(context: context, msg: "Giriş başarılı", isError: false);

        /* if (response.body.contains("erkek")) {
          await prefs.setString('cinsiyet', "erkek");
        } else if (response.body.contains("kadın")) {
          await prefs.setString('cinsiyet', "kadın");
          await prefs.setInt('id', int.parse("${hamList[1]}"));
        } */

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AuthWidget()),
          (route) => false,
        );
      } else {
        appSnackBar(
          context: context,
          msg: "Lütfen hesap bilgilerinizi kontrol edin.",
          isError: false,
        );
      }

      setState(() {
        isPressed = false;
      });
    } else {
      // API'ye ulaşmada bir hata oluştu
      print('Giriş yaparken hata oluştu. Lütfen Tekrar deneyin.');
      setState(() {
        isPressed = false;
      });
    }
  }

  /*   login() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ModeSelectorScreen(),
      ),
    );
  } */
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: b * 30, vertical: h * 16),
        child: Column(
          children: [
            sh(30),
            Image.asset(
              'assets/images/login_illus.png',
              width: b * 178,
              height: h * 133,
            ),
            sh(29),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Giriş",
                    style: TextStyle(
                      fontSize: b * 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.65,
                    ),
                  ),
                  sh(30),
                  AppTextField(
                    label: 'E-Mail Girin',
                    controller: emailController,
                    autofill: [AutofillHints.email],
                    validator: (value) {
                      if (EmailValidator.validate(
                            emailController.text,
                          ).toString() ==
                          "true") {
                        emailValidated = true;
                      } else {
                        emailValidated = false;
                      }
                    },
                  ),
                  sh(20),
                  AppTextFieldPassword(
                    label: 'Parola Girin',
                    controller: pwdController,
                    isMisMatch: false,
                    error: isError,
                    validator: (val) {
                      if (val!.trim() == "") {
                        setState(() {
                          isError = true;
                        });
                        return 'Boş Olamaz';
                      } else {
                        setState(() {
                          isError = false;
                        });
                        return null;
                      }
                    },
                  ),
                  sh(20),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Şifreyi Unuttum',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        fontSize: b * 14,
                      ),
                    ),
                  ),
                  sh(20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        side: BorderSide(
                          color: Color(0xffcccccc),
                          width: b * 1,
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        activeColor: mainColorLight,
                        checkColor: Colors.white,
                        value: terms,
                        onChanged: (v) {
                          setState(() {
                            terms = v!;
                          });
                        },
                      ),
                      sb(8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => kullanimKosullari(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Koşullar ve Şartları',
                                  style: TextStyle(
                                    fontSize: b * 13,
                                    color: mainColorLight,
                                  ),
                                ),
                              ),
                              sh(2),
                              Text(
                                ' Okudum ve Onayladım.',
                                style: TextStyle(
                                  height: 1.6,
                                  fontSize: b * 13,
                                  color: Color(0xff3A3A3A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  sh(22),
                  Center(
                    child: (isPressed && terms)
                        ? LoadingButton()
                        : AppButton(
                            label: 'Giriş',
                            onPressed: () async {
                              if (emailController.text == "Yonetim" &&
                                  pwdController.text == "Yonetim") {
                                /*      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => admin(),
                                    )); */
                              } else {
                                FocusScope.of(context).unfocus();
                                if (terms) {
                                  if (emailValidated) {
                                    if (!_formKey.currentState!.validate())
                                      return null;

                                    isPressed = true;
                                    setState(() {});
                                    loginUser();
                                  } else {
                                    appSnackBar(
                                      context: context,
                                      msg:
                                          "Mail adresinizi doğru yazdığınızdan emin olun.",
                                      isError: false,
                                    );
                                  }
                                } else
                                  appSnackBar(
                                    context: context,
                                    msg: 'Koşullar ve şartları Kabul Edin',
                                    isError: true,
                                  );
                              }
                            },
                          ),
                  ),
                  sh(18),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: b * 10),
                          height: 1,
                          color: Color(0xffe4e4e4),
                        ),
                      ),
                      Text(
                        've ya',
                        style: TextStyle(
                          fontSize: b * 12,
                          color: Color(0xffe4e4e4),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(left: b * 10),
                          height: 1,
                          color: Color(0xffe4e4e4),
                        ),
                      ),
                    ],
                  ),
                  sh(18),
                  sh(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hesabınız Yok Mu?',
                        style: TextStyle(
                          fontSize: b * 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          );
                        },
                        child: Text(
                          ' Hemen Kaydol',
                          style: TextStyle(
                            fontSize: b * 14,
                            fontWeight: FontWeight.w700,
                            color: mainColorLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  sh(30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
