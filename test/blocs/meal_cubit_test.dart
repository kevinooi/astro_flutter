import 'package:astro_flutter/repositories/repositories.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mocks/mocks.dart';

void main() {
  group('MealCubit test', () {
    late MealCubit mealCubit;
    MockMealRepository mockMealRepository;

    setUp(() {
      EquatableConfig.stringify = true;
      mockMealRepository = MockMealRepository();
      mealCubit = MealCubit(mockMealRepository);
    });

    test("expect [MealLoading] for meal cubit initial state", () {
      expect(mealCubit.state.runtimeType, MealLoading);
    });

    blocTest<MealCubit, MockMealState>(
      'emits [MealLoading, MealLoaded] states for'
      'successful meals load',
      build: () => mealCubit,
      act: (cubit) => cubit.getMealsByCategory(''),
      expect: () => [
        MealLoading(),
        const MealLoaded(meals: mockMeals),
      ],
    );

    blocTest<MealCubit, MockMealState>(
      'emits [MealError] state if contract is null',
      build: () => MealCubit(null),
      act: (cubit) => cubit.getMealsByCategory(''),
      expect: () => [
        MealError(),
      ],
    );

    tearDown(() {
      mealCubit.close();
    });
  });
}
