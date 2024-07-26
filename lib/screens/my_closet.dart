import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/widgets/button/navigation_type_button.dart';
import '../core/utilities/routes.dart';
import '../core/utilities/logger.dart';
import '../item_management/core/data/models/closet_item_minimal.dart';
import '../item_management/view_items/widget/item_grid.dart';
import '../core/data/services/supabase/fetch_service.dart';
import '../core/widgets/button/number_type_button.dart';
import '../core/theme/themed_svg.dart';
import '../core/data/type_data.dart';
import '../generated/l10n.dart';
import '../core/widgets/bottom_sheet/filter_premium_bottom_sheet.dart';
import '../core/widgets/bottom_sheet/multi_closet_premium_bottom_sheet.dart';
import '../item_management/upload_item/widgets/upload_confirmation_bottom_sheet.dart';
import '../screens/app_drawer.dart';
import '../core/theme/ui_constant.dart';

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
  int currentStreakCount = 0;
  int highestStreakCount = 0;
  int newItemsCost = 0;
  int newItemsCount = 0;
  bool _isUploadCompleted = false; // Add this state variable
  final CustomLogger logger = CustomLogger('MyClosetPage');

  static const int _batchSize = 1;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _fetchApparelCount();
    _fetchCurrentStreakCount();
    _fetchHighestStreakCount();
    _fetchNewItemsCost();
    _fetchNewItemsCount();
    _checkUploadCompletedStatus(); // Check upload completed status on init
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

  Future<void> _fetchCurrentStreakCount() async {
    try {
      final count = await fetchCurrentStreakCount();
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
      final count = await fetchHighestStreakCount();
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
      final count = await fetchNewItemsCost();
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
      final count = await fetchNewItemsCount();
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

  Future<void> _checkUploadCompletedStatus() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final data = await Supabase.instance.client
          .from('user_achievements')
          .select('achievement_name')
          .eq('user_id', user.id)
          .eq('achievement_name', 'closet_uploaded');

      if (data.isNotEmpty) {
        setState(() {
          _isUploadCompleted = true;
        });
      }
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

  void _onMultiClosetButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const MultiClosetFeatureBottomSheet(isFromMyCloset: true);
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
                Container(
                  decoration: BoxDecoration(
                    color: widget.myClosetTheme.colorScheme.surface,
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
                            NavigationTypeButton(
                              label: uploadData.getName(context),
                              selectedLabel: '',
                              onPressed: _onUploadButtonPressed,
                              imagePath: uploadData.imagePath!,
                              isAsset: true,
                              isFromMyCloset: true,
                              buttonType: ButtonType.primary,
                            ),
                            NavigationTypeButton(
                              label: filterData.getName(context),
                              selectedLabel: '',
                              onPressed: _onFilterButtonPressed,
                              imagePath: filterData.imagePath ?? '', // Ensure non-nullable
                              isAsset: true,
                              isFromMyCloset: true,
                              buttonType: ButtonType.secondary,
                            ),
                            NavigationTypeButton(
                              label: addClosetData.getName(context),
                              selectedLabel: '',
                              onPressed: _onMultiClosetButtonPressed,
                              imagePath: addClosetData.imagePath ?? '', // Ensure non-nullable
                              isAsset: true,
                              isFromMyCloset: true,
                              buttonType: ButtonType.secondary,
                            ),
                          ],
                        ),
                        if (!_isUploadCompleted)
                          Tooltip(
                            message: itemUploadData.getName(context),
                            child: NumberTypeButton(
                              count: apparelCount,
                              imagePath: itemUploadData.imagePath ?? '', // Ensure non-nullable
                              isAsset: itemUploadData.isAsset,
                              isFromMyCloset: true,
                              isHorizontal: false,
                              buttonType: ButtonType.secondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _isUploadCompleted,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: widget.myClosetTheme.colorScheme.surface,
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Tooltip(
                            message: currentStreakData.getName(context),
                            child: NumberTypeButton(
                              count: currentStreakCount,
                              imagePath: currentStreakData.imagePath ?? '', // Ensure non-nullable
                              isAsset: currentStreakData.isAsset,
                              isFromMyCloset: true,
                              isHorizontal: true,
                              buttonType: ButtonType.secondary,
                            ),
                          ),
                          Tooltip(
                            message: highestStreakData.getName(context),
                            child: NumberTypeButton(
                              count: highestStreakCount,
                              imagePath: highestStreakData.imagePath ?? '', // Ensure non-nullable
                              isAsset: highestStreakData.isAsset,
                              isFromMyCloset: true,
                              isHorizontal: true,
                              buttonType: ButtonType.secondary,
                            ),
                          ),
                          Tooltip(
                            message: costOfNewItemsData.getName(context),
                            child: NumberTypeButton(
                              count: newItemsCost,
                              imagePath: costOfNewItemsData.imagePath ?? '', // Ensure non-nullable
                              isAsset: costOfNewItemsData.isAsset,
                              isFromMyCloset: true,
                              isHorizontal: true,
                              buttonType: ButtonType.secondary,
                            ),
                          ),
                          Tooltip(
                            message: numberOfNewItemsData.getName(context),
                            child: NumberTypeButton(
                              count: newItemsCount,
                              imagePath: numberOfNewItemsData.imagePath ?? '', // Ensure non-nullable
                              isAsset: numberOfNewItemsData.isAsset,
                              isFromMyCloset: true,
                              isHorizontal: true,
                              buttonType: ButtonType.secondary,
                            ),
                          ),
                        ],
                      ),
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
                icon: const Icon(Icons.checkroom),
                label: S.of(context).closetLabel,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.apartment),
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
