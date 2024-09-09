import 'package:flutter/material.dart';

class NutritionBar extends StatelessWidget {
  final String label; // 영양소 이름
  final double intake; // 섭취량
  final double recommended; // 권장 섭취량
  final Gradient gradient; // 진행 바의 그라데이션 색상

  const NutritionBar({
    super.key,
    required this.label,
    required this.intake,
    required this.recommended,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = intake / recommended;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 라벨과 섭취/권장 텍스트를 한 줄로 배치
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontFamily: "myfonts",
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              // 섭취 / 권장 (비율%) 텍스트 표시
              Text(
                "${intake.toStringAsFixed(1)} / ${recommended.toStringAsFixed(1)} (${(percentage * 100).toStringAsFixed(1)}%)",
                style: const TextStyle(
                  fontFamily: "myfonts",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 그라데이션이 적용된 바
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    width: double.infinity, // 전체 너비
                    height: 15, // 바 높이
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 202, 202, 202), // 배경 색상
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    width:
                        percentage * constraints.maxWidth, // 부모 위젯 너비에 비례하여 설정
                    height: 15, // 바 높이
                    decoration: BoxDecoration(
                      gradient: gradient, // 그라데이션 적용
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
