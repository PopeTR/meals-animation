import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_animation/models/meal.dart';
import 'package:meals_animation/providers/favourites_provider.dart';

// Changed to ConsumerWidget
class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({super.key, required this.meal});
  final Meal meal;

  @override
  // If you have a stateless class, you need to pass a second parameter ref.
  // We dont have a general ref property in stateless
  Widget build(BuildContext context, WidgetRef ref) {
    final favourites = ref.watch(favouritesProvider);
    final isFavourite = favourites.contains(meal);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // we read only in a function like onPressed
              // notifier gives us access to the notifier class we set up
              // when read has returned the results we can then use the toggle method in the class
              final wasAdded = ref
                  .read(favouritesProvider.notifier)
                  .toggleMealFavouriteStatus(meal);
              // This came from our Snackbar method in tabs which we can now put more accurately on the Meal Details page.
              // The message we display can be determined by the return of the toggleMealFavourite, so we can adjust the return to be a boolean
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      wasAdded ? 'Meal Added as favourite' : 'Meal removed')));
            },
            // AnimatedSwitcher is an implicit animation widget that allows you to move from one icon to another
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  // You can use the built in animation features (0 to 1) or you can set yourself a Tween
                  // We explicitly tell Tween the values we are giving it because we are using 0.8 and 1 not 1.0
                  turns: Tween<double>(begin: 0.8, end: 1).animate(animation),
                  child: child,
                );
              },
              // We must add a key because the animation picks up that the icon data is different even though the same widget
              child: Icon(isFavourite ? Icons.star : Icons.star_border,
                  key: ValueKey(isFavourite)),
            ),
          )
        ],
        title: Text(meal.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // This links the image on the meals screen and animates the image to move from one screen to another
            Hero(
              tag: meal.id,
              child: Image.network(
                meal.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            ...meal.ingredients.map(
              (e) => Text(
                e,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            ...meal.steps.map(
              (e) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  e,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
