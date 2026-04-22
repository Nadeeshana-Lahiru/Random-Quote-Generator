import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../providers/theme_provider.dart';
import '../providers/quotes_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _version = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _version = "${info.version}+${info.buildNumber}";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _version = "Unknown version";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final quotesProvider = Provider.of<QuotesProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Auto-Refresh Quotes', style: TextStyle(fontSize: 18)),
            subtitle: const Text('Fetch a new quote automatically every 30 seconds'),
            secondary: const Icon(Icons.timer),
            value: quotesProvider.isAutoRefreshEnabled,
            onChanged: (value) {
              quotesProvider.toggleAutoRefresh(value);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Theme Mode', style: TextStyle(fontSize: 18)),
            subtitle: const Text('Applies dynamic dark/light backgrounds'),
            trailing: DropdownButton<String>(
              value: themeProvider.themeMode,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System Default')),
                DropdownMenuItem(value: 'light', child: Text('Light Mode')),
                DropdownMenuItem(value: 'dark', child: Text('Dark Mode')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  themeProvider.setThemeMode(newValue);
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.record_voice_over),
            title: const Text('TTS Voice Gender', style: TextStyle(fontSize: 18)),
            subtitle: const Text('Dictates spoken quote profiles'),
            trailing: DropdownButton<String>(
              value: themeProvider.ttsGender,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'female', child: Text('Female Voice')),
                DropdownMenuItem(value: 'male', child: Text('Male Voice')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  themeProvider.setTtsGender(newValue);
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language', style: TextStyle(fontSize: 18)),
            subtitle: const Text('Applies to quotes content'),
            trailing: DropdownButton<String>(
              value: themeProvider.languageCode,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'si', child: Text('Sinhala')),
                DropdownMenuItem(value: 'ta', child: Text('Tamil')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  themeProvider.setLanguage(newValue);
                }
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.text_format),
            title: const Text('Font Style', style: TextStyle(fontSize: 18)),
            trailing: DropdownButton<String>(
              value: themeProvider.fontFamily,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'Outfit', child: Text('Outfit')),
                DropdownMenuItem(value: 'Lato', child: Text('Lato')),
                DropdownMenuItem(value: 'Roboto', child: Text('Roboto')),
                DropdownMenuItem(value: 'Playfair Display', child: Text('Playfair')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  themeProvider.setFontFamily(newValue);
                }
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.format_size, color: Colors.grey),
                    SizedBox(width: 16),
                    Text('Font Size', style: TextStyle(fontSize: 18)),
                  ],
                ),
                Slider(
                  value: themeProvider.fontSize,
                  min: 16.0,
                  max: 42.0,
                  divisions: 13,
                  label: themeProvider.fontSize.round().toString(),
                  onChanged: (double value) {
                    themeProvider.setFontSize(value);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App Version', style: TextStyle(fontSize: 18)),
            trailing: Text(
              _version,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
