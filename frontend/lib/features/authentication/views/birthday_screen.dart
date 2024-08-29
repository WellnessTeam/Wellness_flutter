import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:frontend/features/authentication/view_models/signup_view_model.dart';
import 'package:frontend/features/authentication/views/gender_screen.dart';
import 'package:frontend/features/authentication/views/widgets/form_button.dart';
import 'package:frontend/features/authentication/views/widgets/status_bar.dart';
import 'package:go_router/go_router.dart';

class BirthdayScreen extends ConsumerStatefulWidget {
  static String routeName = "birthday";
  static String routeURL = "/birthday";

  const BirthdayScreen({super.key});

  @override
  ConsumerState<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends ConsumerState<BirthdayScreen> {
  final TextEditingController _birthdayController = TextEditingController();

  DateTime initialDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _setTextFieldDate(initialDate);
  }

  @override
  void dispose() {
    _birthdayController.dispose();
    super.dispose();
  }

  void _onNextTap() {
    final state = ref.read(signUpForm.notifier).state;
    ref.read(signUpForm.notifier).state = {
      ...state,
      "birthday": _birthdayController.text,
    };
    context.goNamed(GenderScreen.routeName);
  }

  void _setTextFieldDate(DateTime date) {
    final textDate = date.toString().split(" ").first;
    _birthdayController.value = TextEditingValue(text: textDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null && selectedDate != initialDate) {
      setState(() {
        initialDate = selectedDate;
        _setTextFieldDate(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.size20),
            const StatusBar(currentStep: 1, totalSteps: 4), // 현재 스텝을 1로 설정
            Gaps.v40,
            const Text(
              "When's your birthday?",
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gaps.v16,
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _birthdayController,
                  decoration: InputDecoration(
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
              ),
            ),
            Gaps.v28,
            GestureDetector(
              onTap: _birthdayController.text.isNotEmpty ? _onNextTap : null,
              child: FormButton(
                disabled: _birthdayController.text.isEmpty,
                text: "Next",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
