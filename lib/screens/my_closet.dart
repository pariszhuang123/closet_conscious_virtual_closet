import 'package:flutter/material.dart';
import '../core/utilities/routes.dart';
import '../core/utilities/logger.dart';
import '../item_management/core/data/models/closet_item_minimal.dart';
import '../item_management/view_items/widget/item_grid.dart';
import '../item_management/core/data/services/item_service.dart';
import '../core/widgets/button/number_type_button.dart';
import '../core/widgets/button/text_type_button.dart';
import '../core/data/type_data.dart';
import '../generated/l10n.dart';
import '../core/widgets/filter_premium_bottom_sheet.dart';

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

  static const int _batchSize =  1;

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

  void _onFilterButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const PremiumFilterBottomSheet(isFromMyCloset: true);
      },
    );
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
      if (mounted) {
        setState(() {
          apparelCount = count;
        });
      }
    } catch (e) {
      logger.e('Error fetching apparel count: $e');
    }
  }

  Future<void> _fetchItems() async {
    if (_isLoading) return;
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final items = await fetchItems(_currentPage, _batchSize);
      if (mounted) {
        setState(() {
          _items.addAll(items);
          _hasMore = items.length == _batchSize;
          if (_hasMore) {
            _currentPage++;
          }
        });
        logger.i('Items fetched successfully');
      }
    } catch (e) {
      logger.e('Error fetching items: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
            title: Text(S.of(context).myClosetTitle, style: widget.myClosetTheme.textTheme.titleMedium),
            automaticallyImplyLeading: false, // Ensure no back button
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: widget.myClosetTheme.colorScheme.background,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: widget.myClosetTheme.shadowColor.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TextTypeButton(
                              label: uploadList[0].getName(context),
                              selectedLabel: '',
                              onPressed: _onUploadButtonPressed,
                              imageUrl: uploadList[0].imageUrl!,
                            ),
                            TextTypeButton(
                              label: filterList[0].getName(context),
                              selectedLabel: '',
                              onPressed: _onFilterButtonPressed,
                              imageUrl: filterList[0].imageUrl!,
                            ),
                            TextTypeButton(
                              label: addClosetList[0].getName(context),
                              selectedLabel: '',
                              onPressed: () {},
                              imageUrl: addClosetList[0].imageUrl!,
                            ),
                          ],
                        ),
                        Container(
                          width: 1.0,
                          height: 40.0,
                          color: widget.myClosetTheme.dividerColor,
                        ),
                        NumberTypeButton(
                          count: apparelCount,
                          imageUrl: itemUploadedList[0].imageUrl!,
                        ),
                      ],
                    ),
                  ),
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
                  child: Text(S.of(context).closetUploadComplete, style: widget.myClosetTheme.textTheme.labelLarge),
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
            selectedItemColor: widget.myClosetTheme.colorScheme.primary,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
