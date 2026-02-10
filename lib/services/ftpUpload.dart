import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:mime/mime.dart'; // MimeType belirlemek için
import 'package:uuid/uuid.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart'
    as types; // Mesaj tipleri için

// Bu fonksiyonu kendi projenizdeki dosyaya göre ayarlayın
import 'internettenVeriler.dart';

// --- Global Değişkenler (Kendi uygulamanızdan alın) ---
const types.User _user = types.User(id: 'kullanici_123'); // Örnek kullanıcı
const String aliciId = 'alici_456';
void Function(types.Message) _addMessage = (message) {
  // Örnek: mesajı bir listeye ekleme
  print("Mesaj eklendi: ${message.id}");
};
void Function(types.Message, {String? uri, types.Status? status})
    _updateMessage = (message, {String? uri, types.Status? status}) {
  // Örnek: mesajı listede bulup güncelleme
  print(
      "Mesaj güncellendi: ${message.id}, Yeni URI: $uri, Yeni Durum: $status");
};

// --- FTP Yükleme Fonksiyonu ---
Future<String?> uploadFileToFTP({
  required FilePickerResult? result,
  String? gonderenId,
  String? aliciId,
  String? uploadType,
}) async {
  if (result == null || result.files.single.path == null) {
    return null;
  }

  File file = File(result.files.single.path!);
  String originalFileName = result.files.single.name;
  String fileExtension = originalFileName.split('.').last.toLowerCase();

  var uuid = const Uuid();
  String uniqueFileName = '${uuid.v4()}.$fileExtension';
  String remotePath = "assets/$uniqueFileName";

  FTPConnect ftpConnect = FTPConnect(
    "ftp.codefellas.com.tr",
    user: "not@codefellas.com.tr",
    pass: "Not22bj744Not.!.",
    port: 21,
    timeout: 10,
    securityType: SecurityType.ftp,
  );

  try {
    await ftpConnect.connect();
    await ftpConnect.setTransferType(TransferType.binary);

    bool res = await ftpConnect.uploadFile(file, sRemoteName: remotePath);

    if (res) {
      String dosyaUrl =
          "https://www.dovmetasarimcisi.com/app/bitanidik/$remotePath";

      // Yükleme tipine göre veritabanına kaydı burada yapıyoruz
      if (uploadType == 'dosya' && gonderenId != null && aliciId != null) {
        String messageType = _getFileType(fileExtension);
        await _sendMessage(
            remotePath, originalFileName, messageType, gonderenId, aliciId);
      }

      print("Dosya başarıyla yüklendi. URL: $dosyaUrl");
      return dosyaUrl; // Başarılı yüklemede URL'yi döndür
    } else {
      print("Yükleme başarısız.");
      return null;
    }
  } catch (e) {
    print("Hata: $e");
    return null;
  } finally {
    await ftpConnect.disconnect();
  }
}

// Dosya uzantısına göre mesaj tipini belirleyen yardımcı fonksiyon
String _getFileType(String extension) {
  List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
  List<String> documentExtensions = [
    'pdf',
    'doc',
    'docx',
    'txt',
    'xlsx',
    'xls',
    'pptx',
    'ppt'
  ];

  if (imageExtensions.contains(extension)) {
    return 'image';
  } else if (documentExtensions.contains(extension)) {
    return 'document';
  } else {
    return 'other';
  }
}

// Mesaj gönderme fonksiyonu (postVeri ile veritabanına kayıt)
Future<void> _sendMessage(
  String remotePath,
  String originalFileName,
  String messageType,
  String gonderenId,
  String aliciId,
) async {
  String dosyaUrl =
      "https://www.dovmetasarimcisi.com/app/bitanidik/$remotePath";

  await postVeri(
    tabloAdi: "mesajlar",
    tabloIsimleri: "gonderen_id, alici_id, mesaj_tipi, dosya_url",
    degerler: "$gonderenId, $aliciId, $messageType, $dosyaUrl",
  );
}

// --- Dosya Seçimi ve Mesaj Gönderme ---
void _handleFileSelection() async {
  final result = await FilePicker.platform.pickFiles(type: FileType.any);

  if (result != null && result.files.single.path != null) {
    // Mesajı geçici yerel URI ile oluştur ve ekle
    final tempMessage = types.FileMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      mimeType: lookupMimeType(result.files.single.path!),
      name: result.files.single.name,
      size: result.files.single.size,
      uri: result.files.single.path!, // Geçici yerel URI
      showStatus: true,
      status: types.Status.sending,
    );

    _addMessage(tempMessage);

    // Dosyayı FTP'ye yükle ve URL'yi al
    final dosyaUrl = await uploadFileToFTP(
      result: result,
      gonderenId: _user.id,
      aliciId: aliciId,
      uploadType: "dosya",
    );

    // Eğer yükleme başarılıysa, mesajı gerçek URL ve 'sent' durumuyla güncelle
    if (dosyaUrl != null) {
      _updateMessage(
        tempMessage,
        uri: dosyaUrl,
        status: types.Status.sent,
      );
    } else {
      // Yükleme başarısız olursa, mesajın durumunu 'error' olarak güncelle
      _updateMessage(
        tempMessage,
        status: types.Status.error,
      );
    }
  }
}
