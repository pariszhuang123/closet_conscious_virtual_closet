import 'package:flutter/material.dart';

import '../../core/utilities/routes.dart';
import '../../core/utilities/logger.dart';
import '../../item_management/core/data/models/closet_item_minimal.dart';
import '../../item_management/view_items/presentation/widgets/item_grid.dart';
import '../../item_management/core/data/services/item_fetch_service.dart';
import '../../item_management/view_items/presentation/widgets/my_closet_container.dart';
import '../../core/data/type_data.dart';
import '../../generated/l10n.dart';
import '../../core/widgets/bottom_sheet/premium_bottom_sheet/filter_premium_bottom_sheet.dart';
import '../../core/widgets/bottom_sheet/premium_bottom_sheet/multi_closet_premium_bottom_sheet.dart';
import '../../core/widgets/bottom_sheet/premium_bottom_sheet/arrange_premium_bottom_sheet.dart';
import '../../item_management/upload_item/presentation/widgets/upload_confirmation_bottom_sheet.dart';
import '../app_drawer.dart';
import '../../core/theme/ui_constant.dart';

class MyClosetPage extends StatefulWidget {
  final ThemeData myClosetTheme;

  const MyClosetPage({super.key, required this.myClosetTheme});

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
  int currentStreakCount = 0;
  int highestStreakCount = 0;
  int newItemsCost = 0;
  int newItemsCount = 0;
  bool _isUploadCompleted = false; // Add this state variable
  final CustomLogger logger = CustomLogger('MyClosetPage');

  // Create an instance of ItemFetchService
  final ItemFetchService _itemFetchService = ItemFetchService();

  static const int _batchSize = 9;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _fetchApparelCount();
    _fetchCurrentStreakCount();
    _fetchHighestStreakCount();
    _fetchNewItemsCost();
    _fetchNewItemsCount();
    _checkUploadCompletedStatus();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore && !_isLoading) {
        _fetchItems();
      }
    });
  }

  Future<void> _fetchApparelCount() async {
    try {
      final count = await _itemFetchService.fetchApparelCount();
      if (mounted) {
        setState(() {
          apparelCount = count;
        });
      }
    } catch (e) {
      logger.e('Error fetching apparel count: $e');
    }
  }

  Future<void> _fetchCurrentStreakCount() async {
    try {
      final count = await _itemFetchService.fetchCurrentStreakCount();
      if (mounted) {
        setState(() {
          currentStreakCount = count;
        });
      }
    } catch (e) {
      logger.e('Error fetching current streak count: $e');
    }
  }

  Future<void> _fetchHighestStreakCount() async {
    try {
      final count = await _itemFetchService.fetchHighestStreakCount();
      if (mounted) {
        setState(() {
          highestStreakCount = count;
        });
      }
    } catch (e) {
      logger.e('Error fetching highest streak count: $e');
    }
  }

  Future<void> _fetchNewItemsCost() async {
    try {
      final count = await _itemFetchService.fetchNewItemsCost();
      if (mounted) {
        setState(() {
          newItemsCost = count;
        });
      }
    } catch (e) {
      logger.e('Error fetching new item cost: $e');
    }
  }

  Future<void> _fetchNewItemsCount() async {
    try {
      final count = await _itemFetchService.fetchNewItemsCount();
      if (mounted) {
        setState(() {
          newItemsCount = count;
        });
      }
    } catch (e) {
      logger.e('Error fetching new items count: $e');
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
      final items = await _itemFetchService.fetchItems(_currentPage, _batchSize);
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

  Future<void> _checkUploadCompletedStatus() async {
    final isUploaded = await _itemFetchService.checkClosetUploadStatus();
    if (isUploaded) {
      setState(() {
        _isUploadCompleted = true;
      });
    }
  }

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
    Navigator.pushReplacementNamed(context, AppRoutes.uploadItemPhoto);
  }

  void _onFilterButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const PremiumFilterBottomSheet(isFromMyCloset: true);
      },
    );
  }

  void _onMultiClosetButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const MultiClosetFeatureBottomSheet(isFromMyCloset: true);
      },
    );
  }

  void _onArrangeButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const ArrangeFeatureBottomSheet(isFromMyCloset: true);
      },
    );
  }

  void _onUploadCompletedButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const UploadConfirmationBottomSheet(isFromMyCloset: true);
      },
    );
    setState(() {
      _isUploadCompleted = true; // Update the state to hide the button
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemUploadData = TypeDataList.itemUploaded(context);
    final uploadData = TypeDataList.upload(context);
    final filterData = TypeDataList.filter(context);
    final addClosetData = TypeDataList.addCloset(context);
    final arrangeData = TypeDataList.arrange(context);
    final currentStreakData = TypeDataList.currentStreak(context);
    final highestStreakData = TypeDataList.highestStreak(context);
    final costOfNewItemsData = TypeDataList.costOfNewItems(context);
    final numberOfNewItemsData = TypeDataList.numberOfNewItems(context);

    return PopScope(
      canPop: false, // Disable back navigation
      child: Theme(
        data: widget.myClosetTheme,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(appBarHeight),
            child: AppBar(
              title: Text(S.of(context).myClosetTitle, style: widget.myClosetTheme.textTheme.titleMedium),
              automaticallyImplyLeading: true, // Ensure no back button
              backgroundColor: widget.myClosetTheme.appBarTheme.backgroundColor,
            ),
          ),
          drawer: AppDrawer(isFromMyCloset: true), // Include the AppDrawer here
          backgroundColor: widget.myClosetTheme.colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyClosetContainer(
                  theme: widget.myClosetTheme,
                  uploadData: uploadData,
                  filterData: filterData,
                  addClosetData: addClosetData,
                  arrangeData: arrangeData,
                  itemUploadData: itemUploadData,
                  currentStreakData: currentStreakData,
                  highestStreakData: highestStreakData,
                  costOfNewItemsData: costOfNewItemsData,
                  numberOfNewItemsData: numberOfNewItemsData,
                  apparelCount: apparelCount,
                  currentStreakCount: currentStreakCount,
                  highestStreakCount: highestStreakCount,
                  newItemsCost: newItemsCost,
                  newItemsCount: newItemsCount,
                  isUploadCompleted: _isUploadCompleted,
                  onUploadButtonPressed: _onUploadButtonPressed,
                  onFilterButtonPressed: _onFilterButtonPressed,
                  onMultiClosetButtonPressed: _onMultiClosetButtonPressed,
                  onArrangeButtonPressed: _onArrangeButtonPressed,
                ),
                Expanded(
                  child: ItemGrid(
                    items: _items,
                    scrollController: _scrollController,
                    myClosetTheme: widget.myClosetTheme,
                    logger: logger,
                  ),
                ),
                if (!_isUploadCompleted)
                  ElevatedButton(
                    onPressed: _onUploadCompletedButtonPressed,
                    style: widget.myClosetTheme.elevatedButtonTheme.style,
                    child: Text(S.of(context).closetUploadComplete, style: widget.myClosetTheme.textTheme.labelLarge),
                  ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.dry_cleaning_outlined),
                label: S.of(context).closetLabel,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.wc_outlined),
                label: S.of(context).outfitLabel,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: widget.myClosetTheme.bottomNavigationBarTheme.selectedItemColor,
            backgroundColor: widget.myClosetTheme.bottomNavigationBarTheme.backgroundColor,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
