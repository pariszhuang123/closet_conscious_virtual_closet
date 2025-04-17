import 'dart:async';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/l10n.dart';
import '../../../core_enums.dart';
import '../../../presentation/bloc/personalization_flow_cubit/personalization_flow_cubit.dart';
import '../../data/models/achievement_registry.dart';
import '../../data/models/achievement_definition_model.dart';
import '../../../utilities/helper_functions/core/onboarding_journey_type_helper.dart';
import '../../../utilities/logger.dart';

class AchievementCompletedScreen extends StatefulWidget {
  final String achievementKey;
  final String achievementUrl;
  final String nextRoute;

  const AchievementCompletedScreen({
    super.key,
    required this.achievementKey,
    required this.achievementUrl,
    required this.nextRoute,
  });

  @override
  State<AchievementCompletedScreen> createState() => _AchievementCompletedScreenState();
}

class _AchievementCompletedScreenState extends State<AchievementCompletedScreen> {
  late ConfettiController _confettiController;
  final _logger = CustomLogger('AchievementCompletedScreen');

  @override
  void initState() {
    super.initState();
    _logger.i('Initializing AchievementCompletedScreen for key: ${widget.achievementKey}');

    _confettiController = ConfettiController(duration: const Duration(seconds: 3))..play();
    _logger.i('Confetti started');

    Timer(const Duration(seconds: 5), () {
      _logger.i('Navigating to next route: ${widget.nextRoute}');
      context.goNamed(widget.nextRoute);
    });
  }

  @override
  void dispose() {
    _logger.i('Disposing confetti controller');
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = S.of(context);

    return BlocBuilder<PersonalizationFlowCubit, String>(
      builder: (context, flowString) {
        final flow = flowString.toOnboardingJourneyType();
        _logger.d('Detected onboarding flow: $flow');

        final AchievementDefinition def = achievements.firstWhere(
              (a) => a.key == widget.achievementKey,
        );

        final titleGetter = def.titleL10nGetters[flow] ?? def.titleL10nGetters[OnboardingJourneyType.defaultFlow];
        final msgGetter = def.msgL10nGetters[flow] ?? def.msgL10nGetters[OnboardingJourneyType.defaultFlow];

        final achievementTitle = titleGetter!(l10n);
        final achievementMessage = msgGetter!(l10n);

        _logger.d('Resolved achievement title: "$achievementTitle"');
        _logger.d('Resolved achievement message: "$achievementMessage"');

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (_, __) {},
          child: Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  colors: const [Colors.blue, Colors.lightGreenAccent, Colors.teal],
                  numberOfParticles: 30,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.congratulations,
                          style: theme.textTheme.displayLarge,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          achievementTitle,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 20),
                        Lottie.asset('assets/lottie/tasty.json', height: 75),
                        const SizedBox(height: 20),
                        Image.network(widget.achievementUrl, height: 100, fit: BoxFit.contain),
                        const SizedBox(height: 20),
                        Text(
                          achievementMessage,
                          style: theme.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
