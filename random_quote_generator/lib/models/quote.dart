class Quote {
  final String id;
  final Map<String, String> text;
  final Map<String, String> author;
  final String category;

  const Quote({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
  });

  String getText(String langCode) {
    return text[langCode] ?? text['en'] ?? '';
  }

  String getAuthor(String langCode) {
    return author[langCode] ?? author['en'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'category': category,
    };
  }

  factory Quote.fromJson(Map<String, dynamic> map) {
    return Quote(
      id: map['id'] ?? '',
      text: Map<String, String>.from(map['text'] ?? {}),
      author: Map<String, String>.from(map['author'] ?? {}),
      category: map['category'] ?? 'All',
    );
  }
}
