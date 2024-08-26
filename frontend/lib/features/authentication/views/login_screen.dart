import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/features/authentication/views/login_form_screen.dart';
import 'package:frontend/features/authentication/views/widgets/auth_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerWidget {
  static String routeName = "login";
  static String routeURL = "/login";

  const LoginScreen({super.key});

  void _onSignUpTap(BuildContext context) {
    context.goNamed("signUp");
  }

  void _onEmailLoginTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
          child: Column(
            children: [
              Gaps.v80,
              const Text(
                "Login to myApp",
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v20,
              const Opacity(
                opacity: 0.7,
                child: Text(
                  "Manage your account, check notifications, comment on videos, and more.",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Gaps.v40,
              GestureDetector(
                onTap: () => _onEmailLoginTap(context),
                child: const AuthButton(
                  icon: FaIcon(
                    FontAwesomeIcons.user,
                  ),
                  text: "Use email & password",
                ),
              ),
              Gaps.v16,
              GestureDetector(
                //       onTap: () =>
                //ref.read(socialAuthProvider.notifier).kakaoSignIn(context),
                child: FractionallySizedBox(
                  widthFactor: 1, // 상위 부모의 사이즈 비율에 맞게 반드는 것
                  child: Container(
                    padding: const EdgeInsets.all(Sizes.size14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE500), // 카카오 노란색

                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: Sizes.size1,
                      ),
                    ),
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: FaIcon(
                            FontAwesomeIcons.comment,
                            color: Color(0xFF000000), // 검정색 심볼
                          ),
                        ),
                        Text(
                          "Continue with Kakao",
                          style: TextStyle(
                            fontSize: Sizes.size16, // 텍스트 크기 조정
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(0, 0, 0, 0.85), // 85% 불투명도 검정
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.size32,
            bottom: Sizes.size64,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(
                  fontSize: Sizes.size16,
                ),
              ),
              Gaps.h5,
              GestureDetector(
                onTap: () => _onSignUpTap(context),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
