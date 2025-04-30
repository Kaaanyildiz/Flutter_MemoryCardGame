import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memorycardgame/memory_game/models/settings_provider.dart';
import 'package:memorycardgame/memory_game/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Tam ekran modunu etkinleştirme (opsiyonel)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  
  // Settings provider oluştur
  final settingsProvider = SettingsProvider();
  // Ayarları yükle
  await settingsProvider.loadSettings();
  
  runApp(
    ChangeNotifierProvider.value(
      value: settingsProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    return MaterialApp(
      title: 'Memory Card Game',
      debugShowCheckedModeBanner: false,
      theme: settingsProvider.isDarkMode 
          ? _applyFontToTheme(settingsProvider.darkTheme, context) 
          : _applyFontToTheme(settingsProvider.lightTheme, context),
      home: const HomePage(),
    );
  }
  
  // Google Fonts'u tema ile birleştirir
  ThemeData _applyFontToTheme(ThemeData theme, BuildContext context) {
    final textTheme = GoogleFonts.poppinsTextTheme(theme.textTheme);
    
    return theme.copyWith(
      textTheme: textTheme,
      useMaterial3: true,
    );
  }
}