import 'package:flutter/material.dart';
import '../core/utilities/routes.dart';
import '../core/utilities/logger.dart';
import '../item_management/core/data/models/closet_item_minimal.dart';
import '../item_management/view_items/widget/item_grid.dart';
import '../item_management/core/data/services/item_service.dart';

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
  final List<ClosetItemMinimal> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final CustomLogger logger = CustomLogger('MyClosetPage');

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
      final items = await fetchItems(_currentPage, _batchSize);
      setState(() {
        _items.addAll(items);
        _hasMore = items.length == _batchSize;
        if (_hasMore) {
          _currentPage++;
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
              Expanded(
                child: ItemGrid(
                  items: _items,
                  scrollController: _scrollController,
                  myClosetTheme: widget.myClosetTheme,
                  logger: logger,
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

