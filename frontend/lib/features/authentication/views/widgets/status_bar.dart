import 'package:flutter/material.dart';
import 'package:frontend/constants/sizes.dart';

class StatusBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StatusBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: Sizes.size12,
            decoration: BoxDecoration(
              color: index < currentStep
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        );
      }),
    );
  }
}
