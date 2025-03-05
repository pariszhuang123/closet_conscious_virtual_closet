import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../data/services/item_fetch_service.dart'; // Ensure this is your service file

part 'fetch_item_image_state.dart';

class FetchItemImageCubit extends Cubit<FetchItemImageState> {
  final CustomLogger logger;
  final ItemFetchService itemFetchService;

  FetchItemImageCubit(this.itemFetchService)
      : logger = CustomLogger('FetchItemImagesCubit'),
        super(FetchItemImageInitial());

  Future<void> fetchItemImage(String itemId) async {
    try {
      logger.i('Fetching image URL for item: $itemId');
      emit(FetchItemImageLoading());

      final List<String> imageUrls = await itemFetchService.fetchItemImageUrl(itemId);
      final String imageUrl = imageUrls.isNotEmpty ? imageUrls.first : '';

      emit(FetchItemImageSuccess(imageUrl));
      logger.i('Image URL fetched: $imageUrl');
        } catch (e) {
      emit(const FetchItemImageError('Failed to fetch image'));
      logger.e('Error fetching image URL: $e');
    }
  }
}
