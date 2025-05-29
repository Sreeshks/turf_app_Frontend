import 'package:flutter/material.dart';
import 'package:turf2/config/theme.dart';
import 'package:turf2/screens/login.dart';
// We'll handle navigation in the splash screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller with duration of 2.5 seconds
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    
    // Create fade-in animation (0.0 to 1.0)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );
    
    // Create scale-up animation (0.8 to 1.0)
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );
    
    // Start animation
    _animationController.forward();
    
    // Navigate to main screen after animation completes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to main screen after animation completes
        Future.delayed(const Duration(milliseconds: 500), () {
  Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoginScreen()),
                                      );        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Use SafeArea to respect device notches and system UI
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              'assets/BG.jpg',
              fit: BoxFit.cover,
            ),
            
            // Dark overlay for sophisticated effect (40-60% opacity)
            Container(
              color: Colors.black.withOpacity(0.5), // 50% opacity dark overlay
            ),
            
            // Animated logo
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Image.asset(
                        'assets/Logo.png',
                        width: MediaQuery.of(context).size.width * 0.6, // 60% of screen width
                      ),
                    ),
                  );
                },
              ),
            ),
            
           
          ],
        ),
      ),
    );
  }
}
