import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'memory_game_screen.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({Key? key}) : super(key: key);

  void _navigateToGame(BuildContext context, int pairCount, String difficultyLevel) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => MemoryGameScreen(pairCount: pairCount, difficultyLevel: difficultyLevel),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildLevelButton({
    required BuildContext context,
    required String title,
    required int pairCount,
    required Color color,
    required IconData icon,
    required String difficultyLevel, // Zorluk seviyesi parametresi
  }) {
    return GestureDetector(
      onTap: () => _navigateToGame(context, pairCount, difficultyLevel),
      child: Container(
        width: 250,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ).animate().fade(duration: 500.ms).slideY(begin: 0.2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zorluk Seç"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.indigo.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLevelButton(
                context: context,
                title: "🟢 Kolay (4 çift)",
                pairCount: 4,
                color: Colors.green,
                icon: Icons.sentiment_satisfied_alt,
                difficultyLevel: 'easy', // Kolay seviyesini belirt
              ),
              _buildLevelButton(
                context: context,
                title: "🟡 Orta (6 çift)",
                pairCount: 6,
                color: Colors.orange,
                icon: Icons.sentiment_neutral,
                difficultyLevel: 'medium', // Orta seviyesini belirt
              ),
              _buildLevelButton(
                context: context,
                title: "🔴 Zor (8 çift)",
                pairCount: 8,
                color: Colors.red,
                icon: Icons.sentiment_very_dissatisfied,
                difficultyLevel: 'hard', // Zor seviyesini belirt
              ),
            ],
          ),
        ),
      ),
    );
  }
}
