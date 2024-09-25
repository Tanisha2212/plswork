import 'package:flutter/material.dart';
import 'package:plswork/screens/functions/recipe_service.dart';
import 'recipe_service.dart'; // Import the RecipeService

class Recipe extends StatefulWidget {
  const Recipe({super.key});

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  final RecipeService _recipeService = RecipeService();
  List<dynamic> _recipes = [];
  String _searchQuery = '';

  // Inventory list of ingredients
  List<String> inventory = ['tomato', 'cheese', 'basil'];
  // Track selected ingredients
  List<String> selectedIngredients = [];

  @override
  void initState() {
    super.initState();
    _fetchSuggestedRecipes(); // Fetch suggested recipes on init
  }

  Future<void> _fetchSuggestedRecipes() async {
    final recipes = await _recipeService.suggestRecipes(selectedIngredients);
    setState(() {
      _recipes = recipes;
    });
  }

  void _searchRecipes() async {
    if (_searchQuery.isNotEmpty) {
      final recipes = await _recipeService.searchRecipes(_searchQuery);
      setState(() {
        _recipes = recipes;
      });
    }
  }

  // Fetch recipes based on selected ingredients
  Future<void> _fetchRecipesBySelectedIngredients() async {
    if (selectedIngredients.isNotEmpty) {
      final recipes = await _recipeService.suggestRecipes(selectedIngredients);
      setState(() {
        _recipes = recipes;
      });
    } else {
      // Optional: Clear recipes if no ingredients are selected
      setState(() {
        _recipes = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Suggestions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _searchRecipes,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search for a recipe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Inventory List with Checkboxes
            Column(
              children: inventory.map((ingredient) {
                return CheckboxListTile(
                  title: Text(ingredient),
                  value: selectedIngredients.contains(ingredient),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedIngredients.add(ingredient);
                      } else {
                        selectedIngredients.remove(ingredient);
                      }
                    });
                    _fetchRecipesBySelectedIngredients(); // Fetch recipes on change
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(_recipes[index]['recipe']['label']),
                      subtitle: Text(
                        _recipes[index]['recipe']['ingredientLines'].join(', '),
                      ),
                      trailing: Image.network(
                        _recipes[index]['recipe']['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        // Handle recipe tap if needed
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
