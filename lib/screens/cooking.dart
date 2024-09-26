import 'package:flutter/material.dart';
import 'package:plswork/screens/Shooping.dart';

class CookingPage extends StatefulWidget {
  final String query;

  const CookingPage({Key? key, required this.query, required String recipeName}) : super(key: key);

  @override
  _CookingPageState createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  List<String> ingredients = []; // This will be fetched from API
  int servings = 1;

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  Future<void> _fetchIngredients() async {
    // Assume widget.query is something like "plan pav bhaji for 20 people"
    // Extract the number of servings and fetch the ingredients from the API
    servings = _extractServings(widget.query);
    ingredients = await _fetchRecipeIngredients(widget.query); // Replace with actual API call
    setState(() {});
  }

  int _extractServings(String query) {
    // A simple logic to extract the number of servings from the query
    final regex = RegExp(r'(\d+) people');
    final match = regex.firstMatch(query);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 1;
  }

  Future<List<String>> _fetchRecipeIngredients(String query) async {
    // Fetch ingredients based on query, you can call the Edamam API here
    // Scale the ingredients for the number of servings (20 in this case)
    return ['Tomatoes', 'Potatoes', 'Onions', 'Spices']; // Mock data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cooking Ingredients'),
      ),
      body: ingredients.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(ingredients[index]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the shopping page, where the ingredients can be placed in order
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ShoppingPage(ingredients: ingredients)),
          );
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
