import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utilities/logger.dart';
import '../../../../core/utilities/routes.dart';
import '../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../core/user_photo/presentation/widgets/base/user_photo.dart';
import '../../../../core/widgets/bottom_sheet/premium_bottom_sheet/share_premium_bottom_sheet.dart';
import '../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../../../generated/l10n.dart';
import '../widgets/selfie_date_share_container.dart';
import '../bloc/outfit_wear_bloc.dart';
import '../../../../core/widgets/container/logo_text_container.dart';
import '../widgets/outfit_creation_success_dialog.dart';
import '../../../../core/theme/my_outfit_theme.dart';
import '../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../core/core_enums.dart';
import '../widgets/event_name_input.dart';
import '../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';

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
  final TextEditingController _eventNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    logger = CustomLogger('OutfitWearViewLogger');
    logger.i('Initializing OutfitWearView with outfitId: ${widget.outfitId}');

    formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    logger.i('Formatted date: $formattedDate');

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
  void dispose() {
    _eventNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
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
              barrierDismissible: false,
              builder: (BuildContext context) {
                return OutfitCreationSuccessDialog(
                  theme: myOutfitTheme,
                );
              },
            );
          }
        },
        child: GestureDetector(
          onTap: () {
            // Dismiss the keyboard
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.translucent,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: EventNameInput(
                          controller: _eventNameController,
                          onChanged: (value) {
                            logger.d('User entered event name: $value');
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: BlocBuilder<CrossAxisCountCubit, int>(
                          builder: (context, crossAxisCount) {
                            return BlocBuilder<OutfitWearBloc, OutfitWearState>(
                              builder: (context, state) {
                                if (state is OutfitImageUrlAvailable) {
                                  final outfitImageUrl = state.imageUrl;
                                  return Center(
                                    child: UserPhoto(
                                      imageUrl: outfitImageUrl,
                                      imageSize: ImageSize.selfie,
                                    ),
                                  );
                                } else if (state is OutfitWearLoaded) {
                                  return BlocBuilder<MultiSelectionItemCubit, MultiSelectionItemState>(
                                    builder: (context, multiSelectionState) {
                                      return InteractiveItemGrid(
                                        scrollController: ScrollController(),
                                        items: state.items,
                                        crossAxisCount: crossAxisCount,
                                        selectedItemIds: const [], // No selection
                                        isDisliked: false,
                                        selectionMode: SelectionMode.action, // No selection
                                        onAction: null, // No action needed
                                      );
                                    },
                                  );
                                } else if (state is OutfitWearError) {
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
                                  return const Center(
                                    child: OutfitProgressIndicator(),
                                  );
                                }
                              },
                            );
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
                        child: BlocBuilder<OutfitWearBloc, OutfitWearState>(
                          builder: (context, state) {
                            final isSubmitting = state is OutfitWearSubmitting;

                            return ThemedElevatedButton(
                              onPressed: isSubmitting
                                  ? null // Disable button when submitting
                                  : () {
                                logger.i('Confirm button pressed');
                                final eventName = _eventNameController.text;
                                context.read<OutfitWearBloc>().add(
                                  ConfirmOutfitCreation(outfitId: widget.outfitId, eventName: eventName),
                                );
                              },
                              text: S.of(context).styleOn, // ✅ Ensure text is passed as a NAMED argument
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
