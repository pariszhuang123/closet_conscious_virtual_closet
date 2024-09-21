import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utilities/logger.dart';
import '../../../../core/utilities/routes.dart';
import '../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../core/widgets/layout/base_grid.dart';
import '../../../../core/user_photo/presentation/widgets/enhanced_user_photo.dart';
import '../../../../core/user_photo/presentation/widgets/base/user_photo.dart';
import '../../../../core/widgets/bottom_sheet/premium_bottom_sheet/share_premium_bottom_sheet.dart';
import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../generated/l10n.dart';
import '../widget/selfie_date_share_container.dart';
import '../bloc/outfit_wear_bloc.dart';
import '../../../../core/widgets/container/logo_text_container.dart';
import '../../../../core/theme/themed_svg.dart';
import '../widget/outfit_creation_success_dialog.dart';
import '../../../../core/theme/my_outfit_theme.dart';
import '../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../core/core_enums.dart';


class OutfitWearScreen extends StatefulWidget {
  final String outfitId;

  const OutfitWearScreen({
    super.key,
    required this.outfitId,
  });

  @override
  OutfitWearScreenState createState() => OutfitWearScreenState();
}

class OutfitWearScreenState extends State<OutfitWearScreen> {
  late CustomLogger logger;
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    // Retrieving the logger from the service locator
    logger = CustomLogger('OutfitWearViewLogger');
    logger.i('Initializing OutfitWearView with outfitId: ${widget.outfitId}');

    // Get the current system date and format it
    formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    logger.i('Formatted date: $formattedDate');

    // Dispatching the event to check for the outfit image URL
    context.read<OutfitWearBloc>().add(CheckForOutfitImageUrl(widget.outfitId));
  }

  void _onSelfieButtonPressed() {
    logger.i('Selfie button pressed for outfitId: ${widget.outfitId}');
    Navigator.pushNamed(
      context,
      AppRoutes.selfiePhoto,
      arguments: widget.outfitId,
    );
  }

  void _onShareButtonPressed() {
    logger.i('Share button pressed');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        logger.i('Showing ShareFeatureBottomSheet');
        return const ShareFeatureBottomSheet(isFromMyCloset: false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false, // Disable back navigation
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          logger.i('Preventing back navigation');
        }
      },
      child: BlocListener<OutfitWearBloc, OutfitWearState>(
        listener: (context, state) {
          if (state is OutfitCreationSuccess) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return OutfitCreationSuccessDialog(
                  theme: myOutfitTheme,
                );
              },
            );
          }
        },
        child: SafeArea(
          child: Scaffold(
            body: Theme(
              data: myOutfitTheme,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    LogoTextContainer(
                      themeData: myOutfitTheme,
                      text: S.of(context).myOutfitOfTheDay,
                      isFromMyCloset: false,
                      buttonType: ButtonType.primary,
                      isSelected: false,
                      usePredefinedColor: true,
                    ),
                    const SizedBox(height: 15),
                    BlocBuilder<OutfitWearBloc, OutfitWearState>(
                      builder: (context, state) {
                        final isSelfieTaken = state is OutfitImageUrlAvailable;
                        return SelfieDateShareContainer(
                          formattedDate: formattedDate,
                          onSelfieButtonPressed: _onSelfieButtonPressed,
                          onShareButtonPressed: _onShareButtonPressed,
                          theme: myOutfitTheme,
                          isSelfieTaken: isSelfieTaken,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: BlocBuilder<OutfitWearBloc, OutfitWearState>(
                        builder: (context, state) {
                          if (state is OutfitImageUrlAvailable) {
                            logger.i('Selfie taken, displaying image');
                            final outfitImageUrl = state.imageUrl;
                            return Center(
                              child: UserPhoto(
                                imageUrl: outfitImageUrl,
                                imageSize: ImageSize.selfie,
                              ),
                            );
                          } else if (state is OutfitWearLoaded) {
                            logger.i('Outfit items loaded, displaying grid');
                            return BaseGrid<OutfitItemMinimal>(
                              items: state.items,
                              scrollController: ScrollController(),
                              logger: logger,
                              itemBuilder: (context, item, index) {
                                return EnhancedUserPhoto(
                                  imageUrl: item.imageUrl,
                                  imageSize: ImageSize.itemGrid3,
                                  isSelected: false,
                                  isDisliked: item.isDisliked,
                                  onPressed: () {},
                                  itemName: item.name,
                                  itemId: item.itemId,
                                );
                              },
                              crossAxisCount: 3,
                              childAspectRatio: 2 / 3,
                            );
                          } else if (state is OutfitWearError) {
                            // Handle the error state
                            logger.e('Error state, displaying error message');
                            return Center(
                              child: Text(
                                state.message,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          } else {
                            logger.i('Loading state, displaying progress indicator');
                            return Center(
                              child: OutfitProgressIndicator(
                                color: myOutfitTheme.colorScheme.onPrimary,
                                size: 24.0,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 2.0,
                        bottom: 20.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: ThemedElevatedButton( // Replaced ElevatedButton with ThemedElevatedButton
                        onPressed: () {
                          logger.i('Confirm button pressed');
                          context.read<OutfitWearBloc>().add(ConfirmOutfitCreation());
                        },
                        text: S.of(context).styleOn, // Button text
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
