enum ImageSize {
  selfie,          // Size for selfies
  itemInteraction, // Size for item interaction screen
  closetMetadata,
  itemGrid2,
  itemGrid3,       // Size for item grid
  itemGrid5,
  itemGrid7
}

enum CameraPermissionContext {
  uploadItem,
  editItem,
  selfie,
  editCloset
}

enum ButtonType {
  primary, secondary
}

enum EmailType {
  support, npsReview
}

enum SaveStatus {
  initial, inProgress,success, loadSuccess, saveSuccess, failure
}

enum AccessStatus { pending, granted, denied, error }

enum SelectionMode {
  singleSelection,
  multiSelection,
  action,
}
