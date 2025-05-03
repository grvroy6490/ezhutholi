import 'package:eluthozhi_v3/utility/screenUtility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eluthozhi_v3/providers/login_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:eluthozhi_v3/models/language_data.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final CollectionReference _languagesCollection = FirebaseFirestore.instance.collection('languages');
  final FlutterTts _flutterTts = FlutterTts();
  String _selectedLanguage = 'tamil';
  Map<String, List<LanguageData>> _cachedLanguages = {};

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Categories'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'tamil', child: Text('Tamil')),
                DropdownMenuItem(value: 'hindi', child: Text('Hindi')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                }
              },
            ),
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: _handleLogout),
        ],
      ),
      body: SafeArea(
        child: user == null
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

                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildCategoryCard(category);
                    },
                  );
                },
              ),
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
    final categories = rawData.map((item) => LanguageData.fromFirestore(item)).toList();
    _cachedLanguages[lang] = categories;
    return categories;
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 120,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(LanguageData category) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if (category.engTitle != null)
              Text(
                category.engTitle!,
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            const SizedBox(height: 8),
            ...category.items.map(_buildItemSection).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemSection(LanguageItem item) {
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
          spacing: 8,
          runSpacing: 8,
          children: item.subItems.map((letter) {
            return GestureDetector(
              onTap: () async {
                try {
                  await _flutterTts.setLanguage(_selectedLanguage == 'tamil' ? 'ta-IN' : 'hi-IN');
                  await _flutterTts.setPitch(1.0);
                  await _flutterTts.setSpeechRate(0.4);
                  await _flutterTts.speak(letter.name);
                } catch (e) {
                  debugPrint('TTS error: $e');
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF${item.backgroundColor!.substring(1)}')),
                  border: Border.all(
                    color: Color(int.parse('0xFF${item.borderColor!.substring(1)}')),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  letter.name,
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(int.parse('0xFF${item.textColor!.substring(1)}')),
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
    await ScreenUtils.clearSharedPreferences();
    Provider.of<LoginStateProvider>(context, listen: false).logOut();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/Login');
    }
  }
}
