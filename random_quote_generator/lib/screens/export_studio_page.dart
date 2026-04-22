import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../models/quote.dart';
import '../providers/theme_provider.dart';

class ExportStudioPage extends StatefulWidget {
  final Quote quote;

  const ExportStudioPage({super.key, required this.quote});

  @override
  State<ExportStudioPage> createState() => _ExportStudioPageState();
}

class _ExportStudioPageState extends State<ExportStudioPage> {
  final GlobalKey _globalKey = GlobalKey();
  bool _isExporting = false;
  
  // Array linking core gradients to map uniquely rendering contexts
  int _selectedBackgroundIndex = 0; 
  
  final List<List<Color>> _backgroundGradients = [
    [const Color(0xFF1E1E1E), const Color(0xFF2C3E50)], // Classic Dark
    [const Color(0xFFFF512F), const Color(0xFFDD2476)], // Sunset
    [const Color(0xFF00B4DB), const Color(0xFF0083B0)], // Ocean
    [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)], // Cyber Purple
    [const Color(0xFF11998E), const Color(0xFF38EF7D)], // Moss Green
  ];

  Future<void> _exportCanvas() async {
    setState(() {
      _isExporting = true;
    });
    
    try {
      final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      
      final image = await boundary.toImage(pixelRatio: 4.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      
      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/quote_export.png').create();
      await imagePath.writeAsBytes(pngBytes);
      
      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(imagePath.path)], text: 'Check out this quote!');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to export: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final activeGradient = _backgroundGradients[_selectedBackgroundIndex];

    return Scaffold(
      backgroundColor: Colors.black, // Dark canvas room
      appBar: AppBar(
        title: const Text('Export Studio', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          _isExporting 
            ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent))),
              )
            : IconButton(
                icon: const Icon(Icons.share, color: Colors.blueAccent),
                onPressed: _exportCanvas,
              ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), // Smooth border on canvas
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: activeGradient.last.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: -5,
                          )
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: activeGradient,
                        ),
                      ),
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Spacer(),
                          const Icon(
                            Icons.format_quote_rounded,
                            size: 64,
                            color: Colors.white54,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '"${widget.quote.getText(themeProvider.languageCode)}"',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontSize: themeProvider.fontSize * 0.9,
                              fontWeight: FontWeight.w700,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            '- ${widget.quote.getAuthor(themeProvider.languageCode)}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: themeProvider.fontSize * 0.6,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          const Text(
                            "Generated via InspireApp",
                            style: TextStyle(color: Colors.white30, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Bottom Editing Dock Palette
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _backgroundGradients.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedBackgroundIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBackgroundIndex = index;
                    });
                  },
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _backgroundGradients[index],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
