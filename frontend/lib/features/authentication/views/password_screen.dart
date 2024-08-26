import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/features/authentication/view_models/signup_view_model.dart';
import 'package:frontend/features/authentication/views/widgets/form_button.dart';
import 'package:frontend/features/authentication/views/birthday_screen.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  final String username;
  final String email;

  const PasswordScreen(
      {super.key, required this.username, required this.email});

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String _password = "";
  String _confirmPassword = "";

  bool _obscureText = true;
  bool _obscureConfirmText = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {
        _password = _passwordController.text;
      });
    });

    _confirmPasswordController.addListener(() {
      setState(() {
        _confirmPassword = _confirmPasswordController.text;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isPasswordValid() {
    return _password.isNotEmpty && _password.length >= 8;
  }

  bool _arePasswordsMatching() {
    return _password == _confirmPassword && _confirmPassword.isNotEmpty;
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  void _onSubmit() {
    if (!_isPasswordValid() || !_arePasswordsMatching()) return;
    final state = ref.read(signUpForm.notifier).state;
    ref.read(signUpForm.notifier).state = {
      ...state,
      "password": _password,
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BirthdayScreen(),
      ),
    );
  }

  void _onClearTap() {
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  void _toggleObscureText() {
    _obscureText = !_obscureText;
    setState(() {});
  }

  void _toggleObscureConfirmText() {
    _obscureConfirmText = !_obscureConfirmText;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Sign up",
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v40,
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v16,
              TextField(
                controller: _passwordController,
                onEditingComplete: _onSubmit,
                obscureText: _obscureText,
                autocorrect: false,
                decoration: InputDecoration(
                  suffix: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: _onClearTap,
                        child: FaIcon(
                          FontAwesomeIcons.timesCircle,
                          color: Colors.grey.shade500,
                          size: Sizes.size20,
                        ),
                      ),
                      Gaps.h16,
                      GestureDetector(
                        onTap: _toggleObscureText,
                        child: FaIcon(
                          _obscureText
                              ? FontAwesomeIcons.eye
                              : FontAwesomeIcons.eyeSlash,
                          color: Colors.grey.shade500,
                          size: Sizes.size20,
                        ),
                      ),
                    ],
                  ),
                  hintText: "Make it strong!",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                cursorColor: Theme.of(context).primaryColor,
              ),
              Gaps.v16,
              const Text(
                "Confirm Password",
                style: TextStyle(
                  fontSize: Sizes.size24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Gaps.v16,
              TextField(
                controller: _confirmPasswordController,
                onEditingComplete: _onSubmit,
                obscureText: _obscureConfirmText,
                autocorrect: false,
                decoration: InputDecoration(
                  suffix: GestureDetector(
                    onTap: _toggleObscureConfirmText,
                    child: FaIcon(
                      _obscureConfirmText
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      color: Colors.grey.shade500,
                      size: Sizes.size20,
                    ),
                  ),
                  hintText: "Re-enter your password",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                cursorColor: Theme.of(context).primaryColor,
              ),
              Gaps.v10,
              const Text(
                'Your password must have:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.v10,
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.checkCircle,
                    size: Sizes.size20,
                    color: _isPasswordValid()
                        ? Colors.green
                        : Colors.grey.shade400,
                  ),
                  Gaps.h5,
                  const Text("8 to 20 characters"),
                ],
              ),
              Gaps.v10,
              Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.checkCircle,
                    size: Sizes.size20,
                    color: _arePasswordsMatching()
                        ? Colors.green
                        : Colors.grey.shade400,
                  ),
                  Gaps.h5,
                  const Text("Passwords match"),
                ],
              ),
              Gaps.v28,
              GestureDetector(
                onTap: _onSubmit,
                child: FormButton(
                  disabled: !_isPasswordValid() || !_arePasswordsMatching(),
                  text: "Next",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
