import '../../model/meal_model.dart';

abstract class BaseMealRepository {
  Future<List<Meal>> getMealsByCategory(String strCategory) async => [];

  Future<Meal?> getMealById(String idMeal) async => await null;
}
