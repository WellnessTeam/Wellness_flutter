import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:frontend/features/home/repos/analyze_repository.dart'; // AnalyzeRepository import

class RecordScreen extends StatefulWidget {
  final bool isLatestFirst;
  final List<Map<String, dynamic>> meals; // meals 매개변수 사용

  const RecordScreen({
    super.key,
    required this.isLatestFirst,
    required this.meals,
  });

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  List<Map<String, dynamic>> meals = [];
  var logger = Logger();
  final AnalyzeRepository _analyzeRepository = AnalyzeRepository();

  @override
  void initState() {
    super.initState();

    meals = widget.meals;

    logger.i('전달된 meals: ${widget.meals}');

    // 서버에서 추가 데이터를 가져옵니다.
    _loadMealRecords();
  }

  Future<void> _loadMealRecords() async {
    try {
      // 첫 번째 API로부터 받은 데이터를 기반으로 두 번째 API 호출
      List<Map<String, dynamic>> fetchedMeals =
          await _analyzeRepository.saveAndFetchMealRecords();

      setState(() {
        widget.meals.addAll(fetchedMeals); // 전달된 meals에 새로 가져온 기록 추가
      });
      logger.i('API로부터 불러온 기록 리스트: ${widget.meals}');
    } catch (e) {
      logger.e('식사 기록을 불러오는 중 오류 발생: $e');
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
    return Scaffold(
      body: widget.meals.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: widget.meals.length,
              itemBuilder: (context, index) {
                final meal = widget.meals[index];
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
            )
          : const Center(
              child: Text(
              '오늘의 기록을 추가해보세요!',
              style: TextStyle(fontFamily: "pretendard-regular", fontSize: 18),
            )),
    );
  }
}
