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
import '../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../core_enums.dart';
import '../../../utilities/logger.dart';
import '../../../utilities/app_router.dart';
import '../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../widgets/tab/single_selection_tab/all_closet_toggle.dart';
import '../widgets/tab/single_selection_tab/closet_grid_widget.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import 'filter_screen_listeners.dart';
import '../../../widgets/layout/base_layout/safe_redirect_scaffold.dart';
import '../../../utilities/helper_functions/tutorial_helper.dart';

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

  bool hasStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FilterBloc>().add(const FilterStarted());
      context.read<TutorialBloc>().add(const CheckTutorialStatus(TutorialType.paidFilter));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;
    _logger.d('Selected theme: ${widget.isFromMyCloset ? "Closet" : "Outfit"}');

    return BlocBuilder<TutorialBloc, TutorialState>(
        builder: (context, tutorialState) {
      if (tutorialState is ShowTutorial) {
        return SafeRedirectScaffold(
          onRedirect: () {
            context.goNamed(
              AppRoutesName.tutorialVideoPopUp,
              extra: {
                'nextRoute': AppRoutesName.filter,
                'tutorialInputKey': TutorialType.paidFilter.value,
                'isFromMyCloset': widget.isFromMyCloset,
              },
            );
          },
        );
      }

      return BlocBuilder<FilterBloc, FilterState>(
        builder: (context, state) {
          if (state.accessStatus == AccessStatus.trialPending) {
            return SafeRedirectScaffold(
              onRedirect: () {
                context.goNamed(
                  AppRoutesName.trialStarted,
                  extra: {
                    'selectedFeatureRoute': AppRoutesName.filter,
                    'isFromMyCloset': widget.isFromMyCloset,
                  },
                );
              },
            );
          }

          if (state.accessStatus == AccessStatus.denied) {
            return SafeRedirectScaffold(
              onRedirect: () {
                context.goNamed(
                  AppRoutesName.payment,
                  extra: {
                    'featureKey': FeatureKey.filter,
                    'isFromMyCloset': widget.isFromMyCloset,
                    'previousRoute': widget.isFromMyCloset
                        ? AppRoutesName.myCloset
                        : AppRoutesName.createOutfit,
                    'nextRoute': AppRoutesName.filter,
                  },
                );
              },
            );
          }

        return Theme(
          data: theme,
          child: FilterScreenListeners(
            isFromMyCloset: widget.isFromMyCloset,
            returnRoute: widget.returnRoute,
            selectedItemIds: widget.selectedItemIds,
            selectedOutfitIds: widget.selectedOutfitIds,
            showOnlyClosetFilter: widget.showOnlyClosetFilter,
            logger: _logger,
            child: PopScope(
              canPop: true,
              onPopInvokedWithResult: (didPop, result) {
                _logger.i('Pop invoked: $didPop → $result');
                if (!didPop) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.goNamed(
                      widget.isFromMyCloset
                          ? AppRoutesName.myCloset
                          : AppRoutesName.createOutfit,
                    );
                  });
                }
              },
              child: DefaultTabController(
                length: widget.showOnlyClosetFilter ? 1 : 2,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: BackButton(onPressed: () {
                      final navigator = Navigator.of(context);
                      if (navigator.canPop()) {
                        navigator.pop();
                      } else {
                        context.goNamed(
                          widget.isFromMyCloset
                              ? AppRoutesName.myCloset
                              : AppRoutesName.createOutfit,
                        );
                      }
                    }),
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
                  body: BlocBuilder<FilterBloc, FilterState>(
                    builder: (context, state) {
                      if (state.saveStatus == SaveStatus.inProgress ||
                          state.saveStatus == SaveStatus.initial ||
                          state.saveStatus == SaveStatus.failure) {
                        return Center(
                          child: widget.isFromMyCloset
                              ? const ClosetProgressIndicator()
                              : const OutfitProgressIndicator(),
                        );
                      }

                      return Column(
                        children: [
                          if (widget.showOnlyClosetFilter) ...[
                            const SizedBox(height: 20),
                            if (state.hasMultiClosetFeature)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: AllClosetToggle(
                                  isAllCloset: state.allCloset,
                                  onChanged: (val) {
                                    context.read<FilterBloc>().add(UpdateFilterEvent(allCloset: val));
                                  },
                                ),
                              ),
                            const SizedBox(height: 20),
                            if (state.hasMultiClosetFeature && !state.allCloset)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: BlocBuilder<CrossAxisCountCubit, int>(
                                    builder: (context, count) => ClosetGridWidget(
                                      closets: state.allClosetsDisplay,
                                      selectedClosetId: state.selectedClosetId,
                                      onSelectCloset: (id) {
                                        context.read<FilterBloc>().add(UpdateFilterEvent(selectedClosetId: id));
                                      },
                                      crossAxisCount: count,
                                    ),
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
                            padding: const EdgeInsets.all(16),
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
      },
    );
  });
  }
}
