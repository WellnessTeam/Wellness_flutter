import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/constants/sizes.dart';
import 'package:logger/logger.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart'; // 카카오 SDK 추가
import 'package:frontend/features/authentication/views/login_screen.dart'; // 로그인 화면 경로 추가
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 추가

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
      _addNewRecord(newRecord);
    }
  }

  bool _isDuplicateRecord(Map<String, dynamic> newRecord) {
    DateTime newRecordTime = DateTime.parse(newRecord['time']);
    return meals.any((meal) {
      DateTime mealTime = DateTime.parse(meal['time']);
      return mealTime.isAtSameMomentAs(newRecordTime);
    });
  }

  void _addNewRecord(Map<String, dynamic> newRecord) {
    setState(() {
      DateTime newRecordTime = DateTime.parse(newRecord['time']);
      final isDuplicate = meals.any((meal) {
        return DateTime.parse(meal['time']).isAtSameMomentAs(newRecordTime);
      });

      if (!isDuplicate) {
        meals = [...meals, newRecord];
        lastAddedRecord = newRecord;
      }
      logger.i('현재 기록 리스트: $meals');
    });
  }

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

  // 로그아웃 기능 추가 (SharedPreferences 사용)
  void signOut() async {
    try {
      // 카카오 로그아웃 API 호출
      await UserApi.instance.logout();
      logger.i('카카오 로그아웃 성공');

      // SharedPreferences에 저장된 세션 정보 삭제
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // SharedPreferences에 저장된 모든 데이터 삭제
      logger.i('로컬 저장된 데이터 삭제 성공');

      // 로그아웃 후 로그인 화면으로 이동
      context.goNamed(LoginScreen.routeName); // 로그인 화면으로 이동
    } catch (error) {
      logger.e('카카오 로그아웃 실패: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('기록 화면'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut, // 로그아웃 버튼 클릭 시 로그아웃 처리
          ),
        ],
      ),
      body: meals.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: Sizes.size16),
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                String formattedTime = DateFormat('HH시 mm분 ss초')
                    .format(DateTime.parse(meal['time']));
                String foodImage = _getImageForFood(meal['food']);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Sizes.size16, vertical: Sizes.size4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin:
                            const EdgeInsets.symmetric(vertical: Sizes.size8),
                        color: Colors.green[50],
                        child: Padding(
                          padding: const EdgeInsets.all(Sizes.size16),
                          child: Row(
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
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
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
                              Align(
                                alignment: Alignment.topRight,
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
              '오늘의 기록을 추가해보세요!',
              style: TextStyle(fontFamily: "pretendard-regular", fontSize: 18),
            )),
    );
  }
}
