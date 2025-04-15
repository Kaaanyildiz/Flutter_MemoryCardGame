import 'package:twistcardgame/features/memory_game/domain/repositories/memory_game_repositorty.dart';
import '../../domain/models/card_model.dart';


class GetCards {
  final MemoryGameRepository repository;

  GetCards({required this.repository});

  Future<List<CardModel>> execute() async {
    return await repository.getCards();
  }
}
