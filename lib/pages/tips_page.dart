import 'package:eluthozhi_v3/models/tip_blog.dart';
import 'package:eluthozhi_v3/pages/tip_detail_page.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:eluthozhi_v3/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  static const _categories = ['All Blogs', 'Traditions', 'History'];

  late final List<TipBlog> _blogs;
  String _selectedCategory = 'All Blogs';
  bool _favoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _blogs = tipBlogsSeed.map((blog) {
      return TipBlog(
        id: blog.id,
        category: blog.category,
        date: blog.date,
        title: blog.title,
        excerpt: blog.excerpt,
        body: blog.body,
        imageAsset: blog.imageAsset,
        isFavorite: blog.isFavorite,
      );
    }).toList();
  }

  int _countFor(String category) {
    if (category == 'All Blogs') return _blogs.length;
    return _blogs.where((b) => b.category == category).length;
  }

  List<TipBlog> get _visibleBlogs {
    return _blogs.where((blog) {
      final matchesCategory =
          _selectedCategory == 'All Blogs' || blog.category == _selectedCategory;
      final matchesFavorite = !_favoritesOnly || blog.isFavorite;
      return matchesCategory && matchesFavorite;
    }).toList();
  }

  void _toggleFavorite(TipBlog blog) {
    setState(() => blog.isFavorite = !blog.isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final blogs = _visibleBlogs;

    return Scaffold(
      backgroundColor: getFigmaColor(context, 'Schemes', 'Surface'),
      bottomNavigationBar: BottomNavBar(
        currentRoute: ModalRoute.of(context)?.settings.name ?? '/Tips',
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: blogs.isEmpty
                  ? Center(
                      child: Text(
                        _favoritesOnly
                            ? 'No favorites yet'
                            : 'No guides in this category',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: getFigmaColor(context, 'Secondary', 'Main'),
                            ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: blogs.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final blog = blogs[index];
                        return _TipBlogCard(
                          blog: blog,
                          onFavorite: () => _toggleFavorite(blog),
                          onLearnMore: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TipDetailPage(blog: blog),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: getFigmaColor(context, 'Schemes', 'Surface'),
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Favorites',
            onPressed: () => setState(() => _favoritesOnly = !_favoritesOnly),
            icon: Icon(
              _favoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: _favoritesOnly
                  ? getFigmaColor(context, 'Primary', 'Main')
                  : getFigmaColor(context, 'Primary', 'Dark'),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  final selected = category == _selectedCategory;
                  final count = _countFor(category);
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _CategoryTab(
                      label: category,
                      count: count,
                      selected: selected,
                      onTap: () => setState(() => _selectedCategory = category),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = getFigmaColor(context, 'Primary', 'Main');
    final muted = getFigmaColor(context, 'Secondary', 'Main');

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: selected ? primary : muted,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: selected
                        ? primary.withValues(alpha: 0.12)
                        : getFigmaColor(context, 'Surface', 'Surface Container'),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$count',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: selected ? primary : muted,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: selected ? 28 : 0,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipBlogCard extends StatelessWidget {
  final TipBlog blog;
  final VoidCallback onFavorite;
  final VoidCallback onLearnMore;

  const _TipBlogCard({
    required this.blog,
    required this.onFavorite,
    required this.onLearnMore,
  });

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String get _dateLabel =>
      '${_months[blog.date.month - 1]} ${blog.date.day}, ${blog.date.year}';

  @override
  Widget build(BuildContext context) {
    final primary = getFigmaColor(context, 'Primary', 'Main');
    final onSurface = getFigmaColor(context, 'Primary', 'Dark');
    final secondary = getFigmaColor(context, 'Secondary', 'Main');

    return Container(
      decoration: BoxDecoration(
        color: getFigmaColor(context, 'Surface', 'Surface Container Lowest'),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  blog.imageAsset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: getFigmaColor(context, 'Surface', 'Surface Container'),
                    alignment: Alignment.center,
                    child: Icon(Icons.image_outlined, color: secondary, size: 40),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.25),
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: onFavorite,
                      icon: Icon(
                        blog.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: blog.isFavorite ? Colors.redAccent : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      blog.category,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: 1,
                        height: 14,
                        color: getFigmaColor(context, 'Schemes', 'Outline Variant'),
                      ),
                    ),
                    Text(
                      _dateLabel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: secondary,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  blog.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: onSurface,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        fontFamily: 'NotoSans',
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  blog.excerpt,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: secondary,
                        height: 1.45,
                      ),
                ),
                const SizedBox(height: 14),
                InkWell(
                  onTap: onLearnMore,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Learn More',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.chevron_right, color: onSurface, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
