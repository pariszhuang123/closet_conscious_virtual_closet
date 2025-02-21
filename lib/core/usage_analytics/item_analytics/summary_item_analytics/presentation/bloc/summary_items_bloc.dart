import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../data/services/core_fetch_services.dart';
import '../../../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../../../user_management/user_service_locator.dart';

part 'summary_items_event.dart';
part 'summary_items_state.dart';

class SummaryItemsBloc extends Bloc<SummaryItemsEvent, SummaryItemsState> {
  final CoreFetchService coreFetchService;
  final CustomLogger logger;
  final AuthBloc authBloc;

  SummaryItemsBloc({
    required this.coreFetchService,
    CustomLogger? logger,
    AuthBloc? authBloc,
  })  : logger = logger ?? CustomLogger('SummaryItemsBlocLogger'),
        authBloc = authBloc ?? locator<AuthBloc>(),
        super(SummaryItemsInitial()) {
    on<FetchSummaryItemEvent>(_onFetchSummaryItem);
  }

  Future<void> _onFetchSummaryItem(
      FetchSummaryItemEvent event,
      Emitter<SummaryItemsState> emit,
      ) async {
    emit(SummaryItemsLoading());
    try {
      final summary = await coreFetchService.getFilteredItemSummary();
      emit(SummaryItemsLoaded(
        totalItems: summary['total_items'] ?? 0,
        totalItemCost: (summary['total_item_cost'] as num?)?.toDouble() ?? 0.0,
        avgPricePerWear:
        (summary['avg_price_per_wear'] as num?)?.toDouble() ?? 0.0,
      ));
    } catch (e) {
      logger.e('Error fetching summary item: $e');
      emit(SummaryItemsError('Failed to load summary item'));
    }
  }

}
