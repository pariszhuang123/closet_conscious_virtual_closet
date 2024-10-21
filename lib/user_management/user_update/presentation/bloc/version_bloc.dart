import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/data/services/user_fetch_service.dart';  // The service handling version checks
import '../../../../core/utilities/logger.dart';

part 'version_bloc_event.dart';
part 'version_bloc_state.dart';

class VersionBloc extends Bloc<VersionEvent, VersionState> {
  final UserFetchSupabaseService _userFetchSupabaseService;
  final CustomLogger logger = CustomLogger('VersionBloc');  // Initialize logger for the BLoC

  VersionBloc(this._userFetchSupabaseService) : super(VersionInitial()) {
    on<CheckVersionEvent>(_onCheckVersion);
  }

  Future<void> _onCheckVersion(CheckVersionEvent event, Emitter<VersionState> emit) async {
    logger.i('Starting version check');  // Log an info message when version check starts
    emit(VersionChecking());

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      logger.d('Current app version: $currentVersion');  // Log current app version

      final bool updateRequired = await _userFetchSupabaseService.isUpdateRequired(currentVersion);

      if (updateRequired) {
        logger.w('Update required');  // Log a warning if update is required
        emit(VersionUpdateRequired());
      } else {
        logger.i('App is up-to-date');  // Log info if no update is required
        emit(VersionValid());
      }
    } catch (e) {
      logger.e('Version check failed: $e');  // Log error if something goes wrong
      emit(VersionError('Failed to check version: $e'));
    }
  }
}
