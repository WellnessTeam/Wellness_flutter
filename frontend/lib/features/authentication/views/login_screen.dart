import 'package:flutter/material.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/constants/gaps.dart';
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
  final Logger _logger = Logger();

  // 카카오 로그인 로직 호출
  void _onKakaoLoginTap(BuildContext context) async {
    _logger.i('Kakao login button tapped');

    final userInfo = await _kakaoLoginService.signInWithKakao();
    _logger.i('Kakao login response: $userInfo');

    if (userInfo['nickname'] != null && userInfo['email'] != null) {
      _logger.i('Navigating to BirthdayScreen with userInfo');
      context.goNamed(BirthdayScreen.routeName, extra: {
        'nickname': userInfo['nickname'],
        'email': userInfo['email'],
      });
    } else {
      _logger.w('Kakao login failed or returned incomplete info');
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('LoginScreen build started');
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/new_rabbit.png',
                  height: 200,
                ),
                Gaps.v20,
                const Text(
                  "WELLNESS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "appname",
                    fontSize: Sizes.size32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v20,
                const Opacity(
                  opacity: 0.7,
                  child: Text(
                    "사진 업로드 한 번으로 끝내는",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "pretendard-regular",
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Gaps.v10,
                const Opacity(
                  opacity: 0.7,
                  child: Text(
                    "'빠르고 간편한' 식단 관리 앱",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "pretendard-regular",
                      fontSize: Sizes.size16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Gaps.v40,
                _KakaoLoginButton(onTap: _onKakaoLoginTap),
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
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(Sizes.size12),
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
