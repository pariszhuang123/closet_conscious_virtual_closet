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


Future<List<Map<String, dynamic>>> fetchPermanentClosets() async {
    try {
      final data = await Supabase.instance.client
          .from('user_closets')
          .select('closet_id, closet_name, closet_image')
          .eq('type', 'permanent')
          .eq('is_active', true);

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
          .eq('is_active', true);

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
}
