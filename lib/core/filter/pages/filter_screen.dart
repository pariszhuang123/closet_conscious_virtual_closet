import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../generated/l10n.dart';
import '../presentation/bloc/filter_bloc.dart';
import '../presentation/widgets/tab/single_selection_tab.dart';
import '../presentation/widgets/tab/multi_selection_tab.dart';
import '../../theme/my_closet_theme.dart';
import '../../theme/my_outfit_theme.dart';
import '../../widgets/button/themed_elevated_button.dart';
import '../../utilities/logger.dart';
import '../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../core_enums.dart';
import '../../utilities/routes.dart';
import '../../paywall/data/feature_key.dart';

class FilterScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final List<String> selectedItemIds;

  // Initialize logger for FilterScreen
  final CustomLogger _logger = CustomLogger('FilterScreen');

  FilterScreen({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds,
  }) {
    _logger.i('FilterScreen initialized with isFromMyCloset: $isFromMyCloset, selectedItemIds: $selectedItemIds');
  }

  @override
  Widget build(BuildContext context) {
    context.read<FilterBloc>().add(CheckFilterAccessEvent());
    context.read<FilterBloc>().add(CheckMultiClosetFeatureEvent());
    // Select theme based on isFromMyCloset
    ThemeData theme = isFromMyCloset ? myClosetTheme : myOutfitTheme;
    _logger.d('Theme selected: ${isFromMyCloset ? "myClosetTheme" : "myOutfitTheme"}');

    return DefaultTabController(
      length: 2,
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).filterItemsTitle, style: theme.textTheme.titleLarge),
            bottom: TabBar(
              tabs: [
                Tab(text: S.of(context).basicFiltersTab),
                Tab(text: S.of(context).advancedFiltersTab),
              ],
            ),
            actions: [
              // Refresh Icon Button
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: S.of(context).resetToDefault,
                onPressed: () {
                  _logger.i('Refresh Filters button pressed');
                  context.read<FilterBloc>().add(ResetFilterEvent());
                },
              ),
            ],
          ),
          body: BlocListener<FilterBloc, FilterState>(
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
              // Handle denied access state
              if (state.accessStatus == AccessStatus.denied) {
                _logger.i('AccessStatus: denied, navigating to payment screen');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.filter, // Use a relevant feature key
                    'isFromMyCloset': isFromMyCloset,
                    'previousRoute': isFromMyCloset ? AppRoutes.myCloset : AppRoutes.createOutfit,
                    'nextRoute': AppRoutes.filter,
                  },
                );
              }
            },
            child: BlocBuilder<FilterBloc, FilterState>(
              builder: (context, state) {
                if (state.saveStatus == SaveStatus.inProgress) {
                  return const ClosetProgressIndicator(); // Use custom ClosetProgressIndicator
                } else if (state.saveStatus == SaveStatus.failure) {
                  return const ClosetProgressIndicator();
                }

                return Column(
                  children: [
                    // TabBarView takes available space above the button
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleSelectionTab(state: state),
                          MultiSelectionTab(state: state),
                        ],
                      ),
                    ),
                    // Save Filter Button using ThemedElevatedButton
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ThemedElevatedButton(
                        onPressed: () {
                          _logger.i('Save Filter button pressed');
                          context.read<FilterBloc>().add(SaveFilterEvent());
                        },
                        text: S.of(context).saveFilter,
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
