// To parse this JSON data, do
//
//     final hesaplarModel = hesaplarModelFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

HesaplarModel hesaplarModelFromMap(String str) => HesaplarModel.fromMap(json.decode(str));

String hesaplarModelToMap(HesaplarModel data) => json.encode(data.toMap());

class HesaplarModel {
    int id;
    String ad;
    String eposta;
    String sifre;
    String durum;
    String notlar;
    String adGizli;
    String telefon;
    String bakiye;
    String tarih;

    HesaplarModel({
        required this.id,
        required this.ad,
        required this.eposta,
        required this.sifre,
        required this.durum,
        required this.notlar,
        required this.adGizli,
        required this.telefon,
        required this.bakiye,
        required this.tarih,
    });

    factory HesaplarModel.fromMap(Map<String, dynamic> json) => HesaplarModel(
        id: json["id"],
        ad: json["ad"],
        eposta: json["eposta"],
        sifre: json["sifre"],
        durum: json["durum"],
        notlar: json["notlar"],
        adGizli: json["ad_gizli"],
        telefon: json["telefon"],
        bakiye: json["bakiye"],
        tarih: json["tarih"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "ad": ad,
        "eposta": eposta,
        "sifre": sifre,
        "durum": durum,
        "notlar": notlar,
        "ad_gizli": adGizli,
        "telefon": telefon,
        "bakiye": bakiye,
        "tarih": tarih,
    };
}
