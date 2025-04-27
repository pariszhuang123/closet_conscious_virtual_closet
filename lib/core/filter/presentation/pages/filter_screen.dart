import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../presentation/bloc/filter_bloc.dart';
import '../../presentation/widgets/tab/single_selection_tab.dart';
import '../../presentation/widgets/tab/multi_selection_tab.dart';
import '../../../theme/my_closet_theme.dart';
import '../../../theme/my_outfit_theme.dart';
import '../../../widgets/button/themed_elevated_button.dart';
import '../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../core_enums.dart';
import '../../../utilities/logger.dart';
import '../../../utilities/app_router.dart';
import '../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../widgets/tab/single_selection_tab/all_closet_toggle.dart';
import '../widgets/tab/single_selection_tab/closet_grid_widget.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';

class FilterScreen extends StatefulWidget {
  final bool isFromMyCloset;
  final List<String> selectedItemIds;
  final List<String> selectedOutfitIds;
  final String returnRoute;
  final bool showOnlyClosetFilter;

  const FilterScreen({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds,
    required this.selectedOutfitIds,
    required this.returnRoute,
    required this.showOnlyClosetFilter,
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final CustomLogger _logger = CustomLogger('FilterScreen');

  @override
  void initState() {
    super.initState();

    _logger.i(
        'FilterScreen initState with isFromMyCloset: ${widget.isFromMyCloset}, selectedItemIds: ${widget.selectedItemIds}, showOnlyClosetFilter: ${widget.showOnlyClosetFilter}');

    context.read<FilterBloc>().add(CheckFilterAccessEvent());
    context.read<FilterBloc>().add(CheckMultiClosetFeatureEvent());

    // 👇 Your desired tutorial event
    context.read<TutorialBloc>().add(
      const CheckTutorialStatus(TutorialType.paidFilter),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;
    _logger.d('Selected theme: ${widget.isFromMyCloset ? "Closet" : "Outfit"}');

    return Theme(
      data: theme,
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
        child: DefaultTabController(
          length: widget.showOnlyClosetFilter ? 1 : 2,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: BackButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) {
                    _logger.i('Navigator can pop, popping');
                    navigator.pop();
                  } else {
                    _logger.i('Navigator cannot pop, fallback navigation');
                    context.goNamed(
                      widget.isFromMyCloset ? AppRoutesName.myCloset : AppRoutesName.createOutfit,
                    );
                  }
                },
              ),
              title: Text(
                S.of(context).filterItemsTitle,
                style: theme.textTheme.titleMedium,
              ),
              bottom: widget.showOnlyClosetFilter
                  ? null
                  : TabBar(
                tabs: [
                  Tab(text: S.of(context).basicFiltersTab),
                  Tab(text: S.of(context).advancedFiltersTab),
                ],
              ),
              actions: [
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
            body: MultiBlocListener(
              listeners: [
                BlocListener<FilterBloc, FilterState>(
                  listener: (context, state) {
                    if (state.saveStatus == SaveStatus.saveSuccess) {
                      _logger.i('Save success, navigating back to ${widget.returnRoute}');
                      context.goNamed(
                        widget.returnRoute,
                        extra: {
                          'selectedItemIds': widget.selectedItemIds,
                          'selectedOutfitIds': widget.selectedOutfitIds,
                        },
                      );
                    } else if (state.accessStatus == AccessStatus.trialPending) {
                      _logger.i('Trial pending, navigating to trialStarted');
                      context.goNamed(
                        AppRoutesName.trialStarted,
                        extra: {
                          'selectedFeatureRoute': AppRoutesName.filter,
                          'isFromMyCloset': widget.isFromMyCloset,
                        },
                      );
                    } else if (state.accessStatus == AccessStatus.denied) {
                      _logger.i('Access denied, navigating to payment');
                      context.goNamed(
                        AppRoutesName.payment,
                        extra: {
                          'featureKey': FeatureKey.filter,
                          'isFromMyCloset': widget.isFromMyCloset,
                          'previousRoute': widget.isFromMyCloset ? AppRoutesName.myCloset : AppRoutesName.createOutfit,
                          'nextRoute': AppRoutesName.filter,
                        },
                      );
                    }
                  },
                ),
                BlocListener<TutorialBloc, TutorialState>(
                  listener: (context, tutorialState) {
                    if (tutorialState is ShowTutorial) {
                      _logger.i('Showing tutorial popup');
                      context.goNamed(
                        AppRoutesName.tutorialVideoPopUp,
                        extra: {
                          'nextRoute': AppRoutesName.filter,
                          'tutorialInputKey': TutorialType.paidFilter.value,
                          'isFromMyCloset': widget.isFromMyCloset,
                        },
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<FilterBloc, FilterState>(
                builder: (context, state) {
                  if (state.saveStatus == SaveStatus.inProgress || state.saveStatus == SaveStatus.failure) {
                    return const ClosetProgressIndicator();
                  }

                  return Column(
                    children: [
                      if (widget.showOnlyClosetFilter) ...[
                        const SizedBox(height: 20),
                        if (state.hasMultiClosetFeature)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: AllClosetToggle(
                              isAllCloset: state.allCloset,
                              onChanged: (value) {
                                context.read<FilterBloc>().add(UpdateFilterEvent(allCloset: value));
                                _logger.i('UpdateFilterEvent dispatched: allCloset = $value');
                              },
                            ),
                          ),
                        const SizedBox(height: 20),
                        if (state.hasMultiClosetFeature && !state.allCloset)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: BlocBuilder<CrossAxisCountCubit, int>(
                                builder: (context, crossAxisCount) {
                                  return ClosetGridWidget(
                                    closets: state.allClosetsDisplay,
                                    selectedClosetId: state.selectedClosetId,
                                    onSelectCloset: (closetId) {
                                      context.read<FilterBloc>().add(UpdateFilterEvent(selectedClosetId: closetId));
                                      _logger.i('UpdateFilterEvent dispatched: selectedClosetId = $closetId');
                                    },
                                    crossAxisCount: crossAxisCount,
                                  );
                                },
                              ),
                            ),
                          ),
                      ] else ...[
                        Expanded(
                          child: TabBarView(
                            children: [
                              SingleSelectionTab(state: state),
                              MultiSelectionTab(
                                state: state,
                                isFromMyCloset: widget.isFromMyCloset,
                              ),
                            ],
                          ),
                        ),
                      ],
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
      ),
    );
  }
}
