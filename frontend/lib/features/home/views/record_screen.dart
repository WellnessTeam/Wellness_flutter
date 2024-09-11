import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/constants/sizes.dart';

class RecordScreen extends StatefulWidget {
  final bool isLatestFirst;
  final Map<String, dynamic>? newRecord;

  const RecordScreen({
    super.key,
    required this.isLatestFirst,
    this.newRecord,
  });

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<Map<String, dynamic>> meals = [];
  Map<String, dynamic>? lastAddedRecord;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newRecord = GoRouterState.of(context).extra as Map<String, dynamic>?;

    if (newRecord != null && !_isDuplicateRecord(newRecord)) {
      print('전달된 기록 데이터: $newRecord');
      _addNewRecord(newRecord);
    }
  }

  bool _isDuplicateRecord(Map<String, dynamic> newRecord) {
    return lastAddedRecord != null &&
        lastAddedRecord!['time'] == newRecord['time'];
  }

  void _addNewRecord(Map<String, dynamic> newRecord) {
    setState(() {
      newRecord['time'] = DateTime.parse(newRecord['time']);
      meals = [...meals, newRecord];
      lastAddedRecord = newRecord;

      print('현재 기록 리스트: $meals');
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: meals.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                String formattedTime =
                    DateFormat('HH시 mm분 ss초').format(meal['time']); // 기록 시간을 포맷
                String mealImage =
                    _getImageForMealType(meal['type']); // 이미지 경로 가져오기

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size16, vertical: Sizes.size4),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: Sizes.size8),
                    color: Colors.green[50],
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Sizes.size16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal['type'],
                                style: const TextStyle(
                                    fontFamily: "myfonts",
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8), // 텍스트 사이 간격
                              Text("음식명 : ${meal['food']}",
                                  style: const TextStyle(
                                    fontFamily: "pretendard-regular",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text("칼로리 : ${meal['calories']} kcal",
                                  style: const TextStyle(
                                    fontFamily: "pretendard-regular",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Text(
                                  "탄수화물 : ${meal['carb']}g / 단백질 : ${meal['protein']}g / 지방 : ${meal['fat']}g",
                                  style: const TextStyle(
                                    fontFamily: "pretendard-regular",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  )),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "기록 시간: $formattedTime",
                                  style: const TextStyle(
                                      fontFamily: "pretendard-regular",
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 오른쪽 위에 이미지를 배치
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Image.asset(
                            mealImage,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(
              child: Text(
              '기록된 데이터가 없습니다.',
              style: TextStyle(fontFamily: "pretendard-regular", fontSize: 18),
            )),
    );
  }
}
