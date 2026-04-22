import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/theme_provider.dart';
import 'providers/quotes_provider.dart';
import 'providers/audio_provider.dart';
import 'screens/home_page.dart';
import 'screens/onboarding_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => QuotesProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Random Quote Generator',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode == 'system' 
              ? ThemeMode.system 
              : (themeProvider.themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2C3E50),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.getTextTheme(themeProvider.fontFamily, ThemeData.light().textTheme),
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
              centerTitle: true,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C3E50),
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2C3E50),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            textTheme: GoogleFonts.getTextTheme(themeProvider.fontFamily, ThemeData.dark().textTheme),
            scaffoldBackgroundColor: const Color(0xFF1E1E1E),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              centerTitle: true,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
            ),
          ),
          home: !themeProvider.isInitialized
            ? const Scaffold(
                backgroundColor: Color(0xFF1E1E1E),
                body: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
              )
            : (themeProvider.hasSeenOnboarding ? const HomePage() : const OnboardingPage()),
        );
      },
    );
  }
}
