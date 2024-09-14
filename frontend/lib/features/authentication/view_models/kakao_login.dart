import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';

class KakaoLoginService {
  final Logger _logger = Logger();

  // 인가 코드를 FastAPI로 전달하는 함수
  Future<void> sendAuthCodeToBackend(String authCode) async {
    var url =
        dotenv.env['KAKAO_AUTH_URL'] ?? ''; // .env 파일에서 URL 가져오기(FastAPI 엔드포인트)
    if (url.isEmpty) {
      _logger.e('Kakao auth URL is not set');
      return;
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'code': authCode, // 받은 authorization code
      }),
    );

    if (response.statusCode == 200) {
      _logger.i('Authorization code sent to backend successfully');
      _logger.i('Response from server: ${response.body}');
    } else {
      _logger
          .e('Failed to send authorization code to backend: ${response.body}');
    }
  }

  // 카카오 로그인 로직
  Future<Map<String, String?>> signInWithKakao() async {
    _logger.d("카카오 로그인 시도");

    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        // 카카오톡으로 로그인
        token = await UserApi.instance.loginWithKakaoTalk();
        _logger.i('카카오톡으로 로그인 성공');
      } else {
        // 카카오 계정으로 로그인
        token = await UserApi.instance.loginWithKakaoAccount();
        _logger.i('카카오계정으로 로그인 성공');
      }

      // 인가 코드(액세스 토큰)를 FastAPI로 전송
      await sendAuthCodeToBackend(token.accessToken);

      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      String? nickname = user.kakaoAccount?.profile?.nickname;
      String? email = user.kakaoAccount?.email;

      _logger.i('사용자 정보: 닉네임 - $nickname, 이메일 - $email');

      return {
        'nickname': nickname,
        'email': email,
      };
    } catch (error) {
      _logger.e('카카오 로그인 실패: $error');
      if (error is PlatformException && error.code == 'CANCELED') {
        _logger.w('사용자가 로그인 취소');
      }
      return {
        'nickname': null,
        'email': null,
      };
    }
  }

  // 로그아웃
  Future<void> signOut() async {
    await UserApi.instance.logout();
    _logger.i('카카오 로그아웃 성공');
  }
}
