// File: lib/widgets/animated_button.dart
import 'package:flutter/material.dart';
import 'package:turf2/config/theme.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? buttonColor;
  final Color? textColor;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.buttonColor,
    this.textColor,
  });

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        _controller.reverse();
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                gradient: widget.buttonColor != null
                    ? null
                    : LinearGradient(
                        colors: _isPressed
                            ? [AppTheme.primaryTeal.withOpacity(0.8), AppTheme.accentPurple.withOpacity(0.8)]
                            : [AppTheme.primaryTeal, AppTheme.accentPurple],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                color: widget.buttonColor != null
                    ? _isPressed
                        ? widget.buttonColor!.withOpacity(0.8)
                        : widget.buttonColor
                    : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isPressed
                    ? []
                    : [
                        BoxShadow(
                          color: widget.buttonColor != null
                              ? widget.buttonColor!.withOpacity(0.4)
                              : AppTheme.primaryTeal.withOpacity(0.4),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor ?? Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }
}