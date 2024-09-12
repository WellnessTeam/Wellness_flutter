import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:logger/logger.dart';

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
  var logger = Logger();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newRecord = GoRouterState.of(context).extra as Map<String, dynamic>?;

    if (newRecord != null && !_isDuplicateRecord(newRecord)) {
      logger.i('전달된 기록 데이터: $newRecord');
      // print('전달된 기록 데이터: $newRecord');
      _addNewRecord(newRecord);
    }
  }

  bool _isDuplicateRecord(Map<String, dynamic> newRecord) {
    // 전달받은 newRecord의 'time' 값을 DateTime으로 변환
    DateTime newRecordTime = DateTime.parse(newRecord['time']);

    // 기존 기록과 중복된 기록이 있는지 확인
    return meals.any((meal) {
      // meal['time']을 String에서 DateTime으로 변환해서 비교
      DateTime mealTime = DateTime.parse(meal['time']);
      return mealTime.isAtSameMomentAs(newRecordTime);
    });
  }

  void _addNewRecord(Map<String, dynamic> newRecord) {
    setState(() {
      // 전달받은 newRecord의 'time' 값을 DateTime으로 변환
      DateTime newRecordTime = DateTime.parse(newRecord['time']);

      // 기존 기록과 중복된 기록이 있는지 확인 (중복 기록 방지)
      final isDuplicate = meals.any((meal) {
        if (meal['time'] is String) {
          // meals의 time이 String일 경우 DateTime으로 변환해서 비교
          return DateTime.parse(meal['time']).isAtSameMomentAs(newRecordTime);
        } else if (meal['time'] is DateTime) {
          // 이미 DateTime 타입일 경우 그대로 비교
          return meal['time'].isAtSameMomentAs(newRecordTime);
        }
        return false;
      });

      // 중복되지 않는다면 새로운 기록을 추가
      if (!isDuplicate) {
        meals = [...meals, newRecord]; // 기존 리스트에 새로운 기록을 추가
        lastAddedRecord = newRecord;
      }
      logger.i('현재 기록 리스트: $meals');
      // print('현재 기록 리스트: $meals');
    });
  }

  // 음식명에 따라 이미지를 반환
  String _getImageForFood(String food) {
    switch (food) {
      case '양념치킨':
        return 'assets/images/food_icons/chicken.png';
      case '된장찌개':
        return 'assets/images/food_icons/hot-soup.png';
      case '짬뽕':
        return 'assets/images/food_icons/noodle.png';
      default:
        return 'assets/images/rice-bowl.png';
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
                String formattedTime = DateFormat('HH시 mm분 ss초').format(
                    DateTime.parse(meal['time'])); // time을 DateTime으로 변환하여 포맷
                String foodImage =
                    _getImageForFood(meal['food']); // 음식명에 따른 이미지 경로 가져오기

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size16, vertical: Sizes.size4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 카드 내용과 이미지를 Row로 배치
                      Card(
                        margin:
                            const EdgeInsets.symmetric(vertical: Sizes.size8),
                        color: Colors.green[50],
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.size16),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Row 안에서 상단 정렬
                            children: [
                              // 카드 내용
                              Expanded(
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
                                  ],
                                ),
                              ),
                              // const SizedBox(width: 5), // 카드 내용과 이미지 사이 간격
                              // 이미지를 위로 배치하기 위해 Align 사용
                              Align(
                                alignment: Alignment.topRight, // 이미지를 상단으로 정렬
                                child: SizedBox(
                                  width: 66,
                                  height: 66,
                                  child: Image.asset(
                                    foodImage,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      // 카드 아래에 기록 시간을 배치
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "기록 시간: $formattedTime",
                          style: const TextStyle(
                            fontFamily: "pretendard-regular",
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
