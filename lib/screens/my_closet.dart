import 'package:flutter/material.dart';
import '../core/utilities/routes.dart';

class MyClosetPage extends StatefulWidget {
  final ThemeData myClosetTheme;
  final ThemeData myOutfitTheme;

  const MyClosetPage({super.key, required this.myClosetTheme, required this.myOutfitTheme});

  @override
  MyClosetPageState createState() => MyClosetPageState();
}

class MyClosetPageState extends State<MyClosetPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/create_outfit');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onUploadButtonPressed() {
    Navigator.pushReplacementNamed(context, AppRoutes.uploadItem);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: widget.myClosetTheme,
        child: Scaffold(
      appBar: AppBar(
        title: const Text('My Closet'),
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _onUploadButtonPressed,
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
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF366d59), // Set selected item color
        onTap: _onItemTapped,
      ),
    ));
  }
}
