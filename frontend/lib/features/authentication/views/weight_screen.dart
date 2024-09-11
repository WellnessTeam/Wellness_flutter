import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController _integerController =
      TextEditingController(); // 정수 부분
  final TextEditingController _decimalController =
      TextEditingController(); // 소수 부분

  final FocusNode _integerFocusNode = FocusNode(); // 정수 부분 포커스 노드
  final FocusNode _decimalFocusNode = FocusNode(); // 소수 부분 포커스 노드

  String? _errorMessage;

  @override
  void dispose() {
    _integerController.dispose();
    _decimalController.dispose();
    _integerFocusNode.dispose();
    _decimalFocusNode.dispose();
    super.dispose();
  }

  void _validateInput() {
    final integerPart = _integerController.text;
    final decimalPart = _decimalController.text;

    if (integerPart.isNotEmpty && decimalPart.isNotEmpty) {
      final double? weight = double.tryParse("$integerPart.$decimalPart");

      if (weight != null && weight >= 20.0 && weight <= 300.0) {
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
    final weight = "${_integerController.text}.${_decimalController.text}";
    ref.read(signUpForm.notifier).state = {
      ...ref.read(signUpForm.notifier).state,
      "weight": weight,
    };

    print("SignUp Form Data: ${ref.read(signUpForm)}");

    // 'home' 탭으로 이동하도록 설정
    context.goNamed(
      HomeScreen.routeName,
      pathParameters: {'tab': 'home'}, // 여기서 'tab' 값을 명시적으로 전달
    );
  }

  void _onIntegerChanged(String value) {
    if (value.length == 3) {
      _decimalFocusNode.requestFocus(); // 정수 부분이 3자리가 되면 소수 부분으로 포커스 이동
    }
    _validateInput();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0), // 상단에 20px 패딩 추가
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  context.goNamed("height");
                },
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0), // 아이콘과 텍스트 사이의 간격
                child: Text(
                  "필수 정보 입력",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "pretendard-regular",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 정수 부분 입력 필드
                SizedBox(
                  width: 80, // 가로 길이 조절
                  child: TextField(
                    controller: _integerController,
                    focusNode: _integerFocusNode, // 정수 포커스 노드 설정
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3), // 최대 3자리까지 입력 가능
                    ],
                    decoration: InputDecoration(
                      hintText: "000", // 텍스트 필드에 표시되는 힌트
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontFamily: "pretendard-regular",
                        fontSize: 15,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    onChanged: _onIntegerChanged, // 값 변경 시 포커스 체크
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  ".",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(width: 10),
                // 소수 부분 입력 필드
                SizedBox(
                  width: 60, // 가로 길이 조절
                  child: TextField(
                    controller: _decimalController,
                    focusNode: _decimalFocusNode, // 소수 포커스 노드 설정
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1), // 최대 1자리까지 입력 가능
                    ],
                    decoration: InputDecoration(
                      hintText: "0", // 텍스트 필드에 표시되는 힌트
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontFamily: "pretendard-regular",
                        fontSize: 15,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    onChanged: (value) {
                      _validateInput();
                    },
                  ),
                ),
              ],
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: Sizes.size14,
                  ),
                ),
              ),
            Gaps.v28,
            GestureDetector(
              onTap: _integerController.text.isNotEmpty &&
                      _decimalController.text.isNotEmpty &&
                      _errorMessage == null
                  ? _onNextTap
                  : null,
              child: FormButton(
                disabled: _integerController.text.isEmpty ||
                    _decimalController.text.isEmpty ||
                    _errorMessage != null,
                text: "Finish",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
