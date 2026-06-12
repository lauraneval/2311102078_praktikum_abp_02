import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  debugPrint('📬 [BG] Notifikasi diterima: ${message.notification?.title}');
}

Future<void> initFCM() async {
  final messaging = FirebaseMessaging.instance;
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debugPrint(
    '🔔 Status izin notifikasi: ${settings.authorizationStatus}',
  );

  final token = await messaging.getToken();
  debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  debugPrint('🔑 FCM TOKEN (salin dari sini):');
  debugPrint('$token');
  debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

  messaging.onTokenRefresh.listen((newToken) {
    debugPrint('🔄 FCM Token diperbarui: $newToken');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  await initFCM();

  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const TaskTrackerApp(),
    ),
  );
}

class TaskProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _tasks = [
    {'id': 1, 'title': 'Melanjutkan translasi project CSTE-1704'},
    {'id': 2, 'title': 'Review dataset NLP'},
    {'id': 3, 'title': 'Mendengarkan rilis lagu Ado'},
  ];

  List<Map<String, dynamic>> get tasks => List.unmodifiable(_tasks);

  int get taskCount => _tasks.length;

  void addTask(String title) {
    if (title.trim().isEmpty) return;
    _tasks.add({
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': title.trim(),
    });
    notifyListeners();
  }

  void removeTask(int id) {
    _tasks.removeWhere((task) => task['id'] == id);
    notifyListeners();
  }

  void clearAll() {
    _tasks.clear();
    notifyListeners();
  }
}

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 [FG] Notifikasi masuk: ${message.notification?.title}');
      _showFCMSnackBar(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📲 App dibuka via notifikasi: ${message.notification?.title}');
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _showFCMSnackBar(RemoteMessage message) {
    if (!mounted) return;
    final title = message.notification?.title ?? 'Notifikasi Baru';
    final body = message.notification?.body ?? '';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF1A73E8),
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  if (body.isNotEmpty)
                    Text(
                      body,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Dialog untuk menambah tugas baru ---
  void _showAddTaskDialog() {
    _taskController.clear();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.add_task, color: Color(0xFF1A73E8)),
              SizedBox(width: 8),
              Text('Tugas Baru'),
            ],
          ),
          content: TextField(
            controller: _taskController,
            autofocus: true,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Deskripsi tugas...',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF1A73E8), width: 1.5),
              ),
            ),
            onSubmitted: (_) => _submitNewTask(ctx),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () => _submitNewTask(ctx),
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _submitNewTask(BuildContext dialogCtx) {
    final text = _taskController.text;
    if (text.trim().isNotEmpty) {
      // Akses Provider tanpa listen karena ini di dalam callback (bukan build).
      context.read<TaskProvider>().addTask(text);
      Navigator.of(dialogCtx).pop();
    }
  }

  // --- Dialog konfirmasi Clear All ---
  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 8),
            Text('Hapus Semua?'),
          ],
        ),
        content: const Text(
          'Seluruh tugas akan dihapus permanen. Lanjutkan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<TaskProvider>().clearAll();
              Navigator.of(ctx).pop();
            },
            child: const Text('Hapus Semua'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── AppBar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Tracker',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            // Consumer kecil untuk menampilkan jumlah tugas secara reaktif.
            Consumer<TaskProvider>(
              builder: (_, provider, __) => Text(
                '${provider.taskCount} tugas aktif',
                style: const TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ),
          ],
        ),
        actions: [
          // Tombol ikon tempat sampah — Clear All
          IconButton(
            tooltip: 'Hapus Semua Tugas',
            icon: const Icon(Icons.delete_sweep_rounded),
            onPressed: _showClearAllDialog,
          ),
        ],
      ),

      // ── Body ──────────────────────────────────────────────────────────────
      body: Consumer<TaskProvider>(
        // Consumer mendengarkan TaskProvider dan rebuild setiap kali
        // notifyListeners() dipanggil.
        builder: (context, provider, child) {
          if (provider.tasks.isEmpty) {
            // ── Empty State ────────────────────────────────────────────────
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 72,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada tugas!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tekan + untuk menambah tugas baru.',
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                ],
              ),
            );
          }

          // ── Task List ──────────────────────────────────────────────────
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return _TaskCard(
                index: index,
                task: task,
                onDelete: () => provider.removeTask(task['id']),
              );
            },
          );
        },
      ),

      // ── FAB — Tambah Tugas Baru ──────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Tugas'),
        backgroundColor: const Color(0xFF1A73E8),
        foregroundColor: Colors.white,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. WIDGET KARTU TUGAS
// ─────────────────────────────────────────────────────────────────────────────
class _TaskCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> task;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.index,
    required this.task,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Warna lencana nomor urut berputar di antara tiga warna.
    final badgeColors = [
      const Color(0xFF1A73E8),
      const Color(0xFF0F9D58),
      const Color(0xFFF4B400),
    ];
    final badgeColor = badgeColors[index % badgeColors.length];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: badgeColor.withOpacity(0.12),
          child: Text(
            '${index + 1}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: badgeColor,
              fontSize: 13,
            ),
          ),
        ),
        title: Text(
          task['title'] as String,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close_rounded, size: 18),
          color: Colors.grey.shade400,
          tooltip: 'Hapus tugas',
          onPressed: onDelete,
        ),
      ),
    );
  }
}