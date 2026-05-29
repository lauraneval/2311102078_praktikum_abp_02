// ============================================================
//  FotoKu — Arsip Koleksi Hobi
//  Flutter Single-File App  |  main.dart
//  Tema: Light Mode · Profesional · Minimalis
//
//  Dependensi (pubspec.yaml):
//    image_picker: ^1.1.2
//    flutter_local_notifications: ^17.2.3
//    intl: ^0.19.0
//    gal: ^2.3.0
//    path_provider: ^2.1.3
//    path: ^1.9.0
//
//  Android AndroidManifest.xml:
//    <uses-permission android:name="android.permission.CAMERA"/>
//    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
//    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="29"/>
//    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
// ============================================================

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gal/gal.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// ────────────────────────────────────────────────────────────
//  NOTIFIKASI
// ────────────────────────────────────────────────────────────

final FlutterLocalNotificationsPlugin _notifPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const init = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    ),
  );
  await _notifPlugin.initialize(init);
  await _notifPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
}

Future<void> showKatalogNotification(String judul, String kategori) async {
  await _notifPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    'Koleksi Baru Ditambahkan',
    '"$judul" berhasil disimpan ke kategori $kategori.',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'fotoku_ch', 'FotoKu',
        channelDescription: 'Notifikasi koleksi baru',
        importance: Importance.high,
        priority: Priority.high,
        color: Color(0xFF2563EB),
        enableVibration: true,
      ),
      iOS: DarwinNotificationDetails(
          presentAlert: true, presentBadge: true, presentSound: true),
    ),
  );
}

// ────────────────────────────────────────────────────────────
//  PALET WARNA — Light Professional
// ────────────────────────────────────────────────────────────

class FC {
  // Backgrounds
  static const bg         = Color(0xFFFAFAFA);   // off-white utama
  static const bgCard     = Color(0xFFFFFFFF);   // putih bersih
  static const bgSecond   = Color(0xFFF3F4F6);   // abu sangat terang
  static const bgThird    = Color(0xFFEFF6FF);   // biru sangat muda

  // Aksen utama — biru profesional
  static const accent     = Color(0xFF2563EB);   // biru primer
  static const accentSoft = Color(0xFFEFF6FF);   // biru muda (bg chip)
  static const accentMid  = Color(0xFF93C5FD);   // biru medium

  // Teks
  static const textDark   = Color(0xFF111827);   // hitam hampir penuh
  static const textMid    = Color(0xFF374151);   // abu gelap
  static const textSub    = Color(0xFF6B7280);   // abu menengah
  static const textHint   = Color(0xFF9CA3AF);   // abu muda

  // Border
  static const border     = Color(0xFFE5E7EB);   // abu sangat muda
  static const borderMid  = Color(0xFFD1D5DB);   // abu sedikit lebih tegas

  // Kategori — diredam, curated
  static const catMerch   = Color(0xFFDC2626);   // merah diredam
  static const catAudio   = Color(0xFF2563EB);   // biru
  static const catFlac    = Color(0xFF059669);   // hijau teal
  static const catVN      = Color(0xFFD97706);   // amber
  static const catBaru    = Color(0xFF7C3AED);   // ungu
  static const catDefault = Color(0xFF0891B2);   // teal

  // Soft backgrounds kategori
  static const catMerchBg  = Color(0xFFFEF2F2);
  static const catAudioBg  = Color(0xFFEFF6FF);
  static const catFlacBg   = Color(0xFFECFDF5);
  static const catVNBg     = Color(0xFFFFFBEB);
  static const catBaruBg   = Color(0xFFF5F3FF);
  static const catDefaultBg= Color(0xFFECFEFF);

  // Status
  static const success    = Color(0xFF059669);
  static const successBg  = Color(0xFFECFDF5);
  static const error      = Color(0xFFDC2626);
  static const errorBg    = Color(0xFFFEF2F2);
}

// ────────────────────────────────────────────────────────────
//  ENTRY POINT
// ────────────────────────────────────────────────────────────

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  await initNotifications();
  runApp(const FotoKuApp());
}

// ────────────────────────────────────────────────────────────
//  DATA MODEL
// ────────────────────────────────────────────────────────────

class KategoriKoleksi {
  final String nama;
  final IconData ikon;
  final Color warna;
  final Color warnaBg;
  final bool isCustom;

  const KategoriKoleksi({
    required this.nama,
    required this.ikon,
    required this.warna,
    required this.warnaBg,
    this.isCustom = false,
  });

  static KategoriKoleksi get merchandise => const KategoriKoleksi(
      nama: 'Merchandise', ikon: Icons.toys_outlined,
      warna: FC.catMerch, warnaBg: FC.catMerchBg);
  static KategoriKoleksi get coverCD => const KategoriKoleksi(
      nama: 'FLAC Digital', ikon: Icons.music_note_outlined,
      warna: FC.catFlac, warnaBg: FC.catFlacBg);
  static KategoriKoleksi get baru => const KategoriKoleksi(
      nama: 'Baru Ditambahkan', ikon: Icons.new_releases_outlined,
      warna: FC.catBaru, warnaBg: FC.catBaruBg);

  static List<KategoriKoleksi> get defaults =>
      [merchandise, coverCD, baru];
}

final List<KategoriKoleksi> _semuaKategori = [...KategoriKoleksi.defaults];

class ItemKoleksi {
  final String judul;
  final String? subjudul;
  final KategoriKoleksi kategori;
  final String? imagePath;
  final bool isFile;
  final DateTime tanggal;

  ItemKoleksi({
    required this.judul,
    this.subjudul,
    required this.kategori,
    this.imagePath,
    this.isFile = false,
    DateTime? tanggal,
  }) : tanggal = tanggal ?? DateTime.now();
}

final List<ItemKoleksi> _dummyKoleksi = [
  ItemKoleksi(
    judul: 'LarvalStagePlanning',
    subjudul: 'Trip -innocent of D- · FLAC 96kHz/24bit',
    kategori: KategoriKoleksi.coverCD,
    tanggal: DateTime(2025, 9, 14),
  ),
  ItemKoleksi(
    judul: 'FigurMyBini',
    subjudul: 'Translasi Bahasa Indonesia · Scene 3',
    kategori: KategoriKoleksi.merchandise,
    tanggal: DateTime(2025, 8, 30),
  ),
];

// ────────────────────────────────────────────────────────────
//  HELPER — Simpan file ke folder kategori
// ────────────────────────────────────────────────────────────

Future<String> simpanKeKategori({
  required String sourcePath,
  required String judulItem,
  required String namaKategori,
}) async {
  final ext =
      p.extension(sourcePath).isNotEmpty ? p.extension(sourcePath) : '.jpg';
  final safeJudul =
      judulItem.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
  final namaFile = '$safeJudul$ext';

  Directory? baseDir;
  if (Platform.isAndroid) {
    final extDirs =
        await getExternalStorageDirectories(type: StorageDirectory.pictures);
    if (extDirs != null && extDirs.isNotEmpty) baseDir = extDirs.first;
  }
  baseDir ??= await getApplicationDocumentsDirectory();

  final kategoriDir =
      Directory(p.join(baseDir.path, 'FotoKu', namaKategori));
  if (!await kategoriDir.exists()) await kategoriDir.create(recursive: true);

  final dest = File(p.join(kategoriDir.path, namaFile));
  await File(sourcePath).copy(dest.path);

  try {
    await Gal.putImage(dest.path, album: 'FotoKu/$namaKategori');
  } catch (_) {}

  return dest.path;
}

// ────────────────────────────────────────────────────────────
//  ROOT APP
// ────────────────────────────────────────────────────────────

class FotoKuApp extends StatelessWidget {
  const FotoKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FotoKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: FC.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: FC.accent,
          brightness: Brightness.light,
          surface: FC.bgCard,
          primary: FC.accent,
        ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: FC.textMid),
          bodySmall: TextStyle(color: FC.textSub),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: FC.bgCard,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          iconTheme: IconThemeData(color: FC.textMid),
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: FC.textDark,
          ),
        ),
        dividerColor: FC.border,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: FC.bgSecond,
          hintStyle: const TextStyle(color: FC.textHint, fontSize: 13),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: FC.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: FC.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: FC.accent, width: 2),
          ),
        ),
      ),
      home: const HalamanUtama(),
    );
  }
}

// ────────────────────────────────────────────────────────────
//  DIALOG TAMBAH KATEGORI BARU
// ────────────────────────────────────────────────────────────

class DialogKategoriBaru extends StatefulWidget {
  const DialogKategoriBaru({super.key});

  @override
  State<DialogKategoriBaru> createState() => _DialogKategoriBaruState();
}

class _DialogKategoriBaruState extends State<DialogKategoriBaru> {
  final _ctrl = TextEditingController();

  // Warna diredam & curated
  Color _warnaDipilih = FC.catDefault;
  IconData _ikonDipilih = Icons.folder_outlined;

  final _warnaOpsi = [
    FC.catMerch,
    FC.catAudio,
    FC.catFlac,
    FC.catVN,
    FC.catBaru,
    FC.catDefault,
    const Color(0xFF7C3AED), // ungu
    const Color(0xFFDB2777), // pink diredam
    const Color(0xFF0369A1), // biru tua
    const Color(0xFF374151), // abu gelap netral
  ];

  final _ikonOpsi = [
    Icons.folder_outlined,
    Icons.star_outline_rounded,
    Icons.favorite_outline_rounded,
    Icons.bookmark_outline_rounded,
    Icons.sports_esports_outlined,
    Icons.movie_outlined,
    Icons.headphones_outlined,
    Icons.image_outlined,
    Icons.collections_outlined,
    Icons.emoji_events_outlined,
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: FC.bgCard,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: FC.accentSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_rounded,
                    color: FC.accent, size: 18),
              ),
              const SizedBox(width: 12),
              const Text('Kategori Baru',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: FC.textDark)),
            ]),
            const SizedBox(height: 16),

            // ── Input Nama ──────────────────────────────────
            _fieldLabel('Nama Kategori'),
            const SizedBox(height: 6),
            TextField(
              controller: _ctrl,
              style: const TextStyle(
                  color: FC.textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                hintText: 'Contoh: Poster, Keychain...',
              ),
            ),
            const SizedBox(height: 16),

            // ── Pilih Ikon ──────────────────────────────────
            _fieldLabel('Ikon'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _ikonOpsi.map((ikon) {
                final aktif = _ikonDipilih == ikon;
                return GestureDetector(
                  onTap: () => setState(() => _ikonDipilih = ikon),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: aktif ? FC.accentSoft : FC.bgSecond,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: aktif ? FC.accent : FC.border,
                        width: aktif ? 2 : 1,
                      ),
                    ),
                    child: Icon(ikon,
                        size: 20,
                        color: aktif ? FC.accent : FC.textSub),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // ── Pilih Warna ─────────────────────────────────
            _fieldLabel('Warna'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _warnaOpsi.map((w) {
                final aktif = _warnaDipilih == w;
                return GestureDetector(
                  onTap: () => setState(() => _warnaDipilih = w),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: w,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: aktif ? FC.textDark : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                    child: aktif
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ── Tombol ──────────────────────────────────────
            Row(children: [
              Expanded(
                  child: _btnOutlineDialog(
                      'Batal', () => Navigator.pop(context))),
              const SizedBox(width: 10),
              Expanded(
                  child: _btnSolidDialog('Tambah', () {
                final nama = _ctrl.text.trim();
                if (nama.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Nama kategori kosong!')));
                  return;
                }
                Navigator.pop(
                    context,
                    KategoriKoleksi(
                      nama: nama,
                      ikon: _ikonDipilih,
                      warna: _warnaDipilih,
                      warnaBg: _warnaDipilih.withValues(alpha: 0.1),
                      isCustom: true,
                    ));
              })),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) => Text(text,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: FC.textSub,
          letterSpacing: 0.3));
}

// ────────────────────────────────────────────────────────────
//  DIALOG TAMBAH KE KOLEKSI
// ────────────────────────────────────────────────────────────

class DialogTambahKoleksi extends StatefulWidget {
  final String imagePath;
  final List<KategoriKoleksi> kategoriList;

  const DialogTambahKoleksi({
    super.key,
    required this.imagePath,
    required this.kategoriList,
  });

  @override
  State<DialogTambahKoleksi> createState() => _DialogTambahKoleksiState();
}

class _DialogTambahKoleksiState extends State<DialogTambahKoleksi> {
  final _judulCtrl = TextEditingController();
  final _subjudulCtrl = TextEditingController();
  late KategoriKoleksi _kategoriDipilih;
  late List<KategoriKoleksi> _kategoriList;

  @override
  void initState() {
    super.initState();
    _kategoriList = List.from(widget.kategoriList);
    _kategoriDipilih = _kategoriList.first;
    _judulCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _subjudulCtrl.dispose();
    super.dispose();
  }

  Future<void> _tambahKategoriBaru() async {
    final hasil = await showDialog<KategoriKoleksi>(
      context: context,
      builder: (_) => const DialogKategoriBaru(),
    );
    if (hasil != null) {
      setState(() {
        _kategoriList.add(hasil);
        _kategoriDipilih = hasil;
      });
    }
  }

  String _namaFileDariInput() {
    final judul = _judulCtrl.text.trim();
    if (judul.isEmpty) return '<judul>.jpg';
    final safe = judul.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
    return '$safe.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: FC.bgCard,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: FC.accentSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.add_photo_alternate_outlined,
                    color: FC.accent, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Tambah ke Koleksi',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: FC.textDark)),
              ),
            ]),
            const SizedBox(height: 16),

            // ── Preview gambar ───────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 130,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FC.bgSecond,
                  border: Border.all(color: FC.border),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(File(widget.imagePath),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Input Judul ──────────────────────────────────
            _label('Judul Item  *  (= nama file)'),
            const SizedBox(height: 6),
            TextField(
              controller: _judulCtrl,
              maxLines: 1,
              style: const TextStyle(
                  color: FC.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                  hintText: 'Contoh: figurin_rem_rezero'),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                'File akan disimpan sebagai: ${_namaFileDariInput()}',
                style: const TextStyle(fontSize: 11, color: FC.textHint),
              ),
            ),
            const SizedBox(height: 12),

            // ── Input Keterangan ─────────────────────────────
            _label('Keterangan (opsional)'),
            const SizedBox(height: 6),
            TextField(
              controller: _subjudulCtrl,
              maxLines: 1,
              style: const TextStyle(
                  color: FC.textDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
              decoration: const InputDecoration(
                  hintText: 'Contoh: Scale 1/8 · Good Smile Co.'),
            ),
            const SizedBox(height: 16),

            // ── Pilih Kategori ───────────────────────────────
            Row(children: [
              _label('Kategori'),
              const Spacer(),
              GestureDetector(
                onTap: _tambahKategoriBaru,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: FC.accentSoft,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: FC.accentMid),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, size: 14, color: FC.accent),
                      SizedBox(width: 4),
                      Text('Kategori Baru',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: FC.accent)),
                    ],
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _kategoriList.map((k) {
                final aktif = _kategoriDipilih.nama == k.nama;
                return GestureDetector(
                  onTap: () => setState(() => _kategoriDipilih = k),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: aktif ? k.warnaBg : FC.bgSecond,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: aktif ? k.warna : FC.border,
                        width: aktif ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: aktif ? k.warna : FC.textHint,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(k.nama,
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: aktif ? k.warna : FC.textSub)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // ── Tombol ──────────────────────────────────────
            Row(children: [
              Expanded(
                  child: _btnOutlineDialog(
                      'Batal', () => Navigator.pop(context))),
              const SizedBox(width: 10),
              Expanded(
                  child: _btnSolidDialog('Simpan', () {
                final judul = _judulCtrl.text.trim();
                if (judul.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Judul tidak boleh kosong!')));
                  return;
                }
                Navigator.pop(context, {
                  'judul': judul,
                  'subjudul': _subjudulCtrl.text.trim(),
                  'kategori': _kategoriDipilih,
                  'kategoriList': _kategoriList,
                });
              })),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: FC.textSub,
          letterSpacing: 0.2));
}

// ── Shared button widgets ────────────────────────────────────

Widget _btnOutlineDialog(String label, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: FC.bgSecond,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: FC.borderMid),
        ),
        child: Center(
            child: Text(label,
                style: const TextStyle(
                    color: FC.textMid,
                    fontWeight: FontWeight.w600,
                    fontSize: 13))),
      ),
    );

Widget _btnSolidDialog(String label, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: FC.accent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13))),
      ),
    );

// ────────────────────────────────────────────────────────────
//  HALAMAN UTAMA
// ────────────────────────────────────────────────────────────

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama>
    with SingleTickerProviderStateMixin {
  File? _imageFile;
  bool _sedangMemuat = false;
  String? _pesanStatus;
  bool _isError = false;

  final List<ItemKoleksi> _koleksi = List.from(_dummyKoleksi);

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutQuart);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── KAMERA ──────────────────────────────────────────────────
  Future<void> _ambilFotoKamera() async {
    setState(() {
      _sedangMemuat = true;
      _pesanStatus = null;
    });
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );
      if (foto != null) {
        final savedPath = await simpanKeKategori(
          sourcePath: foto.path,
          judulItem: 'kamera_${DateTime.now().millisecondsSinceEpoch}',
          namaKategori: 'Baru Ditambahkan',
        );
        final itemBaru = ItemKoleksi(
          judul: 'Foto Kamera ${_formatTanggal(DateTime.now())}',
          subjudul: 'Merchandise fisik · Diambil dari kamera',
          kategori: KategoriKoleksi.baru,
          imagePath: savedPath,
          isFile: true,
        );
        setState(() {
          _imageFile = File(savedPath);
          _koleksi.insert(0, itemBaru);
          _pesanStatus = 'Foto kamera disimpan ke FotoKu/Baru Ditambahkan';
          _isError = false;
          _sedangMemuat = false;
        });
        _animCtrl.reset();
        _animCtrl.forward();
        await showKatalogNotification(itemBaru.judul, 'Baru Ditambahkan');
      } else {
        setState(() {
          _pesanStatus = 'Kamera dibatalkan.';
          _isError = false;
          _sedangMemuat = false;
        });
      }
    } catch (e) {
      setState(() {
        _pesanStatus = 'Error: ${e.toString()}';
        _isError = true;
        _sedangMemuat = false;
      });
    }
  }

  // ── GALERI ──────────────────────────────────────────────────
  Future<void> _pilihFotoGaleri() async {
    setState(() {
      _sedangMemuat = true;
      _pesanStatus = null;
    });
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2560,
        maxHeight: 2560,
        imageQuality: 95,
      );
      if (foto != null) {
        final result = await showDialog<Map<String, dynamic>>(
          context: context,
          barrierDismissible: false,
          builder: (_) => DialogTambahKoleksi(
            imagePath: foto.path,
            kategoriList: _semuaKategori,
          ),
        );

        if (result != null) {
          final judul = result['judul'] as String;
          final subjudul = result['subjudul'] as String;
          final kategori = result['kategori'] as KategoriKoleksi;
          final updatedList = result['kategoriList'] as List<KategoriKoleksi>;

          for (final k in updatedList) {
            if (!_semuaKategori.any((e) => e.nama == k.nama)) {
              _semuaKategori.add(k);
            }
          }

          final savedPath = await simpanKeKategori(
            sourcePath: foto.path,
            judulItem: judul,
            namaKategori: kategori.nama,
          );

          final itemBaru = ItemKoleksi(
            judul: judul,
            subjudul: subjudul.isEmpty
                ? 'Disimpan di FotoKu/${kategori.nama}'
                : subjudul,
            kategori: kategori,
            imagePath: savedPath,
            isFile: true,
          );

          setState(() {
            _imageFile = File(savedPath);
            _koleksi.insert(0, itemBaru);
            _pesanStatus =
                '"$judul" disimpan ke FotoKu/${kategori.nama}';
            _isError = false;
            _sedangMemuat = false;
          });
          _animCtrl.reset();
          _animCtrl.forward();
          await showKatalogNotification(judul, kategori.nama);
        } else {
          setState(() {
            _pesanStatus = 'Penambahan dibatalkan.';
            _isError = false;
            _sedangMemuat = false;
          });
        }
      } else {
        setState(() {
          _pesanStatus = 'Pemilihan gambar dibatalkan.';
          _isError = false;
          _sedangMemuat = false;
        });
      }
    } catch (e) {
      setState(() {
        _pesanStatus = 'Error: ${e.toString()}';
        _isError = true;
        _sedangMemuat = false;
      });
    }
  }

  String _formatTanggal(DateTime dt) =>
      DateFormat('ddMMyyyy_HHmm').format(dt);

  // ────────────────────────────────────────────────────────────
  //  BUILD
  // ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FC.bg,
      body: CustomScrollView(
        slivers: [
          // ── AppBar ───────────────────────────────────────
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: FC.bgCard,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(color: FC.border, height: 1),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
              title: _buildAppBarTitle(),
              background: Container(color: FC.bgCard),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded,
                    color: FC.textSub, size: 22),
                onPressed: () {},
                tooltip: 'Cari koleksi',
              ),
              IconButton(
                icon: const Icon(Icons.tune_rounded,
                    color: FC.textSub, size: 22),
                onPressed: () {},
                tooltip: 'Filter',
              ),
              const SizedBox(width: 4),
            ],
          ),

          // ── Konten ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _seksiHeader('Tambah Item Baru', Icons.add_circle_outline_rounded),
                  const SizedBox(height: 12),
                  _buildTombolAksi(),
                  if (_pesanStatus != null) ...[
                    const SizedBox(height: 10),
                    _buildPesanStatus(),
                  ],
                  const SizedBox(height: 24),
                  _seksiHeader('Pratinjau Terakhir', Icons.image_outlined),
                  const SizedBox(height: 12),
                  _buildPratinjau(),
                  const SizedBox(height: 24),
                  _buildStatistik(),
                  const SizedBox(height: 24),
                  _seksiHeader('Koleksi Terbaru', Icons.collections_outlined),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // ── Grid Koleksi ─────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverGrid(
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _buildKartu(_koleksi[i]),
                childCount: _koleksi.length,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ── Widget Builders ──────────────────────────────────────────

  Widget _buildAppBarTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: FC.accent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.camera_alt_rounded,
              color: Colors.white, size: 14),
        ),
        const SizedBox(width: 8),
        const Text(
          'FotoKu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: FC.textDark,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _seksiHeader(String judul, IconData ikon) {
    return Row(children: [
      Icon(ikon, size: 16, color: FC.accent),
      const SizedBox(width: 8),
      Text(judul,
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: FC.textDark)),
    ]);
  }

  Widget _buildTombolAksi() {
    return Row(children: [
      Expanded(
        child: _sedangMemuat
            ? _loadingBox()
            : _aksiBtn(
                label: 'Kamera\n(Merch Fisik)',
                icon: Icons.camera_alt_outlined,
                warna: FC.catMerch,
                warnaBg: FC.catMerchBg,
                onTap: _ambilFotoKamera,
              ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _sedangMemuat
            ? const SizedBox.shrink()
            : _aksiBtn(
                label: 'Galeri\n(Screenshot/Cover)',
                icon: Icons.photo_library_outlined,
                warna: FC.catAudio,
                warnaBg: FC.catAudioBg,
                onTap: _pilihFotoGaleri,
              ),
      ),
    ]);
  }

  Widget _loadingBox() => Container(
        height: 64,
        decoration: BoxDecoration(
          color: FC.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: FC.border),
        ),
        child: const Center(
          child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2.5, color: FC.accent)),
        ),
      );

  Widget _aksiBtn({
    required String label,
    required IconData icon,
    required Color warna,
    required Color warnaBg,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: FC.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: FC.border),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: warnaBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: warna),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: FC.textMid,
                        height: 1.4)),
              ),
            ],
          ),
        ),
      );

  Widget _buildPesanStatus() {
    final isSuccess = !_isError;
    final warna = isSuccess ? FC.success : FC.error;
    final warnaBg = isSuccess ? FC.successBg : FC.errorBg;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: warnaBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: warna.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
              isSuccess
                  ? Icons.check_circle_outline_rounded
                  : Icons.error_outline_rounded,
              size: 14,
              color: warna),
          const SizedBox(width: 8),
          Expanded(
              child: Text(_pesanStatus!,
                  style: TextStyle(
                      fontSize: 12,
                      color: warna,
                      fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildPratinjau() {
    return FadeTransition(
      opacity: _imageFile != null
          ? _fadeAnim
          : const AlwaysStoppedAnimation(1),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: FC.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _imageFile != null ? FC.accent.withValues(alpha: 0.4) : FC.border,
            width: _imageFile != null ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: _imageFile != null
            ? Stack(fit: StackFit.expand, children: [
                Image.file(_imageFile!, fit: BoxFit.cover),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    color: Colors.black.withValues(alpha: 0.45),
                    child: const Row(children: [
                      Icon(Icons.check_circle_outline_rounded,
                          color: Colors.white, size: 13),
                      SizedBox(width: 6),
                      Text('Pratinjau · Koleksi Terbaru',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ]),
                  ),
                ),
              ])
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      size: 36, color: FC.textHint),
                  const SizedBox(height: 10),
                  const Text('Belum ada gambar.\nGunakan tombol di atas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: FC.textHint,
                          height: 1.6)),
                ],
              ),
      ),
    );
  }

  Widget _buildStatistik() {
    final counts = <String, int>{};
    final katMap = <String, KategoriKoleksi>{};
    for (final item in _koleksi) {
      counts[item.kategori.nama] =
          (counts[item.kategori.nama] ?? 0) + 1;
      katMap[item.kategori.nama] = item.kategori;
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FC.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FC.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.bar_chart_rounded, size: 16, color: FC.accent),
          const SizedBox(width: 8),
          const Text('STATISTIK KOLEKSI',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: FC.textSub,
                  letterSpacing: 0.8)),
          const Spacer(),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: FC.accentSoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: FC.accentMid),
            ),
            child: Text('${_koleksi.length} total',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: FC.accent)),
          ),
        ]),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: counts.entries.map((e) {
            final k = katMap[e.key]!;
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: k.warnaBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: k.warna.withValues(alpha: 0.3)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: k.warna)),
                const SizedBox(width: 6),
                Text('${e.value}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: k.warna)),
                const SizedBox(width: 5),
                Text(k.nama,
                    style: const TextStyle(
                        fontSize: 10, color: FC.textSub)),
              ]),
            );
          }).toList(),
        ),
      ]),
    );
  }

  Widget _buildKartu(ItemKoleksi item) {
    return Container(
      decoration: BoxDecoration(
        color: FC.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FC.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Gambar / Placeholder ──────────────────────────
        Expanded(
          child: Container(
            width: double.infinity,
            color: item.kategori.warnaBg,
            child: item.isFile && item.imagePath != null
                ? Image.file(File(item.imagePath!), fit: BoxFit.cover)
                : _placeholder(item),
          ),
        ),
        // ── Info ─────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chip kategori
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.kategori.warnaBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            item.kategori.warna.withValues(alpha: 0.3)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: item.kategori.warna)),
                    const SizedBox(width: 5),
                    Text(item.kategori.nama,
                        style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: item.kategori.warna)),
                  ]),
                ),
                const SizedBox(height: 6),
                Text(item.judul,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: FC.textDark,
                        height: 1.3)),
                if (item.subjudul != null) ...[
                  const SizedBox(height: 2),
                  Text(item.subjudul!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 9, color: FC.textHint)),
                ],
              ]),
        ),
      ]),
    );
  }

  Widget _placeholder(ItemKoleksi item) {
    return Center(
      child: Icon(item.kategori.ikon,
          size: 42, color: item.kategori.warna.withValues(alpha: 0.35)),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: _pilihFotoGaleri,
      backgroundColor: FC.accent,
      foregroundColor: Colors.white,
      elevation: 2,
      icon: const Icon(Icons.add_rounded, size: 22),
      label: const Text('Tambah',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
    );
  }
}