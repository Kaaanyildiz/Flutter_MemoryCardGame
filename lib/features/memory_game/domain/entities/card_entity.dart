class CardEntity {
  final String id;
  final String content;
  final bool isFlipped;
  final bool isMatched;

  CardEntity({
    required this.id,
    required this.content,
    this.isFlipped = false,
    this.isMatched = false,
  });

  CardEntity copyWith({
    String? id,
    String? content,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return CardEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
