import 'package:flutter/material.dart';
import '../screens/app_drawer.dart';

class CreateOutfitPage extends StatefulWidget {
  final ThemeData myOutfitTheme;
  final ThemeData myClosetTheme;

  const CreateOutfitPage({super.key, required this.myOutfitTheme, required this.myClosetTheme});


  @override
  CreateOutfitPageState createState() => CreateOutfitPageState();
}

class CreateOutfitPageState extends State<CreateOutfitPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/my_closet');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Disable back navigation
      child: Theme(
        data: widget.myOutfitTheme,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Create My Outfit'),
            automaticallyImplyLeading: true, // This removes the back button
          ),
          drawer: const AppDrawer(), // Include the AppDrawer here
          backgroundColor: widget.myOutfitTheme.colorScheme.surface,
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
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF255163), // Set selected item color
            onTap: _onItemTapped,
          ),
        ),
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

