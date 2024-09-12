import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/authentication/view_models/login_platform.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart'; // logger 패키지 추가

class LoginScreen extends StatefulWidget {
  static String routeName = "login";
  static String routeURL = "/";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger _logger = Logger(); // logger 인스턴스 생성
  LoginPlatform _loginPlatform = LoginPlatform.none;

  // 카카오 로그인 로직
  void signInWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      OAuthToken token = isInstalled
          ? await UserApi.instance.loginWithKakaoTalk()
          : await UserApi.instance.loginWithKakaoAccount();

      final url = Uri.https('kapi.kakao.com', '/v2/user/me');

      final response = await http.get(
        url,
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer ${token.accessToken}'
        },
      );

      final profileInfo = json.decode(response.body);
      _logger.i('프로필 정보: ${profileInfo.toString()}'); // 정보 로깅

      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });

      // 유저 정보 가져오기
      User user = await UserApi.instance.me();
      _logger.i('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');
    } catch (error) {
      _logger.e('카카오톡으로 로그인 실패', error: error);
    }
  }

  // 로그아웃
  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  // 버튼 클릭 시 카카오 로그인 함수 호출
  void _onKakaoLoginTap(BuildContext context) {
    signInWithKakao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v80,
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/new_rabbit.png', // 로고 이미지 경로
                      height: 300,
                    ),
                    Gaps.v10,
                    const Text(
                      "WELLNESS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "appname",
                        fontSize: Sizes.size40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.v20,
              Gaps.v20,
              const Center(
                // 이 부분을 추가하여 텍스트를 중앙 정렬
                child: Column(
                  children: [
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        "사진 업로드 한 번으로 끝내는",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "pretendard-regular",
                          fontSize: Sizes.size18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        "'빠르고 간편한' 식단 관리 앱",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "pretendard-regular",
                          fontSize: Sizes.size18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.v40,
              Gaps.v40,
              _KakaoLoginButton(onTap: _onKakaoLoginTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _KakaoLoginButton extends StatefulWidget {
  final void Function(BuildContext) onTap;

  const _KakaoLoginButton({required this.onTap});

  @override
  State<_KakaoLoginButton> createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends State<_KakaoLoginButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedScale(
        scale: _isHovered ? 2.0 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: () => widget.onTap(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Sizes.size14),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Image.asset(
              'assets/images/kakao_login_medium_wide.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
