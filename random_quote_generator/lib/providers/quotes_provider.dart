import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quote.dart';
import '../data/quotes_data.dart';

class QuotesProvider extends ChangeNotifier {
  static const String _favoritesKey = 'favorite_quotes';
  
  Set<String> _favoriteIds = {};
  String _selectedCategory = "All";
  String _searchQuery = "";
  
  Quote? _currentQuote;
  Timer? _autoRefreshTimer;

  QuotesProvider() {
    _loadFavorites();
    _generateRandomQuote();
    _startAutoRefresh();
  }

  Set<String> get favoriteIds => _favoriteIds;
  String get selectedCategory => _selectedCategory;
  Quote? get currentQuote => _currentQuote;

  List<Quote> get filteredQuotes {
    return quotesList.where((quote) {
      final matchesCategory = _selectedCategory == "All" || quote.category == _selectedCategory;
      if (!matchesCategory) return false;

      if (_searchQuery.isEmpty) return true;
      
      final query = _searchQuery.toLowerCase();
      // Search across all languages for simplicity, or just english as fallback
      final textEn = quote.getText('en').toLowerCase();
      final textSi = quote.getText('si').toLowerCase();
      final textTa = quote.getText('ta').toLowerCase();
      final authorEn = quote.getAuthor('en').toLowerCase();
      
      return textEn.contains(query) || textSi.contains(query) || textTa.contains(query) || authorEn.contains(query);
    }).toList();
  }

  List<Quote> get favoriteQuotes {
    return quotesList.where((q) => _favoriteIds.contains(q.id)).toList();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(_favoritesKey);
    if (savedList != null) {
      _favoriteIds = savedList.toSet();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String quoteId) async {
    if (_favoriteIds.contains(quoteId)) {
      _favoriteIds.remove(quoteId);
    } else {
      _favoriteIds.add(quoteId);
    }
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteIds.toList());
  }

  bool isFavorite(String quoteId) {
    return _favoriteIds.contains(quoteId);
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _generateRandomQuote(); // Generate new quote when category changes
    _restartAutoRefresh();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _generateRandomQuote(); // Recalculate
    notifyListeners();
  }

  void _generateRandomQuote() {
    final currentList = filteredQuotes;
    if (currentList.isEmpty) {
      _currentQuote = null;
    } else {
      final random = Random();
      // Ensure we don't show the exact same quote if possible
      if (currentList.length > 1 && _currentQuote != null) {
        Quote newQuote;
        do {
          newQuote = currentList[random.nextInt(currentList.length)];
        } while (newQuote.id == _currentQuote!.id);
        _currentQuote = newQuote;
      } else {
        _currentQuote = currentList[random.nextInt(currentList.length)];
      }
    }
    notifyListeners();
  }

  void generateNewQuoteManually() {
    _generateRandomQuote();
    _restartAutoRefresh(); // Reset the timer if user manually clicks
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _generateRandomQuote();
    });
  }

  void _restartAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }
}
