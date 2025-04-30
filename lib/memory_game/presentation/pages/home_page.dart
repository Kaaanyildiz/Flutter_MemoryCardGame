import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:memorycardgame/memory_game/models/language_model.dart';
import 'package:memorycardgame/memory_game/models/settings_provider.dart';
import 'package:memorycardgame/memory_game/presentation/pages/difficulty_selection_page.dart';
import 'package:memorycardgame/memory_game/presentation/pages/settings_page.dart';
import 'package:memorycardgame/memory_game/presentation/tutorial/memory_game_tutorial.dart';
import 'package:memorycardgame/memory_game/presentation/widgets/animated_card_background.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<String> _cardEmojis = ['🐼', '🦊', '🐶', '🐱', '🦁', '🐯', '🐮', '🦄'];
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final lang = settingsProvider.language;
    final isDarkMode = settingsProvider.isDarkMode;
    
    return Scaffold(
      body: Stack(
        children: [
          // Floating animated cards background
          AnimatedCardBackground(
            controller: _controller, 
            cardEmojis: _cardEmojis,
          ),
          
          // Main content with glass effect
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLogo(lang, isDarkMode),
                      const SizedBox(height: 60),
                      _buildGameOptions(context, lang),
                      const SizedBox(height: 40),
                      _buildHighScoreButton(context, lang, isDarkMode),
                      const SizedBox(height: 20),
                      _buildSettingsButton(context, lang, isDarkMode),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(LanguageModel lang, bool isDarkMode) {
    // Logo için renk teması
    final logoColor = isDarkMode ? Colors.purple.shade400 : Colors.blue.shade600;
    final shadowColor1 = isDarkMode ? Colors.purple.withAlpha(127) : Colors.blue.withAlpha(127);
    final shadowColor2 = isDarkMode ? Colors.blue.withAlpha(77) : Colors.lightBlue.withAlpha(77);
    final textShadowColor = isDarkMode ? Colors.black54 : Colors.black38;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final subtextColor = isDarkMode ? Colors.white.withAlpha(229) : Colors.black.withAlpha(204);
    
    return Column(
      children: [
        // Logo container with 3D effect
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: shadowColor1, // Tema için renk
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: shadowColor2, // Tema için renk
                blurRadius: 20,
                offset: const Offset(-15, -15),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.psychology_alt_rounded,
              size: 70,
              color: logoColor,
            ),
          ),
        )
        .animate()
        .fade(duration: 800.ms)
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          curve: Curves.elasticOut,
          duration: 1200.ms,
        ),
        
        const SizedBox(height: 24),
        
        // Game title
        Text(
          lang.get('app_title'),
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: 2.0,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: textShadowColor,
                offset: const Offset(2.0, 2.0),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        )
        .animate()
        .fadeIn(delay: 400.ms, duration: 800.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack, duration: 800.ms),
        
        const SizedBox(height: 12),
        
        // Tagline
        Text(
          lang.get('app_tagline'),
          style: TextStyle(
            fontSize: 18,
            color: subtextColor,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        )
        .animate()
        .fadeIn(delay: 600.ms, duration: 800.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutBack, duration: 800.ms),
      ],
    );
  }

  Widget _buildGameOptions(BuildContext context, LanguageModel lang) {
    return Column(
      children: [
        _buildGameButton(
          title: lang.get('play_now'),
          icon: Icons.play_circle_fill_rounded,
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.teal.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => 
                  const DifficultySelectionPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          },
        ).animate().fadeIn(delay: 200.ms).slideX(
          begin: 0.3,
          end: 0,
          curve: Curves.easeOutBack,
          duration: 600.ms,
        ),

        const SizedBox(height: 20),

        _buildGameButton(
          title: lang.get('how_to_play'),
          icon: Icons.help_rounded,
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () => _showTutorial(context),
        ).animate().fadeIn(delay: 300.ms).slideX(
          begin: -0.3,
          end: 0,
          curve: Curves.easeOutBack,
          duration: 600.ms,
        ),
      ],
    );
  }

  Widget _buildGameButton({
    required String title,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: Colors.white.withAlpha(51), // 0.2 alpha
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withAlpha(127), // 0.5 alpha
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 36,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHighScoreButton(BuildContext context, LanguageModel lang, bool isDarkMode) {
    // Tema için renk
    final buttonColor = isDarkMode ? Colors.blue.shade500 : Colors.blue.shade400;
    
    return _buildSmallButton(
      title: lang.get('high_scores'),
      icon: Icons.leaderboard_rounded,
      color: buttonColor,
      onTap: () {
        // TO DO: Navigate to high scores page
        // For now just show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${lang.get('high_scores')} - coming soon!')),
        );
      },
    ).animate().fadeIn(delay: 400.ms).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1, 1),
      duration: 500.ms,
    );
  }

  Widget _buildSettingsButton(BuildContext context, LanguageModel lang, bool isDarkMode) {
    // Tema için renk
    final buttonColor = isDarkMode ? Colors.purple.shade500 : Colors.purple.shade400;
    
    return _buildSmallButton(
      title: lang.get('settings'),
      icon: Icons.settings,
      color: buttonColor,
      onTap: () {
        // Settings sayfasına git
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
              const SettingsPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
    ).animate().fadeIn(delay: 500.ms).scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1, 1),
      duration: 500.ms,
    );
  }

  Widget _buildSmallButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          splashColor: Colors.white.withAlpha(51), // 0.2 alpha
          child: Ink(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: color.withAlpha(127), // 0.5 alpha
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void _showTutorial(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
          MemoryGameTutorial(
            onTutorialCompleted: () => Navigator.pop(context),
          ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}