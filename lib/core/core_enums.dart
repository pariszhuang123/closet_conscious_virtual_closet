enum ImageSize {
  selfie,
  monthlyCalendarImage,// Size for selfies
  dailyCalendarImage,
  itemInteraction, // Size for item interaction screen
  closetMetadata,
  itemGrid2,
  itemGrid3,       // Size for item grid
  itemGrid5,
  itemGrid7,
  calendarOutfitItemGrid3,
  calendarOutfitItemGrid5,
  calendarOutfitItemGrid7
}

enum OutfitSize {
  dailyCalendarOutfitImage,
  smallOutfitImage,
  relatedOutfitImage
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

enum AccessStatus { pending, granted, denied, error, trialPending }

enum ItemSelectionMode {
  singleSelection,
  multiSelection,
  action,
  disabled,
}

enum OutfitSelectionMode {
  singleSelection,
  multiSelection,
  action,
  disabled,
}

enum ClosetSelectionMode {
  singleSelection,
  multiSelection,
  action,
  disabled,
}

enum TooltipPosition { left, center, right }

enum ImageSourceType {
  remote,
  localFile,
  assetEntity,
}

enum ImagePurpose {
  preview,
  upload,
}
