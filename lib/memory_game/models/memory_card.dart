class MemoryCard {
  final int id;
  final String imageAssetPath;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.imageAssetPath,
    this.isFlipped = false,
    this.isMatched = false,
  });

  MemoryCard copyWith({
    int? id,
    String? imageAssetPath,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return MemoryCard(
      id: id ?? this.id,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}