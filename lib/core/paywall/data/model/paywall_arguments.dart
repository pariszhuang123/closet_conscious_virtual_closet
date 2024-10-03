class PaywallArguments {
  final String featureKey;         // Feature key for paywall logic
  final bool isFromMyCloset;
  final String previousRoute;     // Previous route (can be null)
  final String nextRoute;         // Next route after payment (can be null)
  final String? itemId;            // Optional itemId
  final String? outfitId;          // Optional outfitId

  PaywallArguments({
    required this.featureKey,
    required this.isFromMyCloset,
    required this.previousRoute,
    required this.nextRoute,
    this.itemId,
    this.outfitId,
  });
}
