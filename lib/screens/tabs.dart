import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_animation/screens/categories.dart';
import 'package:meals_animation/screens/filters.dart';
import 'package:meals_animation/screens/meals.dart';
import 'package:meals_animation/widgets/main_drawer.dart';
import '../providers/favourites_provider.dart';
import '../providers/filters_provider.dart';
import '../providers/meals_provider.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

// ConsumerStatefulWidget for StatefulWidget used ConsumerWidget for stateless.
// This allows us to interact with the Provider
class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});
  @override
  // Add ConsumerState type here
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

// You also need to add ConsumerState here
class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

// We are removing the async await as we are no longer getting a result back from FiltersScreen. We are now managing in the Provider.
  void _setScreen(String identifier) {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (context) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // We setup a new provider here that returns the list of available meals based on filters
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favouriteMeals = ref.watch(favouritesProvider);
      activePage = MealsScreen(meals: favouriteMeals);
      activePageTitle = 'Your favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
    );
  }
}
