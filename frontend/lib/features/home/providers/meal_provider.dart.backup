import 'package:flutter_riverpod/flutter_riverpod.dart';

final mealsProvider =
    StateNotifierProvider<MealsNotifier, List<Map<String, dynamic>>>(
  (ref) => MealsNotifier(),
);

class MealsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  MealsNotifier() : super([]);

  // 새로운 기록을 추가하는 메서드
  void addMeal(Map<String, dynamic> meal) {
    state = [...state, meal];
  }

  // 중복 기록인지 확인하는 메서드
  bool isDuplicateRecord(Map<String, dynamic> newRecord) {
    return state.any((meal) => meal['time'] == newRecord['time']);
  }
}
