import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

class ApiService {
  static const String _quotableUrl = 'https://api.quotable.io/quotes/random';

  Future<Quote> getRandomQuote({String category = "All"}) async {
    try {
      String url = _quotableUrl;
      // Map local categories to quotable tags if needed, or simply append
      if (category != "All") {
        url += '?tags=${category.toLowerCase()}';
      }

      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Quotable /quotes/random returns a List of objects
        if (data is List && data.isNotEmpty) {
           final q = data[0];
           return Quote(
             id: q['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
             text: {"en": q['content'] ?? ""},
             author: {"en": q['author'] ?? "Unknown"},
             category: (q['tags'] != null && q['tags'].isNotEmpty) ? q['tags'][0].toString() : category,
           );
        }
      }
      throw Exception("Invalid data or status code");
    } catch (e) {
      throw Exception("Network Exception: $e");
    }
  }
}
