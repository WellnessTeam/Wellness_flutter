import 'package:http/http.dart' as http;
import 'dart:convert';

class RecordRepository {
  final String _token = 'test_access_token';

  Future<List<Map<String, dynamic>>> fetchMealRecords() async {
    final response = await http.post(
      Uri.parse(
          'http://43.202.124.234:8000/api/v1/history/save_and_get'), // API URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token', // 고정된 토큰을 헤더에 포함
      },
      body: jsonEncode({}),
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
