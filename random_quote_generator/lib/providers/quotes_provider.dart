import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:home_widget/home_widget.dart';
import '../models/quote.dart';
import '../data/quotes_data.dart';
import '../services/api_service.dart';

class QuotesProvider extends ChangeNotifier {
  static const String _favoritesKey = 'favorite_quotes_v2';
  static const String _qotdKey = 'quote_of_the_day_json';
  static const String _qotdDateKey = 'quote_of_the_day_date';
  static const String _historyKey = 'history_quotes_v2';
  
  final ApiService _apiService = ApiService();
  
  List<Quote> _favoriteQuotesList = [];
  List<Quote> _historyQuotesList = [];
  
  String _selectedCategory = "All";
  
  Quote? _currentQuote;
  Quote? _quoteOfTheDay;
  Timer? _autoRefreshTimer;
  bool _isLoading = false;

  QuotesProvider() {
    _initProvider();
  }

  Future<void> _initProvider() async {
    await _loadFavorites();
    await _loadHistory();
    await _loadOrFetchQOTD();
    generateNewQuoteManually();
  }

  List<Quote> get favoriteQuotes => _favoriteQuotesList;
  List<Quote> get historyQuotes => _historyQuotesList;
  String get selectedCategory => _selectedCategory;
  Quote? get currentQuote => _currentQuote;
  Quote? get quoteOfTheDay => _quoteOfTheDay;
  bool get isLoading => _isLoading;

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(_favoritesKey);
    if (savedList != null) {
      _favoriteQuotesList = savedList
          .map((jsonStr) => Quote.fromJson(json.decode(jsonStr)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _favoriteQuotesList
        .map((q) => json.encode(q.toJson()))
        .toList();
    await prefs.setStringList(_favoritesKey, jsonList);
  }
  
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final savedList = prefs.getStringList(_historyKey);
    if (savedList != null) {
      _historyQuotesList = savedList
          .map((jsonStr) => Quote.fromJson(json.decode(jsonStr)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _historyQuotesList
        .map((q) => json.encode(q.toJson()))
        .toList();
    await prefs.setStringList(_historyKey, jsonList);
  }

  void _recordToHistory(Quote quote) {
    if (_historyQuotesList.isEmpty || _historyQuotesList.first.id != quote.id) {
       _historyQuotesList.insert(0, quote);
       if (_historyQuotesList.length > 100) {
         _historyQuotesList.removeLast();
       }
       _saveHistory();
       notifyListeners(); // allows history UI to update instantly
    }
  }

  Future<void> _updateWidget(Quote quote) async {
    try {
      await HomeWidget.saveWidgetData<String>('quote_text', quote.getText('en'));
      await HomeWidget.saveWidgetData<String>('quote_author', '- ${quote.getAuthor('en')}');
      await HomeWidget.updateWidget(name: 'QuoteWidgetProvider', androidName: 'QuoteWidgetProvider');
    } catch (e) {
      // Widget error silently ignored if not supported
    }
  }

  Future<void> _loadOrFetchQOTD() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayDate = DateTime.now().toIso8601String().split('T')[0];
    final String? savedDate = prefs.getString(_qotdDateKey);
    final String? savedQotdJson = prefs.getString(_qotdKey);

    if (savedDate == todayDate && savedQotdJson != null) {
      _quoteOfTheDay = Quote.fromJson(json.decode(savedQotdJson));
      notifyListeners();
    } else {
      try {
        final newQotd = await _apiService.getRandomQuote(category: "Motivation");
        _quoteOfTheDay = newQotd;
        await prefs.setString(_qotdDateKey, todayDate);
        await prefs.setString(_qotdKey, json.encode(newQotd.toJson()));
        notifyListeners();
      } catch (e) {
        _quoteOfTheDay = quotesList.first;
        notifyListeners();
      }
    }
  }

  Future<void> toggleFavorite(Quote quote) async {
    final exists = _favoriteQuotesList.any((q) => q.id == quote.id);
    if (exists) {
      _favoriteQuotesList.removeWhere((q) => q.id == quote.id);
    } else {
      _favoriteQuotesList.add(quote);
    }
    notifyListeners();
    await _saveFavorites();
  }

  bool isFavorite(String quoteId) {
    return _favoriteQuotesList.any((q) => q.id == quoteId);
  }

  void setCategory(String category) {
    _selectedCategory = category;
    generateNewQuoteManually();
  }

  void setSearchQuery(String query) {
    notifyListeners(); 
  }

  Future<void> _generateRandomQuote() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final fetchedQuote = await _apiService.getRandomQuote(category: _selectedCategory);
      _currentQuote = fetchedQuote;
      _recordToHistory(fetchedQuote);
      _updateWidget(fetchedQuote);
    } catch (e) {
      // Offline Mode Fallback
      final list = _localFilteredQuotes();
      if (list.isNotEmpty) {
        final random = Random();
        _currentQuote = list[random.nextInt(list.length)];
        _recordToHistory(_currentQuote!);
        _updateWidget(_currentQuote!);
      } else {
        _currentQuote = null; 
      }
    }
    
    _isLoading = false;
    notifyListeners();
  }

  List<Quote> _localFilteredQuotes() {
    // Advanced offline fallback: use full history if available matching category
    Set<Quote> offlinePool = {};
    
    for (var q in _historyQuotesList) {
      if (_selectedCategory == "All" || q.category == _selectedCategory) {
        offlinePool.add(q);
      }
    }
    
    // Also inject hardcoded quotes so they're always available
    for (var q in quotesList) {
      if (_selectedCategory == "All" || q.category == _selectedCategory) {
        offlinePool.add(q);
      }
    }
    
    return offlinePool.toList();
  }

  void generateNewQuoteManually() {
    _generateRandomQuote();
    _restartAutoRefresh();
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
