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
}
