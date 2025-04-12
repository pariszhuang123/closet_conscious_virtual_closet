import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../utilities/logger.dart';

class PersonalizationFlowCubit extends Cubit<String> {
  final CoreFetchService coreFetchService;
  final CustomLogger _logger = CustomLogger('PersonalizationFlowCubit');

  PersonalizationFlowCubit({required this.coreFetchService}) : super('default_flow'); // Default state

  Future<void> fetchPersonalizationFlowType() async {
    _logger.i('Fetching personalization flow type...');
    try {
      final flowType = await coreFetchService.fetchPersonalizationFlowType();
      _logger.d('Fetched flow type: $flowType');
      emit(flowType);
    } catch (e) {
      _logger.e('Error fetching personalization flow type: $e');
      emit('default_flow');
    }
  }
}
