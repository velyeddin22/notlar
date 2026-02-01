import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class fakulteler {
  static List fakulteleriGetir() {
    List fakulteler = [
      "Diş Hekimliği Fakültesi",
      "Eğitim Fakültesi",
      "Fen-Edebiyat Fakültesi",
      "Güzel Sanatlar Fakültesi.",
      "Hukuk Fakültesi",
      "İktisadi ve İdari Bilimler Fakültesi.",
      "İlahiyat Fakültesi",
      "İnegöl İşletme Fakültesi.",
      "Mimarlık Fakültesi",
      "Mühendislik Fakültesi",
      "Spor Bilimleri Fakültesi.",
      "Sağlık Bilimleri Fakültesi",
      "Tıp Fakültesi",
      "Veteriner Fakültesi",
      "Ziraat Fakültesi"
    ];
    return fakulteler;
  }

  static List bolumSayisi() {
    List<List> fakulteler = [
      ["Diş Hekimliği Bölümü"],
      [
        "Rehberlik ve Psikolojik Danışmanlık",
        "Alman Dili Eğitimi",
        "Özel Eğitim",
        "Türkçe Eğitimi",
        "Sosyal Bilgiler Eğitimi",
        "Matematik Eğitimi",
        "İngiliz Dili Eğitimi",
        "Bilgisayar ve Öğretim Teknolojileri",
        "Okul Öncesi Eğitimi",
        "Sınıf Eğitimi",
        "Fransız Dili Eğitimi",
        "Resim-İş Eğitimi",
        "Müzik Eğitimi",
        "Fen Bilgisi Eğitimi",
        "Eğitim Programları ve Öğretim Ana Bilim Dalı",
        "Eğitimde Ölçme ve Değerlendirme Ana Bilim Dalı",
        "Eğitim Yönetimi Ana Bilim Dalı",
        "Hayat Boyu Öğrenme Ana Bilim Dalı"
      ],
      [
        "Biyoloji Bölümü",
        "Coğrafya Bölümü",
        "Fizik Bölümü",
        "Kimya Bölümü",
        "Matematik Bölümü",
        "Moleküler Biyoloji ve Genetik",
        "Psikoloji Bölümü",
        "Sanat Tarihi",
        "Sosyoloji Bölümü",
        "Türk Dili ve Edebiyatı Bölümü",
        "Arkeoloji Bölümü",
        "Felsefe Bölümü",
        "Tarih Bölümü"
      ],
      [
        "Endüstri Tasarımı Bölümü",
        "Grafik Bölümü",
        "Resim Bölümü",
        "Sahne Sanatları",
        "Seramik Cam Bölümü",
        "Tekstil Moda",
        "Geleneksel Türk Sanatları Bölümü"
      ],
      ["Mali Hukuk Anabilim Dalı"],
      [
        "Uluslararası İlişkiler Bölüm Başkanlığı",
        "Çalışma Ekonomisi ve Endüstri İlişkileri Bölümü",
        "Siyaset Bilimi ve Kamu Yönetimi Bölümü",
        "Maliye Bölümü",
        "İktisat Bölümü",
        "Ekonometri Bölümü",
        "İşletme Bölümü"
      ],
      [
        "İslam Tarihi ve Sanatları"
            "Felsefe Din Bilimleri"
            "Temel İslam Bilimleri"
            "İlahiyat Fakültesi Kütüphanesi"
            "İslam Tarihi ve Sanatları Bölümü"
      ],
      ["İnegöl İşletme Bölümü"],
      ["Mimarlık Bölümü"],
      [
        "Makine Mühendisliği",
        "Otomotiv Mühendisliği",
        "Bilgisayar Mühendisliği",
        "Çevre Mühendisliği",
        "Elektrik Elektronik Mühendisliği",
        "Tekstil Mühendisliği",
        "İnşaat Mühendisliği",
        "Endüstri Mühendisliği",
        "Ekserji 2022"
      ],
      ["Antrenörlük Eğitimi Bölümü"],
      [
        "Sosyal Hizmet Bölümü",
        "Acil Yardım ve Afet Yönetimi Bölümü",
        "Ebelik Bölümü",
        "Fizyoterapi ve Rehabilitasyon Bölümü",
        "Beslenme ve Diyetetik Bölümü",
        "Hemşirelik Bölümü"
      ],
      [
        "Tıbbi Genetik Anabilim Dalı",
        "Göğüs Hastalıkları Anabilim Dalı",
        "Çocuk Cerrahisi Anabilim Dalı",
        "İmmünoloji Anabilim Dalı",
        "Göz Hastalıkları Anabilim Dalı",
        "Deney Hayvanları Yetiştirme ve Araştırma Birimi"
      ],
      ["Veteriner Bölümü"],
      [
        "Bahçe Bitkileri",
        "Gıda Mühendisliği",
        "Zootekni",
        "Bitki Koruma",
        "Toprak Bilimi ve Bitki Besleme",
        "Tarım Ekonomisi",
        "Biyosistem Mühendisliği",
        "Peyzaj",
        "Tarla Bitkileri Bölümü",
        "Journal of Biological & Environmental Sciences (JBES)"
      ]
    ];
    return fakulteler;
  }

  static List fakultelerIcon() {
    List<Icon> fakulteler = [
      Icon(
        Symbols.dentistry,
        color: Colors.white,
      ),
      Icon(
        Symbols.school,
        color: Colors.white,
      ),
      Icon(
        Symbols.history_edu,
        color: Colors.white,
      ),
      Icon(
        Symbols.brush,
        color: Colors.white,
      ),
      Icon(
        Symbols.gavel,
        color: Colors.white,
      ),
      Icon(
        Symbols.receipt_long,
        color: Colors.white,
      ),
      Icon(
        Symbols.mosque,
        color: Colors.white,
      ),
      Icon(
        Symbols.work,
        color: Colors.white,
      ),
      Icon(
        Symbols.location_city,
        color: Colors.white,
      ),
      Icon(
        Symbols.engineering,
        color: Colors.white,
      ),
      Icon(
        Symbols.directions_run,
        color: Colors.white,
      ),
      Icon(
        Symbols.sports,
        color: Colors.white,
      ),
      Icon(
        Symbols.stethoscope,
        color: Colors.white,
      ),
      Icon(
        Symbols.pets,
        color: Colors.white,
      ),
      Icon(
        Symbols.agriculture,
        color: Colors.white,
      )
    ];
    return fakulteler;
  }
}
