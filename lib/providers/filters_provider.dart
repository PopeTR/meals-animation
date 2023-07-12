import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_animation/providers/meals_provider.dart';

// Moving enum Filter here as this is where the all the meta management of filters and all the type definitions for filters basically happen.
enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  // super takes the initial state. So for filters provider, we need to have the state as all false
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegan: false,
          Filter.vegetarian: false,
        });

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    // Here we are creating a NEW Map, by copying all values across and updating the one in question to the required value.
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) {
  return FiltersNotifier();
});

// We want to create a provider which returns a list of filtered meals.
// This provider has mealsProvider and filtersProvider as a dependency. So we need to integrate them
// The ref provided here is the same ref as in widgets that allows us to read, watch objects

final filteredMealsProvider = Provider((ref) {
  // This watch will be re-triggered everytime the watch value changes
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    // Replaced old _selectedFilters returned from Future _setScreen with activeFilters from Provider
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
