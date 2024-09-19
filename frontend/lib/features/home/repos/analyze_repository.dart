import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class AnalyzeRepository {
  final String apiUrl =
      'http://43.202.124.234:8000/api/v1/model/predict'; // 분석 화면 API
  final String saveUrl =
      'http://43.202.124.234:8000/api/v1/history/save_and_get'; // 기록 화면 API

  // 고정된 토큰을 설정
  final String _token = 'test_access_token';
  final Logger _logger = Logger(); // Logger 인스턴스 생성

  Map<String, dynamic>? analysisData;

  // 첫 번째 API에 이미지 업로드 및 데이터 가져오기(분석화면)
  Future<Map<String, dynamic>> uploadImageAndFetchData(File image) async {
    final mimeType = lookupMimeType(image.path) ?? 'application/octet-stream';

    final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..files.add(await http.MultipartFile.fromPath(
        'file', // API에서 기대하는 필드 이름
        image.path,
        contentType: MediaType.parse(mimeType),
      ))
      ..headers['Authorization'] = 'Bearer $_token'; // 헤더에 고정된 토큰 추가

    try {
      _logger.i('이미지 업로드 시작');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _logger.i('이미지 업로드 응답 코드: ${response.statusCode} / 본문: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 응답 데이터를 파싱합니다.
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // 필요한 데이터 저장
        analysisData = {
          'date': data['detail']['wellness_image_info']['date'],
          'meal_type_id': data['detail']['wellness_image_info']['meal_type_id'],
          'category_id': data['detail']['wellness_image_info']['category_id'],
          'image_url': data['detail']['wellness_image_info']['image_url'],
        };

        _logger.i(
            'analysisData 설정됨: ${analysisData.toString()}'); // analysisData 설정 확인
        return data;
      } else {
        _logger
            .e('이미지 업로드 실패: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception(
            '이미지 업로드 실패: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      _logger.e('이미지 업로드 중 예외 발생: $e');
      throw Exception('이미지 업로드 중 예외 발생: $e');
    }
  }

  // 두 번째 API로 데이터 전송 및 기록 가져오기(기록화면)
  Future<List<Map<String, dynamic>>> saveAndFetchMealRecords() async {
    if (analysisData == null) {
      _logger.w('분석 데이터가 없습니다.');
      throw Exception('분석 데이터가 없습니다.');
    }

    _logger.i('데이터 전송 시작: ${analysisData.toString()}');

    // 날짜 형식 변환
    String originalDate = analysisData!['date'];
    // 파싱 가능한 형식으로 변환
    DateTime parsedDate = DateFormat('yyyy:MM:dd HH:mm:ss').parse(originalDate);
    // 서버에서 기대하는 형식으로 변환
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);

    final response = await http.post(
      Uri.parse(saveUrl), // 두 번째 API URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode({
        'date': formattedDate, // 변환된 날짜를 사용
        'meal_type_id': analysisData!['meal_type_id'],
        'category_id': analysisData!['category_id'],
        'image_url': analysisData!['image_url'],
      }),
    );

    //_logger.i('기록 저장 및 가져오기 응답 코드: ${response.statusCode}');
    //_logger.i('기록 저장 및 가져오기 응답 본문: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final mealList = data['detail']['Wellness_meal_list'] as List<dynamic>;

      _logger.i('기록 저장 및 가져오기 성공: ${mealList.toString()}');

      final records = mealList.map((meal) {
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

      _logger.i('반환된 기록: $records');

      return records;
    } else {
      _logger.e(
          '기록 저장 및 가져오기 실패: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception('기록 저장 및 가져오기 실패');
    }
  }
}
