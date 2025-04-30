part of 'library_access_cubit.dart';

class LibraryAccessState {
  final bool hasLibraryPermission;
  final bool hasItemAccess;
  final bool isInitialized;

  const LibraryAccessState({
    this.hasLibraryPermission = false,
    this.hasItemAccess = false,
    this.isInitialized = false,
  });

  LibraryAccessState copyWith({
    bool? hasLibraryPermission,
    bool? hasItemAccess,
    bool? isInitialized,
  }) {
    return LibraryAccessState(
      hasLibraryPermission: hasLibraryPermission ?? this.hasLibraryPermission,
      hasItemAccess: hasItemAccess ?? this.hasItemAccess,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  bool get readyToInitialize =>
      hasLibraryPermission && hasItemAccess && !isInitialized;
}
