import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/base_grid.dart';
import '../../../../core/widgets/user_photo/enhanced_user_photo.dart';
import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../core/utilities/routes.dart';
import '../../../../generated/l10n.dart';
import '../widget/selfie_date_share_container.dart';
import '../../../../core/widgets/bottom_sheet/share_premium_bottom_sheet.dart';
import '../bloc/outfit_wear_bloc.dart';
import '../../../../core/widgets/container/logo_text_container.dart';
import '../../../../core/theme/themed_svg.dart';

class OutfitWearView extends StatefulWidget {
  final DateTime date;
  final String outfitId;
  final ThemeData myOutfitTheme;

  const OutfitWearView({
    super.key,
    required this.date,
    required this.outfitId,
    required this.myOutfitTheme,
  });

  @override
  OutfitWearViewState createState() => OutfitWearViewState();
}

class OutfitWearViewState extends State<OutfitWearView> {
  final CustomLogger logger = CustomLogger('WearOutfit');
  late Future<List<OutfitItemMinimal>> selectedItemsFuture;

  @override
  void initState() {
    super.initState();
    selectedItemsFuture = fetchOutfitItems(widget.outfitId);
  }

  void _onSelfieButtonPressed() {
    context.read<OutfitWearBloc>().add(TakeSelfie(widget.outfitId));
  }

  void _onShareButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const ShareFeatureBottomSheet(isFromMyCloset: false);
      },
    );
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
              LogoTextContainer(
                themeData: widget.myOutfitTheme,
                text: S.of(context).myOutfitOfTheDay,
                isFromMyCloset: false,
                buttonType: ButtonType.primary,
                isSelected: false,
                usePredefinedColor: true,
              ),
              const SizedBox(height: 15), // Space between the text and the logo
              SelfieDateShareContainer(
                formattedDate: formattedDate,
                onSelfieButtonPressed: _onSelfieButtonPressed,
                onShareButtonPressed: _onShareButtonPressed,
                theme: widget.myOutfitTheme,
              ),
              const SizedBox(height: 16),
              // Use BlocBuilder to handle different states
              Expanded(
                child: BlocBuilder<OutfitWearBloc, OutfitWearState>(
                  builder: (context, state) {
                    if (state is SelfieTaken) {
                      // Display the selfie image
                      final outfitImageUrl = state.items.first.imageUrl;
                      return Center(
                        child: Image.network(
                          outfitImageUrl,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else if (state is OutfitWearLoaded) {
                      // Display the grid with the loaded items
                      return BaseGrid<OutfitItemMinimal>(
                        items: state.items,
                        scrollController: ScrollController(),
                        logger: logger,
                        itemBuilder: (context, item, index) {
                          return EnhancedUserPhoto(
                            imageUrl: item.imageUrl,
                            isSelected: false,
                            onPressed: () {},
                            itemName: item.name,
                            itemId: item.itemId,
                          );
                        },
                        crossAxisCount: 3,
                        childAspectRatio: 3 / 4,
                      );
                    } else {
                      // Default loading state while fetching data
                      return const Center(child: CircularProgressIndicator());
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}