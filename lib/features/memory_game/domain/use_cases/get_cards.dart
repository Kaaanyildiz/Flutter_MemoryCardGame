import '../../domain/models/card_model.dart';
import '../repositories/memory_game_repositorty.dart';

class GetCards {
  final MemoryGameRepository repository;

  GetCards({required this.repository});

  Future<List<CardModel>> execute(int pairCount) {
    return repository.getCards(pairCount); // burada pairCount geçilmeli
  }
}
