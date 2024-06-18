import 'package:flutter/material.dart';
import '../core/utilities/routes.dart';
import 'view_my_closet.dart';
import '../core/utilities/logger.dart'; // Import the CustomLogger

class MyClosetPage extends StatefulWidget {
  final ThemeData myClosetTheme;
  final ThemeData myOutfitTheme;

  const MyClosetPage({super.key, required this.myClosetTheme, required this.myOutfitTheme});

  @override
  MyClosetPageState createState() => MyClosetPageState();
}

class MyClosetPageState extends State<MyClosetPage> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final List<Item> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final CustomLogger logger = CustomLogger('MyClosetPage'); // Initialize CustomLogger

  static const int _batchSize = 12;

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
  void initState() {
    super.initState();
    _fetchItems();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore && !_isLoading) {
        _fetchItems();
      }
    });
  }

  Future<void> _fetchItems() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final items = await fetchItems(_currentPage, _batchSize); // Pass the current page and batch size
      setState(() {
        _items.addAll(items);
        _hasMore = items.length == _batchSize;
        if (_hasMore) {
          _currentPage++; // Increment the page number if there are more items to fetch
        }
      });
      logger.i('Items fetched successfully');
    } catch (e) {
      logger.e('Error fetching items: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.myClosetTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Closet'),
          automaticallyImplyLeading: false,
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
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(item.imageUrl, fit: BoxFit.contain),
                          ),
                          const SizedBox(height: 8.0),
                          Text(item.name, style: const TextStyle(fontSize: 16.0)),
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
      ),
    );
  }
}
