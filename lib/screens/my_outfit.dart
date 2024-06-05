import 'package:flutter/material.dart';

class CreateOutfitPage extends StatelessWidget {
  const CreateOutfitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create My Outfit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Icon(Icons.view_comfy),
                      SizedBox(width: 5),
                      Text('View Closets'),
                    ],
                  ),
                ),
                const Row(
                  children: [
                    Column(
                      children: [
                        Icon(Icons.favorite),
                        Text('5'),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        Icon(Icons.local_florist),
                        Text('10'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildOutfitCategoryCard(context, 'Clothes', Icons.checkroom),
                  _buildOutfitCategoryCard(context, 'Accessories', Icons.local_mall),
                  _buildOutfitCategoryCard(context, 'Shoes', Icons.sports_kabaddi),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: 'Closet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Outfit',
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitCategoryCard(BuildContext context, String category, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(category),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            // Handle the addition of items to the category
          },
        ),
      ),
    );
  }
}
