import 'package:flutter/material.dart'; // 플러터에서 화면을 그리기 위한 도구들이 들어있음
import 'package:frontend/constants/gaps.dart'; // 빈 공간을 추가하는데 도움을 주는 클래스들이 있어요
import 'package:frontend/constants/sizes.dart'; // 크기 관련 상수들이 들어있어요
import 'package:frontend/features/authentication/views/email_screen.dart'; // 이메일 입력 화면으로 이동할 때 사용해요
import 'package:frontend/features/authentication/views/widgets/form_button.dart'; // 폼 버튼을 그리기 위한 도구들이에요

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  _UsernameScreenState createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen> {
  final TextEditingController _usernameController =
      TextEditingController(); // 여기서 TextEditingController를 사용해요

  String _username = ""; // 사용자가 입력한 사용자 이름을 저장해요

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(() {
      // 사용자가 입력을 할 때마다 호출되는 함수예요
      setState(() {
        _username = _usernameController.text; // 사용자가 입력한 내용을 변수에 저장해요
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose(); // 화면을 떠나면 컨트롤러를 없애줘요
    super.dispose();
  }

  void _onNextTap() {
    // 사용자가 '다음' 버튼을 눌렀을 때 실행돼요
    if (_username.isNotEmpty) {
      Navigator.push(
        // 이메일 입력 화면으로 넘어가요
        context,
        MaterialPageRoute(
          builder: (context) =>
              EmailScreen(username: _username), // 입력한 사용자 이름을 다음 화면으로 넘겨줘요
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"), // 화면 상단에 'Sign up'이라는 제목을 표시해요
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Sizes.size36), // 좌우에 여백을 줘요
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v40, // 위쪽에 40픽셀만큼 빈 공간을 넣어요
            const Text(
              "Create username", // '사용자 이름을 만들어주세요'라는 메시지를 보여줘요
              style: TextStyle(
                fontSize: Sizes.size24,
                fontWeight: FontWeight.w700, // 텍스트가 굵게 보여요
              ),
            ),
            Gaps.v16, // 또 빈 공간을 넣어요
            TextField(
              controller: _usernameController, // 사용자가 입력하는 내용을 저장하는 역할이에요
              decoration: InputDecoration(
                hintText: "Username", // 'Username'이라는 힌트가 입력 칸에 보여요
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey.shade400), // 입력 칸의 밑줄 색깔을 설정해요
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Colors.grey.shade400), // 입력 중일 때 밑줄 색깔을 설정해요
                ),
              ),
              cursorColor:
                  Theme.of(context).primaryColor, // 커서(깜빡이는 선)의 색깔을 설정해요
            ),
            Gaps.v28, // 또 빈 공간을 넣어요
            GestureDetector(
              onTap: _onNextTap, // 사용자가 버튼을 누르면 _onNextTap 함수가 실행돼요
              child: FormButton(
                disabled: _username.isEmpty, // 사용자 이름이 입력되지 않으면 버튼이 비활성화돼요
                text: "Next", // 버튼에 'Next'라는 글자가 보여요
              ),
            ),
          ],
        ),
      ),
    );
  }
}
