import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utilities/logger.dart';
import '../../filter/data/models/filter_setting.dart';
import '../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../user_management/user_service_locator.dart';

class CoreFetchService {
  final CustomLogger _logger = CustomLogger('CoreFetchService');

  CoreFetchService();

  /// Extracts the relative path from a full URL
  String extractRelativePath(String fullUrl, String bucketName) {
    try {
      _logger.d('Extracting relative path from URL: $fullUrl');
      Uri uri = Uri.parse(fullUrl);
      final bucketIndex = uri.path.indexOf('/$bucketName/');
      if (bucketIndex == -1) {
        _logger.e('Bucket name not found in URL');
        throw Exception('Bucket name not found in URL');
      }
      final relativePath = uri.path.substring(bucketIndex + bucketName.length + 2);
      _logger.i('Relative path extracted: $relativePath');
      return relativePath;
    } catch (e) {
      _logger.e('Error extracting relative path: $e');
      rethrow;
    }
  }

  /// Gets a transformed image URL with the specified width and height
  Future<String> getTransformedImageUrl(String fullUrl, String bucketName, {int? width, int? height}) async {
    try {
      _logger.d('Getting transformed image URL for $fullUrl with width: $width, height: $height');
      final relativePath = extractRelativePath(fullUrl, bucketName);

      final String transformedImageUrl = Supabase.instance.client.storage
          .from(bucketName)
          .getPublicUrl(
        relativePath,
        transform: TransformOptions(
          width: width,    // Optionally provide width
          height: height,  // Optionally provide height
        ),
      );
      _logger.i('Transformed image URL obtained: $transformedImageUrl');
      return transformedImageUrl;
    } catch (e) {
      _logger.e('Error getting transformed image URL: $e');
      rethrow;
    }
  }

  /// Checks user access to upload items
  Future<Map<String, dynamic>> checkUserAccessToUploadItems() async {
    try {
      _logger.d('Checking user access to upload items');
      final response = await Supabase.instance.client.rpc('check_user_access_to_upload_items') as Map<String, dynamic>;

      if (response.isNotEmpty) {
        _logger.i('User upload access fetched successfully: $response');
        return response;
      } else {
        _logger.e('Unexpected response format or no data returned: $response');
        throw Exception('Unexpected response format or no data returned');
      }
    } catch (e) {
      _logger.e('Error checking user access to upload items: $e');
      rethrow;
    }
  }

  /// Checks user access to edit items
  Future<Map<String, dynamic>> checkUserAccessToEditItems() async {
    try {
      _logger.d('Checking user access to edit items');
      final response = await Supabase.instance.client.rpc('check_user_access_to_edit_items') as Map<String, dynamic>;

      if (response.isNotEmpty) {
        _logger.i('User edit access fetched successfully: $response');
        return response;
      } else {
        _logger.e('Unexpected response format or no data returned: $response');
        throw Exception('Unexpected response format or no data returned');
      }
    } catch (e) {
      _logger.e('Error checking user access to edit items: $e');
      rethrow;
    }
  }

  /// Checks user access to take selfies
  Future<Map<String, dynamic>> checkUserAccessToSelfie() async {
    try {
      _logger.d('Checking user access to take selfies');
      final response = await Supabase.instance.client.rpc('check_user_access_to_create_selfie') as Map<String, dynamic>;

      if (response.isNotEmpty) {
        _logger.i('User selfie access fetched successfully: $response');
        return response;
      } else {
        _logger.e('Unexpected response format or no data returned: $response');
        throw Exception('Unexpected response format or no data returned');
      }
    } catch (e) {
      _logger.e('Error checking user access to create selfie: $e');
      rethrow;
    }
  }

  /// Checks user access to edit closet photo
  Future<Map<String, dynamic>> checkUserAccessToEditCloset() async {
    try {
      _logger.d('Checking user access to edit closet photo');
      final response = await Supabase.instance.client.rpc('check_user_access_to_edit_closets') as Map<String, dynamic>;

      if (response.isNotEmpty) {
        _logger.i('User edit access fetched successfully: $response');
        return response;
      } else {
        _logger.e('Unexpected response format or no data returned: $response');
        throw Exception('Unexpected response format or no data returned');
      }
    } catch (e) {
      _logger.e('Error checking user access to edit closet: $e');
      rethrow;
    }
  }

  /// Fetches the cross-axis count from shared preferences
  Future<int> fetchCrossAxisCount() async {
    try {
      _logger.d('Fetching cross-axis count from shared preferences');
      final data = await Supabase.instance.client
          .from('shared_preferences')
          .select('grid')
          .single();

      if (data.isNotEmpty) {
        final count = data['grid'] as int? ?? 3;
        _logger.i('Cross-axis count fetched successfully: $count');
        return count;
      } else {
        _logger.w('No data returned for cross-axis count, defaulting to 3');
        return 3;
      }
    } catch (e) {
      _logger.e('Error fetching cross-axis count: $e');
      return 3;
    }
  }

  /// Fetches arrangement settings from shared preferences
  Future<Map<String, dynamic>> fetchArrangementSettings() async {
    try {
      _logger.d('Fetching arrangement settings from Supabase...');
      final data = await Supabase.instance.client
          .from('shared_preferences')
          .select('grid, sort, sort_order')
          .single();

      _logger.i('Arrangement settings fetched successfully: $data');
      return data;
    } catch (e) {
      _logger.e('Error fetching arrangement settings: $e');
      rethrow;
    }
  }

  Future<bool> checkOutfitAccess() async {
    final result = await Supabase.instance.client.rpc('check_user_access_to_create_outfit');

    if (result is bool) {
      return result;
    } else {
      throw Exception('Unexpected result from RPC: $result');
    }
  }

  /// Checks access to customize pages
  Future<bool> accessCustomizePage() async {
    _logger.i('Starting access check for customize pages.');

    try {
      final result = await Supabase.instance.client.rpc('check_user_access_to_access_customize_page');
      if (result is bool) {
        _logger.i('Access check for customize pages completed successfully. Result: $result');
        return result;
      } else {
        _logger.e('Unexpected result type from RPC for customize pages access: $result');
        throw Exception('Unexpected result from RPC: $result');
      }
    } catch (error) {
      _logger.e('Error during access check for customize pages: $error');
      throw Exception('Failed to access customize pages: $error');
    }
  }

  Future<bool> checkMultiClosetFeature() async {
    _logger.d('Starting check for multi_closet feature.');

    try {
      // Fetching the one_off_features JSON data
      final data = await Supabase.instance.client
          .from('premium_services')
          .select('one_off_features')
          .single();

      _logger.i('Fetched data: $data'); // Log the entire response for debugging

      // Check if data is null or empty
      if (data.isEmpty) {
        _logger.e('Error: No data found in response.');
        return false; // Return false if there's no data
      }

      // Extract one_off_features JSON field
      final features = data['one_off_features'];
      _logger.d(
          'Extracted features data: $features'); // Log the one_off_features data for debugging

      // Check if the specific key exists in the JSON
      final hasMultiClosetFeature = features != null && features.containsKey(
          'com.makinglifeeasie.closetconscious.multicloset');
      _logger.i(
          'Has multi_closet feature: $hasMultiClosetFeature'); // Log the result for debugging

      return hasMultiClosetFeature;
    } catch (e) {
      _logger.e(
          'Exception caught during checkMultiClosetFeature: $e'); // Log any exceptions for debugging
      return false; // Return false if there's an error
    }
  }


  Future<bool> checkCalendarFeature() async {
    _logger.d('Starting check for calendar feature.');

    try {
      // Fetching the one_off_features JSON data
      final data = await Supabase.instance.client
          .from('premium_services')
          .select('one_off_features')
          .single();

      _logger.i('Fetched data: $data'); // Log the entire response for debugging

      // Check if data is null or empty
      if (data.isEmpty) {
        _logger.e('Error: No data found in response.');
        return false; // Return false if there's no data
      }

      // Extract one_off_features JSON field
      final features = data['one_off_features'];
      _logger.d(
          'Extracted features data: $features'); // Log the one_off_features data for debugging

      // Check if the specific key exists in the JSON
      final hasCalendarFeature = features != null && features.containsKey(
          'com.makinglifeeasie.closetconscious.calendar');
      _logger.i(
          'Has calendar feature: $hasCalendarFeature'); // Log the result for debugging

      return hasCalendarFeature;
    } catch (e) {
      _logger.e(
          'Exception caught during checkCalendarFeature: $e'); // Log any exceptions for debugging
      return false; // Return false if there's an error
    }
  }

  Future<bool> checkUsageAnalyticsFeature() async {
    _logger.d('Starting check for usage analytics feature.');

    try {
      // Fetching the one_off_features JSON data
      final data = await Supabase.instance.client
          .from('premium_services')
          .select('one_off_features')
          .single();

      _logger.i('Fetched data: $data'); // Log the entire response for debugging

      // Check if data is null or empty
      if (data.isEmpty) {
        _logger.e('Error: No data found in response.');
        return false; // Return false if there's no data
      }

      // Extract one_off_features JSON field
      final features = data['one_off_features'];
      _logger.d(
          'Extracted features data: $features'); // Log the one_off_features data for debugging

      // Check if the specific key exists in the JSON
      final hasUsageAnalyticsFeature = features != null && features.containsKey(
          'com.makinglifeeasie.closetconscious.usageanalytics');
      _logger.i(
          'Has usageAnalytics feature: $hasUsageAnalyticsFeature'); // Log the result for debugging

      return hasUsageAnalyticsFeature;
    } catch (e) {
      _logger.e(
          'Exception caught during checkUsageAnalyticsFeature: $e'); // Log any exceptions for debugging
      return false; // Return false if there's an error
    }
  }


  Future<bool> isTrialPending() async {
    try {
      _logger.i('Checking trial status from Supabase.');
      final data = await Supabase.instance.client
          .from('premium_services')
          .select('trial_status')
          .single();

      if (data.isNotEmpty) {
        final String trialStatus = data['trial_status'] as String;

        _logger.i('Trial status retrieved: $trialStatus');

        // Return true if the status is 'pending', otherwise return false
        return trialStatus == 'pending';
      } else {
        _logger.w('No trial status found, defaulting to false.');
        return false;
      }
    } catch (e) {
      _logger.e('Error fetching trial status: $e');
      return false; // Default to false on error
    }
  }

  Future<bool> trialStarted() async {
    try {
      // Log the action
      _logger.d('Trial had started.');

      // Call the RPC function
      final response = await Supabase.instance.client.rpc('activate_trial_premium_features');
      _logger.d('Raw RPC response for Trial Started: $response (${response.runtimeType})');

      // Evaluate the response
      if (response == true) {
        _logger.d('Trial features had being activated.');
        return true;
      } else {
        _logger.d('No trial features had being activated.');
        return false;
      }
    } catch (e) {
      _logger.e('Error starting trial: $e');
      return false;
    }
  }

  Future<bool> trialEnded() async {
    try {
      // Log the action
      _logger.d('Validating and updating trial features.');

      // Call the RPC function
      final response = await Supabase.instance.client.rpc('validate_and_update_trial_features');
      _logger.d('Raw RPC response for Trial Ended: $response (${response.runtimeType})');

      // Evaluate the response
      if (response == true) {
        _logger.d('Trial features validated and updated successfully.');
        return true;
      } else {
        _logger.d('No trial features required updating.');
        return false;
      }
    } catch (e) {
      _logger.e('Error ending trial: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPermanentClosets() async {
    try {
      final data = await Supabase.instance.client
          .from('user_closets')
          .select('closet_id, closet_name, closet_image')
          .eq('type', 'permanent')
          .eq('is_active', true)
          .order('created_at', ascending: true);

      if (data.isEmpty) {
        throw Exception('No closets found for this user');
      }

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      // Log error if necessary
      throw Exception('Error fetching closets: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllClosets() async {
    try {
      final data = await Supabase.instance.client
          .from('user_closets')
          .select('closet_id, closet_name, closet_image')
          .eq('is_active', true)
          .order('created_at', ascending: true);


      if (data.isEmpty) {
        throw Exception('No closets found for this user');
      }

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      // Log error if necessary
      throw Exception('Error fetching closets: $e');
    }
  }

/// Fetches filter settings from Supabase
  Future<Map<String, dynamic>> fetchFilterSettings() async {
    try {
      _logger.d('Fetching filter settings from Supabase...');
      final response = await Supabase.instance.client.rpc('fetch_filter_settings');

      if (response == null) {
        _logger.e('RPC call for filter settings returned null');
        throw Exception('Error: RPC call returned null');
      } else {
        final FilterSettings filterSettings = FilterSettings.fromJson(response['f_filter'] ?? {});
        final result = {
          'filters': filterSettings,
          'selectedClosetId': response['f_closet_id'] as String,
          'allCloset': response['f_all_closet'] as bool,
          'onlyItemsUnworn': response['f_only_unworn'] as bool,
          'itemName': response['f_item_name'] as String,
          'ignoreItemName': response['f_ignore_item_name'] as bool
        };
        _logger.i('Filter settings fetched successfully: $result');
        return result;
      }
    } catch (e) {
      _logger.e('Error fetching filter settings: $e');
      rethrow;
    }
  }

  /// Checks access to filter pages
  Future<bool> accessFilterPage() async {
    _logger.i('Starting access check for filter pages.');

    try {
      final result = await Supabase.instance.client.rpc('check_user_access_to_access_filter_page');
      if (result is bool) {
        _logger.i('Access check for filter pages completed successfully. Result: $result');
        return result;
      } else {
        _logger.e('Unexpected result type from RPC for filter pages access: $result');
        throw Exception('Unexpected result from RPC: $result');
      }
    } catch (error) {
      _logger.e('Error during access check for filter pages: $error');
      throw Exception('Failed to access filter pages: $error');
    }
  }

  /// Checks access to  multi_closet page
  Future<bool> accessMultiClosetPage() async {
    _logger.i('Starting access check for multi-closet page.');

    try {
      final result = await Supabase.instance.client.rpc('check_user_access_to_access_multi_closet_page');
      if (result is bool) {
        _logger.i('Access check for multi_closet page completed successfully. Result: $result');
        return result;
      } else {
        _logger.e('Unexpected result type from RPC for  multi_closet page access: $result');
        throw Exception('Unexpected result from RPC: $result');
      }
    } catch (error) {
      _logger.e('Error during access check for  multi_closet page: $error');
      throw Exception('Failed to access filter pages: $error');
    }
  }

  Future<Map<String, dynamic>> getFilteredItemSummary() async {
    try {
      _logger.d('Fetching filtered item summary');

      final response = await Supabase.instance.client
          .rpc('get_filtered_item_summary')
          .single();

      _logger.i('Filtered item summary fetched successfully: $response');
      return response;
        } catch (e) {
      _logger.e('Error fetching filtered item summary: $e');
      rethrow;
    }
  }

  /// Fetches related outfits for a given item ID with pagination
  Future<Map<String, dynamic>> getItemRelatedOutfits({
    required String itemId,
    required int currentPage,
  }) async {
    try {
      _logger.d('Fetching related outfits for item ID: $itemId, page: $currentPage');

      final response = await Supabase.instance.client.rpc(
      'get_item_related_outfits',
      params: {
      'f_item_id': itemId,
      'p_current_page': currentPage,
      },
      );

      // ✅ Directly use response as a map
      final data = response as Map<String, dynamic>?;

      if (data == null) {
        _logger.e('Unexpected response format or no data returned');
        throw Exception('Unexpected response format or no data returned');
      }

      _logger.i('Successfully fetched related outfits: $data');
      return data;
    } catch (error) {
      _logger.e('Error in getItemRelatedOutfits: $error');
      rethrow;
    }
  }


  /// Fetches outfit usage analytics from Supabase RPC `get_outfit_usage_analytics`
  Future<Map<String, dynamic>> getOutfitUsageAnalytics() async {
    try {
      _logger.d('Fetching outfit usage analytics from RPC');

      final response = await Supabase.instance.client.rpc('get_outfit_usage_analytics');

      if (response.isEmpty) {
        _logger.e('No outfit usage analytics data returned.');
        throw Exception('No data returned from RPC.');
      }

      // Extract the first row from the list
      final Map<String, dynamic> analyticsData = response.first as Map<String, dynamic>;

      _logger.i('Outfit usage analytics fetched successfully: $analyticsData');
      return analyticsData;
    } catch (e) {
      _logger.e('Error fetching outfit usage analytics: $e');
      rethrow;
    }
  }


  Future<Map<String, dynamic>> fetchFilteredOutfits({required int currentPage}) async {
    try {
      _logger.d('Fetching filtered outfits for page: $currentPage');

      final response = await Supabase.instance.client.rpc(
        'get_filtered_outfits',
        params: {'p_current_page': currentPage},
      );

      _logger.d('RPC Response: $response');

      if (response is Map<String, dynamic>) {
        final status = response['status'];

        if (status == 'success') {
          _logger.i('✅ Filtered outfits fetched successfully');
          return response;
        }

        if (status == 'no_user_outfits' || status == 'no_filtered_outfits') {
          _logger.w('⚠️ No outfits found: $status');
          return response; // Returning the response without throwing an exception
        }
      }

      _logger.e('Unexpected response format: $response');
      return {'status': 'error', 'message': 'Unexpected response format'};

    } catch (e) {
      _logger.e('❌ Error fetching filtered outfits: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> fetchOutfitById(String outfitId) async {
    try {
      _logger.d('Fetching outfit details for outfitId: $outfitId');

      final response = await Supabase.instance.client.rpc(
        'get_outfit_by_id',
        params: {'_outfit_id': outfitId},
      ) as Map<String, dynamic>;

      if (response.isNotEmpty && response['status'] == 'success') {
        _logger.i('Outfit details fetched successfully: $response');
        return response;
      } else {
        _logger.e('Unexpected response format or no data returned: $response');
        throw Exception('Unexpected response format or no data returned');
      }
    } catch (e) {
      _logger.e('Error fetching outfit details: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchRelatedOutfits({
    required String outfitId,
    required int currentPage,
  }) async {
    try {
      _logger.d('Fetching related outfits for outfitId: $outfitId, page: $currentPage');

      final response = await Supabase.instance.client.rpc(
        'get_related_outfits',
        params: {'_outfit_id': outfitId, 'p_current_page': currentPage},
      );

      if (response is Map<String, dynamic>) {
        if (response['status'] == 'no_similar_items') {
          _logger.i('No related outfits found for outfitId: $outfitId');
          return {'status': 'no_similar_items'};
        } else if (response['status'] == 'success' && response.containsKey('outfits')) {
          _logger.i('Related outfits fetched successfully for outfitId: $outfitId');
          return response;
        } else {
          _logger.e('Unexpected response format: $response');
          throw Exception('Unexpected response format');
        }
      } else {
        _logger.e('Unexpected response type: ${response.runtimeType}');
        throw Exception('Unexpected response type');
      }
    } catch (e) {
      _logger.e('Error fetching related outfits: $e');
      rethrow;
    }
  }

  Future<bool> fetchCalendarSelection() async {
    try {
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      if (userId == null) {
        _logger.e('User ID is null. Cannot fetch is_calendar_selectable.');
        return false;
      }

      _logger.d('Fetching is_calendar_selectable for user: $userId');

      final data = await Supabase.instance.client
          .from('shared_preferences')
          .select('is_calendar_selectable')
          .eq('user_id', userId)
          .single();

      if (data.isNotEmpty) {
        final isSelectable = data['is_calendar_selectable'] as bool? ?? false;
        _logger.i('Fetched is_calendar_selectable: $isSelectable for user: $userId');
        return isSelectable;
      } else {
        _logger.w('No data found for is_calendar_selectable, defaulting to false');
        return false;
      }
    } catch (e) {
      _logger.e('Error fetching is_calendar_selectable: $e');
      return false;
    }
  }

  Future<bool> isFirstTimeTutorial({required String tutorialInput}) async {
    _logger.i('Checking if this is the first interaction for tutorial: $tutorialInput');

    try {
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      if (userId == null) {
        _logger.e('AuthBloc.userId is null — user might not be authenticated.');
        return false;
      }

      final data = await Supabase.instance.client
          .from('tutorial_progress')
          .select('user_id')
          .eq('user_id', userId)
          .eq('tutorial_name', tutorialInput)
          .maybeSingle();

      if (data == null) {
        _logger.i('No matching tutorial entry — first-time interaction.');
        return true;
      } else {
        _logger.i('Tutorial already interacted with — not first-time.');
        return false;
      }
    } catch (e) {
      _logger.e('Error checking tutorial interaction: $e');
      return false;
    }
  }

  Future<bool> isFirstTimeScenario() async {
    _logger.i('Checking if this is the first time scenario');

    try {
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      if (userId == null) {
        _logger.e('AuthBloc.userId is null — user might not be authenticated.');
        return false;
      }

      final data = await Supabase.instance.client
          .from('tutorial_progress')
          .select('user_id')
          .eq('user_id', userId)
          .eq('tutorial_type', 'scenario')
          .limit(1)
          .maybeSingle();

      if (data == null) {
        _logger.i('No scenarios has being created.');
        return true;
      } else {
        _logger.i('They have decided a scenario');
        return false;
      }
    } catch (e) {
      _logger.e('Error checking scenario: $e');
      return false;
    }
  }

  Future<String> fetchPersonalizationFlowType() async {
    _logger.i('Fetching personalization flow type for current user');

    try {
      final authBloc = locator<AuthBloc>();
      final userId = authBloc.userId;

      if (userId == null) {
        _logger.e('AuthBloc.userId is null — user might not be authenticated.');
        return 'default_flow';
      }

      final data = await Supabase.instance.client
          .from('shared_preferences')
          .select('personalization_flow_type')
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null || data['personalization_flow_type'] == null) {
        _logger.w('No personalization_flow_type found — returning default.');
        return 'default_flow';
      }

      final flowType = data['personalization_flow_type'] as String;
      _logger.i('Fetched personalization flow type: $flowType');
      return flowType;
    } catch (e) {
      _logger.e('Error fetching personalization flow type: $e');
      return 'default_flow';
    }
  }

}
