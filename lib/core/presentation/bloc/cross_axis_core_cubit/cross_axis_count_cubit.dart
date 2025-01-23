import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../utilities/logger.dart';

class CrossAxisCountCubit extends Cubit<int> {
  final CoreFetchService coreFetchService;
  final CustomLogger _logger = CustomLogger('CrossAxisCountCubit');

  CrossAxisCountCubit({required this.coreFetchService}) : super(3); // Default to 3 as the initial state

  Future<void> fetchCrossAxisCount() async {
    _logger.i('Fetching cross-axis count...');
    try {
      final crossAxisCount = await coreFetchService.fetchCrossAxisCount();
      _logger.d('Fetched cross-axis count: $crossAxisCount');
      emit(crossAxisCount);
    } catch (e) {
      _logger.e('Error fetching cross-axis count: $e');
      emit(3); // Default to 3 if there's an error
    }
  }
}
