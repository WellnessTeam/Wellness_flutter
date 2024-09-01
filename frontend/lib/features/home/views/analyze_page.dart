import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:go_router/go_router.dart'; // go_router를 사용하여 라우팅

class AnalyzePage extends StatelessWidget {
  final XFile image; // 업로드된 이미지 파일

  const AnalyzePage({
    Key? key,
    required this.image,
  }) : super(key: key);

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
    final String foodName = "샐러드";
    final int calories = 250;
    final double carbs = 20;
    final double protein = 10;
    final double fat = 15;

    return Scaffold(
      appBar: AppBar(
        title: const Text('분석 결과'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 설정된 Meal Type 표시
            Text(
              "식사 종류: $determinedMealType",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // 업로드된 사진 표시
            Center(
              child: Image.file(
                File(image.path),
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            // 분류된 음식명 표시
            Text(
              "음식명: $foodName",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            // 음식의 칼로리 표시
            Text(
              "칼로리: $calories kcal",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            // 음식의 영양정보 표시 (탄수화물, 단백질, 지방)
            const Text(
              "영양정보:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text("탄수화물: $carbs g"),
            Text("단백질: $protein g"),
            Text("지방: $fat g"),
            const Spacer(),
            // 완료 및 취소 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 완료 버튼 클릭 시 HomeScreen으로 이동
                    context.go('/home/home');
                  },
                  child: const Text('완료'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 취소 버튼 클릭 시 HomeScreen으로 이동
                    context.go('/home/home');
                  },
                  child: const Text('취소'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // 회색 버튼
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
