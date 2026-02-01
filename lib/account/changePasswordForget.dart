import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../widgets/appButton.dart';
import '../widgets/appSnackBar.dart';
import '../widgets/appTextField.dart';
import '../widgets/sizeconfig.dart';

class ChangePasswordForgot extends StatefulWidget {
  @override
  State<ChangePasswordForgot> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordForgot> {
  var epostaId;

  Future<String> _getUserID(email) async {
    try {
      var response = await Dio().get(
          'https://codefellas.com.tr/apps/uber/mysql/epostayaAitUserId.php?email=$email');
      var _userList1 = [];
      if (response.statusCode == 200) {
        if (response.data.toString().contains("bulunamadı")) {
        } else {
          epostaId = int.parse(response.data.toString());
        }
      }

      print(epostaId);
      return response.data;
    } on DioError catch (e) {
      return Future.error(e.message as Object);
    }
  }

  Future<void> changePasswordMySQL() async {
    print("1");
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt("userId");
    final url = Uri.parse(
        'https://codefellas.com.tr/apps/altuntasyayin/php/change_password.php'); // Sunucu tarafı URL'si
    final response = await http.post(
      url,
      body: {
        'id': "$id",
        'old_password': "${curPwdController.text}",
        'new_password': "${newPwdController.text}",
      },
    );

    if (response.statusCode == 200) {
      print('${response.body}');

      if (response.body.contains("Eski şifre doğrulama hatası")) {
        appSnackBar(
            context: context,
            msg: "Eski şifrenizin doğru olduğundan emin olun",
            isError: false);
      } else if (response.body.contains("Şifre başarıyla güncellendi")) {
        appSnackBar(
            context: context,
            msg: "Şifre başarıyla güncellendi",
            isError: false);
        Navigator.pop(context);
      } else {
        appSnackBar(
            context: context,
            msg: "Bir sorunla karşılaşıldı. Lütfen tekrar deneyin",
            isError: false);
      }
    } else {
      print('Belge güncelleme hatası: ${response.reasonPhrase}');
    }
  }

  TextEditingController newPwdController = TextEditingController();
  TextEditingController confPwdController = TextEditingController();
  TextEditingController curPwdController = TextEditingController();

  bool isError = false;
  bool isError1 = false;
  bool isError2 = false;

  bool isMisMatch = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPressed = false;
  resetPassword() async {
    isPressed = true;
    setState(() {});
    appSnackBar(
      context: context,
      msg: 'Başarıyla Değiştirildi',
      isError: false,
    );
    Navigator.of(context).pop();
  }

  var errorvar = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var h = SizeConfig.screenHeight / 812;
    var b = SizeConfig.screenWidth / 375;
    @override
    void setState(fn) {
      if (mounted) {
        super.setState(fn);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Parolayı Değiş')),
      body: Column(children: [
        Expanded(
          child: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: b * 15),
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    sh(40),
                    Image.asset(
                      'assets/images/login_illus.png',
                      height: h * 165,
                      width: b * 142,
                    ),
                    Container(
                      width: SizeConfig.screenWidth,
                      margin: EdgeInsets.only(top: h * 20),
                      padding:
                          EdgeInsets.fromLTRB(b * 15, h * 20, b * 15, h * 20),
                      child: Column(
                        children: [
                          sh(20),
                          AppTextFieldPassword(
                            label: 'Eski Şifre',
                            controller: curPwdController,
                            isMisMatch: false,
                            error: isError2,
                            validator: (val) {
                              if (curPwdController.text == "") {
                                setState(() {
                                  errorvar = true;
                                  isError = true;
                                });
                                return 'Boş Olamaz';
                              } else {
                                setState(() {
                                  isError = false;
                                });
                                return 'Bilgileri Kontrol Edin';
                              }
                            },
                          ),
                          sh(20),
                          AppTextFieldPassword(
                            label: 'Yeni Şifre',
                            controller: newPwdController,
                            isMisMatch: isMisMatch,
                            error: isError,
                            validator: (val) {
                              if (newPwdController.text.trim() == "") {
                                setState(() {
                                  isMisMatch = false;
                                  isError = true;
                                  errorvar = true;
                                });
                                return 'Boş Olamaz';
                              } else if (confPwdController.text !=
                                  newPwdController.text) {
                                setState(() {
                                  isMisMatch = true;
                                  isError = true;
                                });
                                return 'Bilgileri Kontrol Edin';
                              } else {
                                setState(() {
                                  isError = false;
                                  isMisMatch = false;
                                });
                                return null;
                              }
                            },
                          ),
                          sh(20),
                          AppTextFieldPassword(
                            label: 'Parolayı Onayla',
                            isMisMatch: isMisMatch,
                            controller: confPwdController,
                            error: isError1,
                            validator: (val) {
                              if (confPwdController.text.trim() == "") {
                                setState(() {
                                  isError1 = true;
                                  errorvar = true;
                                  isMisMatch = false;
                                });
                                return 'Boş Olamaz';
                              } else if (confPwdController.text !=
                                  newPwdController.text) {
                                setState(() {
                                  isMisMatch = true;
                                  isError1 = true;
                                });
                                return 'Parolalar Eşleşmiyor';
                              } else {
                                setState(() {
                                  isMisMatch = false;
                                  isError1 = false;
                                });
                                return null;
                              }
                            },
                          ),
                          sh(30),
                          AppButton(
                            label: 'Parolayı değiş',
                            onPressed: () {
                              if (newPwdController.text ==
                                  confPwdController.text) {
                                print(errorvar);
                                if (errorvar) {
                                  return null;
                                } else if (newPwdController.text.length < 6 ||
                                    newPwdController.text.length > 14) {
                                  setState(() {
                                    isPressed = false;
                                  });
                                  appSnackBar(
                                    context: context,
                                    msg: 'Parola fazla uzun/kısa',
                                    isError: true,
                                  );
                                } else {
                                  if (!errorvar) {
                                    changePasswordMySQL();
                                  }
                                }
                              } else {
                                appSnackBar(
                                  context: context,
                                  msg: 'Şifreler eşleşmiyor',
                                  isError: true,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
