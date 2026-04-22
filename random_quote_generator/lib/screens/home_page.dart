import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/quotes_provider.dart';
import '../providers/theme_provider.dart';
import '../data/quotes_data.dart';
import 'settings_page.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _shareQuote(String text, String author) {
    // ignore: deprecated_member_use
    Share.share('"$text"\n\n- $author');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quotesProvider = Provider.of<QuotesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    final currentQuote = quotesProvider.currentQuote;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search quotes...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  quotesProvider.setSearchQuery(value);
                },
              )
            : const Text('Inspire Me'),
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
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesPage(),
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
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
          // Categories List
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
                        _fadeController.forward(from: 0.0);
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
                child: currentQuote == null
                    ? const Center(child: Text("No quotes found.", style: TextStyle(fontSize: 18)))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Spacer(),
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.format_quote_rounded,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '"${currentQuote.getText(themeProvider.languageCode)}"',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  '- ${currentQuote.getAuthor(themeProvider.languageCode)}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: theme.colorScheme.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 32),
                                // Action Buttons (Favorite and Share)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        quotesProvider.isFavorite(currentQuote.id) 
                                            ? Icons.favorite 
                                            : Icons.favorite_border,
                                        color: quotesProvider.isFavorite(currentQuote.id) 
                                            ? Colors.red 
                                            : theme.iconTheme.color,
                                        size: 32,
                                      ),
                                      onPressed: () {
                                        quotesProvider.toggleFavorite(currentQuote.id);
                                      },
                                    ),
                                    const SizedBox(width: 32),
                                    IconButton(
                                      icon: const Icon(Icons.share, size: 32),
                                      onPressed: () {
                                        _shareQuote(
                                          currentQuote.getText(themeProvider.languageCode),
                                          currentQuote.getAuthor(themeProvider.languageCode)
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              _fadeController.reverse().then((_) {
                                quotesProvider.generateNewQuoteManually();
                                _fadeController.forward();
                              });
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
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
