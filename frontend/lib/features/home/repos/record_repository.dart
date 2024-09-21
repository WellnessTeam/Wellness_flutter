import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import

class RecordRepository {
  // 토큰을 SharedPreferences에서 가져오는 메서드
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); // 저장된 토큰을 가져옴
  }

  Future<List<Map<String, dynamic>>> fetchMealRecords() async {
    final token = await _getToken(); // 저장된 토큰을 가져옴
    if (token == null) {
      throw Exception('No token found'); // 토큰이 없는 경우 예외 처리
    }

    final response = await http.post(
      Uri.parse(
          'http://43.202.124.234:8000/api/v1/history/save_and_get'), // API URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token', // 저장된 토큰을 헤더에 포함
      },
      body: jsonEncode({}), // 필요시 본문에 데이터 추가 가능
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Wellness_meal_list에서 필요한 데이터 추출
      final mealList = data['detail']['Wellness_meal_list'] as List<dynamic>;

      return mealList.map((meal) {
        return {
          'type': meal['meal_type_name'],
          'food': meal['category_name'],
          'calories': meal['food_kcal'],
          'carb': meal['food_car'],
          'protein': meal['food_prot'],
          'fat': meal['food_fat'],
          'time': meal['date'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load meal records');
    }
  }
}
