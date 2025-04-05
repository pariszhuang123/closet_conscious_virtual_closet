import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../widgets/progress_indicator/closet_progress_indicator.dart';
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

class CustomizeScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final List<String> selectedItemIds;
  final String returnRoute;

  // Initialize logger for CustomizeScreen
  final CustomLogger _logger = CustomLogger('CustomizeScreen');

  CustomizeScreen({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds,
    required this.returnRoute,
  }) {
    _logger.i('CustomizeScreen initialized with isFromMyCloset: $isFromMyCloset, selectedItemIds: $selectedItemIds');
  }

  @override
  Widget build(BuildContext context) {
    context.read<CustomizeBloc>().add(CheckCustomizeAccessEvent());
    // Log theme selection
    ThemeData theme = isFromMyCloset ? myClosetTheme : myOutfitTheme;
    _logger.d('Theme selected: ${isFromMyCloset ? "myClosetTheme" : "myOutfitTheme"}');

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).customizeClosetView, style: theme.textTheme.titleMedium),
          actions: [
            // Reset to Default Icon Button
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: S.of(context).resetToDefault,
              onPressed: () {
                _logger.i('Reset to Default button pressed');
                context.read<CustomizeBloc>().add(ResetCustomizeEvent());
              },
            ),
          ],
        ),
        body: BlocListener<CustomizeBloc, CustomizeState>(
          listener: (context, state) {
            if (state.saveStatus == SaveStatus.saveSuccess) {
              _logger.i('SaveStatus: saveSuccess, navigating to returnRoute: $returnRoute');
              context.goNamed(
                returnRoute,
                extra: {'selectedItemIds': selectedItemIds},
              );
            }
            if (state.accessStatus == AccessStatus.trialPending) {
              _logger.i('Trial pending, navigating to trialStarted screen');

              context.goNamed(
                AppRoutesName.trialStarted,
                extra: {
                  'selectedFeatureRoute': AppRoutesName.customize, // ✅ Pass actual AppRoutes value
                  'isFromMyCloset': isFromMyCloset,
                },
              );
            }

            if (state.accessStatus == AccessStatus.denied) {
              _logger.i('AccessStatus: denied, navigating to payment screen');
              context.goNamed(
                AppRoutesName.payment,
                extra: {
                  'featureKey': FeatureKey.customize, // Pass necessary data
                  'isFromMyCloset': isFromMyCloset,
                  'previousRoute': isFromMyCloset ? AppRoutesName.myCloset : AppRoutesName.createOutfit,
                  'nextRoute': AppRoutesName.customize,
                },
              );
            }
          },
          child: BlocBuilder<CustomizeBloc, CustomizeState>(
            builder: (context, state) {
              if (state.saveStatus == SaveStatus.inProgress) {
                _logger.d('SaveStatus: inProgress, showing ClosetProgressIndicator');
                return const Center(child: ClosetProgressIndicator());
              }

              return Column(
                children: [
                  const SizedBox(height: 16),
                  // Title for Grid Size Picker
                  Text(S.of(context).gridSizePickerTitle, style: theme.textTheme.titleMedium),
                  // Grid Size Picker using buildIconRows
                  ...buildIconRows(
                    TypeDataList.gridSizes(context),
                    [state.gridSize.toString()],
                          (selectedKeys) {  // Updated to receive a List<String>
                        final selectedKey = selectedKeys.first;  // Use the first item from the list
                      _logger.d('Grid Size Picker selected: $selectedKey');
                      context.read<CustomizeBloc>().add(
                        UpdateCustomizeEvent(gridSize: int.parse(selectedKey)),
                      );
                    },
                    context,
                    isFromMyCloset,
                    false
                  ),
                  const SizedBox(height: 16),

                  // Title for Sort Category Picker
                  Text(S.of(context).sortCategoryPickerTitle, style: theme.textTheme.titleMedium),
                  // Sort Category Picker using buildIconRows
                  ...buildIconRows(
                    TypeDataList.sortCategories(context),
                    [state.sortCategory],
                          (selectedKeys) {  // Updated to receive a List<String>
                        final selectedKey = selectedKeys.first;  // Use the first item from the list
                      _logger.d('Sort Category Picker selected: $selectedKey');
                      context.read<CustomizeBloc>().add(
                        UpdateCustomizeEvent(sortCategory: selectedKey),
                      );
                    },
                    context,
                    isFromMyCloset,
                    false
                  ),
                  const SizedBox(height: 16),

                  // Title for Sort Order Picker
                  Text(S.of(context).sortOrderPickerTitle, style: theme.textTheme.titleMedium),
                  // Sort Order Picker using buildIconRows
                  ...buildIconRows(
                    TypeDataList.sortOrder(context),
                    [state.sortOrder],
                          (selectedKeys) {  // Updated to receive a List<String>
                        final selectedKey = selectedKeys.first;  // Use the first item from the list
                      _logger.d('Sort Order Picker selected: $selectedKey');
                      context.read<CustomizeBloc>().add(
                        UpdateCustomizeEvent(sortOrder: selectedKey),
                      );
                    },
                    context,
                    isFromMyCloset,
                    false
                  ),
                  const SizedBox(height: 24),

                  // Save Button using ThemedElevatedButton
                  Center(
                    child: ThemedElevatedButton(
                      onPressed: () {
                        _logger.i('Save Button pressed');
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
    );
  }
}
