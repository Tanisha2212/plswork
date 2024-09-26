import 'package:flutter/material.dart';
import 'recipe_service.dart'; // Import the recipe service to fetch recipes
import 'inventory.dart'; // Import the inventory to access inventory items

class RecipeSuggestionsPage extends StatefulWidget {
  @override
  _RecipeSuggestionsPageState createState() => _RecipeSuggestionsPageState();
}

class _RecipeSuggestionsPageState extends State<RecipeSuggestionsPage> {
  List<String> _recipes = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> _fetchRecipesBasedOnInventory() async {
    List<Map<String, String>> inventoryList = Inventory.getInventoryItems();

    // Extract item names from inventoryList
    List<String> inventoryItems = inventoryList.map((item) => item['name']!).toList();

    if (inventoryItems.isNotEmpty) {
      final _recipeService = RecipeService(); // Instantiate the RecipeService
      final recipes = await _recipeService.suggestRecipes(inventoryItems);
      setState(() {
        _recipes = recipes; // Update the state with the fetched recipes
      });
    } else {
      // Show message if inventory is empty
      _showEmptyInventoryDialog();
    }
  }

  Future<void> _searchRecipes() async {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      final _recipeService = RecipeService(); // Instantiate the RecipeService
      final recipes = await _recipeService.searchRecipes(query);
      setState(() {
        _recipes = recipes; // Update the state with the fetched recipes
      });
    }
  }

  void _showEmptyInventoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No ingredients in inventory'),
          content: Text('Please add ingredients to the inventory.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Suggestions'),
      ),
      body: Column(
        children: [
          // Search bar for querying recipes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Recipes',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchRecipes, // Call searchRecipes when button is pressed
                ),
              ),
            ),
          ),
          // Button to suggest recipes based on inventory
          ElevatedButton(
            onPressed: _fetchRecipesBasedOnInventory,
            child: Text('Suggest Recipes Based on Inventory'),
          ),
          // List view to display fetched recipes
          Expanded(
            child: ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_recipes[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
