import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:not/details/colors.dart';
import 'package:not/screens/notlarim.dart';
import 'package:not/widgets/fakulteler.dart';
import 'package:not/widgets/sizedbox.dart';

class kategorilerWidget extends StatelessWidget {
  final String image;
  final String metin;

  const kategorilerWidget({
    required this.image,
    super.key,
    required this.metin,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (metin == "Fakülteler") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Categories(),
              )).then((value) {
            print(value);
          });
        } else if (metin == "Notlarım") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => not(),
              ));
        }
        //
        //
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 46) / 2,

        ///    height: 140,
        decoration: BoxDecoration(
            border: Border.all(color: mainColorDark, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(22))),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80,
                child: Image.asset(
                  "assets/images/${image}",
                  fit: BoxFit.fitWidth,
                ),
              ),
              sbh(5),
              Text(
                maxLines: 1,
                overflow: TextOverflow.fade,
                metin,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
