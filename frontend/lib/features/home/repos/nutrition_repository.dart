import 'dart:convert';
import 'package:http/http.dart' as http;

class NutritionRepository {
  final String apiUrl =
      'http://43.202.124.234:8000/api/v1/recommend/eaten_nutrient?user_id=1&today=2024-09-04'; // 실제 API URL

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
