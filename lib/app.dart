
import 'package:flutter/material.dart';

class GlowFitApp extends StatelessWidget {
  const GlowFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GLOWFIT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF5A9C8),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF4F8),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Welcome to GLOWFIT ✨',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA99BEF),
            ),
          ),
        ),
      ),
    );
  }
}
