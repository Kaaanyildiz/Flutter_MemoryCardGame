class CardModel {
  final String content;
  final String id; // eşsiz id olsun

  CardModel({required this.content, required this.id});

  // Şimdi karşılaştırmaları düzelt
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
