import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MemoryGameApp());
}

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Eşleşen Kartları Bul!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemoryGameScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('Hazırım!'),
            ),
          ],
        ),
      ),
    );
  }
}

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<String> icons = [
    '🍎', '🍌', '🍒', '🍇', '🍉', '🍍', '🥑', '🥕', '🥒', '🌶️', '🥭', '🍋', '🍈', '🍑', '🥥'
  ];
  late List<_Card> cards;
  _Card? firstCard;
  _Card? secondCard;
  bool isChecking = false;
  bool gameCompleted = false;
  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    List<String> allIcons = [...icons, ...icons]; // 15 ikon x 2 = 30 kart
    allIcons.shuffle(Random.secure()); // Daha rastgele karıştırma
    cards = List.generate(30, (index) => _Card(icon: allIcons[index]));
    _stopwatch = Stopwatch();
    _stopwatch.start();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  void _onCardTap(int index) {
    if (isChecking || cards[index].isMatched || cards[index].isOpen) return;

    setState(() {
      cards[index].isOpen = true;
    });

    if (firstCard == null) {
      firstCard = cards[index];
    } else {
      secondCard = cards[index];
      isChecking = true;
      
      if (firstCard!.icon == secondCard!.icon) {
        setState(() {
          firstCard!.isMatched = true;
          secondCard!.isMatched = true;
        });
        _resetSelection();
        _checkGameCompletion();
      } else {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            firstCard!.isOpen = false;
            secondCard!.isOpen = false;
          });
          _resetSelection();
        });
      }
    }
  }

  void _resetSelection() {
    firstCard = null;
    secondCard = null;
    isChecking = false;
  }

  void _checkGameCompletion() {
    if (cards.every((card) => card.isMatched)) {
      _stopwatch.stop();
      _timer.cancel();
      setState(() {
        gameCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Süre: ${_stopwatch.elapsed.inSeconds} sn'),
        backgroundColor: Colors.lightBlue[600],
      ),
      backgroundColor: Colors.cyan[200],
      body: gameCompleted
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Tebrikler! Oyunu tamamladın! 🎉',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Süren: ${_stopwatch.elapsed.inSeconds} saniye',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MemoryGameScreen()),
                      );
                    },
                    child: Text('Tekrar Oyna'),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          cards[index].isOpen || cards[index].isMatched
                              ? cards[index].icon
                              : '❓',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _Card {
  final String icon;
  bool isOpen;
  bool isMatched;

  _Card({required this.icon})
      : isOpen = false,
        isMatched = false;
}
