import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  
  // Array linking core gradients to map uniquely rendering contexts
  int _selectedBackgroundIndex = 0; 
  
  final List<List<Color>> _backgroundGradients = [
    [const Color(0xFF1E1E1E), const Color(0xFF2C3E50)], // Classic Dark
    [const Color(0xFFFF512F), const Color(0xFFDD2476)], // Sunset
    [const Color(0xFF00B4DB), const Color(0xFF0083B0)], // Ocean
    [const Color(0xFF8E2DE2), const Color(0xFF4A00E0)], // Cyber Purple
    [const Color(0xFF11998E), const Color(0xFF38EF7D)], // Moss Green
  ];

  Future<Uint8List?> _generateImageBytes() async {
    try {
      final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      
      final image = await boundary.toImage(pixelRatio: 4.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  void _triggerNativeShare(Uint8List bytes) async {
    final xFile = XFile.fromData(
      bytes,
      mimeType: 'image/png',
      name: 'quote_export.png',
    );
    // ignore: deprecated_member_use
    await Share.shareXFiles([xFile], text: 'Check out this quote!');
  }

  void _openExportMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        bool isProcessing = false;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? const Color(0xFF1E1E1E) 
                    : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle Bar
                  Container(
                    height: 5, 
                    width: 48, 
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5), 
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Export & Share', 
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select how you want to handle your canvas', 
                    style: TextStyle(color: Colors.grey, fontSize: 14)
                  ),
                  const SizedBox(height: 32),

                  if (isProcessing)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          CircularProgressIndicator(color: Colors.blueAccent),
                          SizedBox(height: 16),
                          Text("Rendering High-Def Canvas...", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold))
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        // Share via Apps Block
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blueAccent.withOpacity(0.3))
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.ios_share_rounded, color: Colors.white),
                            ),
                            title: const Text('Share to Apps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                            subtitle: const Text('Open device system menu', style: TextStyle(color: Colors.grey)),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.blueAccent, size: 16),
                            onTap: () async {
                              setModalState(() => isProcessing = true);
                              final bytes = await _generateImageBytes();
                              if (!context.mounted) return;
                              if (bytes != null) {
                                Navigator.pop(context); // Pop menu
                                _triggerNativeShare(bytes); // Fire system sheet afterwards
                              } else {
                                setModalState(() => isProcessing = false);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to render framework boundary.')));
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Fake Copy / Save generic placeholder block enhancing premium feel!
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.copy_rounded, color: Colors.grey),
                            ),
                            title: const Text('Load to Memory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                            subtitle: const Text('Generate raw PNG without system post', style: TextStyle(color: Colors.grey)),
                            onTap: () async {
                              setModalState(() => isProcessing = true);
                              final bytes = await _generateImageBytes();
                              if (!context.mounted) return;
                              if (bytes != null) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Memory array buffered locally! (Simulation)')));
                              } else {
                                setModalState(() => isProcessing = false);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        );
      }
    );
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
          IconButton(
            icon: const Icon(Icons.share, color: Colors.blueAccent),
            // Re-wired the button directly summoning the gorgeous Modal Engine
            onPressed: _openExportMenu,
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
