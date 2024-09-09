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
  String? _errorMessage;

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _validateInput(String input) {
    final regex = RegExp(r'^\d{2,3}(\.\d{0,1})?$');

    if (regex.hasMatch(input)) {
      final double? value = double.tryParse(input);

      if (value != null && value >= 20.0 && value <= 300.0) {
        setState(() {
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = "20 - 300 사이의 값을 입력해주세요.";
        });
      }
    } else {
      setState(() {
        _errorMessage = "유효하지 않는 값입니다.";
      });
    }
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
        title: const Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(
            "필수 정보 입력",
            style: TextStyle(
              fontSize: 20,
              fontFamily: "pretendard-regular",
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.goNamed("height");
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.size10),
            StatusBar(
              currentStep: 4,
              totalSteps: 4,
              width: MediaQuery.of(context).size.width,
              stepCompleteColor: Colors.blue,
              currentStepColor: const Color(0xffdbecff),
              inactiveColor: const Color(0xffbababa),
              lineWidth: 3.5,
            ), // 현재 스텝을 4로 설정
            Gaps.v40,
            const Text(
              "체중(kg)을 입력해주세요.",
              style: TextStyle(
                fontFamily: "pretendard-regular",
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v16,
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "예시) 70.5",
                  hintStyle: TextStyle(
                    fontFamily: "pretendard-regular",
                    color: Colors.grey.shade700,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  errorText: _errorMessage,
                  errorStyle: const TextStyle(
                    fontFamily: "pretendard-regular",
                    fontSize: Sizes.size18,
                  )),
              cursorColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                _validateInput(value);
                // setState(() {});
              },
            ),
            Gaps.v28,
            GestureDetector(
              onTap: _weightController.text.isNotEmpty && _errorMessage == null
                  ? _onNextTap
                  : null,
              child: FormButton(
                disabled:
                    _weightController.text.isEmpty || _errorMessage != null,
                text: "Finish",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
