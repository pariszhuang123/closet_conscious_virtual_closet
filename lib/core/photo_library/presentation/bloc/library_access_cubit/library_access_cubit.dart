import 'package:flutter_bloc/flutter_bloc.dart';

part 'library_access_state.dart';

class LibraryAccessCubit extends Cubit<LibraryAccessState> {
  LibraryAccessCubit() : super(const LibraryAccessState());

  void grantLibraryPermission() =>
      emit(state.copyWith(hasLibraryPermission: true));

  void grantItemAccess() =>
      emit(state.copyWith(hasItemAccess: true));

  void markInitialized() =>
      emit(state.copyWith(isInitialized: true));
}
