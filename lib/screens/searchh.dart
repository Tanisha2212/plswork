import 'package:flutter/material.dart';
import 'cooking.dart';  // Import the new interface

class Searchh extends StatelessWidget {
  const Searchh({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();  // Controller to capture input

    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 30,
        ),
        child: Stack(children: [
          TextField(
            controller: searchController,  // Use controller to capture input
            cursorColor: Colors.black12,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 20,
              ),
              prefixIcon: const Icon(
                Icons.search_outlined,
                color: Color.fromARGB(255, 46, 199, 44),
                size: 30,
              ),
              hintText: 'Search Recipes',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
            onSubmitted: (String query) {
              if (query.isNotEmpty) {
                // Navigate to the Cooking screen with the entered query
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CookingPage(recipeName: query, query: '',),  // Pass recipe name to CookingScreen
                  ),
                );
              }
            },
          ),
          Positioned(
              bottom: 6,
              right: 12,
              child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.lightGreenAccent,
                  ),
                  child: const Icon(
                    Icons.mic_outlined,
                    color: Colors.white,
                    size: 25,
                  ))),
        ]));
  }
}
