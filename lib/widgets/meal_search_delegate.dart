import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meal_details.dart';

class MealSearchDelegate extends SearchDelegate {
  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavorite;

  MealSearchDelegate({
    required this.meals,
    required this.onToggleFavorite,
  });
  
  ///Clear search query
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  ///Close search
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  ///Show result from query
  @override
  Widget buildResults(BuildContext context) {
    final results = meals.where((meal) {
      return meal.title.toLowerCase().contains(query.toLowerCase()) ||
          meal.ingredients.any(
              (ingredient) => ingredient.toLowerCase().contains(query.toLowerCase()));
    }).toList();

    return _buildMealList(context, results);
  }

  ///Show suggestions while typing
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = meals.where((meal) {
      return meal.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildMealList(context, suggestions);
  }

  Widget _buildMealList(BuildContext context, List<Meal> meals) {
    if (meals.isEmpty) {
      return Center(
        child: Text(
          'No meals found.',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      );
    }

    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (ctx, index) {
        final meal = meals[index];
        return ListTile(
          leading: Image.network(
            meal.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(
            meal.title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => MealDetailsScreen(
                  meal: meal,
                  onToggleFavorite: onToggleFavorite,
                ),
              ),
            );
          },
        );
      },
    );
  }
}