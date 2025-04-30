import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:memorycardgame/memory_game/models/settings_provider.dart';
import 'package:memorycardgame/memory_game/presentation/pages/memory_game_screen.dart';
import 'package:memorycardgame/memory_game/presentation/widgets/animated_card_background.dart';
import 'package:provider/provider.dart';

class DifficultySelectionPage extends StatefulWidget {
  const DifficultySelectionPage({super.key});

  @override
  State<DifficultySelectionPage> createState() => _DifficultySelectionPageState();
}

class _DifficultySelectionPageState extends State<DifficultySelectionPage> with SingleTickerProviderStateMixin {
  late final AnimationController _backgroundController;
  final List<String> _cardEmojis = ['🐼', '🦊', '🐶', '🐱', '🦁', '🐯', '🐮', '🦄'];
  
  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }
  
  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final lang = settingsProvider.language;
    final isDarkMode = settingsProvider.isDarkMode;
    
    // Tema durumuna göre arkaplan container rengi
    final containerBackgroundColor = isDarkMode 
        ? Colors.white.withAlpha(38) // 0.15 alpha for dark mode
        : Colors.black.withAlpha(13); // 0.05 alpha for light mode
        
    // Tema durumuna göre metin rengi
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          lang.get('select_difficulty'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: textColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withAlpha(51) // 0.2 alpha for dark mode
                  : Colors.black.withAlpha(38), // 0.15 alpha for light mode
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: textColor,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Animated Background
          AnimatedCardBackground(
            controller: _backgroundController,
            cardEmojis: _cardEmojis,
          ),
          
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header with instruction
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    decoration: BoxDecoration(
                      color: containerBackgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode 
                              ? Colors.black.withAlpha(25) // 0.1 alpha for dark mode
                              : Colors.black.withAlpha(13), // 0.05 alpha for light mode
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      lang.get('choose_challenge'),
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ).animate().fadeIn(duration: 600.ms),
                  
                  // Difficulty Options
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildDifficultyOption(
                            title: lang.get('easy'),
                            subtitle: lang.get('easy_desc'),
                            description: lang.get('easy_pairs'),
                            color: Colors.green.shade400,
                            icon: Icons.sentiment_very_satisfied,
                            pairCount: 6,
                            difficultyLevel: 'easy',
                            delay: 100.ms,
                            isDarkMode: isDarkMode,
                          ),
                          
                          _buildDifficultyOption(
                            title: lang.get('medium'),
                            subtitle: lang.get('medium_desc'),
                            description: lang.get('medium_pairs'),
                            color: Colors.orange.shade400,
                            icon: Icons.sentiment_satisfied,
                            pairCount: 10,
                            difficultyLevel: 'medium',
                            delay: 300.ms,
                            isDarkMode: isDarkMode,
                          ),
                          
                          _buildDifficultyOption(
                            title: lang.get('hard'),
                            subtitle: lang.get('hard_desc'),
                            description: lang.get('hard_pairs'),
                            color: Colors.red.shade400,
                            icon: Icons.sentiment_dissatisfied,
                            pairCount: 15,
                            difficultyLevel: 'hard',
                            delay: 500.ms,
                            isDarkMode: isDarkMode,
                          ),
                          
                          // Expert level with locked option
                          _buildDifficultyOption(
                            title: lang.get('expert'),
                            subtitle: lang.get('expert_desc'),
                            description: lang.get('expert_pairs'),
                            color: Colors.purple.shade600,
                            icon: Icons.psychology,
                            pairCount: 16,
                            difficultyLevel: 'expert',
                            isLocked: true, // Display as locked
                            delay: 700.ms,
                            isDarkMode: isDarkMode,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyOption({
    required String title,
    required String subtitle,
    required String description,
    required Color color,
    required IconData icon,
    required int pairCount,
    required String difficultyLevel,
    Duration delay = Duration.zero,
    bool isLocked = false,
    required bool isDarkMode,
  }) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final lang = settingsProvider.language;
    
    // Light mode için renk parlaklığını hafif azalt
    final cardColor = isDarkMode ? color : color.withOpacity(0.85);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          // Main card
          Card(
            elevation: isDarkMode ? 10 : 6,
            shadowColor: cardColor.withAlpha(isDarkMode ? 127 : 100), // Shadow intensity
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: isLocked 
                  ? () => _showLockedFeatureDialog() 
                  : () => _startGame(pairCount, difficultyLevel),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cardColor,
                      cardColor.withAlpha(isDarkMode ? 178 : 204), // 0.7 vs 0.8 alpha
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    // Icon in a circle
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.white.withAlpha(76) // 0.3 alpha
                            : Colors.white.withAlpha(178), // 0.7 alpha
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDarkMode ? 25 : 20), // 0.1 vs 0.08
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          icon,
                          size: 35,
                          color: isDarkMode ? Colors.white : cardColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (isLocked)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.black.withAlpha(51) // 0.2 alpha
                                        : Colors.black.withAlpha(38), // 0.15 alpha
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.lock,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        lang.get('locked'),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode
                                  ? Colors.white.withAlpha(204) // 0.8 alpha
                                  : Colors.white.withAlpha(229), // 0.9 alpha
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Arrow
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withAlpha(isDarkMode ? 178 : 204), // 0.7 vs 0.8 alpha
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Time indicator (just for visual appeal)
          if (!isLocked)
            Positioned(
              bottom: 0,
              left: 20,
              right: 20,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? Colors.white.withAlpha(76) // 0.3 alpha
                      : Colors.white.withAlpha(102), // 0.4 alpha
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: pairCount == 6 ? 60.0 : (pairCount == 10 ? 100.0 : (pairCount == 15 ? 150.0 : 160.0)),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(isDarkMode ? 229 : 255), // 0.9 vs 1.0
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: delay).slideY(
      begin: 0.2,
      end: 0,
      curve: Curves.easeOutBack,
      duration: 600.ms,
    );
  }
  
  void _startGame(int pairCount, String difficultyLevel) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
          MemoryGameScreen(
            pairCount: pairCount,
            difficultyLevel: difficultyLevel,
          ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
  
  void _showLockedFeatureDialog() {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final lang = settingsProvider.language;
    final isDarkMode = settingsProvider.isDarkMode;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.lock,
                color: isDarkMode ? Colors.purple.shade300 : Colors.purple.shade400,
              ),
              const SizedBox(width: 10),
              Text(
                lang.get('feature_locked'),
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            lang.get('locked_description'),
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                lang.get('ok_got_it'),
                style: TextStyle(
                  color: isDarkMode ? Colors.purple.shade300 : Colors.purple.shade600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}