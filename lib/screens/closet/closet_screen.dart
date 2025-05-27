import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/core_enums.dart';
import '../../core/utilities/app_router.dart';
import '../../core/utilities/logger.dart';
import '../../core/theme/ui_constant.dart';
import '../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../core/widgets/layout/bottom_nav_bar/main_bottom_nav_bar.dart';
import '../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../core/photo_library/presentation/bloc/photo_library_bloc/photo_library_bloc.dart';
import '../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../core/presentation/bloc/trial_bloc/trial_bloc.dart';
import '../../item_management/streak_item/presentation/bloc/upload_item_streak_bloc.dart';
import '../../item_management/view_items/presentation/widgets/my_closet_container.dart';
import '../../core/data/type_data.dart';
import '../../generated/l10n.dart';
import '../../core/widgets/bottom_sheet/premium_bottom_sheet/public_closet_premium_bottom_sheet.dart';
import '../../item_management/upload_item/presentation/widgets/upload_confirmation_bottom_sheet.dart';
import '../app_drawer.dart';
import '../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import 'my_closet_bloc_listeners.dart';
import '../../core/tutorial/core/presentation/bloc/tutorial_cubit.dart';
import '../../core/presentation/bloc/grid_pagination_cubit/grid_pagination_cubit.dart';
import '../../item_management/core/data/models/closet_item_minimal.dart';


class MyClosetScreen extends StatefulWidget {
  final ThemeData myClosetTheme;

  const MyClosetScreen({super.key, required this.myClosetTheme});

  @override
  MyClosetScreenState createState() => MyClosetScreenState();
}

class MyClosetScreenState extends State<MyClosetScreen> {
  final int _selectedIndex = 0;
  final CustomLogger logger = CustomLogger('MyClosetPage');

  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    context.read<UploadStreakBloc>().add(CheckUploadStatus());
    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();

    // 2) But *also* schedule an immediate "page 0" load once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context
          .read<GridPaginationCubit<ClosetItemMinimal>>()
          .pagingController
          .refresh();
    });
    _triggerTrialEndedDialog();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;

    if (!isCurrent && _showFab) {
      setState(() {
        _showFab = false;
      });
    }

    if (isCurrent && !_showFab) {
      setState(() {
        _showFab = true;
      });
    }
  }


  void _triggerTrialEndedDialog() {
    logger.i('Trigger Trial Ended Dialog if it is completed');
    context.read<TrialBloc>().add(TrialEndedEvent());
  }

  void _onUploadButtonPressed() {
    context.read<PhotoLibraryBloc>().add(PhotoLibraryCheckPendingItems());
  }

  void _onPhotoButtonPressed() {
    context.read<TutorialTypeCubit>().setType(TutorialType.freeUploadCamera);
    context.read<TutorialBloc>().add(
      const CheckTutorialStatus(TutorialType.freeUploadCamera),
    );
  }

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    context.pushNamed(
      AppRoutesName.filter,
      extra: {
        'isFromMyCloset': isFromMyCloset,
        'returnRoute': AppRoutesName.myCloset,
      },
    );
  }

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    context.pushNamed(
      AppRoutesName.customize,
      extra: {
        'isFromMyCloset': isFromMyCloset,
        'returnRoute': AppRoutesName.myCloset,
      },
    );
  }

  void _onMultiClosetButtonPressed(BuildContext context, bool isFromMyCloset) {
    context.pushNamed(
      AppRoutesName.viewMultiCloset,
      extra: {
        'isFromMyCloset': isFromMyCloset
      }, // Pass isFromMyCloset as an argument
    );
  }

  void _onPublicClosetButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const PublicClosetFeatureBottomSheet(isFromMyCloset: true);
      },
    );
  }

  void _onUploadCompletedButtonPressed() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const UploadConfirmationBottomSheet(isFromMyCloset: true);
      },
    );
  }

  void _onItemSelected(BuildContext context) {
    final itemId = context
        .read<SingleSelectionItemCubit>()
        .state
        .selectedItemId;

    if (itemId != null) {
      logger.i("Navigating to edit Item for itemId: $itemId");

      context.pushNamed(
        AppRoutesName.editItem, // ✅ Ensure this route exists
        extra: itemId,
      );
    } else {
      logger.w("No item selected, navigation not triggered.");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemUploadData = TypeDataList.itemUploaded(context);
    final uploadData = TypeDataList.bulkUpload(context);
    final filterData = TypeDataList.filter(context);
    final arrangeData = TypeDataList.arrange(context);
    final addClosetData = TypeDataList.addCloset(context);
    final publicClosetData = TypeDataList.publicCloset(context);
    final currentStreakData = TypeDataList.currentStreak(context);
    final highestStreakData = TypeDataList.highestStreak(context);
    final costOfNewItemsData = TypeDataList.costOfNewItems(context);
    final numberOfNewItemsData = TypeDataList.numberOfNewItems(context);

    return Theme(
      data: widget.myClosetTheme,
      child: MyClosetBlocListeners(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(appBarHeight),
            child: AppBar(
              title: Text(
                S
                    .of(context)
                    .myClosetTitle,
                style: widget.myClosetTheme.textTheme.titleMedium,
              ),
              automaticallyImplyLeading: true,
              backgroundColor: widget.myClosetTheme.appBarTheme.backgroundColor,
            ),
          ),
          drawer: AppDrawer(isFromMyCloset: true),
          backgroundColor: widget.myClosetTheme.colorScheme.surface,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [

                /// UploadStreakBloc just for this section
                BlocBuilder<UploadStreakBloc, UploadStreakState>(
                  builder: (context, uploadStreakState) {
                    if (uploadStreakState is UploadStreakLoading) {
                      return const ClosetProgressIndicator();
                    }

                    if (uploadStreakState is UploadStreakSuccess) {
                      return MyClosetContainer(
                        theme: widget.myClosetTheme,
                        apparelCount: uploadStreakState.apparelCount,
                        uploadData: uploadData,
                        filterData: filterData,
                        arrangeData: arrangeData,
                        addClosetData: addClosetData,
                        publicClosetData: publicClosetData,
                        itemUploadData: itemUploadData,
                        currentStreakData: uploadStreakState.isUploadCompleted
                            ? currentStreakData
                                                                                                                                                                     : null,
                        highestStreakData: uploadStreakState.isUploadCompleted
                            ? highestStreakData
                            : null,
                        costOfNewItemsData: uploadStreakState.isUploadCompleted
                            ? costOfNewItemsData
                            : null,
                        numberOfNewItemsData: uploadStreakState
                            .isUploadCompleted ? numberOfNewItemsData : null,
                        currentStreakCount: uploadStreakState
                            .currentStreakCount,
                        highestStreakCount: uploadStreakState
                            .highestStreakCount,
                        newItemsCost: uploadStreakState.newItemsCost,
                        newItemsCount: uploadStreakState.newItemsCount,
                        isUploadCompleted: uploadStreakState.isUploadCompleted,
                        onUploadButtonPressed: _onUploadButtonPressed,
                        onUploadCompletedButtonPressed: _onUploadCompletedButtonPressed,
                        onFilterButtonPressed: () =>
                            _onFilterButtonPressed(context, true),
                        onArrangeButtonPressed: () =>
                            _onArrangeButtonPressed(context, true),
                        onMultiClosetButtonPressed: () =>
                            _onMultiClosetButtonPressed(context, true),
                        onPublicClosetButtonPressed: _onPublicClosetButtonPressed,
                      );
                    }

                    return const SizedBox.shrink(); // Default fallback
                  },
                ),

                /// ViewItemsBloc + CrossAxisCountCubit for Interactive Grid
                Expanded(
                  child: BlocBuilder<CrossAxisCountCubit, int>(
                    builder: (_, crossAxisCount) {
                      return InteractiveItemGrid(
                        usePagination: true,
                        crossAxisCount: crossAxisCount,
                        selectedItemIds: const [],
                        itemSelectionMode: ItemSelectionMode.action,
                        enablePricePerWear: false,
                        enableItemName: true,
                        isOutfit: false,
                        isLocalImage: false,
                        onAction: () => _onItemSelected(context),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: _showFab
              ? FloatingActionButton(
            onPressed: _onPhotoButtonPressed,
            backgroundColor: widget.myClosetTheme.colorScheme.primary,
            child: const Icon(Icons.camera_alt, size: 30),
          )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
          bottomNavigationBar: MainBottomNavBar(
            currentIndex: _selectedIndex,
            isFromMyCloset: true,
          ),
        ),
      ),
    );
  }
}
