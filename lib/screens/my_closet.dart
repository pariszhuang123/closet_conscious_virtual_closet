import 'package:flutter/material.dart';

class MyClosetPage extends StatelessWidget {
  const MyClosetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Closet'),
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
                  child: const Column(
                    children: [
                      Icon(Icons.upload_file),
                      Text('Upload'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Column(
                    children: [
                      Icon(Icons.filter_list),
                      Text('Filter'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Column(
                    children: [
                      Icon(Icons.add_box),
                      Text('Add Closet'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.favorite),
                Icon(Icons.shield),
                Icon(Icons.local_florist),
                Icon(Icons.notifications),
                Icon(Icons.swap_horiz),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset('assets/item_$index.png'),
                        ),
                        Text('Item $index'),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Closet Upload Complete'),
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
}
