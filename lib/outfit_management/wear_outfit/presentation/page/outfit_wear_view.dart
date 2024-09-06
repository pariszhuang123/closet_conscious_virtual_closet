import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../core/widgets/layout/base_grid.dart';
import '../../../../core/photo/presentation/widgets/user_photo/enhanced_user_photo.dart';
import '../../../../core/photo/presentation/widgets/user_photo/base/user_photo.dart';
import '../../../core/data/models/outfit_item_minimal.dart';
import '../../../../generated/l10n.dart';
import '../widget/selfie_date_share_container.dart';
import '../../../../core/widgets/bottom_sheet/premium_bottom_sheet/share_premium_bottom_sheet.dart';
import '../bloc/outfit_wear_bloc.dart';
import '../../../../core/widgets/container/logo_text_container.dart';
import '../../../../core/theme/themed_svg.dart';
import '../widget/outfit_creation_success_dialog.dart';

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
  late CustomLogger logger;

  @override
  void initState() {
    super.initState();
    // Retrieving the logger from the service locator
    logger = CustomLogger('OutfitWearViewLogger');
    logger.i('Initializing OutfitWearView with outfitId: ${widget.outfitId}');

    // Dispatching the event to check for the outfit image URL
    context.read<OutfitWearBloc>().add(CheckForOutfitImageUrl(widget.outfitId));
  }

  void _onSelfieButtonPressed() {
    logger.i('Selfie button pressed for outfitId: ${widget.outfitId}');
    context.read<OutfitWearBloc>().add(TakeSelfie(widget.outfitId));
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
    String formattedDate = DateFormat('dd/MM/yyyy').format(widget.date);
    logger.i('Building OutfitWearView for date: $formattedDate');

    return BlocListener<OutfitWearBloc, OutfitWearState>(
      listener: (context, state) {
        if (state is OutfitCreationSuccess) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return OutfitCreationSuccessDialog(
                theme: widget.myOutfitTheme,
              );
            },
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Theme(
            data: widget.myOutfitTheme,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  LogoTextContainer(
                    themeData: widget.myOutfitTheme,
                    text: S.of(context).myOutfitOfTheDay,
                    isFromMyCloset: false,
                    buttonType: ButtonType.primary,
                    isSelected: false,
                    usePredefinedColor: true,
                  ),
                  const SizedBox(height: 15),
                  BlocBuilder<OutfitWearBloc, OutfitWearState>(
                    builder: (context, state) {
                      final isSelfieTaken = state is SelfieTaken;
                      return SelfieDateShareContainer(
                        formattedDate: formattedDate,
                        onSelfieButtonPressed: _onSelfieButtonPressed,
                        onShareButtonPressed: _onShareButtonPressed,
                        theme: widget.myOutfitTheme,
                        isSelfieTaken: isSelfieTaken,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<OutfitWearBloc, OutfitWearState>(
                      builder: (context, state) {
                        if (state is SelfieTaken) {
                          logger.i('Selfie taken, displaying image');
                          final outfitImageUrl = state.items.first.imageUrl;
                          return Center(
                            child: UserPhoto(
                              imageUrl: outfitImageUrl,
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
                              style: const TextStyle(color: Colors.red, fontSize: 16),
                            ),
                          );
                        } else {
                          logger.i('Loading state, displaying progress indicator');
                          return  Center(child: OutfitProgressIndicator(
                            color: widget.myOutfitTheme.colorScheme.onPrimary,
                            size: 24.0,
                          ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, bottom: 20.0, left: 16.0, right: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        logger.i('Confirm button pressed');
                        context.read<OutfitWearBloc>().add(ConfirmOutfitCreation());
                      },
                      child: Text(S.of(context).styleOn),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
