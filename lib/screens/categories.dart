import 'package:flutter/material.dart';
import 'package:meals_animation/data/dummy_data.dart';
import 'package:meals_animation/models/meal.dart';
import 'package:meals_animation/screens/meals.dart';
import 'package:meals_animation/widgets/category_grid_item.dart';

import '../models/category.dart';

// We convert to a statefulWidget so that the animations can work
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.availableMeals});

  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

// the with keyword allows you to use the features of another class which we need for explicit animations
class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // late keyword: this tells Dart that this in the end is a variable which will have a value
  // as soon as it's being used the first time, but not yet when the class is created.
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // vsync makes sure the animation executes every frame
    // this is used as its using the this value from teh SingleTicketProviderMixin
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 0,
        upperBound: 1);
    // This starts the animation. This only runs if the screen is removed from the stack, not returned to.
    //  This is because initstate is only run when the widget is created
    _animationController.forward();
  }

  // Dont forget to dispose your controller
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: [
            ...widget.availableMeals
                .where((element) => element.categories.contains(category.id))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The extra child parameter here to set any widgets that maybe should be output
    // as part of the animated content, but that should not be animated themselves.
    // And this would allow you to improve the performance of an animation by making
    // sure that not all the items that are part of the animated item are rebuilt and
    // reevaluated as long as the animation is running.
    return AnimatedBuilder(
        animation: _animationController,
        child: GridView(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            children: [
              ...availableCategories.map((e) => CategoryGridItem(
                    category: e,
                    onSelectCategory: () {
                      _selectCategory(context, e);
                    },
                  ))
            ]),
        // An offset for position is amount of offset of an element from the actual position it would normally take.

// .drive allows us to translate from 0 and 1 to two Offset values
        builder: (context, child) => SlideTransition(
              // Tween is an animatable widget
              position: Tween(
                // x axis start is 0 and y axis is 30% down
                begin: const Offset(0, 0.3),
                // x axis doesnt change and y axis moves up 30%
                end: const Offset(0, 0),
                // This allows us to control how the animation between begin and end operates
              ).animate(CurvedAnimation(
                  parent: _animationController, curve: Curves.easeInOut)),

              child: child,
            )

        // Example using Padding but we can use Slide transition instead
        // Padding(
        //     padding: EdgeInsets.only(
        //       // Here we add a dynamic value based on the controller. The value of
        //       //the animation controller will increase from 0 to 1 over 300 milliseconds
        //       // therefore the padding will be adjusted for that
        //       top: 100 - _animationController.value * 100,
        //     ),
        //     child: child),
        );
  }
}
