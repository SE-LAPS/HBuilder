import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';
import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/location_provider.dart';

import 'screens/auth/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812), // Base design size (iPhone X)
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Washtron',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const SignInScreen(),
            builder: (context, widget) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFF6B00), // Orange
                      Color(0xFFFFD700), // Dark Yellow (Gold)
                      Colors.white, // White
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
                child: widget,
              );
            },
          );
        },
      ),
    );
  }
}
