class LanguageData {
  final String name;
  final String english;
  final String sound;
  final int column;

  LanguageData({
    required this.name,
    required this.english,
    required this.sound,
    required this.column,
  });

  factory LanguageData.fromFirestore(Map<String, dynamic> data) {
    return LanguageData(
      name: data['name'] ?? '',
      english: data['english'] ?? '',
      sound: data['sound'] ?? '',
      column: data['column'] ?? 1,
    );
  }
}