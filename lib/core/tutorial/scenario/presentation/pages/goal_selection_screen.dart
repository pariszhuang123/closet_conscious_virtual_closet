import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/button/navigation_type_button.dart';
import '../../../../widgets/container/base_container.dart';
import '../../../../../generated/l10n.dart';
import '../../../../core_enums.dart';
import '../../../../data/type_data.dart';
import '../../../../utilities/app_router.dart';
import '../../../../utilities/helper_functions/tutorial_helper.dart';
import '../bloc/first_time_scenario_bloc.dart';

class GoalSelectionScreen extends StatelessWidget {
  const GoalSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TutorialType? selectedGoal; // local variable

    final goals = [
      (
      type: TutorialType.flowIntroPersonalStyle,
      data: TypeDataList.personalStyle(context),
      ),
      (
      type: TutorialType.flowIntroLifeChange,
      data: TypeDataList.lifeChange(context),
      ),
      (
      type: TutorialType.flowIntroMemory,
      data: TypeDataList.parentMemories(context),
      ),
    ];

    return BlocListener<FirstTimeScenarioBloc, FirstTimeScenarioState>(
      listener: (context, state) {
        if (state is SaveFlowSuccess) {
          context.goNamed(
            AppRoutesName.tutorialVideoPopUp,
            extra: {
              'tutorialInputKey': state.selectedGoal.value,
              'nextRoute': AppRoutesName.myCloset,
              'isFromMyCloset': true,
            },
          );
        }
        else if (state is SaveFlowFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).upload_failed)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).whyAreYouHereToday),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                S.of(context).tailorExperience,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return BaseContainer(
                      theme: theme,
                      child: NavigationTypeButton(
                        label: goal.data.getName(context),
                        selectedLabel: goal.data.getName(context),
                        onPressed: () {
                          selectedGoal = goal.type;

                          final onboardingType = switch (goal.type) {
                            TutorialType.flowIntroPersonalStyle =>
                            OnboardingJourneyType.personalStyleFlow,
                            TutorialType.flowIntroLifeChange =>
                            OnboardingJourneyType.lifeChangeFlow,
                            TutorialType.flowIntroMemory =>
                            OnboardingJourneyType.memoryFlow,
                            _ => OnboardingJourneyType.defaultFlow,
                          };

                          context.read<FirstTimeScenarioBloc>().add(
                            SavePersonalizationFlowTypeEvent(onboardingType),
                          );
                        },
                        assetPath: goal.data.assetPath,
                        isFromMyCloset: true,
                        buttonType: ButtonType.primary,
                        usePredefinedColor: false,
                        isSelected: selectedGoal == goal.type,
                        isHorizontal: false,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
