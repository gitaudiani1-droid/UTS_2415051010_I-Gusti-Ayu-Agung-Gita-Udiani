import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/exercise_provider.dart';
import 'repositories/exercise_repository.dart';
import 'services/exercise_api_service.dart';

class GlowFitApp extends StatelessWidget {
  const GlowFitApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ExerciseProvider(
            repository: ExerciseRepository(
              apiService: ExerciseApiService(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
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
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA99BEF),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
