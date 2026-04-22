import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/quotes_provider.dart';
import '../providers/theme_provider.dart';
import '../models/quote.dart';
import '../data/quotes_data.dart';
import 'settings_page.dart';
import 'library_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _shareQuote(String text, String author) {
    // ignore: deprecated_member_use
    Share.share('"$text"\n\n- $author');
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quotesProvider = Provider.of<QuotesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    final currentQuote = quotesProvider.currentQuote;
    final qotd = quotesProvider.quoteOfTheDay;

    return Scaffold(
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
      extendBodyBehindAppBar: false,
      body: Column(
        children: [
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
                child: quotesProvider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : currentQuote == null
                        ? const Center(child: Text("No quotes found.", style: TextStyle(fontSize: 18)))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Spacer(),
                              AnimatedSwitcher(
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
                                child: Column(
                                  key: ValueKey<String>(currentQuote.id),
                                  children: [
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
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              // Action Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
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
                              const Spacer(),
                              ElevatedButton(
                                onPressed: () {
                                  quotesProvider.generateNewQuoteManually();
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
