import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

/// PHP upload.php API endpoint
const String _uploadApiUrl =
    'http://codefellas.com.tr/apps/notlarim/assets/uploaded/upload.php';

/// Görsel yükle (kapak fotoğrafı vb.)
Future<String?> uploadImage({required FilePickerResult? result}) async {
  return _uploadFile(result: result, fieldName: 'image');
}

/// Doküman yükle (PDF, DOC, DOCX)
Future<String?> uploadDocument({required FilePickerResult? result}) async {
  return _uploadFile(result: result, fieldName: 'document');
}

/// Genel dosya yükleme (otomatik tip algılama)
Future<String?> uploadFile({required FilePickerResult? result}) async {
  return _uploadFile(result: result, fieldName: 'file');
}

/// BOM ve görünmez karakterleri temizle
String _temizle(String s) {
  // UTF-8 BOM, Zero-width space, vs. temizle
  return s
      .replaceAll('\uFEFF', '')
      .replaceAll('\u200B', '')
      .replaceAll('\u00A0', ' ')
      .trim();
}

/// Ortak upload fonksiyonu
Future<String?> _uploadFile({
  required FilePickerResult? result,
  required String fieldName,
}) async {
  if (result == null || result.files.isEmpty) {
    print("⚠️ Dosya seçilmedi.");
    return null;
  }

  final filePath = result.files.single.path;
  if (filePath == null) {
    print("⚠️ Dosya yolu bulunamadı.");
    return null;
  }

  File file = File(filePath);
  String fileName = result.files.single.name;

  try {
    var uri = Uri.parse(_uploadApiUrl);
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      await http.MultipartFile.fromPath(
        fieldName,
        file.path,
        filename: fileName,
      ),
    );

    print("📤 Yükleniyor: $fileName ($fieldName)...");

    var streamedResponse = await request.send().timeout(
      const Duration(seconds: 60),
      onTimeout: () {
        throw Exception("Yükleme zaman aşımına uğradı (60s)");
      },
    );

    var response = await http.Response.fromStream(streamedResponse);

    // ✅ BOM ve görünmez karakter temizliği
    String cleanBody = _temizle(response.body);

    print("📥 Sunucu yanıtı [${response.statusCode}]: $cleanBody");

    if (response.statusCode == 200) {
      try {
        var json = jsonDecode(cleanBody);

        if (json['success'] == true && json['url'] != null) {
          // ✅ URL'den de BOM temizle
          String cleanUrl = _temizle(json['url'].toString());
          print("✅ Yükleme başarılı: $cleanUrl");
          return cleanUrl;
        } else {
          print("❌ Sunucu hatası: ${json['message'] ?? 'Bilinmeyen hata'}");
          return null;
        }
      } catch (e) {
        print("❌ JSON parse hatası: $e");
        print("   Ham yanıt: ${response.body}");
        print("   Temiz yanıt: $cleanBody");
        return null;
      }
    } else {
      print("❌ HTTP hatası: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("❌ Upload exception: $e");
    return null;
  }
}
