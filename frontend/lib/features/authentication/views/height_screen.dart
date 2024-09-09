import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/features/authentication/view_models/signup_view_model.dart';
import 'package:frontend/features/authentication/views/widgets/form_button.dart';
import 'package:frontend/features/authentication/views/weight_screen.dart';
import 'package:frontend/features/authentication/views/widgets/status_bar.dart';
import 'package:go_router/go_router.dart';

class HeightScreen extends ConsumerStatefulWidget {
  static String routeName = "height";
  static String routeURL = "/height";

  const HeightScreen({super.key});

  @override
  ConsumerState<HeightScreen> createState() => _HeightScreenState();
}

class _HeightScreenState extends ConsumerState<HeightScreen> {
  final TextEditingController _heightController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _heightController.dispose();
    super.dispose();
  }

  void _validateInput(String input) {
    final regex = RegExp(r'^\d{3}(\.\d{0,1})?$');

    if (regex.hasMatch(input)) {
      final double? value = double.tryParse(input);

      if (value != null && value >= 100.0 && value <= 250.0) {
        setState(() {
          _errorMessage = null;
        });
      } else {
        setState(() {
          _errorMessage = "100 - 250 사이의 값을 입력해주세요.";
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
      "height": _heightController.text,
    };

    context.goNamed(WeightScreen.routeName);
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
            context.goNamed("gender");
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
              currentStep: 3,
              totalSteps: 4,
              width: MediaQuery.of(context).size.width,
              stepCompleteColor: Colors.blue,
              currentStepColor: const Color(0xffdbecff),
              inactiveColor: const Color(0xffbababa),
              lineWidth: 3.5,
            ), // 현재 스텝을 3로 설정
            Gaps.v40,
            const Text(
              "키(cm)를 입력해주세요.",
              style: TextStyle(
                fontFamily: "pretendard-regular",
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v16,
            TextField(
              controller: _heightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: "예시) 174.3",
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
                ), // 오류 메시지를 표시하는 부분
              ),
              cursorColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                _validateInput(value); // 입력값을 검증하는 함수 호출
              },
            ),
            Gaps.v28,
            GestureDetector(
              onTap: _heightController.text.isNotEmpty && _errorMessage == null
                  ? _onNextTap
                  : null,
              child: FormButton(
                disabled:
                    _heightController.text.isEmpty || _errorMessage != null,
                text: "Next",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
