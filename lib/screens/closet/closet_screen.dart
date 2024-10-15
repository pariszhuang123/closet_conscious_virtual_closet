import 'package:closet_conscious/core/theme/my_closet_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Ensure flutter_bloc is imported

import '../../core/widgets/feedback/custom_snack_bar.dart';
import '../../core/utilities/routes.dart';
import '../../core/utilities/logger.dart';
import '../../item_management/core/data/models/closet_item_minimal.dart';
import '../../item_management/view_items/presentation/widgets/item_grid.dart';
import '../../item_management/core/data/services/item_fetch_service.dart';
import '../../item_management/streak_item/presentation/bloc/upload_item_streak_bloc.dart'; // Import the bloc here
import '../../item_management/core/presentation/bloc/navigate_item_bloc.dart';
import '../../item_management/view_items/presentation/widgets/my_closet_container.dart';
import '../../core/data/type_data.dart';
import '../../generated/l10n.dart';
import '../../core/widgets/bottom_sheet/premium_bottom_sheet/filter_premium_bottom_sheet.dart';
import '../../core/widgets/bottom_sheet/premium_bottom_sheet/multi_closet_premium_bottom_sheet.dart';
import '../../core/widgets/bottom_sheet/premium_bottom_sheet/arrange_premium_bottom_sheet.dart';
import '../../item_management/upload_item/presentation/widgets/upload_confirmation_bottom_sheet.dart';
import '../app_drawer.dart';
import '../../core/screens/achievement_completed_screen.dart';
import '../../core/theme/ui_constant.dart';
import '../../core/widgets/button/themed_elevated_button.dart';
import '../../core/widgets/progress_indicator/closet_progress_indicator.dart';

class MyClosetScreen extends StatefulWidget {
  final ThemeData myClosetTheme;

  const MyClosetScreen({super.key, required this.myClosetTheme});

  @override
  MyClosetScreenState createState() => MyClosetScreenState();
}

class MyClosetScreenState extends State<MyClosetScreen> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final List<ClosetItemMinimal> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final CustomLogger logger = CustomLogger('MyClosetPage');

  // Create an instance of ItemFetchService
  final ItemFetchService _itemFetchService = ItemFetchService();

  static const int _batchSize = 9;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _triggerItemUploadAchievement();
    _triggerItemPicEditedAchievement();
    _triggerItemGiftedAchievement();
    _triggerItemSoldAchievement();
    _triggerItemSwapAchievement();
    context.read<UploadStreakBloc>().add(
        CheckUploadStatus()); // Ensure this is within the correct context
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && _hasMore &&
          !_isLoading) {
        _fetchItems();
      }
    });
  }

  Future<void> _fetchItems() async {
    if (_isLoading) return;
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final items = await _itemFetchService.fetchItems(
          _currentPage, _batchSize);
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

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacementNamed(context, '/create_outfit');
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _triggerItemUploadAchievement() {
    logger.i('Checking if Item Upload Milestone is successful');
    context.read<NavigateItemBloc>().add(const FetchFirstItemUploadedAchievementEvent());
  }

  void _triggerItemPicEditedAchievement() {
    logger.i('Checking if Item Pic Edited Milestone is successful');
    context.read<NavigateItemBloc>().add(const FetchFirstItemPicEditedAchievementEvent());
  }

  void _triggerItemGiftedAchievement() {
    logger.i('Checking if Item Gifted Milestone is successful');
    context.read<NavigateItemBloc>().add(const FetchFirstItemGiftedAchievementEvent());
  }

  void _triggerItemSoldAchievement() {
    logger.i('Checking if Item Sold Milestone is successful');
    context.read<NavigateItemBloc>().add(const FetchFirstItemSoldAchievementEvent());
  }

  void _triggerItemSwapAchievement() {
    logger.i('Checking if Item Pic Edited Milestone is successful');
    context.read<NavigateItemBloc>().add(const FetchFirstItemSwapAchievementEvent());
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
  }

  @override
  Widget build(BuildContext context) {
    // Getting the data from TypeDataList for assets and translations
    final itemUploadData = TypeDataList.itemUploaded(context);
    final uploadData = TypeDataList.upload(context);
    final filterData = TypeDataList.filter(context);
    final addClosetData = TypeDataList.addCloset(context);
    final arrangeData = TypeDataList.arrange(context);
    final currentStreakData = TypeDataList.currentStreak(context);
    final highestStreakData = TypeDataList.highestStreak(context);
    final costOfNewItemsData = TypeDataList.costOfNewItems(context);
    final numberOfNewItemsData = TypeDataList.numberOfNewItems(context);

    return MultiBlocListener(
        listeners: [
          BlocListener<NavigateItemBloc, NavigateItemState>(
            listener: (context, state) {
              if (state is FetchFirstItemUploadedMilestoneSuccessState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Theme(
                      data: myClosetTheme, // Apply the relevant theme
                      child: AchievementScreen(
                        achievementKey: state.achievementName,
                        achievementUrl: state.badgeUrl, // Pass the badge URL
                        nextRoute: AppRoutes.myCloset, // Define the next route if needed
                      ),
                    ),
                  ),
                );
              }
              if (state is FetchFirstItemGiftedMilestoneSuccessState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Theme(
                      data: myClosetTheme, // Apply the relevant theme
                      child: AchievementScreen(
                        achievementKey: state.achievementName,
                        achievementUrl: state.badgeUrl, // Pass the badge URL
                        nextRoute: AppRoutes.myCloset, // Define the next route if needed
                      ),
                    ),
                  ),
                );
              }
              if (state is FetchFirstItemSoldMilestoneSuccessState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Theme(
                      data: myClosetTheme, // Apply the relevant theme
                      child: AchievementScreen(
                        achievementKey: state.achievementName,
                        achievementUrl: state.badgeUrl, // Pass the badge URL
                        nextRoute: AppRoutes.myCloset, // Define the next route if needed
                      ),
                    ),
                  ),
                );
              }
              if (state is FetchFirstItemSwapMilestoneSuccessState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Theme(
                      data: myClosetTheme, // Apply the relevant theme
                      child: AchievementScreen(
                        achievementKey: state.achievementName,
                        achievementUrl: state.badgeUrl, // Pass the badge URL
                        nextRoute: AppRoutes.myCloset, // Define the next route if needed
                      ),
                    ),
                  ),
                );
              }
              if (state is FetchFirstItemPicEditedMilestoneSuccessState) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Theme(
                      data: myClosetTheme, // Apply the relevant theme
                      child: AchievementScreen(
                        achievementKey: state.achievementName,
                        achievementUrl: state.badgeUrl, // Pass the badge URL
                        nextRoute: AppRoutes.myCloset, // Define the next route if needed
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          BlocListener<UploadStreakBloc, UploadStreakState>(
            listener: (context, state) {
              if (state is UploadStreakSuccess && state.apparelCount == 0) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final snackBar = CustomSnackbar(
                    message: S.of(context).clickUploadItemInCloset,
                    theme: Theme.of(context),
                  );
                  snackBar.show(context); // Call show separately, don't treat it like a value
                });
              }
            },
          ),
        ],
        child: BlocBuilder<UploadStreakBloc, UploadStreakState>(
      builder: (context, state) {
        if (state is UploadStreakLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UploadStreakSuccess) {
          final bool isUploadCompleted = state.isUploadCompleted;
          final apparelCount = state.apparelCount;
          final currentStreakCount = state.currentStreakCount;
          final highestStreakCount = state.highestStreakCount;
          final newItemsCost = state.newItemsCost;
          final newItemsCount = state.newItemsCount;


          return PopScope(
            canPop: false, // Disable back navigation
            child: Theme(
              data: widget.myClosetTheme,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(appBarHeight),
                  child: AppBar(
                    title: Text(S
                        .of(context)
                        .myClosetTitle,
                        style: widget.myClosetTheme.textTheme.titleMedium),
                    automaticallyImplyLeading: true, // Ensure no back button
                    backgroundColor: widget.myClosetTheme.appBarTheme
                        .backgroundColor,
                  ),
                ),
                drawer: AppDrawer(isFromMyCloset: true),
                // Include the AppDrawer here
                backgroundColor: widget.myClosetTheme.colorScheme.surface,
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      MyClosetContainer(
                        theme: widget.myClosetTheme,
                        apparelCount: isUploadCompleted ? apparelCount : apparelCount,
                        // Show only when not uploaded
                        uploadData: uploadData,
                        // Passing translation and SVG asset data
                        filterData: filterData,
                        addClosetData: addClosetData,
                        arrangeData: arrangeData,
                        itemUploadData: itemUploadData,
                        currentStreakData: isUploadCompleted
                            ? currentStreakData
                            : null,
                        // Only show streak data when uploaded
                        highestStreakData: isUploadCompleted
                            ? highestStreakData
                            : null,
                        costOfNewItemsData: isUploadCompleted
                            ? costOfNewItemsData
                            : null,
                        numberOfNewItemsData: isUploadCompleted
                            ? numberOfNewItemsData
                            : null,
                        currentStreakCount: currentStreakCount,
                        // Fix: Passing the streak count
                        highestStreakCount: highestStreakCount,
                        // Fix: Passing the highest streak count
                        newItemsCost: newItemsCost,
                        // Fix: Passing the new items cost
                        newItemsCount: newItemsCount,
                        // Fix: Passing the new items count
                        isUploadCompleted: isUploadCompleted,
                        // Fix: Passing the upload completion status
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
                      if (!isUploadCompleted)
                        ThemedElevatedButton(
                          onPressed: _onUploadCompletedButtonPressed,
                          text: S
                              .of(context)
                              .closetUploadComplete, // Pass the localized text
                        ),
                    ],
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.dry_cleaning_outlined),
                      label: S
                          .of(context)
                          .closetLabel,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.wc_outlined),
                      label: S
                          .of(context)
                          .outfitLabel,
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: widget.myClosetTheme
                      .bottomNavigationBarTheme.selectedItemColor,
                  backgroundColor: widget.myClosetTheme.bottomNavigationBarTheme
                      .backgroundColor,
                  onTap: _onItemTapped,
                ),
              ),
            ),
          );
        }

        return const Center(child: ClosetProgressIndicator());
      },
        )
    );

  }
}