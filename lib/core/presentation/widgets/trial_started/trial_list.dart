import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/button/navigation_type_button.dart';
import '../../bloc/trial_bloc/trial_bloc.dart';
import '../../../data/type_data.dart';
import '../../../core_enums.dart';
import '../../../utilities/helper_functions/trial_helper/trial_state_mapper.dart';
import '../../../utilities/helper_functions/trial_helper/get_trial_explainer.dart';
import '../../../utilities/helper_functions/core/onboarding_journey_type_helper.dart';
import '../../../presentation/bloc/personalization_flow_cubit/personalization_flow_cubit.dart';

class TrialList extends StatelessWidget {
  final bool isFromMyCloset;

  const TrialList({super.key, required this.isFromMyCloset});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrialBloc, TrialState>(
      builder: (context, state) {
        List<TypeData> deniedFeatures = [];

        if (state is AccessFilterFeatureDenied) {
          deniedFeatures.add(TypeDataList.filter(context));
        }
        if (state is AccessMultiClosetFeatureDenied) {
          deniedFeatures.add(TypeDataList.addCloset(context));
        }
        if (state is AccessCustomizeFeatureDenied) {
          deniedFeatures.add(TypeDataList.arrange(context));
        }
        if (state is AccessCalendarFeatureDenied) {
          deniedFeatures.add(TypeDataList.calendar(context));
        }
        if (state is AccessOutfitCreationFeatureDenied) {
          deniedFeatures.add(TypeDataList.outfitsUpload(context));
        }
        if (state is AccessUsageAnalyticsFeatureDenied) {
          deniedFeatures.add(TypeDataList.drawerInsights(context));
        }
        if (state is TrialAccessDenied) {
          deniedFeatures.addAll(state.deniedStates.map((deniedState) {
            return mapDeniedStateToTypeData(deniedState, context);
          }).toList());
        }

        if (deniedFeatures.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: deniedFeatures
              .map((typeData) => _buildTrialPoint(typeData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildTrialPoint(TypeData typeData, BuildContext context) {
    final theme = Theme.of(context);
    final flowString = context.watch<PersonalizationFlowCubit>().state;
    final flowType = flowString.toOnboardingJourneyType();

    final explanation = getFlowSpecificTrialExplanation(
      flowType: flowType,
      typeData: typeData,
      context: context,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationTypeButton(
            label: '',
            selectedLabel: '',
            assetPath: typeData.assetPath,
            isFromMyCloset: isFromMyCloset,
            usePredefinedColor: false,
            buttonType: ButtonType.secondary,
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeData.getName(context),
                  style: theme.textTheme.titleMedium,
                ),
                Text(
                  explanation,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}