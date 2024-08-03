import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utilities/logger.dart';
import '../app_drawer.dart';
import '../../../../core/theme/ui_constant.dart';
import '../../outfit_management/view_outfit/widgets/my_outfit_container.dart';
import '../../core/widgets/bottom_sheet/calendar_premium_bottom_sheet.dart';
import '../../core/widgets/bottom_sheet/filter_premium_bottom_sheet.dart';
import '../../core/data/type_data.dart';
import '../../generated/l10n.dart';
import '../../outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';

class MyOutfitView extends StatefulWidget {
  final ThemeData myOutfitTheme;

  const MyOutfitView({super.key, required this.myOutfitTheme});

  @override
  MyOutfitViewState createState() => MyOutfitViewState();
}

class MyOutfitViewState extends State<MyOutfitView> {
  int _selectedIndex = 1;
  final CustomLogger logger = CustomLogger('OutfitPage');
  int outfitCount = 0;

  void _onClothesPressed() {
    logger.i('Clothes container clicked');
    context.read<CreateOutfitItemBloc>().add(const SelectCategoryEvent(OutfitItemCategory.clothing));
  }

  void _onAccessoriesPressed() {
    logger.i('Accessories container clicked');
    context.read<CreateOutfitItemBloc>().add(const SelectCategoryEvent(OutfitItemCategory.accessory));
  }

  void _onShoesPressed() {
    logger.i('Shoes container clicked');
    context.read<CreateOutfitItemBloc>().add(const SelectCategoryEvent(OutfitItemCategory.shoes));
  }

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

  void _onItemSelected(String itemId, OutfitItemCategory category) {
    context.read<CreateOutfitItemBloc>().add(SelectItemEvent(category, itemId));
  }

  @override
  Widget build(BuildContext context) {
    final outfitsUploadData = TypeDataList.outfitsUpload(context);
    final filterData = TypeDataList.filter(context);
    final calendarData = TypeDataList.calendar(context);

    // Define the types
    final outfitClothingType = TypeDataList.outfitClothingType(context);
    final outfitAccessoryType = TypeDataList.outfitAccessoryType(context);
    final outfitShoesType = TypeDataList.outfitShoesType(context);

    return PopScope(
      canPop: false, // Disable back navigation
      child: Theme(
        data: widget.myOutfitTheme,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(appBarHeight),
            child: AppBar(
              title: Text(S.of(context).myOutfitTitle, style: widget.myOutfitTheme.textTheme.titleMedium),
              automaticallyImplyLeading: true, // Ensure no back button
              backgroundColor: widget.myOutfitTheme.appBarTheme.backgroundColor,
            ),
          ),
          drawer: AppDrawer(isFromMyCloset: false),
          backgroundColor: widget.myOutfitTheme.colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                MyOutfitContainer(
                  theme: widget.myOutfitTheme,
                  filterData: filterData,
                  calendarData: calendarData,
                  outfitsUploadData: outfitsUploadData,
                  outfitCount: outfitCount,
                  onFilterButtonPressed: _onFilterButtonPressed,
                  onCalendarButtonPressed: _onCalendarButtonPressed,
                  onClothesPressed: _onClothesPressed,
                  onAccessoriesPressed: _onAccessoriesPressed,
                  onShoesPressed: _onShoesPressed,
                  outfitClothingType: outfitClothingType,
                  outfitAccessoryType: outfitAccessoryType,
                  outfitShoesType: outfitShoesType,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<CreateOutfitItemBloc, CreateOutfitItemState>(
                    builder: (context, state) {
                      if (state.saveStatus == SaveStatus.inProgress) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final items = state.items;
                      if (items.isEmpty) {
                        return const Center(child: Text('No items found'));
                      }

                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final category = state.currentCategory;
                          final isSelected = state.selectedItemIds[category]?.contains(item.itemId) ?? false;

                          return GestureDetector(
                            onTap: () {
                              if (category != null) {
                                _onItemSelected(item.itemId, category);
                              }
                            },
                            child: Card(
                              shape: isSelected
                                  ? RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.green, width: 2.0),
                                borderRadius: BorderRadius.circular(4.0),
                              )
                                  : null,
                              child: Column(
                                children: [
                                  Image.network(item.imageUrl),
                                  Text(item.name),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _onSaveOutfit(),
                    child: const Text('Outfit of the Day'),
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
    );
  }
}
