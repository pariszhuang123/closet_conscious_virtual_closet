import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/utilities/logger.dart';
import '../app_drawer.dart';
import '../../../../core/theme/ui_constant.dart';
import '../../outfit_management/view_outfit/widgets/my_outfit_container.dart';
import '../../core/widgets/bottom_sheet/calendar_premium_bottom_sheet.dart';
import '../../core/widgets/bottom_sheet/filter_premium_bottom_sheet.dart';
import '../../core/data/type_data.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/theme/themed_svg.dart';
import '../../generated/l10n.dart';
import '../../outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../outfit_management/core/data/services/outfits_fetch_service.dart';
import '../../item_management/core/data/models/closet_item_minimal.dart';

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
  List<ClosetItemMinimal> _fetchedItems = [];

  @override
  void initState() {
    super.initState();
    _fetchInitialItems();
  }

  Future<void> _fetchInitialItems() async {
    final items = await fetchCreateOutfitItems(OutfitItemCategory.Clothing, 0, 1); // Fetch the first 10 items
    setState(() {
      _fetchedItems = items;
    });
  }

  Future<void> _onClothesPressed() async {
    logger.i('Clothes container clicked');
    final currentContext = context;
    final items = await fetchCreateOutfitItems(OutfitItemCategory.Clothing, 0, 1); // Fetch the first 10 items
    setState(() {
      _fetchedItems = items;
    });
    if (currentContext.mounted) {
      for (var item in items) {
        currentContext.read<CreateOutfitItemBloc>().add(SelectItemEvent(OutfitItemCategory.Clothing, item.itemId, 0, 1));
      }
    }
  }

  Future<void> _onAccessoriesPressed() async {
    logger.i('Accessories container clicked');
    final currentContext = context;
    final items = await fetchCreateOutfitItems(OutfitItemCategory.Accessory, 0, 1); // Fetch the first 10 items
    setState(() {
      _fetchedItems = items;
    });
    if (currentContext.mounted) {
      for (var item in items) {
        currentContext.read<CreateOutfitItemBloc>().add(SelectItemEvent(OutfitItemCategory.Accessory, item.itemId, 0, 1));
      }
    }
  }

  Future<void> _onShoesPressed() async {
    logger.i('Shoes container clicked');
    final currentContext = context;
    final items = await fetchCreateOutfitItems(OutfitItemCategory.Shoes, 0, 1); // Fetch the first 10 items
    setState(() {
      _fetchedItems = items;
    });
    if (currentContext.mounted) {
      for (var item in items) {
        currentContext.read<CreateOutfitItemBloc>().add(SelectItemEvent(OutfitItemCategory.Shoes, item.itemId, 0, 1));
      }
    }
  }

  Future<void> _onSaveOutfit() async {
    final currentContext = context;
    final bloc = currentContext.read<CreateOutfitItemBloc>();
    final selectedItemIds = bloc.state.selectedItemIds;
    bloc.add(SaveOutfitEvent(selectedItemIds));
    if (currentContext.mounted) {
      // Show confirmation
      ScaffoldMessenger.of(currentContext).showSnackBar(const SnackBar(content: Text('Outfit of the Day saved!')));
    }
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
    context.read<CreateOutfitItemBloc>().add(SelectItemEvent(category, itemId, 0, 1));
  }

  @override
  Widget build(BuildContext context) {
    final outfitsUploadData = TypeDataList.outfitsUpload(context);
    final filterData = TypeDataList.filter(context);
    final calendarData = TypeDataList.calendar(context);

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
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NavigationTypeButton(
                      label: outfitClothingType.getName(context),
                      selectedLabel: '',
                      onPressed: _onClothesPressed,
                      imagePath: outfitClothingType.imagePath!,
                      isAsset: false,
                      isFromMyCloset: false,
                      buttonType: ButtonType.primary,
                    ),
                    NavigationTypeButton(
                      label: outfitAccessoryType.getName(context),
                      selectedLabel: '',
                      onPressed: _onAccessoriesPressed,
                      imagePath: outfitAccessoryType.imagePath!,
                      isAsset: false,
                      isFromMyCloset: false,
                      buttonType: ButtonType.primary,
                    ),
                    NavigationTypeButton(
                      label: outfitShoesType.getName(context),
                      selectedLabel: '',
                      onPressed: _onShoesPressed,
                      imagePath: outfitShoesType.imagePath!,
                      isAsset: false,
                      isFromMyCloset: false,
                      buttonType: ButtonType.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<CreateOutfitItemBloc, CreateOutfitItemState>(
                    builder: (context, state) {
                      if (state.selectedItemIds.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: state.selectedItemIds.length,
                        itemBuilder: (context, index) {
                          final category = state.selectedItemIds.keys.elementAt(index);
                          final items = state.selectedItemIds[category]!;
                          return Column(
                            children: items.map((itemId) {
                              final item = _fetchedItems.firstWhere((item) => item.itemId == itemId);
                              final isSelected = state.selectedItemIds[category]?.contains(itemId) ?? false;
                              return GestureDetector(
                                onTap: () {
                                  _onItemSelected(itemId, category);
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
                                      // Add other item details here
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _onSaveOutfit,
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
