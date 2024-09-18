import 'dart:convert';
import 'package:http/http.dart' as http;

class NutritionRepository {
  final String apiUrl =
      'http://43.202.124.234:8000/api/v1/recommend/eaten_nutrient?today=2024-08-26'; // 실제 API URL

  // 고정된 토큰을 설정
  final String _token = 'test_access_token';

  Future<Map<String, dynamic>> fetchNutritionData() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $_token', // 고정된 토큰을 헤더에 추가
        },
      );

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
