import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../presentation/bloc/customize_bloc.dart';
import '../../core_enums.dart';
import '../../data/type_data.dart';
import '../../widgets/layout/icon_row_builder.dart';
import '../../../generated/l10n.dart';
import '../../theme/my_closet_theme.dart';
import '../../theme/my_outfit_theme.dart';
import '../../widgets/button/themed_elevated_button.dart';
import '../../utilities/routes.dart';
import '../../utilities/logger.dart';
import '../../paywall/data/feature_key.dart';

class CustomizeScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final List<String> selectedItemIds;

  // Initialize logger for CustomizeScreen
  final CustomLogger _logger = CustomLogger('CustomizeScreen');

  CustomizeScreen({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds,
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
          title: Text(S.of(context).customizeClosetView, style: theme.textTheme.titleLarge),
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
              _logger.i('SaveStatus: saveSuccess, navigating to appropriate screen');
              // Navigate based on isFromMyCloset
              if (isFromMyCloset) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.myCloset);
              } else {
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.createOutfit,
                  arguments: {'selectedItemIds': selectedItemIds},
                );
              }
            }
            if (state.accessStatus == AccessStatus.denied) {
              _logger.i('AccessStatus: denied, navigating to payment screen');
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.payment,
                arguments: {
                  'featureKey': FeatureKey.customize, // Pass necessary data
                  'isFromMyCloset': isFromMyCloset,
                  'previousRoute': isFromMyCloset ? AppRoutes.myCloset : AppRoutes.createOutfit,
                  'nextRoute': AppRoutes.customize,
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
                    state.gridSize.toString(),
                        (selectedKey) {
                      _logger.d('Grid Size Picker selected: $selectedKey');
                      context.read<CustomizeBloc>().add(
                        UpdateCustomizeEvent(gridSize: int.parse(selectedKey)),
                      );
                    },
                    context,
                    isFromMyCloset,
                  ),
                  const SizedBox(height: 16),

                  // Title for Sort Category Picker
                  Text(S.of(context).sortCategoryPickerTitle, style: theme.textTheme.titleMedium),
                  // Sort Category Picker using buildIconRows
                  ...buildIconRows(
                    TypeDataList.sortCategories(context),
                    state.sortCategory,
                        (selectedKey) {
                      _logger.d('Sort Category Picker selected: $selectedKey');
                      context.read<CustomizeBloc>().add(
                        UpdateCustomizeEvent(sortCategory: selectedKey),
                      );
                    },
                    context,
                    isFromMyCloset,
                  ),
                  const SizedBox(height: 16),

                  // Title for Sort Order Picker
                  Text(S.of(context).sortOrderPickerTitle, style: theme.textTheme.titleMedium),
                  // Sort Order Picker using buildIconRows
                  ...buildIconRows(
                    TypeDataList.sortOrder(context),
                    state.sortOrder,
                        (selectedKey) {
                      _logger.d('Sort Order Picker selected: $selectedKey');
                      context.read<CustomizeBloc>().add(
                        UpdateCustomizeEvent(sortOrder: selectedKey),
                      );
                    },
                    context,
                    isFromMyCloset,
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
