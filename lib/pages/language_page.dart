// Full Fixed Updated Version (with Correct Per-Category Color Rotation)

import 'package:eluthozhi_v3/providers/theme_provider.dart';
import 'package:eluthozhi_v3/providers/settings_preferences_provider.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:eluthozhi_v3/theme/button_palettes.dart';
import 'package:eluthozhi_v3/widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:eluthozhi_v3/models/language_data.dart';
import 'package:shimmer/shimmer.dart';
import 'package:audioplayers/audioplayers.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final CollectionReference _languagesCollection = FirebaseFirestore.instance
      .collection('languages');
  final AudioPlayer _audioPlayer = AudioPlayer();
  final _selectedLanguage = 'tamil';
  final _selectedPalette = 'default';

  final ScrollController _scrollController = ScrollController();
  final Map<String, List<LanguageData>> _cachedLanguages = {};
  List<GlobalKey> _cardKeys = [];
  Future<void> _scrollToCard(int index) async {
    if (_cardKeys.length > index) {
      final context = _cardKeys[index].currentContext;
      if (context != null) {
        await Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDark = Provider.of<ThemeProvider>(context).isDark;

    return Scaffold(
      backgroundColor: getFigmaColor(context, 'Schemes', 'Surface'),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHorizontalCategoryBar(),
          BottomNavBar(
            currentRoute: ModalRoute.of(context)!.settings.name ?? '',
          ),
        ],
      ),
      body: SafeArea(
        child:
            user == null
                ? const Center(child: Text('Please log in to view content.'))
                : FutureBuilder<List<LanguageData>>(
                  future: _loadLanguageData(_selectedLanguage),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmer();
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No data available'));
                    }

                    final categories = snapshot.data!;
                    _cardKeys = List.generate(
                      categories.length,
                      (_) => GlobalKey(),
                    );

                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: List.generate(categories.length, (index) {
                          final category = categories[index];
                          return SizedBox(
                            width: double.infinity,
                            key: _cardKeys[index],
                            child: _buildCategoryCard(category, isDark, index),
                          );
                        }),
                      ),
                    );
                  },
                ),
      ),
    );
  }

  Widget _buildHorizontalCategoryBar() {
    final isDark = Provider.of<ThemeProvider>(context).isDark;
    final filterStyle =
        Provider.of<SettingsPreferencesProvider>(context).filterStyle;

    return SizedBox(
      height: 50,
      child: FutureBuilder<List<LanguageData>>(
        future: _loadLanguageData(_selectedLanguage),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories available'));
          }
          final categories = snapshot.data!;

          return Container(
            color: getFigmaColor(context, 'Surface', 'Surface Container'),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                final palette = ThemedButtonPalettes.getMainPalette(
                  themeName: _selectedPalette,
                  categoryIndex: index,
                  isDarkMode: isDark,
                );

                if (filterStyle == FilterStyle.colorDots) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Tooltip(
                      message: categories[index].title.split(' ')[0],
                      child: InkWell(
                        onTap: () => _scrollToCard(index),
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: palette.backgroundColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: palette.borderColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () => _scrollToCard(index),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: palette.backgroundColor,
                      foregroundColor: palette.textColor,
                      side: BorderSide(color: palette.borderColor, width: 2.0),
                    ),
                    child: Text(categories[index].title.split(' ')[0]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<List<LanguageData>> _loadLanguageData(String lang) async {
    if (_cachedLanguages.containsKey(lang)) {
      return _cachedLanguages[lang]!;
    }

    final doc = await _languagesCollection.doc(lang).get();
    final innerMap = doc.get('data') as Map<String, dynamic>;
    final rawData = innerMap['data'] as List<dynamic>;
    final categories =
        rawData.map((item) => LanguageData.fromFirestore(item)).toList();
    _cachedLanguages[lang] = categories;
    return categories;
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: getFigmaColor(context, 'Secondary', 'Light'),
          highlightColor: Colors.grey.shade100,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(height: 120, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(LanguageData category, bool isDark, int mainIndex) {
    return Card(
      margin: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      color: getFigmaColor(context, 'Schemes', 'Surface'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(category.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            if (category.engTitle != null)
              Text(
                category.engTitle!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: getFigmaColor(context, 'Secondary', 'Main'),
                ),
              ),
            const SizedBox(height: 8),
            ...List.generate(
              category.items.length,
              (subIndex) => _buildItemSection(
                category.items[subIndex],
                isDark,
                mainIndex,
                subIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemSection(
    LanguageItem item,
    bool isDark,
    int mainIndex,
    int subIndex,
  ) {
    final palette =
        item.subTitle == null
            ? ThemedButtonPalettes.getMainPalette(
              themeName: _selectedPalette,
              categoryIndex: mainIndex,
              isDarkMode: isDark,
            )
            : ThemedButtonPalettes.getSubPalette(
              themeName: _selectedPalette,
              mainCategoryIndex: mainIndex,
              subCategoryIndex: subIndex,
              isDarkMode: isDark,
            );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (item.subTitle != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              item.subTitle!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        const SizedBox(height: 4),
        _buildLetterGrid(item.subItems, palette),
      ],
    );
  }

  /// 4-unit grid: [Letter.column] is the span (1 = 1/4 width, 2 = 1/2 width).
  /// Tiles fill the available width with equal gaps on every side.
  Widget _buildLetterGrid(List<Letter> letters, ButtonPalette palette) {
    const crossAxisCount = 4;
    const spacing = 10.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth =
            (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
            crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: letters.map((letter) {
            final span = letter.column.clamp(1, crossAxisCount);
            final tileWidth = cellWidth * span + spacing * (span - 1);

            return SizedBox(
              width: tileWidth,
              height: cellWidth,
              child: Material(
                color: palette.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: palette.borderColor),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () async {
                    try {
                      await _audioPlayer.play(
                        AssetSource('sounds/${letter.sound}'),
                      );
                    } catch (e) {
                      debugPrint('Audio error: $e');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              letter.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(color: palette.textColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          letter.english.isNotEmpty ? letter.english : '—',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: palette.textColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
