import 'package:flutter/material.dart'; //플러터에서 화면을 그리기 위한 도구들이 들어있음
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/features/authentication/views/password_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/authentication/view_models/signup_view_model.dart';

class EmailScreen extends ConsumerStatefulWidget {
  final String username;

  const EmailScreen({
    super.key,
    required this.username,
  });
  @override
  ConsumerState<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends ConsumerState<EmailScreen> {
  final TextEditingController _emailController = TextEditingController();

  String _email = "";

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {
        _email = _emailController.text;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus(); // 사용자가 빈 곳을 눌렀을때 키보드가 화면에서 사라짐
  }

  String? _isEmailValid() {
    if (_email.isEmpty) return null;
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!regExp.hasMatch(_email)) {
      return "Email not valid";
    }
    return null;
  }

  void _onSubmit() {
    if (_email.isEmpty || _isEmailValid() != null) return;
    ref.read(signUpForm.notifier).state = {"email": _email};
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PasswordScreen(username: widget.username, email: _email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sign up",
          ),
        ),
        body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizes.size36,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v40,
                Text(
                  "What is your email, ${widget.username}?",
                  style: TextStyle(
                    fontSize: Sizes.size24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v16,
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  onEditingComplete: _onSubmit,
                  autocorrect: false,
                )
              ],
            )),
      ),
    );
  }
}
