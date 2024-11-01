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

  /// Calls the check_user_access_to_upload_items function to fetch upload access status
  Future<Map<String, dynamic>> checkUserAccessToUploadItems() async {
    try {
      _logger.d('Checking user access to upload items');
      final response = await Supabase.instance.client.rpc('check_user_access_to_upload_items') as Map<String, dynamic>;

      if (response.isNotEmpty) {
        _logger.i('User upload access fetched successfully');
        return response;  // The response is already the data you need
      } else {
        _logger.e('Unexpected response format or no data returned: $response');
        throw Exception('Unexpected response format or no data returned');
      }
    } catch (e) {
      _logger.e('Error checking user access to upload items: $e');
      rethrow;
    }
  }

  /// Calls the check_user_access_to_edit_items function to fetch edit access status
  Future<Map<String, dynamic>> checkUserAccessToEditItems() async {
    try {
      _logger.d('Checking user access to edit items');
      final response = await Supabase.instance.client.rpc('check_user_access_to_edit_items') as Map<String, dynamic>;

      if (response.isNotEmpty) {
        _logger.i('User upload access fetched successfully');
        return response;  // The response is already the data you need
      } else {
        _logger.e('Unexpected response format or no data returned: $response');
        throw Exception('Unexpected response format or no data returned');
      }
    } catch (e) {
      _logger.e('Error checking user access to edit items: $e');
      rethrow;
    }
  }

  /// Calls the check_user_access_to_take_selfies function to fetch selfie access status
  Future<Map<String, dynamic>> checkUserAccessToSelfie() async {
    try {
      _logger.d('Checking user access to take selfies');
      final response = await Supabase.instance.client.rpc('check_user_access_to_create_selfie') as Map<String, dynamic>;

      if (response.isNotEmpty) {
        _logger.i('User upload access fetched successfully');
        return response;  // The response is already the data you need
      } else {
        _logger.e('Unexpected response format or no data returned: $response');
        throw Exception('Unexpected response format or no data returned');
      }
    } catch (e) {
      _logger.e('Error checking user access to create selfie: $e');
      rethrow;
    }
  }
  Future<int> fetchCrossAxisCount() async {
    final data = await Supabase.instance.client
        .from('shared_preferences')
        .select('grid')
        .single();

    if (data.isNotEmpty) {
      return data['grid'] as int? ?? 3; // Default to 3 if null
    } else {
      // Handle error, log if needed
      return 3; // Default to 3 if error
    }
  }

  Future<Map<String, dynamic>> fetchArrangementSettings() async {
    try {
      _logger.d('Fetching arrangement settings from Supabase...');
      final data = await Supabase.instance.client
          .from('shared_preferences')
          .select('grid, sort, sort_order')
          .single();


      _logger.i('Arrangement settings fetched successfully.');
      return data;
    } catch (e) {
      _logger.e('Error fetching arrangement settings: $e');
      rethrow;
    }
  }

  Future<bool> accessCustomizePage() async {
    _logger.i('Starting access check for customize page.');

    try {
      final result = await Supabase.instance.client.rpc('check_user_access_to_access_customize_page');
      if (result is bool) {
        _logger.i('Access check completed successfully. Result: $result');
        return result;
      } else {
        _logger.e('Unexpected result type from RPC: $result');
        throw Exception('Unexpected result from RPC: $result');
      }
    } catch (error) {
      _logger.e('Error during access check for customize page: $error');
      throw Exception('Failed to access customize page: $error');
    }
  }

  Future<Map<String, dynamic>> fetchFilterSettings() async {
    // Call the Supabase RPC function
    final response = await Supabase.instance.client.rpc('fetch_filter_settings');

    if (response == null) {
      throw Exception('Error: RPC call returned null');
    } else {
      // Parse the filter data using the FilterSettings model
      final FilterSettings filterSettings = FilterSettings.fromJson(response['f_filter'] ?? {});

      // Construct the result with all relevant fields
      return {
        'filters': filterSettings,
        'closetId': response['f_closet_id'] as String,
        'allCloset': response['f_all_closet'] as bool,
        'ignoreItemName': response['f_ignore_item_name'] as bool,
        'itemName': response['f_item_name'] as String,
      };
    }
  }

  Future<bool> accessFilterPage() async {
    _logger.i('Starting access check for filter page.');

    try {
      final result = await Supabase.instance.client.rpc('check_user_access_to_access_filter_page');
      if (result is bool) {
        _logger.i('Access check completed successfully. Result: $result');
        return result;
      } else {
        _logger.e('Unexpected result type from RPC: $result');
        throw Exception('Unexpected result from RPC: $result');
      }
    } catch (error) {
      _logger.e('Error during access check for filter page: $error');
      throw Exception('Failed to access filter page: $error');
    }
  }
}
