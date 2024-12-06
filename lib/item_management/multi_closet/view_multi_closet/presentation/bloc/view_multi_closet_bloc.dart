import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utilities/logger.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../../core/data/models/multi_closet.dart';

part 'view_multi_closet_event.dart';
part 'view_multi_closet_state.dart';

class ViewMultiClosetBloc extends Bloc<ViewMultiClosetEvent, ViewMultiClosetState> {
  final CoreFetchService fetchService;

  final CustomLogger logger = CustomLogger('ViewMultiClosetBloc');


  ViewMultiClosetBloc({
    required this.fetchService,
  }) : super(ViewMultiClosetsInitial()) {
    on<FetchViewMultiClosetsEvent>(_fetchClosets);
  }

  Future<void> _fetchClosets(FetchViewMultiClosetsEvent event, Emitter<ViewMultiClosetState> emit) async {
    emit(ViewMultiClosetsLoading());
    try {
      logger.i('Fetching closet data');
      final closetData = await fetchService.fetchPermanentClosets();
      final allClosetsDisplay = closetData.map((closetMap) => MultiCloset.fromMap(closetMap)).toList();
      logger.i('Successfully fetched ${allClosetsDisplay.length} closets');
      emit(ViewMultiClosetsLoaded(allClosetsDisplay));
    } catch (e) {
      logger.e('Error fetching closets: $e');
      emit(ViewMultiClosetsError('Failed to load closets'));
    }
  }
}
