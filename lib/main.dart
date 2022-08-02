import 'package:attendance_iiitkota/screens/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/login_screen.dart';
import './screens/verify_email_screen.dart';
import './screens/splash_screen.dart';
import './screens/confirm_qr_scan_screen.dart';
import 'screens/get_details_screens.dart';
import './screens/attendance_record_screen.dart';
import './screens/all_subject_screen.dart';
import './screens/edit_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance',
      theme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: const Color.fromRGBO(0, 51, 102, 1),
          onPrimary: Colors.white,
          secondary: const Color.fromRGBO(255, 102, 0, 1),
          onSecondary: Colors.white,
          error: Colors.red.shade800,
          onError: Colors.white,
          background: Colors.grey.shade800,
          onBackground: Colors.white,
          surface: Colors.grey.shade800,
          onSurface: Colors.grey.shade700,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else if (snapshot.hasData &&
              snapshot.data!.emailVerified == false) {
            return const VerifyEmailScreen();
          } else if (snapshot.hasData && snapshot.data!.emailVerified == true) {
            return const DashBoardScreen();
          }
          return const LoginScreen();
        },
      ),
      routes: {
        VerifyEmailScreen.routeName: (context) => const VerifyEmailScreen(),
        DashBoardScreen.routeName: (context) => const DashBoardScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        ConfirmQRScanScreen.routeName: (context) => const ConfirmQRScanScreen(),
        GetDetailsScreen.routeName: (context) => const GetDetailsScreen(),
        AttendanceRecordScreen.routeName: (context) =>
            const AttendanceRecordScreen(),
        AllSubjectScreen.routeName: (context) => const AllSubjectScreen(),
        EditProfileScreen.routeName: (context) => const EditProfileScreen(),
      },
    );
  }
}
