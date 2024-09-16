import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class AnalyzeRepository {
  final String apiUrl =
      'http://43.202.124.234:8000/api/v1/model/predict?user_id=1'; // 실제 API 주소로 교체하세요.

  // 고정된 토큰을 설정
  final String _token = 'test_access_token';

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
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // 응답 데이터를 파싱합니다.
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception(
            '이미지 업로드 실패: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('이미지 업로드 중 예외 발생: $e');
    }
  }
}
