import 'package:flutter/material.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:frontend/features/home/views/widgets/nutrition_bar.dart';
import 'package:frontend/features/home/repos/analyze_repository.dart';
import 'package:logger/logger.dart';
import 'package:exif/exif.dart';

class AnalyzePage extends StatefulWidget {
  final XFile image;

  const AnalyzePage({
    super.key,
    required this.image,
  });

  @override
  _AnalyzePageState createState() => _AnalyzePageState();
}

class _AnalyzePageState extends State<AnalyzePage> {
  String foodName = "분석 중...";
  String mealtype = "분석 중...";
  String date = "분석 중...";
  int foodKcal = 0;
  int foodCarb = 0;
  int foodProt = 0;
  int foodFat = 0;
  int recKcal = 2000;
  int recCarb = 300;
  int recProt = 50;
  int recFat = 70;

  final AnalyzeRepository analyzeRepository = AnalyzeRepository();
  final Logger logger = Logger(); // Logger 인스턴스 생성

  @override
  void initState() {
    super.initState();
    _extractDateFromImage();
    _uploadImageAndLoadFoodData();
  }

  // 이미지 메타데이터에서 date를 추출하는 함수
  Future<void> _extractDateFromImage() async {
    try {
      // 이미지 파일을 바이트로 읽기
      final imageFile = File(widget.image.path);
      final imageData = await imageFile.readAsBytes();

      // EXIF 정보 추출
      final tags = await readExifFromBytes(imageData);

      // DateTimeOriginal 키를 통해 메타데이터에서 날짜를 가져옵니다.
      if (tags.containsKey('EXIF DateTimeOriginal')) {
        date = tags['EXIF DateTimeOriginal'].toString();
        logger.i('Extracted Date from metadata: $date');
        setState(() {});
      } else {
        logger.i('No date metadata found in the image.');
      }
    } catch (e) {
      logger.e('Error extracting metadata: $e');
    }
  }

  Future<void> _uploadImageAndLoadFoodData() async {
    try {
      // JSON 데이터를 받아옵니다.
      final Map<String, dynamic> jsonData = await analyzeRepository
          .uploadImageAndFetchData(File(widget.image.path));

      // API 응답 전체를 로그에 출력하여 확인
      logger.i('API 응답: $jsonData');

      setState(() {
        var wellnessData = jsonData['detail']['wellness_image_info'];

        // `date` 정보 추출 및 로깅
        //date = wellnessData['date'] ?? "날짜 정보 없음";
        //logger.i('Extracted Date: $date');

        foodName = wellnessData['category_name'] ?? "음식 정보 없음";
        mealtype = wellnessData['meal_type'] ?? '식사 타입 없음';
        foodKcal = (wellnessData['food_kcal'] ?? 0).toInt();
        foodCarb = (wellnessData['food_car'] ?? 0).toInt();
        foodProt = (wellnessData['food_prot'] ?? 0).toInt();
        foodFat = (wellnessData['food_fat'] ?? 0).toInt();
        recKcal = (wellnessData['rec_kcal'] ?? 2000).toInt();
        recCarb = (wellnessData['rec_car'] ?? 300).toInt();
        recProt = (wellnessData['rec_prot'] ?? 50).toInt();
        recFat = (wellnessData['rec_fat'] ?? 70).toInt();
      });
    } catch (e) {
      logger.e('API 데이터를 불러오는 중 오류 발생(analyze): $e'); // 오류 로그
      setState(() {
        foodName = "분석 실패";
      });
    }
  }

  // String determineMealType(DateTime dateTime) {
  //   final hour = dateTime.hour;
  //   if (hour >= 6 && hour < 9) {
  //     return '아침';
  //   } else if (hour >= 11 && hour < 14) {
  //     return '점심';
  //   } else if (hour >= 17 && hour < 20) {
  //     return '저녁';
  //   } else {
  //     return '기타';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //inal DateTime now = DateTime.now();
    //final String determinedMealType = determineMealType(now);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50), // AppBar의 높이를 늘립니다
        child: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 30), // Text 위에 20px의 패딩을 추가
            child: Text(
              '업로드 한 사진의 분석 결과예요.',
              style: TextStyle(fontFamily: "myfonts", fontSize: 20),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "식사 종류: $mealtype",
              style: const TextStyle(
                  fontFamily: "myfonts",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.file(
                File(widget.image.path),
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "음식명: $foodName",
              style: const TextStyle(fontFamily: "myfonts", fontSize: 18),
            ),
            const SizedBox(height: 10),
            NutritionBar(
              label: "칼로리",
              intake: foodKcal,
              recommended: recKcal,
              gradient: const LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFFFF5722)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            NutritionBar(
              label: "탄수화물",
              intake: foodCarb,
              recommended: recCarb,
              gradient: const LinearGradient(
                colors: [Color(0xFF90CAF9), Color(0xFF1E88E5)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            NutritionBar(
              label: "단백질",
              intake: foodProt,
              recommended: recProt,
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF176), Color(0xFFFFC107)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            NutritionBar(
              label: "지방",
              intake: foodFat,
              recommended: recFat,
              gradient: const LinearGradient(
                colors: [Color(0xFFF48FB1), Color(0xFFE91E63)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('기록을 취소하실 건가요?'),
                          content: const Text('확인 버튼을 누르면 결과가 기록되지 않아요!'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('취소'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('확인'),
                              onPressed: () {
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
                    Map<String, dynamic> newRecord = {
                      'type': mealtype,
                      'food': foodName,
                      'calories': foodKcal,
                      'carb': foodCarb,
                      'protein': foodProt,
                      'fat': foodFat,
                      'time': DateTime.now().toIso8601String(),
                    };

                    print('전달될 기록 데이터: $newRecord');

                    context.go('/home/record', extra: newRecord);
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
