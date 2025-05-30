import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turf2/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/BG.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 24),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00854A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
