import 'dart:convert';

import 'package:astro_flutter/config/extensions.dart';
import 'package:astro_flutter/model/meal_model.dart';
import 'package:astro_flutter/repositories/meals/base_meal.dart';
import 'package:http/http.dart' as http;

class MealRepository extends BaseMealRepository {
  http.Client client = http.Client();
  MealRepository();

  @override
  Future<List<Meal>> getMealsByCategory(String strCategory) async {
    try {
      final response = await client.get(
        Uri.parse(
            'https://www.themealdb.com/api/json/v1/1/search.php?s=$strCategory'),
      );
      logI('response', response);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final castList = data['meals'] as List<dynamic>?;

        if (castList != null) {
          return castList.map((meal) {
            return Meal.fromJson(meal);
          }).toList();
        }
      }
      return [];
    } catch (e, stackTrace) {
      logE('meals', e.toString(), stackTrace);
      throw Exception('error fetching meals: $e $stackTrace');
    }
  }

  @override
  Future<Meal?> getMealById(String idMeal) async {
    try {
      final response = await client.get(
        Uri.parse(
            'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idMeal'),
      );
      logI('meal response', response);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final castList = data['meals'] as List<dynamic>?;

        if (castList != null) {
          return Meal.fromJson(castList.first);
        }
      }
      return null;
    } catch (e, stackTrace) {
      logE('Meal', e.toString(), stackTrace);
      throw Exception('error fetching meal by id: $e $stackTrace');
    }
  }
}
