import 'dart:convert';
import 'package:http/http.dart' as http;

class AnalyzeRepository {
  final String apiUrl =
      'https://your-api-endpoint.com/analyze'; // 실제 API URL로 변경

  Future<Map<String, dynamic>> fetchAnalyzeData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load analyze data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
