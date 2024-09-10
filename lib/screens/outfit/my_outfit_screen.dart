import 'package:closet_conscious/core/widgets/bottom_sheet/premium_bottom_sheet/arrange_premium_bottom_sheet.dart';
import 'package:closet_conscious/core/widgets/bottom_sheet/usage_bottom_sheet/ai_stylist_usage_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../core/utilities/logger.dart';
import '../app_drawer.dart';
import '../../core/theme/ui_constant.dart';
import '../../outfit_management/create_outfit/presentation/widgets/outfit_feature_container.dart';
import '../../outfit_management/core/data/services/outfits_fetch_service.dart';
import '../../core/widgets/bottom_sheet/premium_bottom_sheet/calendar_premium_bottom_sheet.dart';
import '../../core/widgets/bottom_sheet/premium_bottom_sheet/filter_premium_bottom_sheet.dart';
import '../../core/data/type_data.dart';
import '../../generated/l10n.dart';
import '../../core/utilities/routes.dart';
import '../../outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../outfit_management/navigate_outfit/presentation/bloc/navigate_outfit_bloc.dart';
import '../../outfit_management/create_outfit/presentation/widgets/outfit_grid.dart';
import '../../outfit_management/create_outfit/presentation/widgets/outfit_type_container.dart';
import '../../outfit_management/user_nps_feedback/presentation/nps_dialog.dart';
import '../../user_management/authentication/presentation/bloc/auth_bloc.dart';

class MyOutfitScreen extends StatefulWidget {
  final ThemeData myOutfitTheme;

  const MyOutfitScreen({super.key, required this.myOutfitTheme});

  @override
  MyOutfitScreenState createState() => MyOutfitScreenState();
}

class MyOutfitScreenState extends State<MyOutfitScreen> {
  int _selectedIndex = 1;
  final CustomLogger logger = CustomLogger('OutfitPage');
  final ScrollController _scrollController = ScrollController();
  int newOutfitCount = 0;
  bool _snackBarShown = false;
  bool _isNavigating = false; // New flag to track if navigation is in progress

  final OutfitFetchService _outfitFetchService = GetIt.instance<OutfitFetchService>();

  @override
  void initState() {
    super.initState();
    logger.i('MyOutfitView initialized');
    _fetchOutfitsCount();
    _checkNavigationToReview(context);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        logger.i('Reached the end of the list, fetching more items...');
        _fetchMoreItems();
      }
    });
  }

  void _fetchMoreItems() {
    logger.i('Fetching more items...');
    context.read<CreateOutfitItemBloc>().add(FetchMoreItemsEvent());
  }

  void _onSaveOutfit() {
    logger.i('Save outfit button pressed');
    context.read<CreateOutfitItemBloc>().add(const SaveOutfitEvent());
  }

  void _checkNavigationToReview(BuildContext context) {
    final userId = GetIt.instance<AuthBloc>().userId;  // Access userId from AuthBloc

    if (userId != null) {
      logger.i('Attempting to check navigation to review page with userId: $userId');
      context.read<NavigateOutfitBloc>().add(CheckNavigationToReviewEvent(userId: userId));
    } else {
      logger.e('Error: userId is null. Cannot check navigation to review.');
    }
  }

  void _triggerNpsSurveyIfNeeded() {
    logger.i('Checking if NPS survey should be triggered for outfit count: $newOutfitCount');
    context.read<NavigateOutfitBloc>().add(TriggerNpsSurveyEvent(newOutfitCount));
  }

  void _onFilterButtonPressed() {
    logger.i('Filter button pressed, showing filter interest form...');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const PremiumFilterBottomSheet(isFromMyCloset: false);
      },
    );
  }

  void _onArrangeButtonPressed() {
    logger.i('Arrange button pressed, showing arrange interest form...');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const ArrangeFeatureBottomSheet(isFromMyCloset: false);
      },
    );
  }

  void _onCalendarButtonPressed() {
    logger.i('Calendar button pressed, showing calendar...');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const PremiumCalendarBottomSheet(isFromMyCloset: false);
      },
    );
  }

  void _onAiStylistButtonPressed() {
    logger.i('AI Stylist button pressed, showing ai stylist...');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const AiStylistUsageBottomSheet(isFromMyCloset: false);
      },
    );
  }

  Future<void> _fetchOutfitsCount() async {
    logger.i('Fetching outfits count...');
    try {
      final result = await _outfitFetchService.fetchOutfitsCountAndNPS();
      final count = result['outfits_created'];

      logger.i('Outfits count fetched: $count');

      if (mounted) {
        setState(() {
          newOutfitCount = count;
        });
        logger.i('New outfit count set to $newOutfitCount');
        _triggerNpsSurveyIfNeeded();  // Call the method after setting the outfit count
      }
    } catch (e) {
      logger.e('Error fetching new outfits count: $e');
    }
  }

  void _onItemTapped(int index) {
    logger.i('Bottom navigation item tapped, index: $index');
    if (index == 0) {
      logger.i('Navigating to My Closet screen');
      Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  void dispose() {
    logger.i('Disposing MyOutfitView...');
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building MyOutfitView...');

    final outfitClothingType = TypeDataList.outfitClothingType(context);
    final outfitAccessoryType = TypeDataList.outfitAccessoryType(context);
    final outfitShoesType = TypeDataList.outfitShoesType(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<NavigateOutfitBloc, NavigateOutfitState>(
          listener: (context, state) {
            logger.i('NavigateOutfitBloc listener triggered with state: $state');
            if (state is NpsSurveyTriggeredState) {
              logger.i('NPS Survey triggered for milestone: ${state.milestone}');
              NpsDialog(milestone: state.milestone).showNpsDialog(context);
            }
            if (state is NavigateToReviewPageState) {
              logger.i('Navigating to OutfitReviewProvider for outfitId: ${state.outfitId}');
              _isNavigating = true; // Set navigating to true when navigating to review page
              Navigator.pushNamed(
                context,
                AppRoutes.reviewOutfit,
              );
            }
          },
        ),
        BlocListener<CreateOutfitItemBloc, CreateOutfitItemState>(
          listener: (context, state) {
            logger.i('CreateOutfitItemBloc listener triggered with state: $state');

            if (state.saveStatus == SaveStatus.success && state.outfitId != null) {
              logger.i('Navigating to OutfitWearProvider for outfitId: ${state.outfitId}');
              _isNavigating = true; // Set navigating to true when navigating to wear outfit page
              Navigator.pushNamed(
                context,
                AppRoutes.wearOutfit,
                arguments: state.outfitId,
              );
            }
          },
        ),
      ],
      child: PopScope(
        canPop: false,
        child: Theme(
          data: widget.myOutfitTheme,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(appBarHeight),
              child: AppBar(
                title: Text(S.of(context).myOutfitTitle, style: widget.myOutfitTheme.textTheme.titleMedium),
                automaticallyImplyLeading: true,
                backgroundColor: widget.myOutfitTheme.appBarTheme.backgroundColor,
              ),
            ),
            drawer: AppDrawer(isFromMyCloset: false),
            backgroundColor: widget.myOutfitTheme.colorScheme.surface,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  OutfitFeatureContainer(
                    theme: widget.myOutfitTheme,
                    outfitCount: newOutfitCount,
                    onFilterButtonPressed: _onFilterButtonPressed,
                    onArrangeButtonPressed: _onArrangeButtonPressed,
                    onCalendarButtonPressed: _onCalendarButtonPressed,
                    onStylistButtonPressed: _onAiStylistButtonPressed,
                  ),
                  const SizedBox(height: 15),
                  OutfitTypeContainer(
                    outfitClothingType: outfitClothingType,
                    outfitAccessoryType: outfitAccessoryType,
                    outfitShoesType: outfitShoesType,
                    theme: widget.myOutfitTheme,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<CreateOutfitItemBloc, CreateOutfitItemState>(
                      builder: (context, state) {
                        logger.i('CreateOutfitItemBloc builder triggered with state: $state');

                        // Check for failure status
                        if (state.saveStatus == SaveStatus.failure) {
                          return Center(child: Text(S.of(context).failedToLoadItems));
                        }
                        // If no items are available, show no items message
                        else if (state.items.isEmpty) {
                          _snackBarShown = false;  // Reset the flag when no items are available
                          return Center(child: Text(S.of(context).noItemsInCategory));
                        }
                        // If items are available, show the OutfitGrid, and trigger the snack bar if none are selected
                        else {
                          if (!state.hasSelectedItems && !_snackBarShown && !_isNavigating) { // Add condition for _isNavigating
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(S.of(context).selectItemsToCreateOutfit),
                                ),
                              );
                              _snackBarShown = true;  // Set the flag to true after the snackbar is shown
                            });
                          }
                          return OutfitGrid(
                            scrollController: _scrollController,
                            logger: logger,
                            items: state.items,
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<CreateOutfitItemBloc, CreateOutfitItemState>(
                      builder: (context, state) {
                        logger.i('CreateOutfitItemBloc bottom button builder triggered with state: $state');
                        return state.hasSelectedItems
                            ? ElevatedButton(
                          onPressed: _onSaveOutfit,
                          child: Text(S.of(context).OutfitDay),
                        )
                            : const SizedBox.shrink();
                      },
                    ),
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
              selectedItemColor: widget.myOutfitTheme.bottomNavigationBarTheme.selectedItemColor,
              backgroundColor: widget.myOutfitTheme.bottomNavigationBarTheme.backgroundColor,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
