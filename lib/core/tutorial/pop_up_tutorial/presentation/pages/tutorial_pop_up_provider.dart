import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/bloc/tutorial_bloc.dart';
import 'tutorial_pop_up_screen.dart';
import '../../../../data/services/core_fetch_services.dart';
import '../../../../data/services/core_save_services.dart';

class TutorialPopUpProvider extends StatelessWidget {
  final String tutorialInputKey;
  final String nextRoute;
  final bool isFromMyCloset;

  const TutorialPopUpProvider({
    super.key,
    required this.tutorialInputKey,
    required this.nextRoute,
    required this.isFromMyCloset,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TutorialBloc(
        fetchService: CoreFetchService(),
        saveService: CoreSaveService(),
      ),
      child: TutorialPopUpScreen(
        tutorialInputKey: tutorialInputKey,
        nextRoute: nextRoute,
        isFromMyCloset: isFromMyCloset,
      ),
    );
  }
}
