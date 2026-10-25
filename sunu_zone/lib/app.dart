import 'package:flutter/material.dart';
import 'features/splash/splash_page.dart';

class SunuLoyerApp extends StatelessWidget {
  const SunuLoyerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SUNU LOYER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B1E3F)),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
