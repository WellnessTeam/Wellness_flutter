import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/constants/gaps.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  static String routeName = "login";
  static String routeURL = "/";

  const LoginScreen({super.key});

  void _onKakaoLoginTap(BuildContext context) {
    context.goNamed('birthday');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      'assets/images/new_rabbit.png', // 여기에 로고 이미지 경로를 입력하세요
                      height: 300, // 이미지 높이를 조정하세요
                    ),
                    Gaps.v10, // 이미지와 앱 이름 사이에 간격을 추가
                    const Text(
                      "WELLNESS", // 여기에 앱 이름을 입력하세요
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
                          //fontStyle: FontStyle.italic,
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
                          //fontStyle: FontStyle.italic,
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
              color: Colors.transparent, // No background needed for an image
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Image.asset(
              'assets/images/kakao_login_medium_wide.png', // Use the uploaded image
              fit: BoxFit.contain, // Adjust the image to fit the container
            ),
          ),
        ),
      ),
    );
  }
}
