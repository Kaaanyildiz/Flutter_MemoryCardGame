import 'package:flutter/material.dart';
import 'package:twistcardgame/features/memory_game/domain/repositories/memory_game_repositorty.dart';
import 'package:twistcardgame/features/memory_game/domain/use_cases/get_cards.dart';
import '../../domain/models/card_model.dart';
import '../../data/repositories/memory_game_repository_impl.dart';
import '../../data/datasources/memory_game_local_data_source.dart';
import '../widgets/card_widget.dart';

class MemoryGameScreen extends StatefulWidget {
  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<CardModel> _cards = [];
  List<CardModel> _flippedCards = [];
  List<CardModel> _matchedCards = [];  // Eşleşen kartları burada saklıyoruz
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
    _cards = await getCards.execute();
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
        _matchedCards.add(card1); // Eşleşen kartları sabitliyoruz
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Memory Game")),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return CardWidget(
            card: card,
            onTap: () => _flipCard(card),
            isFlipped: _flippedCards.contains(card) || _matchedCards.contains(card),  // Eşleşen kartlar sabit kalsın
          );
        },
      ),
    );
  }
}
