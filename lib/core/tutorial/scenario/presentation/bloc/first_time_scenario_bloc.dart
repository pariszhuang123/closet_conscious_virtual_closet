import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/core_fetch_services.dart';
import '../../../../data/services/core_save_services.dart';
import '../../../../utilities/logger.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/helper_functions/core/onboarding_journey_type_helper.dart';

part 'first_time_scenario_event.dart';
part 'first_time_scenario_state.dart';

class FirstTimeScenarioBloc extends Bloc<FirstTimeScenarioEvent, FirstTimeScenarioState> {
  final CoreFetchService coreFetchService;
  final CoreSaveService coreSaveService;
  final CustomLogger _logger = CustomLogger('FirstTimeScenarioBloc');

  FirstTimeScenarioBloc({
    required this.coreFetchService,
    required this.coreSaveService,
  }) : super(FirstTimeInitial()) {
    on<CheckFirstTimeScenario>(_onCheckFirstTimeScenario);
    on<SavePersonalizationFlowTypeEvent>(_onSavePersonalizationFlowType);
  }

  Future<void> _onCheckFirstTimeScenario(
      CheckFirstTimeScenario event,
      Emitter<FirstTimeScenarioState> emit,
      ) async {
    _logger.i('Checking if this is the first-time scenario...');
    emit(FirstTimeCheckInProgress());
    try {
      final isFirstTime = await coreFetchService.isFirstTimeScenario();
      _logger.d('Is first time: $isFirstTime');
      emit(FirstTimeCheckSuccess(isFirstTime));
    } catch (e) {
      _logger.e('Error checking first-time scenario: $e');
      emit(FirstTimeCheckFailure());
    }
  }

  Future<void> _onSavePersonalizationFlowType(
      SavePersonalizationFlowTypeEvent event,
      Emitter<FirstTimeScenarioState> emit,
      ) async {
    final flowType = event.flowType;
    final selectedGoal = flowType.toTutorialType();

    _logger.i('📝 User selected flow type: $flowType → TutorialType: $selectedGoal');
    emit(FlowTypeSelected(selectedGoal));

    _logger.i('💾 Attempting to save flow type to Supabase...');
    try {
      final success = await coreSaveService.savePersonalizationFlowType(flowType);

      if (success) {
        _logger.i('✅ Flow type "$flowType" successfully saved.');
        emit(SaveFlowSuccess(selectedGoal));
      } else {
        _logger.w('⚠️ Flow type "$flowType" failed to save (no error thrown).');
        emit(SaveFlowFailure());
      }
    } catch (error) {
      _logger.e('❌ Exception while saving flow type "$flowType".');
      emit(SaveFlowFailure());
    }
  }
}
