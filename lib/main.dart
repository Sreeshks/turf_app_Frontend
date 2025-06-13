import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:turf2/providers/auth_provider.dart';
import 'package:turf2/screens/Venue.dart';
import 'package:turf2/screens/home_screen.dart';
import 'package:turf2/screens/login.dart';
import 'package:turf2/screens/splash_screen.dart';
import 'package:turf2/screens/summary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  // Setting system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp(
            title: 'Turf App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => SplashScreen(),
              '/': (context) =>
                  authProvider.isLoggedIn ? HomeScreen() : LoginScreen(),
              '/venue_detail': (context) => VenueDetailScreen(),
              '/summary': (context) => CheckoutSummaryPage(),
              '/login': (context) => LoginScreen(),
            },
          );
        },
      ),
    );
  }
}
