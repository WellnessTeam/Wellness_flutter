import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NutritionRepository {
  final String apiUrl = dotenv.env['HOME_SCREEN_DATA_URL'] ?? ''; // 실제 API URL

  Future<Map<String, dynamic>> fetchNutritionData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load nutrition data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
