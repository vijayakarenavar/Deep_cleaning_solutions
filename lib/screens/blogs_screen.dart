import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dcs_app/utils/app_colors.dart';
import 'package:dcs_app/utils/responsive.dart';
import 'package:dcs_app/widgets/srg_app_bar.dart';
import 'package:dcs_app/widgets/srg_drawer.dart';
import 'package:dcs_app/providers/blog_provider.dart';

class BlogsScreen extends ConsumerStatefulWidget {
  const BlogsScreen({super.key});

  @override
  ConsumerState<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends ConsumerState<BlogsScreen> {
  int _selectedCategory = 0;

  // ── Static fallback categories ────────────────────────────────────
  static const List<Map<String, dynamic>> _staticBlogs = [
    {
      'category': 'Cleaning',
      'title': 'How to Choose the Right Office Cleaning Company: A Complete Guide',
      'desc': 'A clean office is not just about looks. It directly affects employee health, productivity, and your company\'s professionalism.',
      'icon': '🏢',
      'color': 0xFFD5E8D4,
      'slug': '',
    },
    {
      'category': 'Cleaning',
      'title': 'Cleaning Standards for Corporate Offices in Pune: Why Deep Cleaning Is Essential',
      'desc': 'Cleanliness as a Corporate Priority in Pune has emerged as one of India\'s most important corporate and IT hubs.',
      'icon': '🏙️',
      'color': 0xFFDAE8FC,
      'slug': '',
    },
    {
      'category': 'Home Care',
      'title': 'How to Maintain Home Cleanliness After the Monsoon',
      'desc': 'The monsoon season brings relief from heat, but once the rains stop, they often leave behind dampness, dirt, and hidden issues.',
      'icon': '🏠',
      'color': 0xFFE8DFF5,
      'slug': '',
    },
    {
      'category': 'Tips',
      'title': '5 Easy Ways to Keep Your Kitchen Spotless Every Day',
      'desc': 'The kitchen is the heart of every home. Keeping it clean not only ensures hygiene but also makes cooking more enjoyable.',
      'icon': '🍳',
      'color': 0xFFFFE6CC,
      'slug': '',
    },
    {
      'category': 'Cleaning',
      'title': 'Why Professional Bathroom Cleaning is Better Than DIY',
      'desc': 'Bathrooms are breeding grounds for germs and bacteria. Professional cleaning ensures deep sanitization that regular cleaning can\'t.',
      'icon': '🚿',
      'color': 0xFFDBE4EE,
      'slug': '',
    },
    {
      'category': 'Tips',
      'title': 'Top 7 Signs You Need a Deep Cleaning Service Right Now',
      'desc': 'Most people clean their homes regularly, but there are times when a regular clean just isn\'t enough. Here are the signs.',
      'icon': '✨',
      'color': 0xFFF8D7DA,
      'slug': '',
    },
  ];

  static const List<int> _colors = [
    0xFFD5E8D4, 0xFFDAE8FC, 0xFFE8DFF5,
    0xFFFFE6CC, 0xFFDBE4EE, 0xFFF8D7DA,
  ];

  static const List<String> _icons = [
    '🏢', '🏙️', '🏠', '🍳', '🚿', '✨',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(blogProvider.notifier).getBlogs();
      ref.read(blogProvider.notifier).getBlogCategories();
    });
  }

  List<Map<String, dynamic>> get _blogs {
    final blogState = ref.watch(blogProvider);
    if (blogState.blogs.isNotEmpty) {
      return blogState.blogs.asMap().entries.map((e) {
        final i = e.key;
        final b = e.value;
        return {
          'category': (b['category'] ?? b['category_name'] ?? 'Cleaning').toString(),
          'title':    (b['title']    ?? '').toString(),
          'desc':     (b['desc']     ?? b['description'] ?? b['excerpt'] ?? '').toString(),
          'icon':     _icons[i % _icons.length],
          'color':    _colors[i % _colors.length],
          'slug':     (b['slug']     ?? '').toString(),
          'image':    (b['image']    ?? b['thumbnail'] ?? '').toString(),
        };
      }).toList();
    }
    return _staticBlogs;
  }

  List<String> get _categories {
    final blogState = ref.watch(blogProvider);
    if (blogState.categories.isNotEmpty) {
      return ['All Posts', ...blogState.categories.map((c) => c['name'].toString())];
    }
    return ['All Posts', 'Cleaning', 'Tips', 'Home Care'];
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedCategory == 0) return _blogs;
    final cat = _categories[_selectedCategory];
    return _blogs.where((b) => b['category'] == cat).toList();
  }

  @override
  Widget build(BuildContext context) {
    final blogState = ref.watch(blogProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      drawer: const SRGDrawer(),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref.read(blogProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            const SRGSliverAppBar(),
            SliverList(
              delegate: SliverChildListDelegate([
                // ── Hero ──────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, Color(0xFF9B59B6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Our Blog',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: R.sp(context, 24),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discover tips, insights, and stories about cleaning services',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: R.sp(context, 13),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Category Filter ───────────────────
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final isActive = _selectedCategory == i;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _selectedCategory = i;
                          ref.read(blogProvider.notifier).setSelectedCategory(i);
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.secondary : AppColors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isActive ? AppColors.secondary : AppColors.border,
                            ),
                          ),
                          child: Text(
                            _categories[i],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isActive ? Colors.white : AppColors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // ── Loading / Error / Blog List ───────
                if (blogState.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  )
                else if (blogState.error != null && _blogs == _staticBlogs)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.secondary, size: 48),
                        const SizedBox(height: 8),
                        Text(
                          blogState.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => ref.read(blogProvider.notifier).refresh(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, i) => _BlogCard(data: _filtered[i]),
                  ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlogCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _BlogCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final color = Color(data['color'] as int);
    final imgH  = R.wp(context, 55);

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: imgH,
                    color: color,
                    child: Center(
                      child: Text(
                        data['icon'] as String,
                        style: const TextStyle(fontSize: 64),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        (data['category'] as String).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] as String,
                    style: TextStyle(
                      fontSize: R.sp(context, 15),
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['desc'] as String,
                    style: TextStyle(
                      fontSize: R.sp(context, 12),
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'READ MORE',
                        style: TextStyle(
                          fontSize: R.sp(context, 12),
                          color: AppColors.black,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, size: 14, color: AppColors.black),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}