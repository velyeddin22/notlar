import 'package:flutter/material.dart';
import 'package:not/details/colors.dart';

import '../widgets/sizeconfig.dart';

class kullanimKosullari extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 375;

    return Scaffold(
      appBar: AppBar(
        title: Text("Koşullar ve Şartla"),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: b * 30),
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sh(42),
                        Text(
                          "Son güncelleme: 22 Nisan 2024",
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                            color: Color(0xff999999),
                          ),
                        ),
                        sh(10),
                        Text(
                          'LUNA Video chat Kullanıcı Sözleşmesi',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          '1. Satıcı, işlem sırasında sınırlı bir iade veya iptal politikasını doğru bir şekilde açıklamıştır. Web sitemizde açık ve öz bir politika beyanı geliştiriyor ve bunları ana sayfamızdaki bağlantılar aracılığıyla müşterilerimizin kullanımına sunuyoruz.İptal politikasının ayrıntıları için lütfen 6. maddeye bakın.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '1. Özel Bildirimler',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Bu LUNA video chat Kullanıcı Sözleşmesi (bu "Sözleşme"), bizim tarafımızdan geliştirilen bir video akış uygulaması ve sosyal ağ olan LUNA Uygulaması dahil hizmetlerimizi (bundan böyle "Hizmetler" denilecektir) kullanımınıza yönelik yönetmeliği içerir. Taraflardan biri siz ve diğeri de  LUNA video chat bağlı şirketlerinden (bundan böyle "biz" veya " LUNA video chat " olarak söz edilecektir) biridir. Bu Sözleşmenin amaçları doğrultusunda, siz ve LUNA video chat birlikte "Taraflar" ve sırasıyla "Taraf" olarak anılacaktır Bu sözlesmenin uygulanmasından veya yorumlanmasindan dogacak her türlü uyuşmazlığın çözümünde, Türkiye cumhuriyeti yasaları uygulanır; Niğde adliyesi mahkemeleri ve icra daireleri yetkilidir.\nHizmetleri kullanırken, LUNA video chat Gizlilik Politikasına, LUNA video chat Topluluk Sözleşmelerine, Yayıncı Sözleşmesine tabi olacaksınız. Bunun yannında Hizmetlerde yayınlanan, kullanımınıza sunulan veya bu hizmetlerle bağlantılı olarak size açıklanan belirli servis ve özellikler için geçerli olan ek yönergelere veya kurallara tabi olacaksınız. Ayrıca, bu tür hizmetlerle bağlantılı olarak size açıklanan ek hüküm veya koşullara tabi olan belirli ücretli hizmetler de sunabiliriz.\nHizmetlerimizi kullanarak veya kayıt işlemi sırasında "Kaydol" seçeneğine tıklayarak bu Sözleşmenin tüm şartlarını kabul etmiş olursunuz. Tamamen kendi takdirimize bağlı olarak, bu Sözleşmeyi zaman zaman revize edebiliriz ve mevcut sürüm belirtilen bağlantıda bulunabilir: Hakkımızda> Kullanıcı Sözleşmesi. Hizmetlerimizden yararlanmaya devam ederek, revize edilmiş Sözleşmeye bağlı kalmayı kabul edersiniz.\nHizmetleri, 18 yaşın altındakiler kullanamazlar. Hizmetleri kullanmaya başladığınızda;\n(1) aşağıda tanımlandığı üzere “Asgari Yaş”ta veya üzerinde olduğunuzu; ve\n(2) LUNA video chat Hizmetlerini kullanmaktan kısıtlanmamış olduğunuzu, doğru olmayan bilgiler ile hesap açmamış olduğunuzu, bununla birlikte, başkasına adına veya 18 yaş altındaki biri adına hesap açmanızın kullanıcı şartlarını ihlal ettiğiniz anlamına geldiğini kabul etmektesiniz.\n“Asgari Yaş”ın anlamı 18 yaşında olmaktır. Ancak, yargı bölgenizdeki yasalar, LUNA video chat Hizmetleri size yasal olarak ebeveyn izni olmadan (kişisel verilerinizin kullanılması dahil) sunabilmesi için Asgari Yaş’tan büyük olmanızı gerektiriyorsa, Asgari Yaş yasada belirtilen yaştır.\nLUNA video chat hesabınızın ve şifrenizin güvenliğinden yalnızca siz sorumlu olacaksınız. LUNA video chat hesabınız aracılığıyla gerçekleştirilen tüm davranışlar ve faaliyetler, yalnızca sizin sorumlu olacağınız davranışlarınız ve faaliyetleriniz olarak kabul edilecektir.\nKüba, İran, Kuzey Kore, Sudan, Suriye ve Kırım bölgesindeki bireyler veya kuruluşlardan ödeme kabul etmiyoruz veya onlarla iş yapmıyoruz. Bu bölgelerden iseniz, Hizmetleri kullanmanız yasaklanabilir.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '2. Hizmet İçeriği',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Misyonumuz insanlara bir topluluk oluşturma, dünyanın farklı yerlerindeki insanları bir araya getirme ve güzel anlarını paylaşma gücü vermektir. Bir milyar insanın hayatına ilham veren bir içerik platformu olma vizyonuyla bu misyonu ilerletmeye yardımcı olmak için size aşağıda açıklanan hizmetleri sunuyoruz:\ni. Kullanıcı Tarafından Oluşturulan İçerikler\nLUNA video chat, kullanıcıların canlı yayın başlatmasına, sohbet, ilan tahtaları, forum gönderileri, sesli etkileşimli hizmetler gibi hizmetleri kullanmalarına ve Hizmetler ("Kullanıcı İçeriği") içindeki metin, ses, resim, uygulama, kod veya diğer veri ve materyaller ile içerik ve mesajlar oluşturabilecekleri, gönderebilecekleri, iletebilecekleri, gerçekleştirebilecekleri veya depolayabilecekleri diğer etkinliklere katılmalarına olanak tanır. Hizmet kullanıcıları ayrıca LUNA video chat tarafından sağlanan müzik, grafik, çıkartma, sanal öğeler ve diğer özellikleri ("LUNA video chat Özellikleri") bu Kullanıcı İçeriğinin üzerine yerleştirebilir ve bu Kullanıcı İçeriğini Hizmetler aracılığıyla iletebilir. Hizmetlerde diğer kullanıcılar tarafından ifade edilen görüşler (sanal hediyelerin kullanımı dahil) bizim görüşlerimizi veya değerlerimizi temsil etmemektedir.\nii. İlginizi çekebilecek içerik, ürün ve hizmetleri keşfetmenize yardımcı olmak\nLUNA video chat kullanan birçok işletme ve kuruluş tarafından sunulan içerik, ürün ve hizmetleri keşfetmenize yardımcı olmak için size reklamlar, teklifler ve diğer sponsorlu içerikleri gösteririz.\niii. Zararlı davranışlarla mücadele etmek ve topluluğumuzu korumak ve desteklemek\nHizmetlerimizin kötüye kullanımını, başkalarına karşı zararlı davranışları ve topluluğumuzu desteklemeye veya korumaya daha iyi yardımcı olabileceğimiz durumları tespit etmek için dünya çapında özel ekipler çalıştırıyoruz ve ileri teknik sistemler geliştiriyoruz. Bu tür zararlı içerik veya davranışlardan haberdar olursak, uygun önlemleri alacağız - örneğin, destek önermek, içeriği kaldırmak, belirli özelliklere erişimi kaldırmak veya kısıtlamak, bir hesabı devre dışı bırakmak veya kanun uygulayıcılarla iletişim kurmak.\niv. Hizmetlerimize küresel erişim\nKüresel olarak hizmet verebilmek için, ikamet ettiğiniz ülkenin dışındaki yerler de dahil olmak üzere dünyanın her yerindeki veri merkezlerimizde ve sistemlerimizde içerik ve verileri depolamamız ve dağıtmamız gerekir. Bu altyapı LUNA video chat ve iştirakleri tarafından işletilebilir veya kontrol edilebilir.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '3. Hesap',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Bir hesap açabilmeniz için, hesap adı ve şifre gibi belirli bilgileri bize vermeniz istenecektir.\n\nHesabınızın ve şifrenizin gizliliğini korumaktan, bilgisayarınıza erişimi kısıtlamaktan ve hesabınız veya şifrenizle gerçekleşen tüm faaliyetlerden yalnızca siz sorumlusunuz. Lütfen kayıt sırasında ve diğer zamanlarda LUNA video chat sağladığınız bilgilerin bilginiz dahilinde doğru, kesin, güncel ve eksiksiz olduğundan emin olun. \n\n Bazı üçüncü taraf hizmetleri aracılığıyla Hizmetlerimize kaydolmanıza ve oturum açmanıza izin verebiliriz. Üçüncü tarafın bilgilerinizi toplaması, kullanması ve ifşa etmesi, söz konusu üçüncü taraf hizmetinin gizlilik politikasına tabi olacaktır. LUNA video chat kişisel bilgilerinizi nasıl topladığı, kullandığı ve ifşa ettiği hakkında daha fazla bilgiyi LUNA video chat hesabınızı ve herhangi bir üçüncü şahıs hizmetindeki hesabınızla bağladığınızda Gizlilik Politikamızda bulabilirsiniz. \n\n Bu şartların herhangi bir hükmüne uymamanız veya hesabınızda Hizmetlere zarar verici, herhangi bir üçüncü taraf hakkını, herhangi bir geçerli yasa veya düzenlemeyi ihlal edici faaliyetin hesabınızda meydana gelmesi dahil olmak üzere, herhangi bir zamanda kullanıcı hesabınızı devre dışı bırakma hakkını tamamen kendi takdirimize bağlı olarak saklı tutuyoruz. \n\n Eğer artık Hizmetlerimizi kullanmak istemiyorsanız, uygulama içinde destek@lunalive.com üzerinden mail göndererek hesabınızın silinmesini talep edebilirsiniz. Alternatif olarak, Hesabınızı silme konusunda herhangi bir sorun yaşarsanız, bunu sizin için biz halledebiliriz. Lütfen destek@lunalive.com adresinden bize ulaşın, size daha fazla yardımcı olacak ve süreç boyunca size rehberlik edecek bir destek sağlayacağız. Hesabınızı sildiğinizde, hesabınızı yeniden etkinleştiremez veya eklediğiniz içerik veya bilgileri kurtaramazsınız. Kişisel bilgilerinizin silinme ve silinme hakkınız hakkında daha fazla bilgi için Gizlilik Politikamızı inceleyin.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '4. Gizlilik',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Gizliliğiniz LUNA video chat için önemlidir. Kişisel bilgilerinizi nasıl topladığımız, kullandığımız ve açıkladığımız ve Hizmetleri kullandığınızda çevrimiçi gizliliğinizi nasıl yönetebileceğinizle ilgili bilgiler için lütfen Gizlilik Politikamıza bakın.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '5. Hizmetlerin Kullanımı',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Hizmetlere erişiminiz ve kullanımınız bu şartlara ve tüm geçerli yasa ve düzenlemelere tabidir. Bu Hizmet şartlarına ve LUNA video chat Topluluk Kurallarına uyacağınızı ve şunları yapmayacağınızı kabul edersiniz: \n\n i. yanlış, yasadışı, ihlal eden, karalayıcı, müstehcen, pornografik, mahremiyet veya tanıtım haklarını ihlal eden, taciz edici, tehdit edici, küfürlü, kışkırtıcı veya başka bir şekilde sakıncalı içerik oluşturmak, yüklemek, iletmek, dağıtmak veya depolamak; \n\n ii. herhangi bir kişi veya kuruluşun kimliğine bürünmek, yanlış bir şekilde herhangi bir kişi veya kuruluşla bir ilişkisi olduğunu iddia etmek veya başkalarının LUNA video chat hesaplarına izinsiz erişmek, başka bir kişinin kimliğini veya Hizmetler aracılığıyla iletilen bilgilerin içeriğini taklit etmek veya başka herhangi bir benzer dolandırıcılık faaliyetinde bulunmak; \n\n iii. LUNA video chat kullanıcılarını kötüye kullanmak, taciz etmek, taciz etmek, tehdit etmek veya dolandırmak veya kullanıcılar veya üçüncü şahıslar hakkında rızaları olmadan kişisel bilgiler toplamak veya toplamaya teşebbüs etmek; \n\n iv. Hizmetlerin veya Kullanıcı İçeriğinin güvenlikle ilgili özelliklerini, Hizmetler aracılığıyla erişilebilen herhangi bir içeriğin kullanımını veya kopyalanmasını engelleyen veya kısıtlayan özellikleri, kullanım sınırlamalarını uygulayan özellikleri kaldırma, atlatma, devre dışı bırakma, bu özelliklere hasar verme veya başka şekilde müdahale etme, Kullanıcı İçeriği veya Hizmetler üzerindeki telif hakkı veya diğer mülkiyet hakkı bildirimlerini silme; \n\n v. Hizmetlerin veya herhangi bir kısmının kaynak kodunu tersine döndürme, kaynak koda dönüştürme, parçalarına ayırma veya başka bir şekilde keşfetme girişiminde bulunma; ancak ve yalnızca bu etkinlikleri, ikamet ettiğiniz yargı yetkisinin kanunlarınca açıkça izin verildiği ölçüler dışında gerçekleştirmeme; \n\n vi. Hizmetlere veya herhangi bir kısmına dayalı olarak, bu tür bir faaliyete, bu sınırlamaya bakılmaksızın, yürürlükteki yasalar tarafından açıkça izin verildiği müddetçe ve yalnızca bu tür faaliyetlere dayalı olarak değişiklik yapmak, uyarlamak, tercüme etmek veya türev çalışmalar oluşturmak; \n\n vii. virüsler, reklam yazılımları, casus yazılımlar, solucanlar veya diğer kötü amaçlı kodların yüklenmesi veya başka şekilde yayılması dahil olmak üzere herhangi bir yolla Hizmetlerin çalışmasına veya herhangi bir kullanıcının bunlardan yararlanmasına müdahale etmek veya zarar vermek; \n\n viii. Twitch Hizmetleri aracılığıyla iletilen herhangi bir Kullanıcı İçeriğinin kökenini gizlemek için tanımlayıcıları değiştirmek; \n\n ix. Hizmetlere veya Hizmetlere bağlı sunuculara veya ağlara müdahale etmek veya bunları bozmak veya Hizmetlere bağlı ağların gerekliliklerine, prosedürlerine, politikalarına veya düzenlemelerine uymamak; Hizmetleri, diğer kullanıcıların Hizmetlerden tam olarak yararlanmasını engelleyebilecek, kesintiye uğratacak, olumsuz etkileyebilecek veya Hizmetlerin işleyişine herhangi bir şekilde zarar verebilecek, devre dışı bırakabilecek, aşırı yüklenmesine yol açacak veya bozabilecek herhangi bir şekilde kullanmak; \n\n x. kullandığımız herhangi bir içerik filtreleme tekniğini atlatmaya çalışmak veya erişim yetkiniz olmayan herhangi bir hizmet veya Hizmet alanına erişmeye çalışmak; \n\n xi. Hizmetleri herhangi bir yasadışı amaç için veya fikri mülkiyet ve diğer mülkiyet hakları, veri koruma ve gizlilik dahil ancak bunlarla sınırlı olmamak üzere yerel, eyalet, ulusal veya uluslararası bazda yasa veya düzenlemeleri ihlal edecek şekilde kullanmak. \n\n LUNA video chat, herhangi bir Kullanıcı İçeriği veya bunlardan kaynaklanan herhangi bir kayıp veya zarar için hiçbir sorumluluk almaz ve sorumluluk kabul etmez. Ayrıca LUNA video chat,Hizmetleri kullanırken karşılaşabileceğiniz herhangi bir hata, iftira, ihmal, yanlışlık, müstehcenlik, pornografi veya küfürden sorumlu değildir. Hizmetleri kullanımınızın riski size aittir. Buna ek olarak, bu kurallar herhangi bir üçüncü taraf adına herhangi bir özel dava hakkı veya Hizmetlerin bu tür kurallar tarafından yasaklanan herhangi bir içeriği içermeyeceğine dair herhangi bir makul beklenti oluşturmaz. \n\n LUNA video chat, Kullanıcı İçeriğinde yer alan herhangi bir beyan veya beyandan sorumlu değildir. LUNA video chat, burada ifade edilen herhangi bir Kullanıcı İçeriğini, fikrini, tavsiyesini veya tavsiyeyi desteklemez ve LUNA video chat, Kullanıcı İçeriği ile bağlantılı her türlü sorumluluğu açıkça reddeder. Yürürlükteki yasaların izin verdiği en geniş ölçüde, LUNA video chat, bu Kullanıcı İçeriğinin Hizmetlerin bu Kullanım koşullarını ihlal ettiği durumlar da dahil olmak üzere, Hizmetlerde yayınlanan veya depolanan Kullanıcı İçeriğini istediği zaman ve bildirimde bulunmaksızın kaldırma, görüntüleme veya düzenleme hakkını saklı tutar. Yürürlükteki yasalar ve Hizmetler üzerinde yayınladığınız veya sakladığınız Kullanıcı İçeriğinin yedek kopyalarını oluşturmak ve değiştirmek tamamen sizin sorumluluğunuzdadır. Yukarıdakileri ihlal edecek şekilde Hizmetlerin herhangi bir şekilde kullanılması, Hizmetlerin bu Kullanım şartlarını ihlal eder ve diğer şeylerin yanı sıra Hizmetleri kullanma haklarınızın feshedilmesine veya askıya alınmasına neden olabilir.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '6. Sanal Öğeler',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Yalnızca sanal Coinler ("Elmaslar") ve sanal hediyeler (Hediye) satın alabilir, başkalarına Hediye gönderebilir, parasal değeri olan Hediyeler alabilir, sanal coin kazanabilir ve 18 yaşında ve üzeri iseniz (veya bulunduğunuz yargı bölgesinde reşitseniz) Coinleri çekebilirsiniz. \n\n COINLERIN fiyatı, satın alma noktasında gösterilecektir. Coin için tüm ücretler ve ödemeler, ilgili ödeme mekanizması aracılığıyla satın alma noktasında belirtilen para biriminde yapılacaktır. Döviz takas ödemeleri, yabancı işlem ücretleri ve varsa ödeme kanalı ücretleri, ilgili ödeme sağlayıcısıyla yaptığınız sözleşmeye bağlıdır. \n\n Satın aldığınız herhangi bir Elmasın ödenmesinden siz sorumlu olacaksınız. Satın alma işleminiz tamamlandığında, kullanıcı hesabınıza Elmas yatırılacaktır. Elmaslar, Hediye satın almak için kullanılabilir. Elmaslar, nakit veya yasal banknot ile veya herhangi bir eyalet, bölge veya herhangi bir siyasi varlığın para birimi veya başka herhangi bir kredi formu ile takas edilemez. Elmaslar yalnızca LUNA video chat ve Hizmetlerimizin bir parçası olarak kullanılabilir ve tarafımızca belirtilmiş olanlar dışında diğer promosyonlar, kuponlar, indirimler veya özel tekliflerle birleştirilemez veya birlikte kullanılamaz. \n\n Bu Sözleşmede aksi belirtilmedikçe, tüm coin ve Hediye satışları nihaidir ve satın alınan coinler ve Hediyeler için geri ödeme yapmıyoruz. Coin ve Hediyeler nakit paraya çevrilemez veya takas edilemez veya herhangi bir nedenle tarafımızdan iade veya geri ödenemez.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '7. Ödeme Koşulları',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Ödeme şekli olarak belli google play satın al, belirli banka kartlarını ve / veya sitemiz aracılığıyla size zaman zaman sunabileceğimiz diğer ödeme yöntemlerini kabul ediyoruz. Seçtiğiniz ödeme yönteminin tüm hüküm ve koşullarına tabisiniz. Hizmet aracılığıyla bir sipariş göndererek, bize veya belirlenen ödeme işlemi ortaklarımıza, satın alma tutarı için belirttiğiniz hesaptan ücret alma yetkisi verirsiniz. Diğer para birimlerinin LUNA video chat tarafından uygun görülen ödeme yöntemleriyle sunulduğu durumlar haricinde tüm ödemeler Türk lirasi cinsinden yapılacaktır. \n\n Ödeme işlemi ortaklarımız, finansal kurumları aracılığıyla ödeme yapmak ve geçerli uluslararası, ulusal, ulusal ve uluslararası mevzuata uymak amacıyla belirli kişisel verileri (ör. Devlet tarafından verilmiş geçerli bir kimlik, yasal adınız, adresiniz ve doğum tarihiniz) sağlamanızı isteyebilir. federal, eyalet ve yerel yasalar ve düzenlemeler. Ayrıca, ödemelerle ilgili herhangi bir soruna ilişkin sizinle doğrudan iletişim kurabilirler. Buna ek olarak, LUNA video chat ödeme tutarları ve yöntemleri ile sınırlı olmamak üzere tüm satın alma işlemleri ile ilgili olarak sizinle doğrudan iletişime geçebilir. Yukarıda belirtilen hususlarla ilgili olarak, sizinle iletişime geçildikten sonra LUNA video chat tarafından uygun görülmesi halinde talep edilen işlemlerin tamamlanması için sizden yazılı onay da istenebilir. \n\n Ödeme yönteminizle ilgili sorunlar nedeniyle bir satın alma işlemi çevrimiçi olarak reddedildiyse, lütfen tüm verilerin doğru olduğundan emin olun ve yeniden gönderin. İşlem çevrimiçi olarak kabul edilmezse, lütfen satın alma ile bağlantılı olarak size verilen e-posta adresi aracılığıyla müşteri desteği ile iletişime geçin. Hizmet ile ilgili satın alma işlemleri için LUNA video chat ile iletişime geçebilirsiniz.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '8. Fikri Mülkiyet Hakları',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'LUNA video chat tarafından sağlanan Hizmetler dahilindeki tüm metin, veri, resim, grafik, ses ve / veya video bilgileri ve diğer materyaller, LUNA video chat mülkiyetindedir ve telif hakkı, ticari marka ve / veya diğer mülkiyet hakları yasaları ile korunmaktadır. Bu Sözleşmedeki hiçbir şey, size LUNA video chat tarafından herhangi bir fikri mülkiyet hakkı veya bu tür materyallerin lisansını veriyor olarak yorumlanmayacaktır. \n\n Bir LUNA video chat Hizmetleri aracılığıyla herhangi bir canlı akış içeriğini veya diğer içeriği kullanarak ve / veya LUNA video chat web sitesinin halka açık alanlarına yükleyerek, LUNA video chat ve alt lisans sahiplerine içerkilerle ilgili şu izinleri verirsiniz: Ücretsiz, kalıcı, geri alınamaz, münhasır olmayan ve tamamen alt lisanslanabilir haklar ve lisanslar, bunların herhangi bir bölge veya zaman sınırlaması olmaksızın ve herhangi bir onay ve / veya tazminat gerektirmeden kullanılması, kopyalanması, değiştirilmesi, uyarlanması, yayınlanması, tercüme edilmesi, düzenlenmesi, elden çıkarılması, türetilmiş çalışmalar oluşturulması ve dağıştılması ve bu tür içeriklerin (tamamen veya kısmen) kamuya açık olarak sergilenmesi ve / veya bu içeriklerin mevcut veya gelecekteki çalışmalara, medya veya teknoloji biçimlerine dahil edilmesi.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '9. Sonlandırma Hizmetleri',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Yürürlükteki yasaların izin verdiği en geniş ölçüde, LUNA video chat, önceden haber vermeksizin ve tamamen bizim takdirimize bağlı olarak, Hizmetleri kullanma lisansınızı (Kullanıcı İçeriğini yayınlamak dahil) feshetme ve gelecekte erişiminizi ve kullanımınızı engelleme veya engelleme hakkını saklı tutar. Bu eylemlerin gerçekleştirebileceği durumlar aşağıda makul olarak değerlendirdiğimiz durumlardır: (a) Hizmetleri kullanımınız bu Sözleşmeyi veya geçerli yasayı ihlal ediyor; "(b) Hizmetleri sahtekarlık için veya kötüye kullanıyorsunuz; veya (c) teknik veya meşru ticari nedenlerden dolayı Hizmetleri size sağlamaya devam edemiyoruz. Bu, satın alınan herhangi bir ürüne erişiminizi sonlandırma veya askıya alma yetkinliği içerir. Yürürlükteki yasaların izin verdiği en geniş ölçüde, (i) Hizmetlere, (ii) bu Hizmet şartlarının herhangi bir şartına, (iii) LUNA video chat Hizmetlerin yönetilmesiyle ilgili herhangi bir politikaya veya bunların uygulanmasına (iv) Hizmetler aracılığıyla iletilen herhangi bir içerik veya bilgiye dair duyduğunuz memnuniyetsizliğe yönelik tek çözümünüz hesabınızı sonlandırmak ve Hizmetlerimizn herhangi bir bölümünü veya tüm bölümlerini kullanmayı bırakmaktır.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '10. Sorumluluk Reddi',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'LUNA video chat Hizmetlerinin kullanımıyla ilgili tüm risklerden tamamen siz sorumlu olacaksınız. LUNA video chat Hizmetlerinin herhangi bir şekilde kullanılması veya bunlara güvenilmesinin riski size ait olacaktır. \n\n LUNA video chat, hiçbir koşulda Hizmetlerin gereksinimlerinizi karşılayacağını veya Hizmetlerin kesintisiz olacağını garanti etmez. Hizmetlerin güncelliği, güvenliği ve doğruluğu da garanti edilmez. Hizmetlerin LUNA video chat tarafından "olduğu gibi" sağlandığını onaylar ve kabul edersiniz. LUNA video chat, bu Hizmetlerin veya herhangi bir kısmının işletilmesi ve sağlanmasıyla ilgili açık veya zımni hiçbir beyanda bulunmaz veya garanti vermez. LUNA video chat, Hizmetlerin kalitesi, güncelliği, doğruluğu veya bütünlüğünden hiçbir şekilde sorumlu olmayacak ve bu tür Hizmetleri kullanmanızdan doğabilecek sonuçlardan sorumlu olmayacaktır. \n\n LUNA video chat, Hizmetler kullanılarak erişilebilen herhangi bir harici bağlantının ve / veya size kolaylık sağlamak için yerleştirilmiş herhangi bir harici bağlantının doğruluğunu ve bütünlüğünü garanti etmez. LUNA video chat, bağlantılı herhangi bir sitenin içeriğinden veya bağlantılı bir sitede yer alan herhangi bir bağlantıdan sorumlu olmayacaktır ve LUNA video chat, Hizmetlerin sizin tarafınızdan kullanımıyla bağlantılı herhangi bir kayıp veya hasardan doğrudan veya dolaylı olarak sorumlu veya yükümlü tutulmayacaktır.Ayrıca LUNA video chat, LUNA video chat kontrolü altında olmayan harici bir bağlantı aracılığıyla yönlendirildiğiniz herhangi bir web sayfasının içeriğinden sorumlu olmayacaktır. \n\n LUNA video chat, mücbir sebep durumlarından kaynaklanan veya LUNA video chat kontrolü dışında olan Hizmetlerin kesintiye uğraması veya diğer yetersizliklerden sorumlu değildir. Bununla birlikte, LUNA video chat, mümkün olduğu ölçüde, sizin üzerinizde oluşan kayıpları ve etkileri en aza indirmeye makul bir şekilde çalışacaktır.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '11. Adli Yargı',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Bu Sözleşme, hukuk ilkelerinin seçimine bakılmaksızın, TURKIYE CUMHURIYETI DEVLETININ yasalarına tabi olacak ve bu yasalara göre yorumlanacaktır. Varlığı, geçerliliği veya feshi ile ilgili herhangi bir soru da dahil olmak üzere, bu Sözleşmeden kaynaklanan veya bu Sözleşmeyle bağlantılı olarak ortaya çıkan herhangi bir anlaşmazlık, Niğde adliyesi Mahkemeleri ve icra Daireleri yetkilidir. Bu maddedeki kuralların referans olarak dahil edilmesine bu Merkez karar verir. Tahkim yeri Türkiye niğde olacaktır. Tahkim dili Türkçe olacaktır. Bir istekte bulunmak için lütfen buraya gidin.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '12. Bilgi isteme',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Beklenen, olası veya mevcut yasal işlemler, soruşturmalar veya anlaşmazlıklar veya üçüncü şahıs kullanıcı bilgileriyle ilgili LUNA video chat Hizmetlerinden tüm bilgi veya belge talepleri, uygun yasal süreç düzeyi kullanılarak yapılmalıdır ve LUNA video chat aracılığı ile LUNA video chate uygun şekilde sunulmalıdır.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '13. Sözleşmenin Değiştirilmesi',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Zaman zaman, örneğin Hizmetlerimizin işlevselliğini güncellediğimizde, tarafımızdan veya bağlı kuruluşlarımız tarafından işletilen birden fazla uygulamayı veya hizmeti tek bir birleşik hizmet veya uygulamada birleştirdiğimizde veya yasal değişiklikler olduğunda bu Sözleşmenin bu şartlarını değiştiririz. LUNA video chat platformunda bildirim yolu örneğinde olduğu gibi, bu şartlarda yapılan herhangi bir önemli değişikliği genel olarak tüm kullanıcıları bilgilendirmek için ticari açıdan makul olan çabayı göstereceğiz. Ancak, bu tür değişiklikleri kontrol etmek için Sözleşmeye düzenli olarak bakmalısınız. Yeni şartların tarihinden sonra Hizmetleri kullanmaya devam etmeniz, yeni şartları kabul ettiğiniz anlamına gelir. Yeni şartları kabul etmiyorsanız, Hizmetlere erişmeyi veya Hizmetleri kullanmayı bırakmalısınız.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(10),
                        Text(
                          '14. Diğer Koşullar',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Bu Sözleşme, her iki taraf arasında mutabık kalınan maddeler ve diğer ilgili konuların tamamen uzlaşmasını oluşturur. Bu Sözleşmede öngörülenler dışında, bu Sözleşmenin Taraflarından herhangi birine başka hiçbir hak verilmemektedir. \n\n Bu Sözleşmenin herhangi bir hükmü, herhangi bir nedenle kısmen veya tamamen yetkili makamlar tarafından geçersiz kılınır veya uygulanamaz hale gelirse, bu Sözleşmenin geri kalan hükümleri geçerli ve bağlayıcı kalacaktır.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        sh(10),
                        Text(
                          'Gizlilik Politikası',
                          style: TextStyle(
                            fontSize: b * 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                        Text(
                          'Son güncellenme: 19/04/2024 \n\n Güvenliğiniz bizim için önemli. Bu sebeple bizimle paylaşacağınız kişisel verileriz hassasiyetle korunmaktadır.  Biz, Luna, veri sorumlusu olarak, bu gizlilik ve kişisel verilerin korunması politikası ile, hangi kişisel verilerinizin hangi amaçla işleneceği,  işlenen verilerin kimlerle ve neden paylaşılabileceği,   veri işleme yöntemimiz ve hukuki sebeplerimiz ile; işlenen verilerinize ilişkin haklarınızın neler olduğu hususunda sizleri aydınlatmayı amaçlıyoruz. Toplanan Kişisel Verileriniz, Toplanma Yöntemi ve Hukuki Sebebi  Kimlik, (isim, soy isim, doğum tarihi gibi) iletişim, (adres, e-posta adresi, telefon, IP, konum gibi) özlük, sosyal medya, finans bilgileriniz ile  görsel ve işitsel kayıtlarınız tarafımızca, çerezler (cookies) vb. teknolojiler vasıtasıyla, otomatik veya otomatik olmayan yöntemlerle ve  bazen de analitik sağlayıcılar, reklam ağları, arama bilgi sağlayıcıları, teknoloji sağlayıcıları gibi üçüncü taraflardan elde edilerek, kaydedilerek, depolanarak ve güncellenerek, aramızdaki hizmet ve sözleşme ilişkisi çerçevesinde ve süresince, meşru menfaat işleme şartına dayanılarak işlenecektir.  Kişisel Verilerinizin İşlenme Amacı  Bizimle paylaştığınız kişisel verileriniz; hizmetlerimizden faydalanabilmeniz amacıyla sizlerle sözleşmeler kurabilmek, sunduğumuz hizmetlerin gerekliliklerini  en iyi şekilde ve aramızdaki sözleşmelere uygun olarak yerine getirebilmek, bu sözleşmelerden doğan haklarınızın tarafınızca kullanılmasını sağlayabilmek,  ürün ve hizmetlerimizi, ihtiyaçlarınız doğrultusunda geliştirebilmek ve bu gelişmelerden sizleri haberdar edebilmek, ayrıca sizleri daha geniş kapsamlı hizmet sağlayıcıları ile yasal çerçeveler içerisinde buluşturabilmek ve kanundan doğan zorunlulukların (kişisel verilerin talep halinde   adli ve idari makamlarla paylaşılması) yerine getirilebilmesi amacıyla, sözleşme ve hizmet süresince, amacına uygun ve ölçülü bir şekilde işlenecek ve güncellenecektir. Toplanan Kişisel Verilerin Kimlere ve Hangi Amaçlarla Aktarılabileceği  Bizimle paylaştığınız kişisel verileriniz; faaliyetlerimizi yürütmek üzere hizmet aldığımız ve/veya verdiğimiz, sözleşmesel ilişki içerisinde bulunduğumuz,  iş birliği yaptığımız, yurt içi ve yurt dışındaki 3. şahıslar ile kurum ve kuruluşlara ve talep halinde adli ve idari makamlara, gerekli teknik ve idari önlemler alınması koşulu ile aktarılabilecektir. Kişisel Verileri İşlenen Kişi Olarak Haklarınız  KVKK madde 11 uyarınca herkes, veri sorumlusuna başvurarak aşağıdaki haklarını kullanabilir: Kişisel veri işlenip işlenmediğini öğrenme, Kişisel verileri işlenmişse buna ilişkin bilgi talep etme, Kişisel verilerin işlenme amacını ve bunların amacına uygun kullanılıp kullanılmadığını öğrenme, Yurt içinde veya yurt dışında kişisel verilerin aktarıldığı üçüncü kişileri bilme, Kişisel verilerin eksik veya yanlış işlenmiş olması hâlinde bunların düzeltilmesini isteme, Kişisel verilerin silinmesini veya yok edilmesini isteme, (e) ve (f) bentleri uyarınca yapılan işlemlerin, kişisel verilerin aktarıldığı üçüncü kişilere bildirilmesini isteme, İşlenen verilerin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi suretiyle kişinin kendisi aleyhine bir sonucun ortaya çıkmasına itiraz etme, Kişisel verilerin kanuna aykırı olarak işlenmesi sebebiyle zarara uğraması hâlinde zararın giderilmesini talep etme, haklarına sahiptir.  Yukarıda sayılan haklarınızı kullanmak üzere destek@lunalive.com üzerinden bizimle iletişime geçebilirsiniz. letişim Sizlere talepleriniz doğrultusunda hizmet sunabilmek amacıyla, sadece gerekli olan kişisel verilerinizin, işbu gizlilik ve kişisel verilerin işlenmesi politikası uyarınca işlenmesini,  kabul edip etmemek hususunda tamamen özgürsünüz. Uygulamayı kullanmaya devam ettiğiniz takdirde, kabul etmiş olduğunuz tarafımızca varsayılacaktır.  Şayet kabul etmiyorsanız, lütfen uygulamayı tüm cihazlarınızdan kaldırınız. Ayrıntılı bilgi için bizimle destek@lunalive.com e-mail adresi üzerinden  iletişime geçmekten lütfen çekinmeyiniz.',
                          style: TextStyle(
                            fontSize: b * 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.6,
                          ),
                        ),
                        sh(21),
                      ],
                    ),
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
