import 'package:flutter/material.dart';
import 'game_over_screen.dart';
import 'package:twistcardgame/features/memory_game/domain/repositories/memory_game_repositorty.dart';
import 'package:twistcardgame/features/memory_game/domain/use_cases/get_cards.dart';
import '../../domain/models/card_model.dart';
import '../../data/repositories/memory_game_repository_impl.dart';
import '../../data/datasources/memory_game_local_data_source.dart';
import '../widgets/card_widget.dart';

class MemoryGameScreen extends StatefulWidget {
  final int pairCount;
  final String difficultyLevel;

  const MemoryGameScreen({Key? key, required this.pairCount, required this.difficultyLevel}) : super(key: key);

  @override
  _MemoryGameScreen createState() => _MemoryGameScreen();
}

class _MemoryGameScreen extends State<MemoryGameScreen> {
  List<CardModel> _cards = [];
  List<CardModel> _flippedCards = [];
  List<CardModel> _matchedCards = [];
  bool _isProcessing = false;

  late MemoryGameRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = MemoryGameRepositoryImpl(localDataSource: MemoryGameLocalDataSourceImpl());
    _loadCards();
  }

  void _loadCards() async {
    final getCards = GetCards(repository: _repository);
    _cards = await getCards.execute(widget.pairCount);
    setState(() {});
  }

  void _flipCard(CardModel card) {
    if (_isProcessing || _flippedCards.contains(card) || _matchedCards.contains(card)) return;

    setState(() {
      _flippedCards.add(card);
    });

    if (_flippedCards.length == 2) {
      _checkMatch();
    }
  }

  void _checkMatch() async {
    final card1 = _flippedCards[0];
    final card2 = _flippedCards[1];

    if (card1.content == card2.content) {
      setState(() {
        _matchedCards.add(card1);
        _matchedCards.add(card2);
        _flippedCards.clear();
      });
    } else {
      setState(() {
        _isProcessing = true;
      });

      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _flippedCards.clear();
        _isProcessing = false;
      });
    }

    if (_matchedCards.length == widget.pairCount * 2) {
      _showGameOverScreen();
    }
  }

  void _showGameOverScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameOverScreen(pairCount: widget.pairCount, difficultyLevel: widget.difficultyLevel),
      ),
    );
  }

  BoxDecoration _getBackgroundDecoration() {
    // Zorluk seviyesine göre arkaplan gradientlerini ayarlıyoruz
    if (widget.difficultyLevel == 'easy') {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.shade100, // pastel pembe
            Colors.yellow.shade100, // pastel sarı
          ],
        ),
      );
    } else if (widget.difficultyLevel == 'medium') {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade400, // mavi
            Colors.orange.shade400, // turuncu
          ],
        ),
      );
    } else {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade800, // koyu mor
            Colors.blue.shade900, // koyu mavi
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Memory Game"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 3),
        decoration: _getBackgroundDecoration(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return CardWidget(
                  card: card,
                  onTap: () => _flipCard(card),
                  isFlipped: _flippedCards.contains(card) || _matchedCards.contains(card),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
