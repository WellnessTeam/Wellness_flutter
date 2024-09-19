import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
//import 'package:frontend/features/home/repos/analyze_repository.dart'; // AnalyzeRepository import

class RecordScreen extends StatefulWidget {
  final bool isLatestFirst;

  const RecordScreen({
    super.key,
    required this.isLatestFirst,
  });

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  var logger = Logger();
  List<Map<String, dynamic>> meals = []; // 화면에 표시할 데이터를 저장할 리스트

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 전달된 데이터를 초기화합니다.
    final Object? extraData =
        GoRouter.of(context).routerDelegate.currentConfiguration.extra;
    logger.i(
        'Data received in RecordScreen: ${extraData.runtimeType}'); // 데이터 타입 확인

    if (extraData is List<Map<String, dynamic>>) {
      setState(() {
        meals = extraData;
      });
      logger.i('RecordScreen - 전달된 기록 데이터: $meals');
    } else {
      logger.w('No valid data received for records');
      setState(() {
        meals = []; // 빈 리스트로 설정
      });
    }
  }

  String _getImageForFood(String food) {
    switch (food) {
      case '비빔밥':
        return 'assets/images/food_icons/bibimbap.png';
      case '설렁탕':
        return 'assets/images/food_icons/hot-soup.png';
      case '김치찌개':
        return 'assets/images/food_icons/kimchi.png';
      case '족발':
        return 'assets/images/food_icons/jokbal.png';
      case '삼겹살':
        return 'assets/images/food_icons/samgyeop.png';
      case '카레라이스':
        return 'assets/images/food_icons/curry.png';
      case '우동':
        return 'assets/images/food_icons/udon.png';
      case '돈까스':
        return 'assets/images/food_icons/tonkastu.png';
      case '짬뽕':
        return 'assets/images/food_icons/jjambbong.png';
      case '짜장면':
        return 'assets/images/food_icons/jjajangmyeon.png';
      case '탕수육':
        return 'assets/images/food_icons/tangsu.png';
      case '후라이드 치킨':
        return 'assets/images/food_icons/chicken.png';
      case '피자':
        return 'assets/images/food_icons/pizza.png';
      case '크림 스파게티':
        return 'assets/images/food_icons/cream_spaghetti.png';
      case '햄버거':
        return 'assets/images/food_icons/hamburger.png';
      case '김밥':
        return 'assets/images/food_icons/gimbap.png';
      case '떡볶이':
        return 'assets/images/food_icons/tteokbokki.png';
      default:
        return 'assets/images/food_icons/rice-bowl.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.i('RecordScreen - 표시할 meals: $meals');

    return Scaffold(
      body: meals.isEmpty
          ? const Center(child: Text('오늘의 기록을 추가해보세요!'))
          : ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                final meal = meals[index];
                String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss')
                    .format(DateTime.parse(meal['time']));
                String foodImage = _getImageForFood(meal['food']);

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.green[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
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
            ),
    );
  }
}
