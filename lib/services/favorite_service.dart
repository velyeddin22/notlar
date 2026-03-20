// services/favorite_service.dart

import 'dart:convert';
import 'prefs.dart'; // Mevcut Storage sınıfınızın olduğu dosya

class FavoriteService {
  static Future<String> _getPrefsKey() async {
    int? userId = await Storage.getInt("userid");
    return "favorites_${userId ?? 0}";
  }

  static Future<void> toggleFavorite(Map<String, dynamic> note) async {
    String key = await _getPrefsKey();
    List<Map<String, dynamic>> favorites = await getFavorites();
    
    int index = favorites.indexWhere((item) => item['id'] == note['id']);
    
    if (index >= 0) {
      favorites.removeAt(index);
    } else {
      favorites.add(note);
    }

    String encodedData = jsonEncode(favorites);
    await Storage.setString(key, encodedData);
  }

 static Future<List<Map<String, dynamic>>> getFavorites() async {
  try {
    String key = await _getPrefsKey();
    String? data = await Storage.getString(key);

    // Veri boşsa, null ise veya JSON formatında değilse boş liste döndür
    if (data == null || data.isEmpty || data == "yok") {
      return [];
    }

    final decoded = jsonDecode(data);
    if (decoded is List) {
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  } catch (e) {
    print("Favori okuma hatası: $e");
    return []; // Hata anında uygulamayı çökertmek yerine boş liste dönüyoruz
  }
}

  static Future<bool> isFavorite(String noteId) async {
    List<Map<String, dynamic>> favorites = await getFavorites();
    return favorites.any((item) => item['id'].toString() == noteId.toString());
  }

  // Çıkış yaparken çağrılacak metod
  static Future<void> clearFavoritesOnLogout() async {
     int? userId = await Storage.getInt("userid");
     await Storage.remove("favorites_$userId");
  }
}