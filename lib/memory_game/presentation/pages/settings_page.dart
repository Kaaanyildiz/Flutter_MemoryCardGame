import 'package:flutter/material.dart';
import 'package:memorycardgame/memory_game/models/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:memorycardgame/memory_game/models/language_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _selectedLanguage;
  late bool _isDarkMode;
  
  @override
  void initState() {
    super.initState();
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    _isDarkMode = settingsProvider.isDarkMode;
    _selectedLanguage = settingsProvider.language == LanguageData.turkish ? 'tr' : 'en';
  }
  
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final lang = settingsProvider.language;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          lang.get('settings_title'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51), // 0.2 alpha
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              settingsProvider.isDarkMode
                  ? Colors.deepPurple.shade900
                  : Colors.blue.shade500,
              settingsProvider.isDarkMode
                  ? Colors.indigo.shade800
                  : Colors.lightBlue.shade300,
              settingsProvider.isDarkMode
                  ? Colors.blue.shade900
                  : Colors.blue.shade200,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Dil seçimi
                _buildSettingsCard(
                  title: lang.get('language'),
                  icon: Icons.language,
                  child: Column(
                    children: [
                      _buildLanguageOption(
                        title: 'English',
                        value: 'en',
                        groupValue: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                            Provider.of<SettingsProvider>(context, listen: false)
                                .setLanguage(value);
                          });
                        },
                      ),
                      const Divider(),
                      _buildLanguageOption(
                        title: 'Türkçe',
                        value: 'tr',
                        groupValue: _selectedLanguage,
                        onChanged: (value) {
                          setState(() {
                            _selectedLanguage = value!;
                            Provider.of<SettingsProvider>(context, listen: false)
                                .setLanguage(value);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Tema seçimi
                _buildSettingsCard(
                  title: lang.get('theme'),
                  icon: _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  child: SwitchListTile(
                    title: Text(_isDarkMode
                        ? lang.get('dark_mode')
                        : lang.get('light_mode')),
                    value: _isDarkMode,
                    activeColor: Colors.purple.shade400,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                        Provider.of<SettingsProvider>(context, listen: false)
                            .setDarkMode(value);
                      });
                    },
                  ),
                ),
                
                const Spacer(),
                
                // Kaydet butonu
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: Text(lang.get('save')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: Colors.black45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          child,
        ],
      ),
    );
  }
  
  Widget _buildLanguageOption({
    required String title,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: groupValue,
      activeColor: Colors.purple.shade400,
      onChanged: onChanged,
    );
  }
}