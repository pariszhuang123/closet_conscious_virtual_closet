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
  editCloset,
  qrScan
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
  assetEntity,
}

enum ImagePurpose {
  preview,
  upload,
}

enum UploadSource {
  camera,
  photoLibrary
}

enum TransitionType {
  slideFromTop,
  slideFadeFromTop,
  slideFromBottom,
  slideFadeFromBottom,
  slideFromLeft,
  slideFromRight,
  zoomFadeFromCenter,
  fadeScale,
  fade
}

enum TutorialType {
  freeUploadCamera,
  freeUploadPhotoLibrary,
  freeEditCamera,
  paidFilter,
  paidCustomize,
  paidMultiCloset,
  freeCreateOutfit,
  paidCalendar,
  freeClosetUpload,
  freeInfoHub,
  paidUsageAnalytics,
  flowIntroDefault,
  flowIntroMemory,
  flowIntroPersonalStyle,
  flowIntroLifeChange,
}

enum OnboardingJourneyType {
  defaultFlow,
  memoryFlow,
  personalStyleFlow,
  lifeChangeFlow,
}

enum FeatureKey {
  uploadItemBronze,
  uploadItemSilver,
  uploadItemGold,
  editItemBronze,
  editItemSilver,
  editItemGold,
  selfieBronze,
  selfieSilver,
  selfieGold,
  editClosetBronze,
  editClosetSilver,
  editClosetGold,
  multiOutfit,
  customize,
  filter,
  multicloset,
  calendar,
  usageAnalytics
}

enum TutorialDismissType {
  confirmed,    // from "I am ready"
  dismissed,    // from close icon
}
