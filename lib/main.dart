import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/s1_bot_screen.dart';
import 'screens/s2_plan_screen.dart';
import 'screens/s3_funds_screen.dart';
import 'screens/s4_alignment_screen.dart';
import 'screens/s5_workers_screen.dart';
import 'screens/s6_booking_screen.dart';
import 'screens/s7_tracking_screen.dart';
import 'screens/s8_feedback_screen.dart';

void main() {
  runApp(const StrahApp());
}

class StrahApp extends StatelessWidget {
  const StrahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'S-TRAH',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const S1BotScreen(),
        '/plan': (context) => const S2PlanScreen(),
        '/funds': (context) => const S3FundsScreen(),
        '/alignment': (context) => const S4AlignmentScreen(),
        '/workers': (context) => const S5WorkersScreen(),
        '/booking': (context) => const S6BookingScreen(),
        '/tracking': (context) => const S7TrackingScreen(),
        '/feedback': (context) => const S8FeedbackScreen(),
      },
    );
  }
}
