import 'package:flutter/material.dart';

class CookingScreen extends StatelessWidget {
  final String recipeName;

  // Constructor to accept the recipe name from the Search screen
  CookingScreen({required this.recipeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Recipe for $recipeName'), // Display the recipe name in the title
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Here is the recipe for $recipeName:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Placeholder for recipe details - you can add API data fetching here
            Text(
              'Step 1: Gather your ingredients...',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Step 2: Follow these instructions...',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // You can dynamically display more information here based on the recipe
            Text(
              'Step 3: Enjoy your delicious $recipeName!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
