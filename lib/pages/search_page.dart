import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eluthozhi_v3/models/language_data.dart';
import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:eluthozhi_v3/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _queryController = TextEditingController();
  final _audioPlayer = AudioPlayer();
  List<Letter> _allLetters = [];
  List<Letter> _results = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLetters();
  }

  @override
  void dispose() {
    _queryController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadLetters() async {
    try {
      final doc =
          await FirebaseFirestore.instance.collection('languages').doc('tamil').get();
      final innerMap = doc.get('data') as Map<String, dynamic>;
      final rawData = innerMap['data'] as List<dynamic>;
      final categories =
          rawData.map((item) => LanguageData.fromFirestore(item)).toList();

      final letters = <Letter>[];
      for (final category in categories) {
        for (final item in category.items) {
          letters.addAll(item.subItems);
        }
      }

      if (!mounted) return;
      setState(() {
        _allLetters = letters;
        _results = letters;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onQueryChanged(String value) {
    final query = value.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _results = _allLetters;
      } else {
        _results = _allLetters.where((letter) {
          return letter.name.toLowerCase().contains(query) ||
              letter.english.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> _playSound(Letter letter) async {
    try {
      await _audioPlayer.play(AssetSource('sounds/${letter.sound}'));
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getFigmaColor(context, 'Schemes', 'Surface'),
      bottomNavigationBar: BottomNavBar(
        currentRoute: ModalRoute.of(context)?.settings.name ?? '/Search',
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: getFigmaColor(context, 'Primary', 'Dark'),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Find letters by Tamil character or English sound.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: getFigmaColor(context, 'Secondary', 'Main'),
                        ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _queryController,
                    onChanged: _onQueryChanged,
                    decoration: InputDecoration(
                      hintText: 'Search letters…',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor:
                          getFigmaColor(context, 'Surface', 'Surface Container'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No letters found',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: getFigmaColor(context, 'Secondary', 'Main'),
              ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final letter = _results[index];
        return ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          tileColor: getFigmaColor(context, 'Surface', 'Surface Container'),
          title: Text(
            letter.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: getFigmaColor(context, 'Primary', 'Dark'),
                ),
          ),
          subtitle: Text(
            letter.english,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: getFigmaColor(context, 'Secondary', 'Main'),
                ),
          ),
          trailing: Icon(
            Icons.volume_up_outlined,
            color: getFigmaColor(context, 'Primary', 'Main'),
          ),
          onTap: () => _playSound(letter),
        );
      },
    );
  }
}
