import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/features/authentication/view_models/signup_view_model.dart';
import 'package:frontend/features/authentication/views/widgets/form_button.dart';
import 'package:frontend/features/authentication/views/widgets/status_bar.dart';
import 'package:frontend/features/home/views/home_screen.dart';
import 'package:go_router/go_router.dart';

class WeightScreen extends ConsumerStatefulWidget {
  static String routeName = "weight";
  static String routeURL = "/weight";

  const WeightScreen({super.key});

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  final TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    final state = ref.read(signUpForm.notifier).state;
    ref.read(signUpForm.notifier).state = {
      ...state,
      "weight": _weightController.text,
    };

    // 'home' 탭으로 이동하도록 설정
    context.goNamed(
      HomeScreen.routeName,
      pathParameters: {'tab': 'home'}, // 여기서 'tab' 값을 명시적으로 전달
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.size20),
            const StatusBar(currentStep: 4, totalSteps: 4), // 현재 스텝을 4로 설정
            Gaps.v40,
            const Text(
              "Enter your weight (kg)",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v16,
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Weight",
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
              onChanged: (_) {
                setState(() {});
              },
            ),
            Gaps.v28,
            GestureDetector(
              onTap: _weightController.text.isNotEmpty ? _onNextTap : null,
              child: FormButton(
                disabled: _weightController.text.isEmpty,
                text: "Finish",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
