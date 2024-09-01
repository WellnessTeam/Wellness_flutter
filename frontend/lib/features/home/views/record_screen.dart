import 'package:flutter/material.dart';
import 'package:frontend/constants/gaps.dart';
import 'package:frontend/constants/sizes.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 더미 데이터: 실제 데이터는 백엔드와 연결 후 가져올 예정
    final List<Map<String, dynamic>> meals = [
      {
        'type': '아침 식사',
        'food': '시리얼과 우유',
        'calories': 250,
        'carb': 40,
        'protein': 8,
        'fat': 5,
        'time': '08:00 AM'
      },
      {
        'type': '점심 식사',
        'food': '치킨 샐러드',
        'calories': 400,
        'carb': 20,
        'protein': 30,
        'fat': 15,
        'time': '12:30 PM'
      },
      {
        'type': '저녁 식사',
        'food': '스파게티',
        'calories': 600,
        'carb': 70,
        'protein': 20,
        'fat': 25,
        'time': '07:00 PM'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('식사 기록'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
        child: ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: Sizes.size8),
              child: Padding(
                padding: const EdgeInsets.all(Sizes.size12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal['type'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Gaps.v8,
                    Text(
                      "음식명: ${meal['food']}",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Gaps.v4,
                    Text(
                      "칼로리: ${meal['calories']} kcal",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Gaps.v4,
                    Text(
                      "탄수화물: ${meal['carb']}g / 단백질: ${meal['protein']}g / 지방: ${meal['fat']}g",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Gaps.v8,
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        "기록 시간: ${meal['time']}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
