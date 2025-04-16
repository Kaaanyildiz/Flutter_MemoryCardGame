import 'dart:math';
import '../../domain/models/card_model.dart';

abstract class MemoryGameLocalDataSource {
  Future<List<CardModel>> getShuffledCards(int pairCount); // Burada metodun imzası olacak
}

class MemoryGameLocalDataSourceImpl implements MemoryGameLocalDataSource {
  @override
  Future<List<CardModel>> getShuffledCards(int pairCount) async {
    final allContents = ['🐶', '🐱', '🐭', '🦊', '🐻', '🐼', '🐨', '🐯', '🦁', '🐷'];

    final selected = allContents.sublist(0, pairCount);
    final List<CardModel> cards = [];

    int uniqueId = 0;
    for (var content in selected) {
      cards.add(CardModel(content: content, id: 'id_${uniqueId++}'));
      cards.add(CardModel(content: content, id: 'id_${uniqueId++}'));
    }

    cards.shuffle(Random());
    return cards;
  }
}
