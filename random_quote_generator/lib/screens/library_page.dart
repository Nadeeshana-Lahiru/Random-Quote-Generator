import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quotes_provider.dart';
import '../providers/theme_provider.dart';
import '../models/quote.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Library'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: "Favorites"),
              Tab(icon: Icon(Icons.history), text: "History"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FavoritesTab(),
            _HistoryTab(),
          ],
        ),
      ),
    );
  }
}

class _FavoritesTab extends StatelessWidget {
  const _FavoritesTab();

  @override
  Widget build(BuildContext context) {
    final quotesProvider = Provider.of<QuotesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final favorites = quotesProvider.favoriteQuotes;

    if (favorites.isEmpty) {
      return const Center(child: Text("No favorites saved yet."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final quote = favorites[index];
        return _QuoteCard(quote: quote, themeProvider: themeProvider, quotesProvider: quotesProvider);
      },
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    final quotesProvider = Provider.of<QuotesProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final history = quotesProvider.historyQuotes;

    if (history.isEmpty) {
      return const Center(child: Text("Start viewing quotes to build a history!"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final quote = history[index];
        return _QuoteCard(quote: quote, themeProvider: themeProvider, quotesProvider: quotesProvider);
      },
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final Quote quote;
  final ThemeProvider themeProvider;
  final QuotesProvider quotesProvider;

  const _QuoteCard({
    required this.quote,
    required this.themeProvider,
    required this.quotesProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"${quote.getText(themeProvider.languageCode)}"',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '- ${quote.getAuthor(themeProvider.languageCode)}',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Theme.of(context).colorScheme.primary),
                ),
                IconButton(
                  icon: Icon(
                    quotesProvider.isFavorite(quote.id) ? Icons.favorite : Icons.favorite_border,
                    color: quotesProvider.isFavorite(quote.id) ? Colors.red : Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    quotesProvider.toggleFavorite(quote);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
