import 'package:flutter/material.dart';
import '../../domain/models/card_model.dart';

class CardWidget extends StatefulWidget {
  final CardModel card;
  final bool isFlipped;
  final VoidCallback onTap;

  const CardWidget({
    Key? key,
    required this.card,
    required this.isFlipped,
    required this.onTap,
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void didUpdateWidget(CardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFront() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Icon(Icons.question_mark, size: 40),
    );
  }

  Widget _buildBack() {
    return Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text(widget.card.content, style: TextStyle(fontSize: 30, color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * 3.1416;
          final isUnder = _flipAnimation.value > 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isUnder ? _buildBack() : _buildFront(),
          );
        },
      ),
    );
  }
}
