import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../core/utilities/logger.dart';
import '../app_drawer.dart';
import '../../core/theme/ui_constant.dart';
import '../../outfit_management/create_outfit/presentation/widgets/outfit_feature_container.dart';
import '../../outfit_management/core/data/services/outfits_fetch_service.dart';
import '../../core/widgets/bottom_sheet/calendar_premium_bottom_sheet.dart';
import '../../core/widgets/bottom_sheet/filter_premium_bottom_sheet.dart';
import '../../core/data/type_data.dart';
import '../../generated/l10n.dart';
import '../../outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../outfit_management/create_outfit/presentation/widgets/outfit_grid.dart';
import '../../outfit_management/create_outfit/presentation/widgets/outfit_type_container.dart';
import '../../outfit_management/wear_outfit/presentation/page/outfit_wear_provider.dart';
import '../../core/theme/my_outfit_theme.dart';
import '../../outfit_management/user_nps_feedback/presentation/nps_dialog.dart';

class MyOutfitView extends StatefulWidget {
  final ThemeData myOutfitTheme;

  const MyOutfitView({super.key, required this.myOutfitTheme});

  @override
  MyOutfitViewState createState() => MyOutfitViewState();
}

class MyOutfitViewState extends State<MyOutfitView> {
  int _selectedIndex = 1;
  final CustomLogger logger = CustomLogger('OutfitPage');
  final ScrollController _scrollController = ScrollController();
  int newOutfitCount = 0;

  final OutfitFetchService _outfitFetchService = GetIt.instance<OutfitFetchService>();

  @override
  void initState() {
    super.initState();
    _fetchOutfitsCount();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchMoreItems();
      }
    });
  }

  void _fetchMoreItems() {
    context.read<CreateOutfitItemBloc>().add(FetchMoreItemsEvent());
  }

  void _onSaveOutfit() {
    context.read<CreateOutfitItemBloc>().add(const SaveOutfitEvent());
  }

  void _triggerNpsSurveyIfNeeded() {
    logger.i('Checking if NPS survey should be triggered for outfit count: $newOutfitCount');
    context.read<CreateOutfitItemBloc>().add(TriggerNpsSurveyEvent(newOutfitCount));
  }

  void _onFilterButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const PremiumFilterBottomSheet(isFromMyCloset: false);
      },
    );
  }

  void _onCalendarButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const PremiumCalendarBottomSheet(isFromMyCloset: false);
      },
    );
  }

  Future<void> _fetchOutfitsCount() async {
    try {
      // Fetch the count of outfits created and ignore the NPS status
      final result = await _outfitFetchService.fetchOutfitsCountAndNPS();
      final count = result['outfits_created'];

      if (mounted) {
        setState(() {
          newOutfitCount = count;
        });
        _triggerNpsSurveyIfNeeded();  // Call the method after setting the outfit count
      }
    } catch (e) {
      logger.e('Error fetching new outfits count: $e');
    }
  }

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
  void dispose() {
    _scrollController.dispose(); // Properly dispose of the ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final outfitsUploadData = TypeDataList.outfitsUpload(context);
    final filterData = TypeDataList.filter(context);
    final calendarData = TypeDataList.calendar(context);

    final outfitClothingType = TypeDataList.outfitClothingType(context);
    final outfitAccessoryType = TypeDataList.outfitAccessoryType(context);
    final outfitShoesType = TypeDataList.outfitShoesType(context);

    return BlocListener<CreateOutfitItemBloc, CreateOutfitItemState>(
      listener: (context, state) {
        logger.i('BlocListener is active, received state: $state');

        if (state.saveStatus == SaveStatus.success && state.outfitId != null) {
          logger.i('Navigating to OutfitWearProvider for outfitId: ${state.outfitId}');

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OutfitWearProvider(
                date: DateTime.now(),
                outfitId: state.outfitId!,
                myOutfitTheme: widget.myOutfitTheme,
              ),
            ),
          );
        }
        if (state is NpsSurveyTriggered) {
          logger.i('NPS Survey triggered for milestone: ${state.milestone}');
          NpsDialog(milestone: state.milestone).showNpsDialog(context); // Correct usage
        }
      },

      child: PopScope(
        canPop: false, // Disable back navigation
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
                    filterData: filterData,
                    calendarData: calendarData,
                    outfitsUploadData: outfitsUploadData,
                    outfitCount: newOutfitCount,
                    onFilterButtonPressed: _onFilterButtonPressed,
                    onCalendarButtonPressed: _onCalendarButtonPressed,
                  ),
                  const SizedBox(height: 15),
                  OutfitTypeContainer(
                    outfitClothingType: outfitClothingType,
                    outfitAccessoryType: outfitAccessoryType,
                    outfitShoesType: outfitShoesType,
                    theme: myOutfitTheme,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<CreateOutfitItemBloc, CreateOutfitItemState>(
                      builder: (context, state) {
                        if (state.saveStatus == SaveStatus.failure) {
                          return Center(child: Text(S.of(context).failedToLoadItems));
                        } else if (state.items.isEmpty) {
                          return Center(child: Text(S.of(context).noItemsInCategory));
                        } else {
                          return OutfitGrid(
                            scrollController: _scrollController,
                            logger: logger,
                            items: state.items,  // Use the items from the state
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<CreateOutfitItemBloc, CreateOutfitItemState>(
                      builder: (context, state) {
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
