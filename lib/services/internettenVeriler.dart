// ignore_for_file: prefer_const_constructors, camel_case_types, unnecessary_string_interpolations, sort_child_properties_last, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, unnecessary_new, prefer_typing_uninitialized_variables, no_logic_in_create_state, prefer_const_constructors_in_immutables, prefer_final_fields, unnecessary_brace_in_string_interps, unnecessary_import
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;

var site = "http://codefellas.com.tr/apps/notlarim/api";

postVeri({
  required String tabloAdi,
  required String tabloIsimleri,
  required String degerler,
}) async {
  var url = "$site/veri_ekle.php";

  var data = {
    'tableName': '$tabloAdi', // Tablo adı
    'columnNames': '$tabloIsimleri', // Sütun adları
    'values': '$degerler', // Sütunlara atanacak değerler
  };

  // HTTP POST isteği yap
  var response = await http.post(Uri.parse(url), body: data);

  // İstek sonucunu kontrol et
  if (response.statusCode == 200) {
    print('Veri başarıyla eklendi');
    return true;
  } else {
    print('Hata: ${response.reasonPhrase}');
    return false;
  }
}

updateVeri({
  required String tabloAdi,
  required String tabloIsimleri,
  required String degerler,
  required String whereColumnName,
  required String whereColumnValue,
}) async {
  /* tabloAdi: "atilanHediyeler",
                            whereColumnName: "gonderenID",
                            whereColumnValue: "123",
                            tabloIsimleri: "yayinID, hediyeID",
                            degerler: "103, 1" */
  var url = '$site/veri_guncelle.php'; // PHP dosyasının URL'si

  var data = {
    'tableName': '$tabloAdi', // Tablo adı
    'updateColumnNames': '$tabloIsimleri', // Güncellenecek sütunlar
    'updateColumnValues': '$degerler', // Güncellenecek değerler
    'whereColumnName':
        '$whereColumnName', // Filtreleme için kullanılacak sütun adı
    'whereColumnValue':
        "$whereColumnValue", // Filtreleme için kullanılacak sütun değeri
  };

  // HTTP POST isteği yap
  var response = await http.post(Uri.parse(url), body: data);

  // İstek sonucunu kontrol et
  if (response.statusCode == 200) {
    print('Veri başarıyla güncellendi${response.body}');
    return true;
  } else {
    print('Hata: ${response.reasonPhrase}');
    return false;
  }
}

Future<List<Map<String, dynamic>>?> getCustomData({
  required String tabloAdi,
  required String whereColumnName,
  required String whereColumnValue,
}) async {
  var url = '$site/veri_cek_custom.php'; // PHP dosyasının URL'si

  var data = {
    'tableName': '$tabloAdi', // Tablo adı
    'whereColumnName':
        '$whereColumnName', // Filtreleme için kullanılacak sütun adı
    'whereColumnValue':
        '$whereColumnValue', // Filtreleme için kullanılacak sütun değeri
  };

  // HTTP POST isteği yap
  var response = await http.post(Uri.parse(url), body: data);
  List<Map<String, dynamic>> dataList;
  // İstek sonucunu kontrol et

  if (response.statusCode == 200) {
    if (!response.body.contains("Veri bulunamadı") &&
        response.body.toString() != null &&
        !response.body.contains("Warning") &&
        response.body.toString() != '') {
      dataList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      // print('Veri başarıyla alındı: ${dataList[0]["id"]}');
      return dataList;
    } else {
      print('Veri bulunmadı');

      return [];
    }
  } else {
    print('Hata: ${response.reasonPhrase}');
  }
}

Future<List<Map<String, dynamic>>?> getCustomAllData({
  required String tabloAdi,
}) async {
  var url =
      '$site/veri_cek.php?db_name=codefellas_notlar&query=$tabloAdi'; // PHP dosyasının
  var response = await http.post(Uri.parse(url));
  List<Map<String, dynamic>> dataList;

  if (response.statusCode == 200) {
    if (!response.body.contains("Veri bulunamadı")) {
      dataList = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      // print('Veri başarıyla alındı: ${dataList[0]["id"]}');

      return dataList;
    } else {
      print('Veri bulunmadı');
      return [];
    }
  } else {
    print('Hata: ${response.reasonPhrase}');
    return [];
  }
}

veriSil({
  required String tabloAdi,
  required String whereColumnName,
  required String whereColumnValue,
}) async {
  var url = '$site/veri_sil.php'; // PHP dosyasının URL'si

  var data = {
    'tableName': '$tabloAdi', // Tablo adı
    'whereColumnName':
        '$whereColumnName', // Filtreleme için kullanılacak sütun adı
    'whereColumnValue':
        '$whereColumnValue', // Filtreleme için kullanılacak sütun değeri
  };

  // HTTP POST isteği yap
  var response = await http.post(Uri.parse(url), body: data);

  // İstek sonucunu kontrol et
  if (response.statusCode == 200) {
    print("Veri başarıyla silindi${response.body}");
  } else {
    print('Hata: ${response.reasonPhrase}');
  }
}

izlenendkArttir({required String userID}) async {
  var url = '$site/izlenendkArttir.php?id=$userID'; // PHP dosyasının URL'si

  // HTTP POST isteği yap
  var response = await http.post(Uri.parse(url));

  // İstek sonucunu kontrol et
  if (response.statusCode == 200) {
    print("Zaman arttırıldı${response.body}");
  } else {
    print('HATA Zaman Attırılamadı : ${response.reasonPhrase}');
  }
}
