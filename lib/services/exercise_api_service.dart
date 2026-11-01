
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercise.dart';

class ExerciseApiService {
  static const String baseUrl = 'https://wger.de/api/v2';

  Future<List<Exercise>> fetchExercises() async {
    final uri = Uri.parse(
      '$baseUrl/exerciseinfo/',
    ).replace(
      queryParameters: {
        'format': 'json',
        'limit': '20',
        'language': '2',
      },
    );

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final results = data['results'] as List? ?? [];

      return results
          .map(
            (item) => Exercise.fromJson(
          item as Map<String, dynamic>,
        ),
      )
          .toList();
    } else {
      throw Exception(
        'Gagal mengambil data latihan: ${response.statusCode}',
      );
    }
  }
}
