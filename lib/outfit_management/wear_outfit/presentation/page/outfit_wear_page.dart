import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/base_grid.dart';
import '../../../../core/widgets/user_photo/enhanced_user_photo.dart';
import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../core/utilities/routes.dart';
import '../../../../generated/l10n.dart';

class OutfitWearPage extends StatefulWidget {
  final DateTime date;
  final String outfitId;
  final ThemeData myOutfitTheme;

  const OutfitWearPage({
    super.key,
    required this.date,
    required this.outfitId,
    required this.myOutfitTheme,
  });

  @override
  OutfitWearPageState createState() => OutfitWearPageState();
}

class OutfitWearPageState extends State<OutfitWearPage> {
  final CustomLogger logger = CustomLogger('WearOutfit');
  late Future<List<OutfitItemMinimal>> selectedItemsFuture;

  @override
  void initState() {
    super.initState();
    selectedItemsFuture = fetchOutfitItems(widget.outfitId);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(widget.date);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20), // Space between the text and the logo
              Container(
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
                      'assets/images/SVG_CC_Logo.svg',
                      height: 24.0,
                    ),
                    const SizedBox(width: 8), // Space between the logo and the text
                    Expanded( // Wrap the text with Expanded or Flexible
                      child: Text(
                        S.of(context).myOutfitOfTheDay,
                        style: widget.myOutfitTheme.textTheme.titleMedium,
                        textAlign: TextAlign.center, // Ensure the text is centered within the available space
                      ),
                    ),
                    const SizedBox(width: 8), // Space between the text and the logo
                    SvgPicture.asset(
                      'assets/images/SVG_CC_Logo.svg',
                      height: 24.0,
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 15), // Space between the text and the logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${S.of(context).date}: $formattedDate',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Outfit Items Grid using BaseGrid with EnhancedUserPhoto
              Expanded(
                child: FutureBuilder<List<OutfitItemMinimal>>(
                  future: selectedItemsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${S.of(context).error}: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text(S.of(context).noItemsFound));
                    } else {
                      final selectedItems = snapshot.data!;
                      return BaseGrid<OutfitItemMinimal>(
                        items: selectedItems,
                        scrollController: ScrollController(),
                        logger: logger,
                        itemBuilder: (context, item, index) {
                          return EnhancedUserPhoto(
                            imageUrl: item.imageUrl,
                            isSelected: false,
                            onPressed: () {
                            },
                            itemName: item.name,
                            itemId: item.itemId,
                          );
                        },
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 4,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Confirm Button
        Padding(
          padding: const EdgeInsets.only(top: 2.0, bottom: 70.0, left: 16.0, right: 16.0),
          child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.createOutfit,
                  );
                },
            child: Text(S.of(context).styleOn),
              ),
        )],
          ),
        ),
      ),
    );
  }
}
