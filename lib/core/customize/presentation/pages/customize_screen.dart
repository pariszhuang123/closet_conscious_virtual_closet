import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../presentation/bloc/customize_bloc.dart';
import '../../../core_enums.dart';
import '../../../data/type_data.dart';
import '../../../widgets/layout/icon_selection/icon_row_builder.dart';
import '../../../../generated/l10n.dart';
import '../../../theme/my_closet_theme.dart';
import '../../../theme/my_outfit_theme.dart';
import '../../../widgets/button/themed_elevated_button.dart';
import '../../../utilities/app_router.dart';
import '../../../utilities/logger.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import 'customize_screen_listeners.dart';

class CustomizeScreen extends StatefulWidget {
  final bool isFromMyCloset;
  final List<String> selectedItemIds;
  final String returnRoute;

  const CustomizeScreen({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds,
    required this.returnRoute,
  });

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  final CustomLogger _logger = CustomLogger('CustomizeScreen');

  @override
  void initState() {
    super.initState();
    _logger.i('CustomizeScreen initState');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CustomizeBloc>().add(const CustomizeStarted());
      context.read<TutorialBloc>().add(
        const CheckTutorialStatus(TutorialType.paidCustomize),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;

    return Theme(
      data: theme,
      child: CustomizeScreenListeners(
        isFromMyCloset: widget.isFromMyCloset,
        returnRoute: widget.returnRoute,
        selectedItemIds: widget.selectedItemIds,
        logger: _logger,
        child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            _logger.i('Pop invoked: didPop = $didPop, result = $result');
            if (!didPop) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(
                  widget.isFromMyCloset ? AppRoutesName.myCloset : AppRoutesName.createOutfit,
                );
              });
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: BackButton(
                onPressed: () {
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) {
                    _logger.i('Navigator can pop, popping');
                    navigator.pop();
                  } else {
                    _logger.i('Navigator cannot pop, fallback');
                    context.goNamed(
                      widget.isFromMyCloset ? AppRoutesName.myCloset : AppRoutesName.createOutfit,
                    );
                  }
                },
              ),
              title: Text(S.of(context).customizeClosetView, style: theme.textTheme.titleMedium),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: S.of(context).resetToDefault,
                  onPressed: () {
                    _logger.i('Reset to Default pressed');
                    context.read<CustomizeBloc>().add(ResetCustomizeEvent());
                  },
                ),
              ],
            ),
            body: BlocBuilder<CustomizeBloc, CustomizeState>(
              builder: (context, state) {
                if (state.saveStatus == SaveStatus.inProgress ||
                    state.saveStatus == SaveStatus.initial ||
                    state.saveStatus == SaveStatus.failure) {
                  _logger.i('Showing loading spinner based on isFromMyCloset');

                  return Center(
                    child: widget.isFromMyCloset
                        ? const ClosetProgressIndicator()
                        : const OutfitProgressIndicator(),
                  );
                }

                return Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(S.of(context).gridSizePickerTitle, style: theme.textTheme.titleMedium),
                    ...buildIconRows(
                      TypeDataList.gridSizes(context),
                      [state.gridSize.toString()],
                          (selectedKeys) {
                        final selectedKey = selectedKeys.first;
                        context.read<CustomizeBloc>().add(UpdateCustomizeEvent(gridSize: int.parse(selectedKey)));
                      },
                      context,
                      widget.isFromMyCloset,
                      false,
                    ),
                    const SizedBox(height: 16),
                    Text(S.of(context).sortCategoryPickerTitle, style: theme.textTheme.titleMedium),
                    ...buildIconRows(
                      TypeDataList.sortCategories(context),
                      [state.sortCategory],
                          (selectedKeys) {
                        final selectedKey = selectedKeys.first;
                        context.read<CustomizeBloc>().add(UpdateCustomizeEvent(sortCategory: selectedKey));
                      },
                      context,
                      widget.isFromMyCloset,
                      false,
                    ),
                    const SizedBox(height: 16),
                    Text(S.of(context).sortOrderPickerTitle, style: theme.textTheme.titleMedium),
                    ...buildIconRows(
                      TypeDataList.sortOrder(context),
                      [state.sortOrder],
                          (selectedKeys) {
                        final selectedKey = selectedKeys.first;
                        context.read<CustomizeBloc>().add(UpdateCustomizeEvent(sortOrder: selectedKey));
                      },
                      context,
                      widget.isFromMyCloset,
                      false,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ThemedElevatedButton(
                        onPressed: () {
                          _logger.i('Save customization pressed');
                          context.read<CustomizeBloc>().add(SaveCustomizeEvent());
                        },
                        text: S.of(context).saveCustomization,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
