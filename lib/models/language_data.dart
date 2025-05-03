class LanguageData {
  final String title;
  final String? engTitle;
  final List<LanguageItem> items;

  LanguageData({
    required this.title,
    this.engTitle,
    required this.items,
  });

  factory LanguageData.fromFirestore(Map<String, dynamic> json) {
    return LanguageData(
      title: json['title'],
      engTitle: json['eng_title'],
      items: (json['items'] as List<dynamic>)
          .map((item) => LanguageItem.fromJson(item))
          .toList(),
    );
  }
}

class LanguageItem {
  final String? subTitle;
  final String? engTitle;
  final String? textColor;
  final String? borderColor;
  final String? backgroundColor;
  final List<Letter> subItems;

  LanguageItem({
    this.subTitle,
    this.engTitle,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    required this.subItems,
  });

  factory LanguageItem.fromJson(Map<String, dynamic> json) {
    return LanguageItem(
      subTitle: json['subTitle'],
      engTitle: json['engTitle'],
      textColor: json['textColor'],
      borderColor: json['borderColor'],
      backgroundColor: json['backgroundColor'],
      subItems: (json['subItems'] as List<dynamic>)
          .map((e) => Letter.fromJson(e))
          .toList(),
    );
  }
}

class Letter {
  final String name;
  final String english;
  final String sound;
  final int column;

  Letter({
    required this.name,
    required this.english,
    required this.sound,
    required this.column,
  });

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      name: json['name'],
      english: json['english'] ?? '',
      sound: json['sound'],
      column: json['column'],
    );
  }
}
