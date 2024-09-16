import 'package:flutter/material.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/constants/gaps.dart';
//import 'package:frontend/features/authentication/view_models/login_platform.dart';
import 'package:frontend/features/authentication/views/birthday_screen.dart';
import 'package:frontend/features/authentication/view_models/kakao_login.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "login";
  static String routeURL = "/";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final KakaoLoginService _kakaoLoginService = KakaoLoginService();
  final bool _isLoading = false; // 로딩 상태 추가
  final Logger _logger = Logger(); // Logger 인스턴스 생성

  // 카카오 로그인 로직 호출
  void _onKakaoLoginTap(BuildContext context) async {
    _logger.i('Kakao login button tapped'); // 버튼 탭 로그 추가

    final userInfo = await _kakaoLoginService.signInWithKakao();

    _logger.i('Kakao login response: $userInfo'); // 로그인 응답 로그 추가

    if (userInfo['nickname'] != null && userInfo['email'] != null) {
      // GoRouter를 사용하여 BirthdayScreen으로 이동 (사용자 정보 전달)
      _logger.i('Navigating to BirthdayScreen with userInfo'); // 네비게이션 로그 추가

      context.goNamed(BirthdayScreen.routeName, extra: {
        'nickname': userInfo['nickname'],
        'email': userInfo['email'],
      });
    } else {
      _logger.w('Kakao login failed or returned incomplete info'); // 실패 로그 추가
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('LoginScreen build started'); // 시작 로그 추가
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_isLoading)
                  const CircularProgressIndicator(), // 로딩 인디케이터 추가
                if (!_isLoading) ...[
                  Image.asset(
                    'assets/images/new_rabbit.png', // 로고 이미지 경로
                    height: 200, // 이미지 크기 축소
                  ),
                  Gaps.v20, // 이미지와 텍스트 사이에 간격 추가
                  const Text(
                    "WELLNESS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "appname",
                      fontSize: Sizes.size32, // 텍스트 크기 축소
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gaps.v20, // 텍스트와 다음 요소 사이에 간격 추가
                  const Opacity(
                    opacity: 0.7,
                    child: Text(
                      "사진 업로드 한 번으로 끝내는",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "pretendard-regular",
                        fontSize: Sizes.size16, // 텍스트 크기 축소
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Gaps.v10, // 텍스트 사이 간격 조정
                  const Opacity(
                    opacity: 0.7,
                    child: Text(
                      "'빠르고 간편한' 식단 관리 앱",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "pretendard-regular",
                        fontSize: Sizes.size16, // 텍스트 크기 축소
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Gaps.v40, // 텍스트와 버튼 사이에 간격 추가
                  _KakaoLoginButton(onTap: _onKakaoLoginTap),
                ],
              ],
            ),
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
  _KakaoLoginButtonState createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends State<_KakaoLoginButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(context),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // 너비를 화면의 80%로 설정
        padding: const EdgeInsets.all(Sizes.size12), // 패딩 축소
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Image.asset(
          'assets/images/kakao_login_medium_wide.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
