import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:memorycardgame/memory_game/models/settings_provider.dart';
import 'package:provider/provider.dart';

class MemoryGameTutorial extends StatefulWidget {
  final VoidCallback onTutorialCompleted;

  const MemoryGameTutorial({
    super.key,
    required this.onTutorialCompleted,
  });

  @override
  State<MemoryGameTutorial> createState() => _MemoryGameTutorialState();
}

class _MemoryGameTutorialState extends State<MemoryGameTutorial> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final lang = settingsProvider.language;
    
    return Scaffold(
      backgroundColor: settingsProvider.isDarkMode ? 
        Colors.deepPurple.shade900 : Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          lang.get('tutorial_title'),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close),
          ),
          onPressed: widget.onTutorialCompleted,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildTutorialPage(
                    title: lang.get('tutorial_step1_title'),
                    description: lang.get('tutorial_step1_desc'),
                    icon: Icons.psychology_alt_rounded,
                    iconColor: Colors.purple.shade300,
                  ),
                  _buildTutorialPage(
                    title: lang.get('tutorial_step2_title'),
                    description: lang.get('tutorial_step2_desc'),
                    icon: Icons.touch_app_rounded,
                    iconColor: Colors.blue.shade300,
                    showCardExample: true,
                  ),
                  _buildTutorialPage(
                    title: lang.get('tutorial_step3_title'),
                    description: lang.get('tutorial_step3_desc'),
                    icon: Icons.cases_rounded,
                    iconColor: Colors.green.shade300,
                    showMatchExample: true,
                  ),
                  _buildTutorialPage(
                    title: lang.get('tutorial_step4_title'),
                    description: lang.get('tutorial_step4_desc'),
                    icon: Icons.emoji_events_rounded,
                    iconColor: Colors.amber,
                    isLastPage: true,
                  ),
                ],
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTutorialPage({
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    bool showCardExample = false,
    bool showMatchExample = false,
    bool isLastPage = false,
  }) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final lang = settingsProvider.language;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 70,
              color: iconColor,
            ),
          ).animate().scale(
            duration: 600.ms, 
            curve: Curves.easeOutBack,
          ),
          
          const SizedBox(height: 40),
          
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: settingsProvider.isDarkMode ? Colors.white : Colors.black87,
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms).slideY(
            begin: 0.2, 
            end: 0, 
            curve: Curves.easeOutBack,
            duration: 600.ms,
          ),
          
          const SizedBox(height: 24),
          
          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 18,
              color: settingsProvider.isDarkMode 
                ? Colors.white.withOpacity(0.9) 
                : Colors.black87.withOpacity(0.9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms),
          
          const SizedBox(height: 40),
          
          // Card examples based on the page content
          if (showCardExample)
            _buildFlipCardExample(),
          
          if (showMatchExample)
            _buildMatchingPairExample(),
            
          if (isLastPage)
            ElevatedButton(
              onPressed: widget.onTutorialCompleted,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.green.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 5,
              ),
              child: Text(
                lang.get('got_it'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ).animate().fadeIn(delay: 600.ms).scale(
              duration: 600.ms,
              curve: Curves.easeOutBack,
            ),
        ],
      ),
    );
  }

  Widget _buildFlipCardExample() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTutorialCard(
          frontIcon: Icons.question_mark,
          frontColor: Colors.blue.shade700,
          backContent: '🐼',
          backColor: Colors.white,
          showFlipAnimation: true,
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildMatchingPairExample() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTutorialCard(
          backContent: '🦊',
          backColor: Colors.green.shade600,
          showFrontSide: false,
          showGlowAnimation: true,
        ),
        const SizedBox(width: 16),
        _buildTutorialCard(
          backContent: '🦊',
          backColor: Colors.green.shade600,
          showFrontSide: false,
          showGlowAnimation: true,
        ),
      ],
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildTutorialCard({
    IconData? frontIcon,
    Color? frontColor,
    required String backContent,
    required Color backColor,
    bool showFlipAnimation = false,
    bool showFrontSide = true,
    bool showGlowAnimation = false,
  }) {
    Widget card = Container(
      width: 80,
      height: 110,
      decoration: BoxDecoration(
        color: showFrontSide ? frontColor : backColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
          if (showGlowAnimation)
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Center(
        child: showFrontSide 
            ? Icon(
                frontIcon,
                color: Colors.white.withOpacity(0.7),
                size: 36,
              )
            : Text(
                backContent,
                style: const TextStyle(fontSize: 40),
              ),
      ),
    );

    if (showFlipAnimation) {
      return card.animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      ).flipH(
        duration: 1200.ms, 
        curve: Curves.easeInOutBack,
      );
    }

    if (showGlowAnimation) {
      return card.animate(
        onPlay: (controller) => controller.repeat(reverse: true),
      ).scale(
        begin: const Offset(1.0, 1.0),
        end: const Offset(1.05, 1.05),
        duration: 1000.ms,
      );
    }

    return card;
  }

  Widget _buildBottomControls() {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final lang = settingsProvider.language;
    final isDark = settingsProvider.isDarkMode;
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _totalPages,
              (index) => Container(
                width: _currentPage == index ? 24 : 12,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: _currentPage == index 
                      ? (isDark ? Colors.white : Colors.blue)
                      : (isDark ? Colors.white.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              if (_currentPage > 0)
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: isDark ? Colors.white : Colors.blue.shade700,
                    ),
                    label: Text(
                      lang.get('back'),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.blue.shade700,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark ? Colors.white : Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                )
              else
                const SizedBox(width: 100),
              
              // Next/Skip button
              if (_currentPage < _totalPages - 1)
                ElevatedButton.icon(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: Icon(Icons.arrow_forward_ios),
                  label: Text(_currentPage == _totalPages - 2 ? lang.get('got_it') : lang.get('next')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    backgroundColor: isDark ? Colors.purple.shade500 : Colors.blue.shade500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                )
              else
                const SizedBox(width: 100),
            ],
          ),
        ],
      ),
    );
  }
}