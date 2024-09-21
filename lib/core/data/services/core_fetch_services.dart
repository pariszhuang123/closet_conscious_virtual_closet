import 'package:supabase_flutter/supabase_flutter.dart';

class CoreFetchService {
  final String bucketName;

  CoreFetchService(this.bucketName);

  /// Extracts the relative path from a full URL
  String extractRelativePath(String fullUrl) {
    Uri uri = Uri.parse(fullUrl);
    final bucketIndex = uri.path.indexOf('/$bucketName/');
    if (bucketIndex == -1) {
      throw Exception('Bucket name not found in URL');
    }
    return uri.path.substring(bucketIndex + bucketName.length + 2);
  }

  /// Gets a transformed image URL with the specified width and height
  Future<String> getTransformedImageUrl(String fullUrl, {int? width, int? height}) async {
    final relativePath = extractRelativePath(fullUrl);

    // Apply the transformation
    final String transformedImageUrl = Supabase.instance.client.storage
        .from(bucketName)
        .getPublicUrl(
      relativePath,
      transform: TransformOptions(
        width: width,    // Optionally provide width
        height: height,  // Optionally provide height
      ),
    );

    return transformedImageUrl;
  }
}
