part of 'upload_item_streak_bloc.dart';

abstract class UploadStreakEvent {}

class CheckUploadStatus extends UploadStreakEvent {}

class CompleteUpload extends UploadStreakEvent {}
