import '../../domain/models/card_model.dart';

abstract class MemoryGameLocalDataSource {
  Future<List<CardModel>> getCards();
}

class MemoryGameLocalDataSourceImpl implements MemoryGameLocalDataSource {
  @override
  Future<List<CardModel>> getCards() async {
    final List<String> contents = ['🍎', '🍌', '🍒', '🍇', '🍉', '🍍', '🥑', '🥕', '🥒', '🌶️', '🥭','🍈'];
    final List<CardModel> cards = [];

    // Her emoji çiftini ekliyoruz
    for (int i = 0; i < contents.length; i++) {
      final String content = contents[i];
      cards.add(CardModel(id: '$i-a', content: content));
      cards.add(CardModel(id: '$i-b', content: content));
    }

    cards.shuffle();  // Kartları karıştırıyoruz
    return cards;
  }
}
