// // // File: lib/main.dart
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:turf/config/theme.dart';
// // import 'package:turf/screens/Sportselection.dart';

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
// //     statusBarColor: Colors.transparent,
// //     statusBarIconBrightness: Brightness.light,
// //   ));
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Premium Turf Booking',
// //       debugShowCheckedModeBanner: false,
// //       theme: AppTheme.darkTheme,
// // home:SportSelectionScreen(),
// //       // home: SplashScreen(),
// //     );
// //   }
// // }
// // File: lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:turf/config/theme.dart';
// import 'package:turf/screens/success.dart';
// import 'package:turf/screens/ticket.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     statusBarIconBrightness: Brightness.light,
//   ));
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Premium Turf Booking',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         scaffoldBackgroundColor: AppTheme.primaryDark, // Fixed the bgColor issue
//       ),
//       home:CustomPaint(
//         painter: PaymentSuccessScreen(),
//         child: Container(), // Add a child widget if needed
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turf2/screens/Venue.dart';
import 'package:turf2/screens/home_screen.dart';
import 'package:turf2/screens/splash_screen.dart';
import 'package:turf2/screens/summary.dart';
import 'package:turf2/screens/u.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setting system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turf Booking',
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.darkTheme, // Use the dark theme from AppTheme
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/': (context) =>  HomeScreen(),
        '/booking': (context) => SlotBookingPageRound(turfName: "Hi Hello"),
        '/venue_detail': (context) => VenueDetailScreen(),
        '/summary': (context) => CheckoutSummaryPage(),
      },
    );
  }
}
