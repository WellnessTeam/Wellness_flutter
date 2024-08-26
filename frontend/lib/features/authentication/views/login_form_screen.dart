import 'package:flutter/material.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/features/authentication/views/widgets/form_button.dart';
import 'package:frontend/features/home/views/home_screen.dart'; // HomeScreen import

class LoginFormScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, String> formData = {};

  LoginFormScreen({super.key});

  void _onSubmitTap(BuildContext context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print("Email: ${formData['email']}, Password: ${formData['password']}");

      // 로그인 로직이 성공했다고 가정하고 HomeScreen으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen(
                  tab: "home",
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Gaps.v28,
              _buildEmailField(),
              Gaps.v16,
              _buildPasswordField(),
              Gaps.v28,
              GestureDetector(
                onTap: () => _onSubmitTap(context),
                child: const FormButton(
                  disabled: false,
                  text: "Log in",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email',
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
      validator: (value) {
        if (value != null && value.isEmpty) {
          return "Please write your email";
        }
        return null;
      },
      onSaved: (newValue) {
        if (newValue != null) {
          formData['email'] = newValue;
        }
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Password',
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
      validator: (value) {
        if (value != null && value.isEmpty) {
          return "Please write your password";
        }
        return null;
      },
      obscureText: true,
      onSaved: (newValue) {
        if (newValue != null) {
          formData['password'] = newValue;
        }
      },
    );
  }
}
