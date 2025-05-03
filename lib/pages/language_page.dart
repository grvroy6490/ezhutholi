// Full Fixed Updated Version (with Correct Per-Category Color Rotation)

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:eluthozhi_v3/providers/theme_provider.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:eluthozhi_v3/theme/button_palettes.dart';
import 'package:eluthozhi_v3/utility/screenUtility.dart';
import 'package:eluthozhi_v3/widgets/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eluthozhi_v3/providers/login_state_provider.dart';
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

  @override
  void initState() {
    super.initState();
    ScreenUtils.debugPrintSharedPreferences(); // prints all saved SharedPreferences to console
  }

  final ScrollController _scrollController = ScrollController();
  Map<String, List<LanguageData>> _cachedLanguages = {};
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
                          return Container(
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
    final palette = ThemedButtonPalettes.getMainPalette(
      themeName: _selectedPalette,
      categoryIndex: mainIndex,
      isDarkMode: isDark,
    );

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
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              item.subItems.map((letter) {
                return GestureDetector(
                  onTap: () async {
                    try {
                      await _audioPlayer.play(
                        AssetSource('sounds/${letter.sound}'),
                      );
                    } catch (e) {
                      debugPrint('Audio error: $e');
                    }
                  },
                  child: Container(
                    width:
                        letter.column == 1
                            ? ScreenUtils.width(context, 0.2)
                            : ScreenUtils.width(context, 0.5) - 30,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: palette.backgroundColor,
                      border: Border.all(color: palette.borderColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          letter.name,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(color: palette.textColor),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Ak',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: palette.textColor),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
