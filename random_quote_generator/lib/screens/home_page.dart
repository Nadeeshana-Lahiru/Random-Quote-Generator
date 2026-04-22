import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../providers/quotes_provider.dart';
import '../providers/theme_provider.dart';
import '../models/quote.dart';
import '../data/quotes_data.dart';
import '../widgets/quote_skeleton.dart';
import 'settings_page.dart';
import 'library_page.dart';
import 'export_studio_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _gradientController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  double _dragDistance = 0.0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _gradientController = AnimationController(
      vsync: this, 
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _fadeController.dispose();
    _gradientController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _speakQuote(String text, String author, String gender) async {
    await _flutterTts.setPitch(gender == 'male' ? 0.6 : 1.2);
    await _flutterTts.setSpeechRate(0.5); 
    await _flutterTts.speak("$text... By $author.");
  }

  void _showQuoteOfTheDay(BuildContext context, Quote qotd, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.wb_sunny, color: Colors.orange),
              SizedBox(width: 8),
              Text('Quote of the Day', style: TextStyle(fontSize: 20)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                '"${qotd.getText(themeProvider.languageCode)}"',
                style: TextStyle(
                  fontSize: themeProvider.fontSize * 0.8,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '- ${qotd.getAuthor(themeProvider.languageCode)}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _generateNewQuoteWithAnimation(QuotesProvider quotesProvider) {
    if (quotesProvider.isLoading) return; // Prevent spamming during shimmer layer
    _flutterTts.stop(); 
    _fadeController.reverse().then((_) {
      quotesProvider.generateNewQuoteManually();
      _fadeController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final quotesProvider = Provider.of<QuotesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    final currentQuote = quotesProvider.currentQuote;
    final qotd = quotesProvider.quoteOfTheDay;

    return Scaffold(
      backgroundColor: Colors.transparent, // Handled flawlessly by Parallax logic below!
      extendBodyBehindAppBar: true, // Elevates the modern style
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search offline cache...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  quotesProvider.setSearchQuery(value);
                },
              )
            : Text('Hello, ${themeProvider.userName}', style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  quotesProvider.setSearchQuery("");
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.library_books),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LibraryPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // 1. Dynamic Ambience Parallax Loop Layout
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            Color.lerp(const Color(0xFF0F2027), const Color(0xFF2C3E50), _gradientController.value)!,
                            Color.lerp(const Color(0xFF203A43), const Color(0xFF000000), _gradientController.value)!,
                          ]
                        : [
                            Color.lerp(const Color(0xFFE8F3F1), const Color(0xFFFDEBEE), _gradientController.value)!,
                            Color.lerp(const Color(0xFFE1F5FE), const Color(0xFFFFF3E0), _gradientController.value)!,
                          ],
                  ),
                ),
              );
            },
          ),

          // 2. Core Functional Body
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + AppBar().preferredSize.height + 16),
              // Banner for Quote of the Day
              if (qotd != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: InkWell(
                    onTap: () => _showQuoteOfTheDay(context, qotd, themeProvider),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wb_sunny, color: Colors.orange, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Quote of the Day",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const Text(
                                  "Tap to view today's inspiration!",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),

              // Categories List Scrollable Ribbon
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: availableCategories.length,
                  itemBuilder: (context, index) {
                    final category = availableCategories[index];
                    final isSelected = quotesProvider.selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            quotesProvider.setCategory(category);
                          }
                        },
                        // ignore: deprecated_member_use
                        selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              Expanded(
                child: SafeArea(
                  top: false, // Prevents safety bounds double-up due to underlying Stack matrix
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                    child: GestureDetector(
                      onHorizontalDragStart: (details) {
                        _dragDistance = 0;
                      },
                      onHorizontalDragUpdate: (details) {
                        _dragDistance += details.primaryDelta ?? 0;
                      },
                      onHorizontalDragEnd: (details) {
                        if (_dragDistance.abs() > 50 || (details.primaryVelocity != null && details.primaryVelocity!.abs() > 300)) {
                          _generateNewQuoteWithAnimation(quotesProvider);
                        }
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.05),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: quotesProvider.isLoading
                            ? const QuoteSkeleton(key: ValueKey('skeletonLayer'))
                            : currentQuote == null
                                ? const Center(key: ValueKey('emptyLayer'), child: Text("No quotes found.", style: TextStyle(fontSize: 18)))
                                : Column(
                                    key: ValueKey<String>(currentQuote.id),
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Spacer(),
                                      const Icon(
                                        Icons.format_quote_rounded,
                                        size: 56,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        '"${currentQuote.getText(themeProvider.languageCode)}"',
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                          fontSize: themeProvider.fontSize,
                                          fontWeight: FontWeight.w600,
                                          height: 1.4,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        '- ${currentQuote.getAuthor(themeProvider.languageCode)}',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontSize: themeProvider.fontSize * 0.7,
                                          fontStyle: FontStyle.italic,
                                          color: theme.colorScheme.primary,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 32),
                                      // Action Buttons Layer
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.volume_up, size: 32),
                                            onPressed: () {
                                              _speakQuote(
                                                currentQuote.getText(themeProvider.languageCode),
                                                currentQuote.getAuthor(themeProvider.languageCode),
                                                themeProvider.ttsGender
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 16),
                                          IconButton(
                                            icon: AnimatedSwitcher(
                                              duration: const Duration(milliseconds: 300),
                                              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                                              child: Icon(
                                                quotesProvider.isFavorite(currentQuote.id) 
                                                    ? Icons.favorite 
                                                    : Icons.favorite_border,
                                                key: ValueKey(quotesProvider.isFavorite(currentQuote.id)),
                                                color: quotesProvider.isFavorite(currentQuote.id) 
                                                    ? Colors.red 
                                                    : theme.iconTheme.color,
                                                size: 32,
                                              ),
                                            ),
                                            onPressed: () {
                                              quotesProvider.toggleFavorite(currentQuote);
                                            },
                                          ),
                                          const SizedBox(width: 16),
                                          IconButton(
                                            icon: const Icon(Icons.share, size: 32),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => ExportStudioPage(quote: currentQuote),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () {
                                          _generateNewQuoteWithAnimation(quotesProvider);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: const Text(
                                          'NEW QUOTE',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "Swipe left/right for new quotes!",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.grey, fontSize: 12),
                                      )
                                    ],
                                  ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
