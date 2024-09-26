import 'package:flutter/material.dart';
import 'package:plswork/screens/functions/inventory.dart';

import 'package:plswork/screens/functions/nearby_shop.dart';
import 'package:plswork/screens/functions/recipe.dart';
import 'package:plswork/screens/functions/doubts_ai.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) {
          final categories = [
            {
              'name': 'Inventory Tracking',
              'icon': Icons.inventory,
              'page': Inventory()
            },
            {
              'name': 'Recipe Suggestion',
              'icon': Icons.receipt,
              'page': Recipe()
            },
            {'name': 'Shop Nearby', 'icon': Icons.store, 'page': NearbyShop()},
            {'name': 'Ask AI', 'icon': Icons.list_alt, 'page': DoubtsAi},
          ];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => categories[index]['page'] as Widget),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    categories[index]['icon'] as IconData,
                    size: 40,
                    color: Colors.green[800],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    categories[index]['name'] as String,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
