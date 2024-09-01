import 'package:flutter/material.dart';

class NutritionBar extends StatelessWidget {
  final String label;
  final double intake;
  final double recommended;
  final Color color;

  const NutritionBar({
    Key? key,
    required this.label,
    required this.intake,
    required this.recommended,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentage = intake / recommended;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 라벨과 퍼센트 텍스트를 한 줄로 배치
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "${(percentage * 100).toStringAsFixed(1)}%",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: percentage >= 1 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 모서리가 둥근 LinearProgressIndicator
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              color: color,
              minHeight: 20,
            ),
          ),
        ],
      ),
    );
  }
}
