import '../../../outfit_management/core/outfit_enums.dart';

OutfitReviewFeedback stringToFeedback(String feedback) {
  final feedbackValue = feedback.split('.').last;
  switch (feedbackValue) {
    case 'like':
      return OutfitReviewFeedback.like;
    case 'dislike':
      return OutfitReviewFeedback.dislike;
    case 'alright':
      return OutfitReviewFeedback.alright;
    default:
      throw Exception('Invalid feedback string: $feedback');
  }
}
