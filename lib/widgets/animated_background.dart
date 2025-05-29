import 'dart:math';

import 'package:flutter/material.dart';
import 'package:turf2/config/theme.dart';

class AnimatedBackground extends StatefulWidget {
  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryDark,
                Color(0xFF151C2E),
              ],
            ),
          ),
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            painter: BackgroundPainter(_controller.value),
          ),
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppTheme.primaryTeal.withOpacity(0.05),
          AppTheme.accentPurple.withOpacity(0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw animated shapes
    for (int i = 0; i < 5; i++) {
      double offset = i * 0.2;
      double offsetValue = (animationValue + offset) % 1.0;
      
      double x = size.width * 0.5 + sin(offsetValue * 2 * 3.14) * size.width * 0.4;
      double y = size.height * 0.3 + cos(offsetValue * 2 * 3.14) * size.height * 0.3;
      
      double radius = 50 + 30 * sin(offsetValue * 3.14);
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }

    // Draw subtle field lines
    final linePaint = Paint()
      ..color = AppTheme.primaryTeal.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.7),
        width: size.width * 0.8,
        height: size.width * 0.4,
      ),
      linePaint,
    );

    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.7),
      Offset(size.width * 0.9, size.height * 0.7),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}