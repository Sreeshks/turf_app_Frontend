import 'dart:math';

import 'package:flutter/material.dart';
import 'package:turf2/config/theme.dart';

class VenueBackground extends StatefulWidget {
  @override
  _VenueBackgroundState createState() => _VenueBackgroundState();
}

class _VenueBackgroundState extends State<VenueBackground> {
  @override
  Widget build(BuildContext context) {
    // Simple black background
    return Container(
      color: Colors.black,
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

    // Draw animated football field
    final fieldPaint = Paint()
      ..color = Color(0xFF39FF14).withOpacity(0.05) // Bright neon green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.7),
          width: size.width * 0.8,
          height: size.width * 0.4,
        ),
        Radius.circular(size.width * 0.05),
      ),
      fieldPaint,
    );

    // Draw center circle
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.7),
      size.width * 0.1,
      fieldPaint,
    );

    // Draw center line
    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.7),
      Offset(size.width * 0.9, size.height * 0.7),
      fieldPaint,
    );

    // Draw subtle glowing orbs
    for (int i = 0; i < 5; i++) {
      double offset = i * 0.2;
      double offsetValue = (animationValue + offset) % 1.0;
      
      double x = size.width * 0.5 + sin(offsetValue * 2 * 3.14) * size.width * 0.4;
      double y = size.height * 0.3 + cos(offsetValue * 2 * 3.14) * size.height * 0.3;
      
      double radius = 30 + 20 * sin(offsetValue * 3.14);
      
      final orbPaint = Paint()
        ..shader = RadialGradient(
          colors: i % 2 == 0 
            ? [
                Color(0xFF39FF14).withOpacity(0.3), // Bright neon green
                Color(0xFF39FF14).withOpacity(0.0),
              ]
            : [
                Color(0xFF39FF14).withOpacity(0.2), // Slightly dimmer neon green
                Color(0xFF39FF14).withOpacity(0.0),
              ],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: radius));
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        orbPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}