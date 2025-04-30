import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../bloc/view_multi_closet_bloc.dart';
import '../../../../../core/filter/presentation/widgets/tab/single_selection_tab/closet_grid_widget.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../../core/data/type_data.dart';
import '../widgets/multi_closet_navigation_buttons.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import 'view_multi_closet_listeners.dart';

class ViewMultiClosetScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final CustomLogger logger = CustomLogger('ViewMultiClosetScreen');

  ViewMultiClosetScreen({
    super.key,
    required this.isFromMyCloset,
  });

  @override
  Widget build(BuildContext context) {
    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
    context.read<ViewMultiClosetBloc>().add(FetchViewMultiClosetsEvent());
    context.read<MultiClosetNavigationBloc>().add(CheckMultiClosetAccessEvent());
    context.read<TutorialBloc>().add(
      const CheckTutorialStatus(TutorialType.paidMultiCloset),
    );

    final createClosetTypeData = TypeDataList.createCloset(context);
    final allClosetsTypeData = TypeDataList.allClosets(context);

    logger.i('Building ViewMultiClosetScreen');

    return ViewMultiClosetListeners(
      isFromMyCloset: isFromMyCloset,
      logger: logger,
      child: Column(
        children: [
          MultiClosetNavigationButtons(
            createClosetTypeData: createClosetTypeData,
            allClosetsTypeData: allClosetsTypeData,
            isFromMyCloset: isFromMyCloset,
            logger: logger,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<CrossAxisCountCubit, int>(
              builder: (context, crossAxisCount) {
                if (crossAxisCount == 0) {
                  return const Center(child: ClosetProgressIndicator());
                }

                return BlocBuilder<ViewMultiClosetBloc, ViewMultiClosetState>(
                  builder: (context, state) {
                    if (state is ViewMultiClosetsLoading || state is ViewMultiClosetsInitial) {
                      return const Center(child: ClosetProgressIndicator());
                    } else if (state is ViewMultiClosetsLoaded) {
                      return ClosetGridWidget(
                        closets: state.closets,
                        selectedClosetId: '',
                        crossAxisCount: crossAxisCount,
                        onSelectCloset: (closetId) {
                          context.read<MultiClosetNavigationBloc>().add(
                            NavigateToEditSingleMultiCloset(closetId),
                          );
                        },
                      );
                    } else if (state is ViewMultiClosetsError) {
                      return Center(child: Text(state.error));
                    }

                    return Center(child: Text(S.of(context).noClosetsFound));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
