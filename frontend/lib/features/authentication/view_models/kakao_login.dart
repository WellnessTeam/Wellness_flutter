import 'package:frontend/features/authentication/repos/token_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class KakaoLoginService {
  final Logger _logger = Logger();

  // 카카오 로그인
  Future<Map<String, String?>> signInWithKakao() async {
    _logger.d("카카오 로그인 시도");

    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        // 카카오톡으로 로그인
        token = await UserApi.instance.loginWithKakaoTalk();
        _logger.i('카카오톡으로 로그인 성공, token: ${token.accessToken}');
      } else {
        // 카카오 계정으로 로그인
        token = await UserApi.instance.loginWithKakaoAccount();
        _logger.i('카카오계정으로 로그인 성공, token: ${token.accessToken}');
      }

      // 사용자 정보 가져오기
      User? user = await UserApi.instance.me();
      String? nickname = user.kakaoAccount?.profile?.nickname;
      String? email = user.kakaoAccount?.email;

      if (nickname == null || email == null) {
        _logger.e('Failed to fetch user info from Kakao.');
        return {'nickname': null, 'email': null};
      }

      _logger.i('Kakao login successful, nickname: $nickname, email: $email');
      return {'nickname': nickname, 'email': email};
    } catch (error) {
      _logger.e('카카오 로그인 실패: $error');
      return {'nickname': null, 'email': null};
    }
  }

  // 로그인 API 호출
  Future<bool> loginToBackend(String nickname, String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://43.202.124.234:8000/api/v1/user/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nickname': nickname,
          'email': email,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final accessToken = data['detail']['wellness_info']['access_token'];
        final refreshToken = data['detail']['wellness_info']['refresh_token'];

        // 엑세스 토큰저장
        await TokenStorage.updateTokensIfNeeded(accessToken, refreshToken);
        _logger.i(
            'Tokens are saved successfully: Acess : $accessToken / Refresh : $refreshToken');
        return true;
      } else {
        _logger.e('Failed to login: ${response.body}');
        return false;
      }
    } catch (error) {
      _logger.e('Error logging in: $error');
      return false;
    }
  }

  // 로컬 저장소에 토큰이 존재하는지 확인하는 메서드
  Future<bool> hasValidToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('access_token');
    return storedToken != null;
  }

  // 로그아웃 로직 (토큰은 삭제하지 않음)
  Future<void> signOut() async {
    try {
      await UserApi.instance.logout(); // 카카오 로그아웃 호출
      _logger.i('카카오 로그아웃 성공');

      // 토큰을 남겨두고, 로그아웃 상태만 처리
      _logger.i('Token remains in local storage');
    } catch (e) {
      _logger.e('카카오 로그아웃 실패: $e');
      throw Exception('로그아웃 실패');
    }
  }
}
