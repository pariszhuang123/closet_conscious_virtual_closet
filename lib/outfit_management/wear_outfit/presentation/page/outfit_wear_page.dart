import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/base_grid.dart';
import '../../../../core/widgets/user_photo/enhanced_user_photo.dart';

class OutfitWearPage extends StatelessWidget {
  final DateTime date;
  final List<OutfitItem> selectedItems;
  final CustomLogger logger = CustomLogger('WearOutfit');

  OutfitWearPage({super.key, required this.date, required this.selectedItems});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60), // Space for the popup container
                  // Row with Date and Share Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date: $formattedDate',
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          // Handle share button press
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Outfit Items Grid using BaseGrid with EnhancedUserPhoto
                  Expanded(
                    child: BaseGrid<OutfitItem>(
                      items: selectedItems,
                      scrollController: ScrollController(),
                      logger: logger,
                      itemBuilder: (context, item, index) {
                        return EnhancedUserPhoto(
                          imageUrl: item.imageUrl,
                          isSelected: false, // Update this based on your selection logic
                          onPressed: () {
                            // Handle photo selection or any other interaction
                          },
                          itemName: item.name,
                          itemId: item.itemId, // Assuming OutfitItem has itemId field
                        );
                      },
                      crossAxisCount: 3,
                      childAspectRatio: 3 / 4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Confirm Button
                  ElevatedButton(
                    onPressed: () {
                      // Handle confirm outfit
                    },
                    child: const Text('Style On'),
                  ),
                ],
              ),
              // Popup Container with Logo and Text
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 10.0,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/logo.svg',
                        height: 24.0,
                      ),
                      const SizedBox(width: 8), // Space between the logo and the text
                      const Text(
                        'My Outfit of the Day',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8), // Space between the text and the logo
                      SvgPicture.asset(
                        'assets/images/logo.svg',
                        height: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OutfitItem {
  final String itemId;
  final String name;
  final String imageUrl;

  OutfitItem({required this.itemId, required this.name, required this.imageUrl});
}
