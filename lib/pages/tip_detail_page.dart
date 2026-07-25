import 'package:eluthozhi_v3/models/tip_blog.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:flutter/material.dart';

class TipDetailPage extends StatelessWidget {
  final TipBlog blog;

  const TipDetailPage({super.key, required this.blog});

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
    return Scaffold(
      backgroundColor: getFigmaColor(context, 'Schemes', 'Surface'),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: getFigmaColor(context, 'Schemes', 'Surface'),
            foregroundColor: getFigmaColor(context, 'Primary', 'Dark'),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                blog.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: getFigmaColor(context, 'Surface', 'Surface Container'),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        blog.category,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: getFigmaColor(context, 'Primary', 'Main'),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: 1,
                          height: 14,
                          color: getFigmaColor(
                            context,
                            'Schemes',
                            'Outline Variant',
                          ),
                        ),
                      ),
                      Text(
                        _dateLabel,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: getFigmaColor(
                                context,
                                'Secondary',
                                'Main',
                              ),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    blog.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: getFigmaColor(context, 'Primary', 'Dark'),
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                          fontFamily: 'NotoSans',
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    blog.body,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: getFigmaColor(context, 'Secondary', 'Main'),
                          height: 1.55,
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
}
