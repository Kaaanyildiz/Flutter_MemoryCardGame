import '../models/card_model.dart';

abstract class MemoryGameRepository {
  Future<List<CardModel>> getCards(int pairCount);
}
