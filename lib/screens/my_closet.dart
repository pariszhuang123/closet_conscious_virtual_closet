import 'package:flutter/material.dart';
import '../core/utilities/routes.dart';
import '../core/utilities/logger.dart';
import '../item_management/core/data/models/closet_item_minimal.dart';
import '../item_management/view_items/widget/item_grid.dart';
import '../item_management/core/data/services/item_service.dart';
import '../core/widgets/number_type_button.dart';
import '../core/widgets/text_type_button.dart';
import '../item_management/core/data/type_data.dart';
import '../generated/l10n.dart';

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
  int apparelCount = 0;
  final CustomLogger logger = CustomLogger('MyClosetPage');

  static const int _batchSize = 6;

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
    _fetchApparelCount();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore && !_isLoading) {
        _fetchItems();
      }
    });
  }

  Future<void> _fetchApparelCount() async {
    try {
      final count = await fetchApparelCount();
      setState(() {
        apparelCount = count;
      });
    } catch (e) {
      logger.e('Error fetching apparel count: $e');
    }
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
    final uploadList = TypeDataList.upload(context);
    final filterList = TypeDataList.filter(context);
    final addClosetList = TypeDataList.addCloset(context);
    final itemUploadedList = TypeDataList.itemUploaded(context);

    return PopScope(
      canPop: false, // Disable back navigation
      child: Theme(
        data: widget.myClosetTheme,
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).myClosetTitle),
            automaticallyImplyLeading: false, // Ensure no back button
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12), // Increase the value for more rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextTypeButton(
                                label: uploadList[0].getName(context),
                                selectedLabel: '',
                                onPressed: _onUploadButtonPressed,
                                imageUrl: uploadList[0].imageUrl,
                              ),
                              TextTypeButton(
                                label: filterList[0].getName(context),
                                selectedLabel: '',
                                onPressed: () {},
                                imageUrl: filterList[0].imageUrl,
                              ),
                              TextTypeButton(
                                label: addClosetList[0].getName(context),
                                selectedLabel: '',
                                onPressed: () {},
                                imageUrl: addClosetList[0].imageUrl,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12), // Increase the value for more rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: NumberTypeButton(
                        count: apparelCount,
                        imageUrl: itemUploadedList[0].imageUrl,
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
                  child: Text(S.of(context).closetUploadComplete),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.checkroom),
                label: S.of(context).closetLabel,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.apartment),
                label: S.of(context).outfitLabel,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: const Color(0xFF366d59), // Set selected item color
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
