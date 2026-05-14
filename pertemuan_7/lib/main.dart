import 'package:flutter/material.dart';

void main() {
  runApp(const LightNovelApp());
}

// ─────────────────────────────────────────────────────────────────────────────
// ROOT APP
// ─────────────────────────────────────────────────────────────────────────────
class LightNovelApp extends StatelessWidget {
  const LightNovelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Light Novel Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C3DE8),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0A1E),
        fontFamily: 'sans-serif',
      ),
      home: const HomePage(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// HOME PAGE – STATE
// ─────────────────────────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ── DUMMY DATA untuk ListView.builder (Rilis Terbaru) ──────────────────────
  final List<Map<String, dynamic>> _newReleases = [
    {
      'title': 'Furimukinasai, Watashi ni!',
      'author': 'Inori',
      'genre': 'Drama, Fantasy, Romance',
      'rating': 3.5,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx206023-i36yP4yEH3Zs.jpg',
      'color': Color(0xFF1A2A4A),
    },
    {
      'title': 'Dare ga Yuusha wo Koroshita ka: Kenja no Shou',
      'author': 'Daken',
      'genre': 'Action, Adventure, Fantasy',
      'rating': 3.4,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx211774-S2LORiddqg42.png',
      'color': Color(0xFF2A1A0A),
    },
    {
      'title': 'Anata wa Akumu no Sankasha ni Erabaremashita',
      'author': 'Wataru Fuyuzuki',
      'genre': 'Horror, Mystery, Psychological',
      'rating': 4.5,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx205689-xfERb7GYeBBV.jpg',
      'color': Color(0xFF1A0A2A),
    },
    {
      'title': 'Yakiharae!: Net Miko Tsumugi-chan',
      'author': 'Kazuma Kamachi',
      'genre': 'Comedy, Sci-Fi, Supernatural',
      'rating': 4.1,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx209469-FG3jhtHxI5ty.jpg',
      'color': Color(0xFF0A2A1A),
    },
    {
      'title': 'Yaebuki Kikan: Senmanjoutou Touharoku',
      'author': 'Asato Asato',
      'genre': 'Action, Adventure, Fantasy',
      'rating': 3.9,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx210803-hmu7Gjn1iJPe.jpg',
      'color': Color(0xFF2A0A1A),
    },
  ];

  // ── DUMMY DATA untuk ListView.separated (Top Peringkat) ───────────────────
  final List<Map<String, dynamic>> _topRanked = [
    {
      'rank': 1,
      'title': 'Youkoso Jitsuryoku Shijou Shugi no Kyoushitsu e',
      'author': 'Shougo Kinugasa',
      'score': 9.6,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx94970-q77X5sfRIKvU.jpg',
      'rankColor': Color(0xFFFFD700),
    },
    {
      'rank': 2,
      'title': 'Mushoku Tensei: Isekai Ittara Honki Dasu',
      'author': 'Rifujin na Magonote',
      'score': 9.4,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/nx85470-jt6BF9tDWB2X.jpg',
      'rankColor': Color(0xFFC0C0C0),
    },
    {
      'rank': 3,
      'title': 'Re:Zero kara Hajimeru Isekai Seikatsu',
      'author': 'Tappei Nagatsuki',
      'score': 9.3,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx85737-WkWOr5EgwPyo.jpg',
      'rankColor': Color(0xFFCD7F32),
    },
    {
      'rank': 4,
      'title': '86: Eighty Six',
      'author': 'Asato Asato',
      'score': 9.2,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx98610-TIf7R1gkU0vc.jpg',
      'rankColor': Color(0xFF6C3DE8),
    },
    {
      'rank': 5,
      'title': 'Yahari Ore no Seishun Love Come wa Machigatteiru',
      'author': 'Wataru Watari',
      'score': 9.1,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx70171-SjwD5wlgUpJV.jpg',
      'rankColor': Color(0xFF3DE8B0),
    },
    {
      'rank': 6,
      'title': 'Overlord',
      'author': 'Kugane Maruyama',
      'score': 9.0,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx85976-hVr99G1kD1M5.png',
      'rankColor': Color(0xFFE83D7B),
    },
    {
      'rank': 7,
      'title': 'Kono Subarashii Sekai ni Shukufuku wo!',
      'author': 'Natsume Akatsuki',
      'score': 8.9,
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/nx86238-PvTZXUWWg2gd.jpg',
      'rankColor': Color(0xFF3D9BE8),
    },
  ];

  // ── DUMMY DATA untuk GridView (Rekomendasi Utama) ─────────────────────────
  final List<Map<String, dynamic>> _recommended = [
    {
      'title': 'Youkoso Jitsuryoku Shijou Shugi no Kyoushitsu e',
      'genre': 'Psychological, Thriller',
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx94970-q77X5sfRIKvU.jpg',
    },
    {
      'title': 'No Game No Life',
      'genre': 'Adventure, Fantasy',
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx78399-ohUhCDKw0CJs.jpg',
    },
    {
      'title': 'Seishun Buta Yarou wa Bunny Girl Senpai no Yume wo Minai',
      'genre': 'Psychological, Romance',
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx91170-qHi5fD36nWks.jpg',
    },
    {
      'title': 'Otonari no Tenshi-sama ni Itsunomanika Dame Ningen ni Sareteita Ken',
      'genre': 'Comedy, Romance',
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx113533-u3D4i0jHzt2z.jpg',
    },
    {
      'title': 'Tokidoki Bosotto Russiago de Dereru Tonari no Alya-san',
      'genre': 'Comedy, Romance',
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx130687-yny5jDh62wbA.jpg',
    },
    {
      'title': 'Violet Evergarden',
      'genre': 'Drama, Fantasy',
      'imageUrl':
          'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx97298-2KETOAaDaTw7.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0A1E),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              _buildBannerStack(),          // 1. STACK
              _buildSectionTitle('Kategori'),
              _buildCategoryListView(),     // 3. LISTVIEW (horizontal)
              _buildSectionTitle('Rekomendasi Utama'),
              _buildRecommendedGridView(),  // 4. GRIDVIEW
              _buildSectionTitle('Rilis Terbaru'),
              _buildNewReleasesBuilder(),   // 5. LISTVIEW.BUILDER
              _buildSectionTitle('🏆 Top Peringkat'),
              _buildTopRankedSeparated(),   // 6. LISTVIEW.SEPARATED
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ── APP BAR ───────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Light Novel',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const Text(
                'Hub Indonesia',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9B7FE8),
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          // IMPLEMENTASI CONTAINER – dengan border radius dan decoration
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C3DE8), Color(0xFFB03DE8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C3DE8).withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 1. IMPLEMENTASI STACK – Banner / Highlight Novel dengan Image.network
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildBannerStack() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          // Layer 1 – Background container gradient
          Container(
            width: double.infinity,
            height: 210,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFF0D0521), Color(0xFF1E0A3C), Color(0xFF3D1A6E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Layer 2 – Cover novel (Image.network) fade di sisi kanan
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: SizedBox(
                width: 160,
                // ShaderMask membuat gambar fade ke kiri agar menyatu
                child: ShaderMask(
                  shaderCallback: (rect) => const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.transparent, Colors.black54],
                  ).createShader(rect),
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    // Gambar banner utama dari URL
                    'https://s4.anilist.co/file/anilistcdn/media/manga/cover/large/bx85737-WkWOr5EgwPyo.jpg',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(color: const Color(0xFF1E0A3C));
                    },
                    errorBuilder: (context, error, stack) => Container(
                      color: const Color(0xFF1E0A3C),
                      child: const Icon(Icons.broken_image, color: Colors.white30),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Layer 3 – Lingkaran dekoratif (efek glow)
          Positioned(
            right: 110,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6C3DE8).withOpacity(0.2),
              ),
            ),
          ),

          // Layer 4 – Teks & tombol overlap di atas semua layer (inti Stack)
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            right: 120,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3DE8B0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '⭐ NOVEL PILIHAN',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F0A1E),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Re:Zero kara Hajimeru Isekai Seikatsu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.25,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'by Tappei Nagatsuki',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Baca Sekarang →',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3D1A6E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 3. IMPLEMENTASI LISTVIEW – Horizontal statis, 3 item kategori
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildCategoryListView() {
    final List<Map<String, dynamic>> categories = [
      {'label': '⚔️ Action', 'color': const Color(0xFF1A4FDE)},
      {'label': '🌀 Isekai', 'color': const Color(0xFF6C3DE8)},
      {'label': '💕 Romance', 'color': const Color(0xFFE83D7B)},
    ];

    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: categories.map((cat) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: (cat['color'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: (cat['color'] as Color).withOpacity(0.6),
                width: 1.5,
              ),
            ),
            child: Text(
              cat['label'] as String,
              style: TextStyle(
                color: cat['color'] as Color,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 4. IMPLEMENTASI GRIDVIEW – Rekomendasi Utama dengan Image.network
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildRecommendedGridView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        // shrinkWrap & NeverScrollableScrollPhysics wajib agar tidak error
        // saat digabungkan dengan SingleChildScrollView
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _recommended.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.68,
        ),
        itemBuilder: (context, index) {
          final item = _recommended[index];
          return ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Layer 1 – Cover gambar dari URL (Image.network)
                Image.network(
                  item['imageUrl'] as String,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: const Color(0xFF1A1030),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6C3DE8),
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stack) => Container(
                    color: const Color(0xFF1A1030),
                    child: const Icon(Icons.broken_image,
                        color: Colors.white30, size: 36),
                  ),
                ),

                // Layer 2 – Gradien gelap di bagian bawah untuk teks
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 110,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                  ),
                ),

                // Layer 3 – Teks genre & judul overlap di atas gambar
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C3DE8).withOpacity(0.85),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['genre'] as String,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          height: 1.3,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 4),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 5. IMPLEMENTASI LISTVIEW.BUILDER – Rilis Terbaru dengan Image.network
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildNewReleasesBuilder() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        // ListView.builder men-generate item dari _newReleases secara dinamis
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _newReleases.length,
        itemBuilder: (context, index) {
          final novel = _newReleases[index];
          return Container(
            width: 145,
            margin: const EdgeInsets.only(right: 14),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Layer 1 – Cover gambar dari URL (Image.network)
                  Image.network(
                    novel['imageUrl'] as String,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: novel['color'] as Color,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white54,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stack) => Container(
                      color: novel['color'] as Color,
                      child: const Icon(Icons.auto_stories,
                          color: Colors.white30, size: 36),
                    ),
                  ),

                  // Layer 2 – Overlay gradien gelap dari bawah
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Color(0xDD000000),
                        ],
                        stops: [0.0, 0.35, 1.0],
                      ),
                    ),
                  ),

                  // Layer 3 – Badge rating di pojok kanan atas
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '★ ${novel['rating']}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Layer 4 – Teks judul, genre, author di bawah
                  Positioned(
                    bottom: 12,
                    left: 10,
                    right: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          novel['genre'] as String,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF3DE8B0),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          novel['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                            height: 1.25,
                            shadows: [
                              Shadow(color: Colors.black, blurRadius: 4),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          novel['author'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.65),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // 6. IMPLEMENTASI LISTVIEW.SEPARATED – Top Peringkat dengan Image.network
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildTopRankedSeparated() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1030),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF6C3DE8).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: ListView.separated(
          // shrinkWrap & NeverScrollableScrollPhysics wajib di sini
          // agar ListView.separated bisa hidup dalam SingleChildScrollView
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _topRanked.length,
          separatorBuilder: (context, index) => Divider(
            // Divider sebagai pemisah antar item (ciri khas ListView.separated)
            color: const Color(0xFF6C3DE8).withOpacity(0.2),
            thickness: 1,
            indent: 86,
            endIndent: 16,
          ),
          itemBuilder: (context, index) {
            final novel = _topRanked[index];
            final isTop3 = (novel['rank'] as int) <= 3;
            final rankColor = novel['rankColor'] as Color;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  // Badge nomor peringkat
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: isTop3
                          ? rankColor.withOpacity(0.2)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                      border: isTop3
                          ? Border.all(color: rankColor, width: 1.5)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '#${novel['rank']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: isTop3
                              ? rankColor
                              : Colors.white.withOpacity(0.35),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Cover gambar kecil dari URL (Image.network)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 42,
                      height: 56,
                      child: Image.network(
                        novel['imageUrl'] as String,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(color: const Color(0xFF2A1A4A));
                        },
                        errorBuilder: (context, error, stack) => Container(
                          color: const Color(0xFF2A1A4A),
                          child: const Icon(Icons.book,
                              color: Colors.white30, size: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Judul & penulis
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          novel['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          novel['author'] as String,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Badge skor
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C3DE8).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${novel['score']}',
                      style: const TextStyle(
                        color: Color(0xFF9B7FE8),
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Helper: Section Title ─────────────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 14),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C3DE8), Color(0xFF3DE8B0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}