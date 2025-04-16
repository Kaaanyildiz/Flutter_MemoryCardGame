import '../../domain/models/card_model.dart';
import '../../domain/repositories/memory_game_repositorty.dart';
import '../datasources/memory_game_local_data_source.dart';

class MemoryGameRepositoryImpl implements MemoryGameRepository {
  final MemoryGameLocalDataSource localDataSource;

  MemoryGameRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CardModel>> getCards(int pairCount) {
    return localDataSource.getShuffledCards(pairCount);
  }
}
