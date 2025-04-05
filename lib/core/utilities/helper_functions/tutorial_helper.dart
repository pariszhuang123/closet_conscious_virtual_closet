import '../../core_enums.dart';

extension TutorialTypeExtension on TutorialType {
  String get value {
    switch (this) {
      case TutorialType.freeUploadCamera:
        return 'free_upload_camera';
      case TutorialType.freeUploadPhotoLibrary:
        return 'free_upload_photo_library';
      case TutorialType.freeEditCamera:
        return 'free_edit_camera';
      case TutorialType.freeCreateOutfit:
        return 'free_create_outfit';
      case TutorialType.freeClosetUpload:
        return 'free_closet_upload';
      case TutorialType.freeInfoHub:
        return 'free_info_hub';
      case TutorialType.paidFilter:
        return 'paid_filter';
      case TutorialType.paidCustomize:
        return 'paid_customize';
      case TutorialType.paidMultiCloset:
        return 'paid_multi_closet';
      case TutorialType.paidCalendar:
        return 'paid_calendar';
      case TutorialType.paidUsageAnalytics:
        return 'paid_usage_analytics';
    }
  }
}
