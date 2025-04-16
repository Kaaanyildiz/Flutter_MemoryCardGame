import 'package:flutter/material.dart';
import '../../domain/models/card_model.dart';

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
      onTap: isFlipped ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                ScaleTransition(scale: animation, child: child),
            child: isFlipped
                ? Text(
                    card.content,
                    key: const ValueKey(true),
                    style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : const Icon(
                    Icons.help_outline,
                    key: ValueKey(false),
                    size: 32,
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }
}
