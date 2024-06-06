import 'package:flutter/material.dart';

class UploadReviewThirdPage extends StatelessWidget {

  const UploadReviewThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Colour Variations', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(color: Colors.black, width: 40, height: 40),
                Container(color: Colors.grey, width: 40, height: 40),
                Container(color: Colors.white, width: 40, height: 40),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Clothing Type', style: TextStyle(fontSize: 18)),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.category, size: 40),  // Change to appropriate icons
                Icon(Icons.shopping_bag, size: 40),
                Icon(Icons.emoji_objects, size: 40),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Clothing Layer', style: TextStyle(fontSize: 18)),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.category, size: 40),  // Change to appropriate icons
                Icon(Icons.shopping_bag, size: 40),
                Icon(Icons.emoji_objects, size: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
