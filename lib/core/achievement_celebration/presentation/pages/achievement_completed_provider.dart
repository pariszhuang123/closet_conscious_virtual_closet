import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../presentation/bloc/personalization_flow_cubit/personalization_flow_cubit.dart';
import 'achievement_completed_screen.dart';
import '../../../data/services/core_fetch_services.dart';

class AchievementCompletedProvider extends StatelessWidget {
  final String achievementKey;
  final String achievementUrl;
  final String nextRoute;

  const AchievementCompletedProvider({
    super.key,
    required this.achievementKey,
    required this.achievementUrl,
    required this.nextRoute,
  });

  @override
  Widget build(BuildContext context) {
    final coreFetchService = GetIt.instance<CoreFetchService>();

    return BlocProvider(
      create: (_) => PersonalizationFlowCubit(coreFetchService: coreFetchService)
        ..fetchPersonalizationFlowType(),
      child: AchievementCompletedScreen(
        achievementKey: achievementKey,
        achievementUrl: achievementUrl,
        nextRoute: nextRoute,
      ),
    );
  }
}
