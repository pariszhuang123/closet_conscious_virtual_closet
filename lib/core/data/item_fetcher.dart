import '../../item_management/core/data/models/closet_item_minimal.dart';

abstract class ItemFetcher {
  List<ClosetItemMinimal> get items; // Items to display
  bool get hasMoreItems; // Whether more items can be fetched
  void fetchMoreItems(); // Trigger fetching of more items
  bool get hasCategorySupport; // Whether filtering by category is supported
  List<String> get categories; // Available categories
  String get selectedCategory; // Currently selected category
  void selectCategory(String category); // Change category
}
