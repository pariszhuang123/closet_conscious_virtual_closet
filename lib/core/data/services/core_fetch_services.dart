import 'package:supabase_flutter/supabase_flutter.dart';
import '../../utilities/logger.dart';
import '../../filter/data/models/filter_setting.dart';

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
          'itemName': response['f_item_name'] as String,
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

      if (response.error != null) {
        _logger.e('Error fetching related outfits: ${response.error!.message}');
        throw Exception('Error fetching related outfits: ${response.error!.message}');
      }

      final data = response.data as Map<String, dynamic>?;
      if (data == null) {
        _logger.e('Unexpected response format or no data returned');
        throw Exception('Unexpected response format or no data returned');
      }

      _logger.i('Successfully fetched related outfits: $data');
      return data;
    } catch (e) {
      _logger.e('Error in getItemRelatedOutfits: $e');
      rethrow;
    }
  }

  /// Fetches outfit usage analytics from Supabase RPC `get_outfit_usage_analytics`
  Future<Map<String, dynamic>> getOutfitUsageAnalytics() async {
    try {
      _logger.d('Fetching outfit usage analytics from RPC');

      final response = await Supabase.instance.client.rpc('get_outfit_usage_analytics');

      if (response.error != null) {
        _logger.e('Error fetching outfit usage analytics: ${response.error!.message}');
        throw Exception(response.error!.message);
      }

      if (response.data == null || response.data.isEmpty) {
        _logger.e('No outfit usage analytics data returned.');
        throw Exception('No data returned from RPC.');
      }

      // Extract first row (since the RPC returns a single row of data)
      final Map<String, dynamic> analyticsData = response.data[0];

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

      if (response is Map<String, dynamic> && response['status'] == 'success') {
        _logger.i('Filtered outfits fetched successfully');
        return response;
      } else {
        _logger.e('Unexpected response format: $response');
        throw Exception('Failed to fetch filtered outfits');
      }
    } catch (e) {
      _logger.e('Error fetching filtered outfits: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchRelatedOutfits(String outfitId) async {
    try {
      _logger.d('Fetching related outfits for outfitId: $outfitId');

      final response = await Supabase.instance.client.rpc(
        'get_related_outfits',
        params: {'f_outfit_id': outfitId},
      ) as Map<String, dynamic>;

      if (response.isNotEmpty) {
        _logger.i('Related outfits fetched successfully: $response');
        return response;
      } else {
        _logger.e('Unexpected response format or no data returned: $response');
        throw Exception('Unexpected response format or no data returned');
      }
    } catch (e) {
      _logger.e('Error fetching related outfits: $e');
      rethrow;
    }
  }
}
