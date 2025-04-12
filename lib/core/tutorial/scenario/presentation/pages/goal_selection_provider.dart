import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/core_fetch_services.dart';
import '../../../../data/services/core_save_services.dart';
import '../bloc/first_time_scenario_bloc.dart';
import 'goal_selection_screen.dart';

class GoalSelectionProvider extends StatelessWidget {
  const GoalSelectionProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FirstTimeScenarioBloc(
        coreFetchService: CoreFetchService(),
        coreSaveService: CoreSaveService(),
      ),
      child: const GoalSelectionScreen(),
    );
  }
}
