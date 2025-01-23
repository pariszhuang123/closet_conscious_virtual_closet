import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utilities/logger.dart';
import '../../../core/data/models/calendar_metadata.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../user_management/user_service_locator.dart';


class OutfitSaveService {
  final SupabaseClient client;
  final CustomLogger logger;

  OutfitSaveService({
    required this.client,
    CustomLogger? logger,
  }) : logger = logger ?? CustomLogger('OutfitSaveServiceLogger');

  Future<bool> reviewOutfit({
    required String outfitId,
    required String feedback,
    required List<String> itemIds,
    String comments = 'cc_none',
  }) async {
    try {
      final strippedFeedback = feedback.split('.').last.trim();
      if (comments.trim().isEmpty) {
        comments = 'cc_none'; // Set to default value if blank
      }

      final response = await client.rpc('review_outfit', params: {
        'p_outfit_id': outfitId,
        'p_feedback': strippedFeedback,
        'p_item_ids': itemIds,
        'p_outfit_comments': comments,
      });

      if (response is Map<String, dynamic>) {
        if (response['status'] == 'success') {
          logger.i('Successfully reviewed outfit with ID: $outfitId');
          return true;
        } else {
          logger.e('Error in response: ${response['message']}');
          return false;
        }
      } else {
        logger.e('Unexpected response format: $response');
        return false;
      }
    } catch (error) {
      logger.e('Error during RPC call: $error');
      return false;
    }
  }

  Future<Map<String, dynamic>> saveOutfitItems({
    required List<String> allSelectedItemIds,
  }) async {
    try {
      final response = await client.rpc(
        'save_outfit_items',
        params: {
          'p_selected_items': allSelectedItemIds,
        },
      );

      if (response != null && response.containsKey('status')) {
        return response;
      } else if (response.error != null) {
        logger.e('Error in RPC call: ${response.error.message}');
        return {'status': 'error', 'message': response.error.message};
      } else {
        logger.e('Unexpected response format: $response');
        return {'status': 'error', 'message': 'Unexpected response format'};
      }
    } catch (error) {
      logger.e('Error during RPC call: $error');
      return {'status': 'error', 'message': error.toString()};
    }
  }

  Future<bool> updateOutfitEventName({
    required String outfitId,
    String? eventName, // Optional eventName parameter
  }) async {
    try {
      // Default to 'cc_none' if eventName is empty or null
      final eventNameToUse = (eventName == null || eventName.trim().isEmpty)
          ? 'cc_none'
          : eventName.trim();

      // Send an update request with SQL 'now()' for the updated_at field
      final response = await client
          .from('outfits')
          .update({'event_name': eventNameToUse,
      })
          .eq('outfit_id', outfitId)
          .select();  // Add this to return the updated row


      if (response.isNotEmpty) {
        logger.i('Successfully updated event name for outfit ID: $outfitId');
        return true;
      } else {
        logger.e('Unexpected empty or null response from the update query');
        return false;
      }
    } catch (error) {
      logger.e('Error occurred while updating event name: $error');
      return false;
    }
  }


Future<bool> recordUserReview({
    required String userId,
    required int score,
    required int milestone,
  }) async {
    try {
      final response = await client.rpc('update_nps_review', params: {
        'p_user_id': userId,
        'p_nps_score': score,
        'p_milestone_triggered': milestone,
      });

      if (response != null && response['status'] == 'success') {
        logger.i('Successfully recorded NPS review for user ID: $userId');
        return true;
      } else {
        logger.e('Unexpected response format: $response');
        return false;
      }
    } catch (error) {
      logger.e('Error during RPC call: $error');
      return false;
    }
  }

  Future<bool> saveCalendarMetadata(CalendarMetadata metadata) async {
    try {
      final response = await client.rpc('save_calendar_metadata', params: {
        'new_event_name': metadata.eventName,
        'new_feedback': metadata.feedback,
        'new_is_calendar_selectable': metadata.isCalendarSelectable,
        'new_is_outfit_active': metadata.isOutfitActive,
      });

      if (response == true) {
        logger.i('Successfully saved calendar metadata');
        return true;
      } else {
        logger.e('Failed to save calendar metadata. Response: $response');
        return false;
      }
    } catch (error) {
      logger.e('Error during RPC call to save calendar metadata: $error');
      return false;
    }
  }

  Future<bool> updateFocusedDate(String selectedDate) async {
    try {
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      if (userId == null) {
        throw Exception("User not authenticated");
      }

      await Supabase.instance.client
          .from('shared_preferences')
          .update({'focused_date': selectedDate}).eq('user_id', userId);

      logger.i('Update successfully with focused date.');
      return true; // Indicating success
    } catch (e) {
      logger.e('Error updating focused date: $e');
      return false; // Indicating failure
    }
  }

  Future<bool> resetMonthlyCalendar() async {
    try {
      final response = await client.rpc('reset_monthly_calendar');

      if (response == true) {
        logger.i('Successfully reset the monthly calendar.');
        return true;
      } else {
        logger.e('Failed to reset the monthly calendar. Response: $response');
        return false;
      }
    } catch (error) {
      logger.e('Error during RPC call to reset monthly calendar: $error');
      return false;
    }
  }

  Future<bool> navigateCalendar(String direction) async {
    try {
      // Validate direction
      if (direction != 'backward' && direction != 'forward') {
        throw ArgumentError('Invalid direction: $direction. Must be "backward" or "forward".');
      }

      // Call the Supabase RPC function
      final response = await client.rpc('navigate_calendar', params: {
        'direction': direction,
      });

      if (response == true) {
        logger.i('Successfully navigated calendar $direction.');
        return true;
      } else {
        logger.e('Failed to navigate calendar $direction. Response: $response');
        return false;
      }
    } catch (error) {
      logger.e('Error during RPC call to navigate calendar: $error');
      return false;
    }
  }

}

