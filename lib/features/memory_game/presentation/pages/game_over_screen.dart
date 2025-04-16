import 'package:flutter/material.dart';
import 'package:twistcardgame/features/memory_game/presentation/pages/memory_game_screen.dart';
import 'level_selection_screen.dart';  // Ana menü ekranının import edilmesi

class GameOverScreen extends StatelessWidget {
  final int pairCount;
  final String difficultyLevel; // Eklenen parametre

  const GameOverScreen({Key? key, required this.pairCount, required this.difficultyLevel}) : super(key: key);

  void _restartGame(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MemoryGameScreen(pairCount: pairCount, difficultyLevel: difficultyLevel),
      ),
    );
  }

  void _goToMainMenu(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LevelSelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Oyun Sonu"),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.star,
              color: Colors.yellow,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Tebrikler! Tüm kartları eşleştirdiniz!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _restartGame(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text("Yeniden Başlat"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _goToMainMenu(context),  // Ana menüye yönlendirme
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: Text("Ana Menüye Dön"),
            ),
          ],
        ),
      ),
    );
  }
}
