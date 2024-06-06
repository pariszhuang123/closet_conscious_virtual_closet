import 'package:flutter/material.dart';

class UploadBasicFirstPage extends StatelessWidget {
  const UploadBasicFirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'What is the name of your item?',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'How much did the item cost?',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.category, size: 40),
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
