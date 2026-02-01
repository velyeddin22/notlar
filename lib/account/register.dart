// ignore_for_file: prefer_const_constructors, camel_case_types, unnecessary_string_interpolations, sort_child_properties_last, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_new, prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_const_constructors_in_immutables, prefer_final_fields, unnecessary_brace_in_string_interps, unnecessary_import
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:not/account/activate_email.dart';
import 'package:not/details/colors.dart';
import 'package:not/services/internettenVeriler.dart';

import '../widgets/appButton.dart';
import '../widgets/appSnackBar.dart';
import '../widgets/appTextField.dart';
import '../widgets/sizeconfig.dart';

class RegisterScreen extends StatefulWidget {
//  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

int randomNumber = 123456;
GlobalKey<FormState> _formKey = GlobalKey<FormState>();
TextEditingController nameController = TextEditingController();
TextEditingController kullaniciAdiController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController dogumGunuController = TextEditingController();

TextEditingController pwdController = TextEditingController();
TextEditingController confPwdController = TextEditingController();
TextEditingController InvitationCodeController = TextEditingController();

class _RegisterScreenState extends State<RegisterScreen> {
  bool isPwdVisible = false;
  bool isConfVisible = false;

  bool isPressed = false;

  bool isError = false;
  bool isError1 = false;

  bool isMisMatch = false;

  String cinsiyet = 'erkek';

  String generateRandomCode(int length) {
    Random random = Random();
    String code = '';

    for (int i = 0; i < length; i++) {
      code += random.nextInt(10).toString();
    }

    return code;
  }

  Future sendMail() async {
    Random random = Random();
    int min = 100000; // Minimum 6 haneli sayı
    int max = 999999; // Maximum 6 haneli sayı

    // Rastgele sayıyı oluştur
    randomNumber = min + random.nextInt(max - min);
    final response = await http.post(
      Uri.parse(
          'https://codefellas.com.tr/apps/altuntasyayin/php/mail/mail.php'), // API URL'yi güncelleyin
      body: {
        'to': '${emailController.text}', // Alıcı mail adresi
        'subject': 'Notlarım hesap dogrulama',
        'message':
            'Merhaba, Hesabınızı doğrulamanız için kodunuz: $randomNumber',
      },
    );
    return randomNumber;
  }

  bool isCustomer = false;
  Future<void> registerUser() async {
    String randomCode = generateRandomCode(8);
    String ad = nameController.text;
    String eposta = emailController.text;
    String sifre = confPwdController.text;
    String durum = 'aktif'; // Boş string olarak ayarlanmış
    String notlar = 'bos'; // Boş string olarak ayarlanmış
    String ad_gizli = 'evet'; // Boş string olarak ayarlanmış
    String telefon = phoneController.text;
    String bakiye = '0';
    final response = await http.post(
      Uri.parse(
          'https://codefellas.com.tr/apps/not/api/register.php'), // API URL'yi güncelleyin
      body: {
        'ad': ad,
        'eposta': eposta,
        'sifre': sifre,
        'durum': durum,
        'notlar': notlar,
        'ad_gizli': ad_gizli,
        'telefon': telefon,
        'bakiye': bakiye,
      },
    );

    if (response.statusCode == 200) {
      // Başarılı bir şekilde API'ye ulaşıldı
      // Yanıtın içeriğini kontrol edin ve isteğe bağlı olarak kullanıcıyı kayıt yapmış sayabilirsiniz
      print('API Yanıtı: ${response.body}');
    } else {
      // API'ye ulaşmada bir hata oluştu
      print('Hata Kodu: ${response.statusCode}');
    }
  }

  MailIsAvaliable(eposta) async {
    var geciciData = await getCustomData(
        tabloAdi: "hesaplar",
        whereColumnName: "eposta",
        whereColumnValue: "$eposta");

    if (geciciData.toString() == "[]") {
      return false;
    } else {
      return true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  List emailList = [];
  List kullaniciAdiList = [];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;
    var h = SizeConfig.screenHeight / 812;
    // ignore: unused_local_variable
    return Scaffold(
        body: Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              sh(10),
              TextButton(
                onPressed: () {
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
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: b * 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sh(20),
                      Text(
                        'Kaydol',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: b * 24,
                          letterSpacing: 0.5,
                        ),
                      ),
                      sh(30),
                      AppTextField(
                        label: 'Isim',
                        controller: nameController,
                        suffix: null,
                        isVisibilty: null,
                        validator: (val) {
                          if (nameController.text.trim() == "")
                            return 'Boş Olamaz';
                          else
                            return null;
                        },
                      ),
                      sh(20),
                      AppTextField(
                        label: 'E-mail',
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
                            return 'Doğru E-mail Giriniz';
                          } else if (emailList.contains(emailController.text)) {
                            return 'E-Posta Zaten Kullanılıyor';
                          } else
                            return null;
                        },
                      ),
                      sh(20),
                      AppTextField(
                        label: 'Telefon Numarası',
                        controller: phoneController,
                        maxLength: 10,
                        suffix: Text(
                          "+90",
                          style: TextStyle(
                            fontSize: b * 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        isVisibilty: null,
                        inputType: TextInputType.number,
                        validator: (val) {
                          if (phoneController.text.trim() == "")
                            return 'Boş Olamaz';
                          else if (phoneController.text.length != 10)
                            return "Doğru Numara Girin";
                          else
                            return null;
                        },
                      ),
                      sh(20),
                      AppTextFieldPassword(
                        label: 'Parola',
                        controller: pwdController,
                        isMisMatch: isMisMatch,
                        error: isError,
                        validator: (val) {
                          if (pwdController.text.trim() == "") {
                            isError = true;
                            setState(() {});
                            return 'Boş Olamaz';
                          } else if (confPwdController.text !=
                              pwdController.text) {
                            setState(() {
                              isMisMatch = true;
                              isError = true;
                            });
                            return 'Parolalar Eşleşmiyor';
                          } else {
                            setState(() {
                              isError = false;
                            });
                            return null;
                          }
                        },
                      ),
                      sh(20),
                      sb(8),
                      AppTextFieldPassword(
                        label: 'Parolayı doğrula',
                        isMisMatch: isMisMatch,
                        controller: confPwdController,
                        error: isError1,
                        validator: (val) {
                          if (confPwdController.text.trim() == "") {
                            setState(() {
                              isError1 = true;
                            });
                            return 'Boş Olamaz';
                          } else if (confPwdController.text !=
                              pwdController.text) {
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
                      sh(20),
                      isPressed
                          ? LoadingButton()
                          : AppButton(
                              label: 'Kaydol',
                              onPressed: () async {
                                // dialogBoxActivationLinkSent(context);

                                FocusScope.of(context).unfocus();
                                if (!_formKey.currentState!.validate()) return;

                                if (pwdController.text.trim().length < 6 ||
                                    pwdController.text.trim().length > 14) {
                                  appSnackBar(
                                    context: context,
                                    msg: 'Parolanız fazla uzun/kısa',
                                    isError: true,
                                  );
                                } else {
                                  isPressed = true;
                                  setState(() {});

                                  try {
                                    sendMail();
                                    bool epostaKullanildiMi =
                                        await MailIsAvaliable(
                                            emailController.text);

                                    if (!epostaKullanildiMi) {
                                      await dialogBoxActivationLinkSent(context)
                                          .then((k) async {
                                        if (k != null) {
                                          if (k != false) {
                                         
                                            await registerUser();
                                            appSnackBar(
                                              context: context,
                                              msg: 'Doğrulama başarılı oldu',
                                              isError: false,
                                            );
                                            Navigator.pop(context);
                                          } else {
                                            appSnackBar(
                                              context: context,
                                              msg: 'Doğrulama başarısız oldu',
                                              isError: false,
                                            );
                                          }
                                        } else {
                                          appSnackBar(
                                            context: context,
                                            msg: 'Doğrulama başarısız oldu',
                                            isError: false,
                                          );
                                        }

                                        // use the value as you wish
                                      });
                                      // registerUser();
                                    } else {
                                      appSnackBar(
                                        context: context,
                                        msg:
                                            'Bu eposta hesabı zaten kullanıldı',
                                        isError: false,
                                      );
                                    }

                                    /*   Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              login(
                                                            fromRoot: true,
                                                          ),
                                                        ),
                                                        (route) => false); */
                                  } catch (e) {
                                    appSnackBar(
                                      context: context,
                                      msg: e.toString(),
                                      isError: true,
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        isPressed = false;
                                      });
                                    }
                                  }
                                }
                              },
                            ),
                      sh(15),
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
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: b * 10),
                              height: 1,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                      sh(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Zaten Hesabınız var mı? ",
                            style: TextStyle(
                              fontSize: b * 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Giriş',
                              style: TextStyle(
                                fontSize: b * 14,
                                color: mainColorLight,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          )
                        ],
                      ),
                      sh(30),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
    //
    //
    //
  }
}
