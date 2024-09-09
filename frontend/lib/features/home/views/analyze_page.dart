import 'package:flutter/material.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:go_router/go_router.dart'; // go_router를 사용하여 라우팅
import 'package:frontend/features/home/views/widgets/nutrition_bar.dart'; // NutritionBar import

class AnalyzePage extends StatelessWidget {
  final XFile image; // 업로드된 이미지 파일

  const AnalyzePage({
    super.key,
    required this.image,
  });

  // 이미지 메타데이터를 읽어 식사 종류를 결정하는 함수
  String determineMealType(DateTime dateTime) {
    final hour = dateTime.hour;
    if (hour >= 6 && hour < 9) {
      return '아침';
    } else if (hour >= 11 && hour < 14) {
      return '점심';
    } else if (hour >= 17 && hour < 20) {
      return '저녁';
    } else {
      return '기타';
    }
  }

  @override
  Widget build(BuildContext context) {
    // 이미지 파일이 존재하지 않을 경우의 기본값 처리
    final DateTime now = DateTime.now();
    final String determinedMealType = determineMealType(now);

    // 예제 데이터: 식사 종류, 음식명, 칼로리 및 영양정보
    const String foodName = "샐러드";
    const int calories = 250;
    const double carbs = 20;
    const double protein = 10;
    const double fat = 15;

    // 권장 섭취량 예제 데이터
    const int recommendedCalories = 2000;
    const double recommendedCarbs = 50.0;
    const double recommendedProtein = 30.0;
    const double recommendedFat = 40.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '업로드 한 사진의 분석 결과예요.',
          style: TextStyle(fontFamily: "myfonts", fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 설정된 Meal Type 표시
            Text(
              "식사 종류: $determinedMealType",
              style: const TextStyle(
                  fontFamily: "myfonts",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // 업로드된 사진 표시
            Center(
              child: Image.file(
                File(image.path),
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            // 분류된 음식명 및 칼로리 정보
            const Text(
              "음식명: $foodName",
              style: TextStyle(fontFamily: "myfonts", fontSize: 18),
            ),
            const SizedBox(height: 10),
            // 칼로리 표시 및 Bar
            // const Text(
            //   "칼로리: $calories kcal",
            //   style: TextStyle(fontFamily: "myfonts", fontSize: 18),
            // ),
            NutritionBar(
              label: "칼로리",
              intake: calories.toDouble(),
              recommended: recommendedCalories.toDouble(),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFFFF5722)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            // 영양정보 바 추가 (탄수화물, 단백질, 지방)
            const NutritionBar(
              label: "탄수화물",
              intake: carbs,
              recommended: recommendedCarbs,
              gradient: LinearGradient(
                colors: [Color(0xFF90CAF9), Color(0xFF1E88E5)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            const NutritionBar(
              label: "단백질",
              intake: protein,
              recommended: recommendedProtein,
              gradient: LinearGradient(
                colors: [Color(0xFFFFF176), Color(0xFFFFC107)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            const NutritionBar(
              label: "지방",
              intake: fat,
              recommended: recommendedFat,
              gradient: LinearGradient(
                colors: [Color(0xFFF48FB1), Color(0xFFE91E63)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            const Spacer(),
            // 완료 및 취소 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      // 팝업창 띄우기
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            '기록을 취소하실 건가요?',
                            style: TextStyle(fontFamily: "pretendard-regular"),
                          ),
                          content: const Text(
                            '확인 버튼을 누르면 결과가 기록되지 않아요!',
                            style: TextStyle(
                                fontFamily: "pretendart-regular",
                                fontWeight: FontWeight.w300),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                '취소',
                                style: TextStyle(
                                    fontFamily: "pretendard-regular",
                                    fontWeight: FontWeight.w300),
                              ),
                              onPressed: () {
                                // 취소 버튼을 누르면 HomeScreen으로 이동
                                Navigator.of(context).pop(); // 팝업창 닫기
                              },
                            ),
                            TextButton(
                              child: const Text(
                                '확인',
                                style: TextStyle(
                                    fontFamily: "pretendard-regular",
                                    fontWeight: FontWeight.w300),
                              ),
                              onPressed: () {
                                // 확인 버튼을 누르면 home 화면으로 이동
                                context.go('/home/home');
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(57, 39, 138, 26)),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                        fontFamily: "pretendard-regular",
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 완료 버튼 클릭 시 record 화면으로 이동
                    context.go('/home/record');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(57, 39, 138, 26)),
                  child: const Text(
                    '완료',
                    style: TextStyle(
                        fontFamily: "pretendard-regular",
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
