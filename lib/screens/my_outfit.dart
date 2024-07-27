import 'package:flutter/material.dart';
import '../core/utilities/logger.dart';
import 'app_drawer.dart';
import '../../../core/theme/ui_constant.dart';
import '../outfit_management/view_outfit/widgets/my_outfit_container.dart';
import '../core/widgets/bottom_sheet/calendar_premium_bottom_sheet.dart';
import '../core/widgets/bottom_sheet/filter_premium_bottom_sheet.dart';
import '../core/data/type_data.dart';
import '../../../core/widgets/button/navigation_type_button.dart';
import '../../../core/theme/themed_svg.dart';
import '../generated/l10n.dart';


class CreateOutfitPage extends StatefulWidget {
  final ThemeData myOutfitTheme;

  const CreateOutfitPage({super.key, required this.myOutfitTheme});

  @override
  CreateOutfitPageState createState() => CreateOutfitPageState();
}

class CreateOutfitPageState extends State<CreateOutfitPage> {
  int _selectedIndex = 1;
  final CustomLogger logger = CustomLogger('OutfitPage');

  int outfitCount = 0;

  void _onClothesPressed() {
    // Handle Clothes container click
    logger.i('Clothes container clicked');
  }

  void _onAccessoriesPressed() {
    // Handle Accessories container click
    logger.i('Accessories container clicked');
  }

  void _onShoesPressed() {
    // Handle Shoes container click
    logger.i('Shoes container clicked');
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
          drawer: AppDrawer(isFromMyCloset: false), // Include the AppDrawer here
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
