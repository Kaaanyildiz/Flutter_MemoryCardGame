import 'package:flutter/material.dart';
import 'package:memorycardgame/memory_game/models/language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  // Varsayılan değerler
  LanguageModel _language = LanguageData.english;
  bool _isDarkMode = true;
  
  // Getter metodları
  LanguageModel get language => _language;
  bool get isDarkMode => _isDarkMode;
  
  // Tema hazır renkleri
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade500,
      secondary: Colors.purple.shade400,
      background: Colors.grey.shade100,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.grey.shade100,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue.shade500,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
  
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.purple.shade700,
    colorScheme: ColorScheme.dark(
      primary: Colors.purple.shade700,
      secondary: Colors.blue.shade500,
      background: const Color(0xFF121212),
      surface: const Color(0xFF202020),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.purple.shade800,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF202020),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
  
  // Dil ve tema değiştirme metodları
  void setLanguage(String languageCode) {
    if (languageCode == 'tr') {
      _language = LanguageData.turkish;
    } else {
      _language = LanguageData.english;
    }
    _saveSettings();
    notifyListeners();
  }
  
  void setDarkMode(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    _saveSettings();
    notifyListeners();
  }
  
  // Ayarları kaydetme ve yükleme metodları
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _language == LanguageData.turkish ? 'tr' : 'en');
    await prefs.setBool('darkMode', _isDarkMode);
  }
  
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language') ?? 'en';
    final isDarkMode = prefs.getBool('darkMode') ?? true;
    
    if (languageCode == 'tr') {
      _language = LanguageData.turkish;
    } else {
      _language = LanguageData.english;
    }
    
    _isDarkMode = isDarkMode;
    notifyListeners();
  }
}