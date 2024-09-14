import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/features/authentication/view_models/login_platform.dart';
import 'package:frontend/features/authentication/views/birthday_screen.dart';
import 'package:frontend/features/authentication/view_models/kakao_login.dart';
import 'package:go_router/go_router.dart'; // GoRouter 패키지 추가

class LoginScreen extends StatefulWidget {
  static String routeName = "login";
  static String routeURL = "/";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final KakaoLoginService _kakaoLoginService = KakaoLoginService();
  LoginPlatform _loginPlatform = LoginPlatform.none;

  // 카카오 로그인 로직 호출
  void _onKakaoLoginTap(BuildContext context) async {
    final userInfo = await _kakaoLoginService.signInWithKakao();
    if (userInfo['nickname'] != null && userInfo['email'] != null) {
      setState(() {
        _loginPlatform = LoginPlatform.kakao;
      });
      // GoRouter를 사용하여 BirthdayScreen으로 이동 (사용자 정보 전달)
      context.goNamed(BirthdayScreen.routeName, extra: {
        'nickname': userInfo['nickname'],
        'email': userInfo['email'],
      });
    }
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
  _KakaoLoginButtonState createState() => _KakaoLoginButtonState();
}

class _KakaoLoginButtonState extends State<_KakaoLoginButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}
