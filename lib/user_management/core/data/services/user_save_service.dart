import '../../../../core/config/supabase_config.dart';
import '../../../../core/utilities/logger.dart';
import 'dart:convert';

class UserSaveService {
  final CustomLogger logger;

  UserSaveService() : logger = CustomLogger('UserSaveService');


  Future<Map<String, dynamic>> notifyDeleteUserAccount() async {
    try {
      final response = await SupabaseConfig.client.rpc(
          'notify_delete_user_account')
          .single();

      logger.i('Full response: ${jsonEncode(response)}');

      if (response.containsKey('status') && response['status'] == 'success') {
        return response;
      } else {
        logger.e('Unexpected response format');
        throw Exception('Failed to mark user for deletion');
      }
    } catch (e) {
      logger.e('Error in calling delete user account RPC: $e');
      rethrow;
    }
  }
}