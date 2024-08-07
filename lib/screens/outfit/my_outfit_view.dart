import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utilities/logger.dart';
import '../app_drawer.dart';
import '../../../../core/theme/ui_constant.dart';
import '../../outfit_management/view_outfit/widgets/outfit_feature_container.dart';
import '../../core/widgets/bottom_sheet/calendar_premium_bottom_sheet.dart';
import '../../core/widgets/bottom_sheet/filter_premium_bottom_sheet.dart';
import '../../core/data/type_data.dart';
import '../../generated/l10n.dart';
import '../../outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../outfit_management/view_outfit/widgets/outfit_grid.dart';
import '../../outfit_management/view_outfit/widgets/outfit_type_container.dart';

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
  int outfitCount = 0;

  void _onSaveOutfit() {
    context.read<CreateOutfitItemBloc>().add(const SaveOutfitEvent());
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
  Widget build(BuildContext context) {
    final outfitsUploadData = TypeDataList.outfitsUpload(context);
    final filterData = TypeDataList.filter(context);
    final calendarData = TypeDataList.calendar(context);

    final outfitClothingType = TypeDataList.outfitClothingType(context);
    final outfitAccessoryType = TypeDataList.outfitAccessoryType(context);
    final outfitShoesType = TypeDataList.outfitShoesType(context);

    return BlocProvider(
      create: (context) => CreateOutfitItemBloc()..add(const SelectCategoryEvent(OutfitItemCategory.clothing)), // Initial fetch
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
                    outfitCount: outfitCount,
                    onFilterButtonPressed: _onFilterButtonPressed,
                    onCalendarButtonPressed: _onCalendarButtonPressed,
                  ),
                  const SizedBox(height: 15),
                  OutfitTypeContainer(
                    outfitClothingType: outfitClothingType,
                    outfitAccessoryType: outfitAccessoryType,
                    outfitShoesType: outfitShoesType,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: OutfitGrid(
                      scrollController: _scrollController,
                      logger: logger,
                    ),
                  ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _onSaveOutfit,
                  child: Text(S.of(context).OutfitDay),
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
