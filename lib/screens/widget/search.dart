import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 30,
        ),
        child: Stack(children: [
          TextField(
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
              hintText: 'Search Recipies',
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.withOpacity(0.7),
              ),
            ),
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
                  )))
        ]));
  }
}
