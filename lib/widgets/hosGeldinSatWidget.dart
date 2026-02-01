import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:not/details/colors.dart';
import 'package:not/screens/notEklemeSayfasi.dart';

import '../screens/aramaSayfasi.dart';

class hosGeldinSatWidget extends StatelessWidget {
  final String image;
  final String metin;
  final String? baslik;
  final bool? satici;
  const hosGeldinSatWidget({
    required this.image,
    super.key,
    required this.metin,
    this.baslik,
    this.satici,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (satici == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotEkleSayfasi()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AramaSayfasi()),
          );
        }
      },
      child: Container(
        ///    height: 140,
        decoration: BoxDecoration(
          border: Border.all(color: mainColorDark, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(22)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (baslik != null)
                        ? Text(
                            "Merhaba!",
                            style: TextStyle(
                              color: mainColorLight,
                              fontSize: 22,
                            ),
                          )
                        : SizedBox(),
                    Text(
                      maxLines: 4,
                      "$metin",
                      style: TextStyle(
                        color: mainColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: 120,
                  child: Image.asset(
                    "assets/images/${image}",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
