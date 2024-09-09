import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/features/authentication/view_models/signup_view_model.dart';
import 'package:frontend/features/authentication/views/widgets/form_button.dart';
import 'package:frontend/features/authentication/views/height_screen.dart';
import 'package:frontend/features/authentication/views/widgets/status_bar.dart';
import 'package:go_router/go_router.dart';

class GenderScreen extends ConsumerStatefulWidget {
  static String routeName = "gender";
  static String routeURL = "/gender";

  const GenderScreen({super.key});

  @override
  ConsumerState<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends ConsumerState<GenderScreen> {
  String _selectedGender = "없음";

  void _onNextTap() {
    final state = ref.read(signUpForm.notifier).state;
    ref.read(signUpForm.notifier).state = {
      ...state,
      "gender": _selectedGender,
    };

    context.goNamed(HeightScreen.routeName);
  }

  void _onGenderTap(String gender) {
    setState(() {
      _selectedGender = gender;
    });
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
            context.goNamed("birthday");
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
              currentStep: 2,
              totalSteps: 4,
              width: MediaQuery.of(context).size.width,
              stepCompleteColor: Colors.blue,
              currentStepColor: const Color(0xffdbecff),
              inactiveColor: const Color(0xffbababa),
              lineWidth: 3.5,
            ), // 현재 스텝을 2로 설정
            Gaps.v40,
            const Text(
              "성별을 선택해주세요.",
              style: TextStyle(
                fontFamily: "pretendard-regular",
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),

            Gaps.v16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _onGenderTap('남성'),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: const EdgeInsets.symmetric(vertical: Sizes.size80),
                    decoration: BoxDecoration(
                      color: _selectedGender == '남성'
                          ? const Color(0xffdbecff)
                          : const Color.fromARGB(255, 238, 237, 237),
                      borderRadius: BorderRadius.circular(Sizes.size12),
                    ),
                    child: Center(
                      child: Text(
                        "남성",
                        style: TextStyle(
                          fontFamily: "pretendard-regular",
                          color: _selectedGender == '남성'
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.black,
                          fontSize: Sizes.size18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _onGenderTap('여성'),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: const EdgeInsets.symmetric(vertical: Sizes.size80),
                    decoration: BoxDecoration(
                      color: _selectedGender == '여성'
                          ? const Color(0xffdbecff)
                          : const Color.fromARGB(255, 238, 237, 237),
                      borderRadius: BorderRadius.circular(Sizes.size12),
                    ),
                    child: Center(
                      child: Text(
                        "여성",
                        style: TextStyle(
                          fontFamily: "pretendard-regular",
                          color: _selectedGender == '여성'
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : Colors.black,
                          fontSize: Sizes.size18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Gaps.v28,
            GestureDetector(
              onTap: _selectedGender != '없음' ? _onNextTap : null,
              child: FormButton(
                disabled: _selectedGender == '없음',
                text: "Next",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
