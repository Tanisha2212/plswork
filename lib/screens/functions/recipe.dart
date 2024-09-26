import 'package:flutter/material.dart';
import 'package:plswork/screens/functions/recipe_service.dart'; // Import the RecipeService

class Recipe extends StatefulWidget {
  const Recipe({super.key});

  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  final RecipeService _recipeService = RecipeService();
  List<dynamic> _recipes = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchSuggestedRecipes(); // Fetch suggested recipes on init
  }

  Future<void> _fetchSuggestedRecipes() async {
    final recipes = await _recipeService.suggestRecipes([]);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Suggestions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar with search icon inside
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onSubmitted: (value) {
                _searchRecipes(); // Perform search when user hits "enter"
              },
              decoration: InputDecoration(
                hintText: 'Search for a recipe',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchRecipes,
                ),
              ),
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
