import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:memorycardgame/memory_game/models/settings_provider.dart';
import 'package:provider/provider.dart';

class AnimatedCardBackground extends StatefulWidget {
  final AnimationController controller;
  final List<String> cardEmojis;

  const AnimatedCardBackground({
    Key? key,
    required this.controller,
    required this.cardEmojis,
  }) : super(key: key);

  @override
  State<AnimatedCardBackground> createState() => _AnimatedCardBackgroundState();
}

class _AnimatedCardBackgroundState extends State<AnimatedCardBackground> {
  final List<CardParticle> _particles = [];
  final int _particleCount = 15;
  
  @override
  void initState() {
    super.initState();
    
    // Generate random particles
    final random = math.Random();
    for (int i = 0; i < _particleCount; i++) {
      _particles.add(CardParticle(
        emoji: widget.cardEmojis[random.nextInt(widget.cardEmojis.length)],
        position: Offset(
          random.nextDouble() * 400 - 50,
          random.nextDouble() * 800 - 100,
        ),
        size: 30 + random.nextDouble() * 50,
        speed: 0.2 + random.nextDouble() * 0.3,
        angle: random.nextDouble() * 360,
        rotationSpeed: (random.nextDouble() - 0.5) * 0.02,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tema durumunu al
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isDarkMode = settingsProvider.isDarkMode;
    
    // Tema durumuna göre gradient renkleri
    final List<Color> backgroundColors = isDarkMode
        ? [
            Colors.indigo.shade800,
            Colors.purple.shade900,
            Colors.deepPurple.shade800,
          ]
        : [
            Colors.blue.shade200,
            Colors.lightBlue.shade300,
            Colors.cyan.shade200,
          ];
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: backgroundColors,
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, child) {
          return CustomPaint(
            painter: ParticlePainter(
              particles: _particles,
              progress: widget.controller.value,
              isDarkMode: isDarkMode,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class CardParticle {
  final String emoji;
  final Offset position;
  final double size;
  final double speed;
  final double angle;
  final double rotationSpeed;

  CardParticle({
    required this.emoji,
    required this.position,
    required this.size,
    required this.speed,
    required this.angle,
    required this.rotationSpeed,
  });
}

class ParticlePainter extends CustomPainter {
  final List<CardParticle> particles;
  final double progress;
  final bool isDarkMode;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Light/dark mode için kart renkleri
    final cardColor = isDarkMode
        ? Colors.white.withOpacity(0.8)
        : Colors.white;
    
    final borderColor = isDarkMode
        ? Colors.white
        : Colors.white.withOpacity(0.9);
    
    final shadowColor = isDarkMode
        ? Colors.black.withOpacity(0.5)
        : Colors.black.withOpacity(0.3);
    
    // Paint for cards
    final cardPaint = Paint()
      ..color = cardColor
      ..style = PaintingStyle.fill;
    
    // Paint for card border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var particle in particles) {
      final offset = Offset(
        (particle.position.dx + progress * 100 * particle.speed) % size.width,
        (particle.position.dy + progress * 60 * particle.speed) % size.height,
      );
      
      // Calculate rotation based on time and particle's rotation speed
      final rotation = progress * math.pi * 2 * particle.rotationSpeed;
      
      canvas.save();
      
      // Translate to the particle position and apply rotation
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(rotation);
      
      // Draw a rounded rectangle as a card
      final rect = Rect.fromCenter(
        center: Offset.zero,
        width: particle.size,
        height: particle.size * 1.4,
      );
      
      final rrect = RRect.fromRectAndRadius(
        rect,
        const Radius.circular(10),
      );
      
      // Draw card with shadow
      canvas.drawShadow(
        Path()..addRRect(rrect),
        shadowColor,
        isDarkMode ? 2.0 : 1.5,
        true,
      );
      
      // Draw card body
      canvas.drawRRect(rrect, cardPaint);
      canvas.drawRRect(rrect, borderPaint);
      
      // Draw emoji in the center
      final textPainter = TextPainter(
        text: TextSpan(
          text: particle.emoji,
          style: TextStyle(
            fontSize: particle.size * 0.6,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => 
    oldDelegate.progress != progress || oldDelegate.isDarkMode != isDarkMode;
}