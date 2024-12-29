import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/data/services/item_fetch_service.dart';
import '../../../../../../core/utilities/logger.dart';
import '../../../../core/data/models/closet_metadata.dart';

part 'edit_closet_metadata_state.dart';
part 'edit_closet_metadata_event.dart';

class EditClosetMetadataBloc extends Bloc<EditClosetMetadataEvent, EditClosetMetadataState> {
  final ItemFetchService itemFetchService;
  final CustomLogger logger;

  EditClosetMetadataBloc({required this.itemFetchService, CustomLogger? customLogger})
      : logger = customLogger ?? CustomLogger('EditClosetMetadataBloc'),
        super(EditClosetMetadataInitial()) {
    on<FetchMetadataEvent>(_onFetchMetadata);
    on<MetadataChangedEvent>(_onMetadataChanged);
  }

  Future<void> _onFetchMetadata(
      FetchMetadataEvent event, Emitter<EditClosetMetadataState> emit) async {
    logger.i("Handling FetchMetadataEvent...");
    emit(EditClosetMetadataLoading());
    logger.d("State changed to EditClosetMetadataLoading.");

    try {
      logger.i("Calling fetchClosetMetadataConditions in ItemFetchService.");
      final result = await itemFetchService.fetchClosetMetadataConditions();
      logger.d("Fetched metadata conditions: $result");

      final shouldHideFeatures = result['should_hide'] ?? false;
      final metadataJson = result['metadata'];

      if (shouldHideFeatures) {
        logger.i("Closet features should be hidden.");
        emit(EditClosetMetadataHidden());
      } else {
        logger.i("Closet features available. Parsing metadata...");
        final metadata = ClosetMetadata.fromJson(metadataJson);
        logger.d("Parsed metadata: $metadata");
        emit(EditClosetMetadataAvailable(metadata: metadata));
        logger.d("State changed to EditClosetMetadataAvailable.");
      }
    } catch (error) {
      logger.e("Failed to fetch metadata: $error");
      emit(EditClosetMetadataFailure(errorMessage: error.toString()));
      logger.d("State changed to EditClosetMetadataAvailable.");

    }
  }

  void _onMetadataChanged(
      MetadataChangedEvent event, Emitter<EditClosetMetadataState> emit) {
    logger.i("Handling MetadataChangedEvent...");
    if (state is EditClosetMetadataAvailable) {
      final currentState = state as EditClosetMetadataAvailable;
      logger.d("Current metadata: ${currentState.metadata}");
      logger.d("Updated metadata: ${event.updatedMetadata}");

      final updatedMetadata = currentState.metadata.copyWith(
        closetType: event.updatedMetadata.closetType,
        closetName: event.updatedMetadata.closetName,
        isPublic: event.updatedMetadata.isPublic,
        validDate: event.updatedMetadata.validDate,
        closetImage: currentState.metadata.closetImage,
      );

      logger.d("Metadata changed: $updatedMetadata");
      emit(EditClosetMetadataAvailable(metadata: updatedMetadata));
      logger.d("State changed to EditClosetMetadataAvailable.");
    } else {
      logger.w("Metadata change attempted in invalid state.");
    }
  }
}
