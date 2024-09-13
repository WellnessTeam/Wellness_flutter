import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/features/authentication/view_models/login_platform.dart';
import 'package:frontend/features/authentication/views/birthday_screen.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:logger/logger.dart';
import 'package:go_router/go_router.dart'; // GoRouter 패키지 추가

class LoginScreen extends StatefulWidget {
  static String routeName = "login";
  static String routeURL = "/";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logger _logger = Logger();
  LoginPlatform _loginPlatform = LoginPlatform.none;

  // 카카오 로그인 로직
  void signInWithKakao() async {
    _logger.d("카카오 로그인 시도");
    // _logger.i(await KakaoSdk.origin); //hash key 출력코드

    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        _logger.i('카카오톡으로 로그인 성공');
        setState(() {
          _loginPlatform = LoginPlatform.kakao;
        });

        // 로그인 성공 후 사용자 정보 가져오기
        User user = await UserApi.instance.me();
        String? nickname = user.kakaoAccount?.profile?.nickname;
        String? email = user.kakaoAccount?.email;

        _logger.i('사용자 정보: 닉네임 - $nickname, 이메일 - $email');

        // GoRouter를 사용하여 BirthdayScreen으로 이동
        context.goNamed(
          BirthdayScreen.routeName,
          extra: {
            'nickname': nickname,
            'email': email,
          },
        );
      } catch (error) {
        _logger.e('카카오톡으로 로그인 실패: $error');

        if (error is PlatformException && error.code == 'CANCELED') {
          _logger.w('사용자가 로그인 취소');
          return;
        }

        try {
          await UserApi.instance.loginWithKakaoAccount();
          _logger.i('카카오계정으로 로그인 성공');
          setState(() {
            _loginPlatform = LoginPlatform.kakao;
          });

          User user = await UserApi.instance.me();
          String? nickname = user.kakaoAccount?.profile?.nickname;
          String? email = user.kakaoAccount?.email;

          _logger.i('사용자 정보: 닉네임 - $nickname, 이메일 - $email');

          context.goNamed(
            BirthdayScreen.routeName,
            extra: {
              'nickname': nickname,
              'email': email,
            },
          );
        } catch (error) {
          _logger.e('카카오계정으로 로그인 실패: $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        _logger.i('카카오계정으로 로그인 성공');
        setState(() {
          _loginPlatform = LoginPlatform.kakao;
        });

        User user = await UserApi.instance.me();
        String? nickname = user.kakaoAccount?.profile?.nickname;
        String? email = user.kakaoAccount?.email;

        _logger.i('사용자 정보: 닉네임 - $nickname, 이메일 - $email');

        context.goNamed(
          BirthdayScreen.routeName,
          extra: {
            'nickname': nickname,
            'email': email,
          },
        );
      } catch (error) {
        _logger.e('카카오계정으로 로그인 실패: $error');
      }
    }
  }

  // 로그아웃
  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.kakao:
        await UserApi.instance.logout();
        _logger.i('카카오 로그아웃 성공');
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

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
