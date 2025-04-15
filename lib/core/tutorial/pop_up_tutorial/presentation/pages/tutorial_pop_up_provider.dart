import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/bloc/tutorial_bloc.dart';
import 'tutorial_pop_up_screen.dart';
import '../../../../data/services/core_fetch_services.dart';
import '../../../../data/services/core_save_services.dart';
import '../../../../presentation/bloc/personalization_flow_cubit/personalization_flow_cubit.dart';

class TutorialPopUpProvider extends StatelessWidget {
  final String tutorialInputKey;
  final String nextRoute;
  final bool isFromMyCloset;
  final String? itemId;

  const TutorialPopUpProvider({
    super.key,
    required this.tutorialInputKey,
    required this.nextRoute,
    required this.isFromMyCloset,
    this.itemId, // ✅ optional param

  });

  @override
  Widget build(BuildContext context) {
    final coreFetchService = CoreFetchService();
    final coreSaveService = CoreSaveService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TutorialBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          ),
        ),
        BlocProvider(
          create: (_) => PersonalizationFlowCubit(coreFetchService: coreFetchService)
            ..fetchPersonalizationFlowType(),
        ),
      ],
      child: TutorialPopUpScreen(
        tutorialInputKey: tutorialInputKey,
        nextRoute: nextRoute,
        isFromMyCloset: isFromMyCloset,
        itemId: itemId, // ✅ forward it
      ),
    );
  }
}
