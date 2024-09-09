import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';

class RecordScreen extends StatefulWidget {
  final bool isLatestFirst; // 정렬 상태를 받는 변수

  const RecordScreen({super.key, required this.isLatestFirst});

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  // 더미 데이터
  List<Map<String, dynamic>> meals = [];

  @override
  void initState() {
    super.initState();

    // 더미 데이터 초기화
    DateTime breakfastTime = DateTime(2024, 9, 8, 8, 0, 0);
    DateTime lunchTime = DateTime(2024, 9, 8, 12, 30, 0);
    DateTime dinnerTime = DateTime(2024, 9, 8, 19, 0, 0);
    DateTime snackTime = DateTime(2024, 9, 8, 22, 0, 0);

    meals = [
      {
        'type': '아침 식사',
        'food': '시리얼과 우유',
        'calories': 250,
        'carb': 40,
        'protein': 8,
        'fat': 5,
        'time': breakfastTime, // DateTime 형식으로 저장
      },
      {
        'type': '점심 식사',
        'food': '치킨 샐러드',
        'calories': 400,
        'carb': 20,
        'protein': 30,
        'fat': 15,
        'time': lunchTime, // DateTime 형식으로 저장
      },
      {
        'type': '저녁 식사',
        'food': '스파게티',
        'calories': 600,
        'carb': 70,
        'protein': 20,
        'fat': 25,
        'time': dinnerTime, // DateTime 형식으로 저장
      },
      {
        'type': '기타',
        'food': '과일',
        'calories': 100,
        'carb': 25,
        'protein': 1,
        'fat': 0,
        'time': snackTime, // DateTime 형식으로 저장
      },
    ];
  }

  // 식사 시간을 기준으로 정렬하는 함수
  void _sortMeals() {
    meals.sort((a, b) {
      DateTime timeA = a['time'];
      DateTime timeB = b['time'];
      return widget.isLatestFirst
          ? timeB.compareTo(timeA)
          : timeA.compareTo(timeB);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 매번 build될 때마다 정렬을 반영
    _sortMeals();

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          final imagePath =
              _getImageForMealType(meal['type']); // 식사 타입에 맞는 이미지 경로 가져오기
          String formattedTime = DateFormat('HH시 mm분 ss초')
              .format(meal['time']); // 기록 시간을 'HH시 mm분 ss초' 형식으로 변환

          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Sizes.size16, vertical: Sizes.size4),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: Sizes.size8),
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(Sizes.size16), // 카드 내부 여백 추가
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal['type'],
                                style: const TextStyle(
                                    fontFamily: "myfonts",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Gaps.v8,
                              Text(
                                "음식명 : ${meal['food']}",
                                style: const TextStyle(
                                    fontFamily: "nanum",
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              Gaps.v4,
                              Text(
                                "칼로리 : ${meal['calories']} kcal",
                                style: const TextStyle(
                                    fontFamily: "nanum",
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                              Gaps.v4,
                              Text(
                                "탄수화물 : ${meal['carb']}g / 단백질 : ${meal['protein']}g / 지방 : ${meal['fat']}g",
                                style: const TextStyle(
                                    fontFamily: "nanum",
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              imagePath, // 각 식사 타입에 맞는 이미지 삽입
                              fit: BoxFit.cover, // 이미지를 꽉 채우기
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gaps.v8,
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "기록 시간: $formattedTime",
                        style: const TextStyle(
                          fontFamily: "nanum",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 77, 77, 77),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 이미지 경로를 식사 타입에 맞게 반환하는 함수
  String _getImageForMealType(String mealType) {
    switch (mealType) {
      case '아침 식사':
        return 'assets/images/breakfast.png'; // 아침 식사 이미지 경로
      case '점심 식사':
        return 'assets/images/lunch.png'; // 점심 식사 이미지 경로
      case '저녁 식사':
        return 'assets/images/dinner.png'; // 저녁 식사 이미지 경로
      default:
        return 'assets/images/snack.png'; // 기본 이미지 경로
    }
  }
}
