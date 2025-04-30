import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:memorycardgame/memory_game/presentation/pages/memory_game_screen.dart';

class CardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;
  final bool isFlipped;

  const CardWidget({
    Key? key,
    required this.card,
    required this.onTap,
    required this.isFlipped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FlipCard(
        isFlipped: isFlipped,
        frontSide: _buildCardSide(
          color: Colors.blueGrey.shade700,
          child: const Center(
            child: Text(
              '?',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
        ),
        backSide: _buildCardSide(
          color: Colors.blue.shade600,
          child: Center(
            child: Text(
              card.content,
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSide({required Color color, required Widget child}) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Kart çevirme animasyonu için basit bir widget
class FlipCard extends StatelessWidget {
  final bool isFlipped;
  final Widget frontSide;
  final Widget backSide;

  const FlipCard({
    Key? key,
    required this.isFlipped,
    required this.frontSide,
    required this.backSide,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isFlipped
        ? backSide
            .animate()
            .scale(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
            )
            .rotate(
              begin: 0.1,
              end: 0,
              duration: const Duration(milliseconds: 300),
            )
        : frontSide;
  }
}
