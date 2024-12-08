import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/data/services/core_fetch_services.dart';
import '../../core/theme/my_closet_theme.dart';
import '../../core/widgets/feedback/custom_snack_bar.dart';
import '../../core/utilities/routes.dart';
import '../../core/utilities/logger.dart';
import '../../item_management/view_items/presentation/widgets/item_grid.dart';
import '../../item_management/view_items/presentation/bloc/view_items_bloc.dart'; // Import ViewItemsBloc
import '../../item_management/streak_item/presentation/bloc/upload_item_streak_bloc.dart';
import '../../item_management/core/presentation/bloc/navigate_item_bloc/navigate_item_bloc.dart';
import '../../item_management/view_items/presentation/widgets/my_closet_container.dart';
import '../../core/data/type_data.dart';
import '../../generated/l10n.dart';
import '../../core/widgets/bottom_sheet/premium_bottom_sheet/public_closet_premium_bottom_sheet.dart';
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
  final CustomLogger logger = CustomLogger('MyClosetPage');

  late Future<int> crossAxisCountFuture;

  @override
  void initState() {
    super.initState();
    // Dispatch initial item fetch event
    context.read<ViewItemsBloc>().add(FetchItemsEvent(0));
    crossAxisCountFuture = _getCrossAxisCount();
    _triggerItemUploadAchievement();
    _triggerItemPicEditedAchievement();
    _triggerItemGiftedAchievement();
    _triggerItemSoldAchievement();
    _triggerItemSwapAchievement();
    context.read<UploadStreakBloc>().add(CheckUploadStatus());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        final currentState = context
            .read<ViewItemsBloc>()
            .state;
        if (currentState is ItemsLoaded) {
          final currentPage = currentState.currentPage;
          context.read<ViewItemsBloc>().add(FetchItemsEvent(currentPage));
        }
      }
    });
  }

  Future<int> _getCrossAxisCount() async {
    final coreFetchService = CoreFetchService();
    return await coreFetchService.fetchCrossAxisCount();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.createOutfit);
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
    logger.i('Checking if Item Swap Milestone is successful');
    context.read<NavigateItemBloc>().add(const FetchFirstItemSwapAchievementEvent());
  }

  void _onUploadButtonPressed() {
    Navigator.pushReplacementNamed(context, AppRoutes.uploadItemPhoto);
  }

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    Navigator.of(context).pushNamed(
      AppRoutes.filter,
      arguments: {'isFromMyCloset': isFromMyCloset}, // Pass isFromMyCloset as an argument
    );
  }

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    Navigator.of(context).pushNamed(
      AppRoutes.customize,
      arguments: {'isFromMyCloset': isFromMyCloset}, // Pass isFromMyCloset as an argument
    );
  }

  void _onMultiClosetButtonPressed(BuildContext context, bool isFromMyCloset) {
    Navigator.of(context).pushNamed(
      AppRoutes.viewMultiCloset,
      arguments: {'isFromMyCloset': isFromMyCloset}, // Pass isFromMyCloset as an argument
    );
  }

  void _onPublicClosetButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const PublicClosetFeatureBottomSheet(isFromMyCloset: true);
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
    final itemUploadData = TypeDataList.itemUploaded(context);
    final uploadData = TypeDataList.upload(context);
    final filterData = TypeDataList.filter(context);
    final arrangeData = TypeDataList.arrange(context);
    final addClosetData = TypeDataList.addCloset(context);
    final publicClosetData = TypeDataList.publicCloset(context);
    final currentStreakData = TypeDataList.currentStreak(context);
    final highestStreakData = TypeDataList.highestStreak(context);
    final costOfNewItemsData = TypeDataList.costOfNewItems(context);
    final numberOfNewItemsData = TypeDataList.numberOfNewItems(context);

    return FutureBuilder<int>(
        future: crossAxisCountFuture,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        logger.e("Error fetching crossAxisCount: ${snapshot.error}");
        return Center(child: Text(S.of(context).failedToLoadItems));
      } else {
        final crossAxisCount = snapshot.data ?? 3;

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
                snackBar.show(context);
              });
            }
          },
        ),
      ],
      child: BlocBuilder<UploadStreakBloc, UploadStreakState>(
        builder: (context, uploadStreakState) {
          if (uploadStreakState is UploadStreakLoading) {
            return const Center(child: ClosetProgressIndicator());
          }

          if (uploadStreakState is UploadStreakSuccess) {
            final bool isUploadCompleted = uploadStreakState.isUploadCompleted;
            final apparelCount = uploadStreakState.apparelCount;
            final currentStreakCount = uploadStreakState.currentStreakCount;
            final highestStreakCount = uploadStreakState.highestStreakCount;
            final newItemsCost = uploadStreakState.newItemsCost;
            final newItemsCount = uploadStreakState.newItemsCount;

            return BlocBuilder<ViewItemsBloc, ViewItemsState>(
              builder: (context, viewItemsState) {
                if (viewItemsState is ItemsLoading) {
                  return const Center(child: ClosetProgressIndicator());
                } else if (viewItemsState is ItemsLoaded) {
                  return PopScope(
                    canPop: false,
                    child: Theme(
                      data: widget.myClosetTheme,
                      child: Scaffold(
                        appBar: PreferredSize(
                          preferredSize: const Size.fromHeight(appBarHeight),
                          child: AppBar(
                            title: Text(S.of(context).myClosetTitle,
                                style: widget.myClosetTheme.textTheme.titleMedium),
                            automaticallyImplyLeading: true,
                            backgroundColor: widget.myClosetTheme.appBarTheme.backgroundColor,
                          ),
                        ),
                        drawer: AppDrawer(isFromMyCloset: true),
                        backgroundColor: widget.myClosetTheme.colorScheme.surface,
                        body: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              MyClosetContainer(
                                theme: widget.myClosetTheme,
                                apparelCount: isUploadCompleted ? apparelCount : apparelCount,
                                uploadData: uploadData,
                                filterData: filterData,
                                arrangeData: arrangeData,
                                addClosetData: addClosetData,
                                publicClosetData: publicClosetData,
                                itemUploadData: itemUploadData,
                                currentStreakData: isUploadCompleted ? currentStreakData : null,
                                highestStreakData: isUploadCompleted ? highestStreakData : null,
                                costOfNewItemsData: isUploadCompleted ? costOfNewItemsData : null,
                                numberOfNewItemsData: isUploadCompleted ? numberOfNewItemsData : null,
                                currentStreakCount: currentStreakCount,
                                highestStreakCount: highestStreakCount,
                                newItemsCost: newItemsCost,
                                newItemsCount: newItemsCount,
                                isUploadCompleted: isUploadCompleted,
                                onUploadButtonPressed: _onUploadButtonPressed,
                                onFilterButtonPressed: () =>_onFilterButtonPressed(context, true),
                                onArrangeButtonPressed: () => _onArrangeButtonPressed(context, true),
                                onMultiClosetButtonPressed:  () => _onMultiClosetButtonPressed(context, true),
                                onPublicClosetButtonPressed: _onPublicClosetButtonPressed,
                              ),
                              Expanded(
                                child: ItemGrid(
                                  items: viewItemsState.items,
                                  scrollController: _scrollController,
                                  myClosetTheme: widget.myClosetTheme,
                                  logger: logger,
                                  crossAxisCount: crossAxisCount,
                                ),
                              ),
                              if (!isUploadCompleted)
                                ThemedElevatedButton(
                                  onPressed: _onUploadCompletedButtonPressed,
                                  text: S.of(context).closetUploadComplete,
                                ),
                            ],
                          ),
                        ),
                        bottomNavigationBar: BottomNavigationBar(
                          items: [
                            BottomNavigationBarItem(
                              icon: const Icon(Icons.dry_cleaning_outlined),
                              label: S.of(context).myClosetTitle,
                            ),
                            BottomNavigationBarItem(
                              icon: const Icon(Icons.wc_outlined),
                              label: S.of(context).myOutfitTitle,
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
                } else if (viewItemsState is ItemsError) {
                  return Center(child: Text('Error fetching items: ${viewItemsState.error}'));
                } else {
                  return const Center(child: ClosetProgressIndicator());
                }
              },
            );
          }

          return const Center(child: ClosetProgressIndicator());
        },
      ),
        );
      }
        },
    );
  }
}
