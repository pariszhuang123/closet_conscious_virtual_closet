import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utilities/logger.dart';  // Import your custom logger
import '../../../core/data/services/item_fetch_service.dart';

part 'upload_item_streak_event.dart';
part 'upload_item_streak_state.dart';

class UploadStreakBloc extends Bloc<UploadStreakEvent, UploadStreakState> {
  final ItemFetchService _itemFetchService;
  final CustomLogger _logger;

  UploadStreakBloc(this._itemFetchService)
      : _logger = CustomLogger('UploadStreakBloc'),
        super(UploadStreakInitial()) {
    on<CheckUploadStatus>(_onCheckUploadStatus);
    on<CompleteUpload>(_onCompleteUpload);
  }

  Future<void> _onCheckUploadStatus(
      CheckUploadStatus event, Emitter<UploadStreakState> emit) async {
    _logger.d('Checking upload status...');
    emit(UploadStreakLoading());
    try {
      final isUploaded = await _itemFetchService.checkClosetUploadStatus();
      const initialApparelCount = 2;

      _logger.i('Closet upload status: $isUploaded');

      UploadStreakSuccess newState = state is UploadStreakSuccess
          ? (state as UploadStreakSuccess).copyWith(isUploadCompleted: isUploaded)
          : UploadStreakSuccess(
          isUploadCompleted: isUploaded,
          apparelCount: initialApparelCount,
          currentStreakCount: 0,
          highestStreakCount: 0,
          newItemsCost: 0,
          newItemsCount: 0);

      emit(newState);
      _logger.d('Upload status checked and state updated.');

      if (!isUploaded) {
        // Fetch only apparel count when upload is not completed
        await _fetchApparelCount(newState, emit);
      } else {
        // Fetch full streak data when upload is completed
        await _fetchFullStreakData(newState, emit);
      }

    } catch (e) {
      _logger.e('Error checking upload status: $e');
      emit(UploadStreakFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _fetchApparelCount(
      UploadStreakSuccess currentState, Emitter<UploadStreakState> emit) async {
    _logger.i('Closet is not uploaded. Fetching apparel count...');
    final apparelCount = await _itemFetchService.fetchApparelCount();
    emit(currentState.copyWith(apparelCount: apparelCount));
    _logger.i('Apparel count fetched: $apparelCount');
  }

  Future<void> _fetchFullStreakData(
      UploadStreakSuccess currentState, Emitter<UploadStreakState> emit) async {
    _logger.i('Closet is uploaded. Fetching full streak data...');

    final currentStreakCount = await _itemFetchService.fetchCurrentStreakCount();
    final highestStreakCount = await _itemFetchService.fetchHighestStreakCount();
    final newItemsCost = await _itemFetchService.fetchNewItemsCost();
    final newItemsCount = await _itemFetchService.fetchNewItemsCount();

    emit(currentState.copyWith(
      currentStreakCount: currentStreakCount,
      highestStreakCount: highestStreakCount,
      newItemsCost: newItemsCost,
      newItemsCount: newItemsCount,
    ));
    _logger.i('Full streak data fetched successfully.');
  }

  Future<void> _onCompleteUpload(
      CompleteUpload event, Emitter<UploadStreakState> emit) async {
    _logger.d('Completing upload...');
    try {
      if (state is UploadStreakSuccess) {
        emit((state as UploadStreakSuccess).copyWith(isUploadCompleted: true));
        _logger.i('Upload marked as complete.');
      } else {
        _logger.w('Attempting to complete upload without valid data.');
        emit(const UploadStreakFailure(errorMessage: "Upload data is missing"));
      }
    } catch (e) {
      _logger.e('Error completing upload: $e');
      emit(UploadStreakFailure(errorMessage: e.toString()));
    }
  }
}
