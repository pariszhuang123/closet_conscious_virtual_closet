enum FeatureKey {
  uploadItemBronze,
  uploadItemSilver,
  uploadItemGold,
  editItemBronze,
  editItemSilver,
  editItemGold,
  selfieBronze,
  selfieSilver,
  selfieGold,
  multiOutfit
}

extension FeatureKeyExtension on FeatureKey {
  String get key {
    switch (this) {
      case FeatureKey.uploadItemBronze:
        return 'upload_item_bronze';
      case FeatureKey.uploadItemSilver:
        return 'upload_item_silver';
      case FeatureKey.uploadItemGold:
        return 'upload_item_gold';
      case FeatureKey.editItemBronze:
        return 'edit_item_bronze';
      case FeatureKey.editItemSilver:
        return 'edit_item_silver';
      case FeatureKey.editItemGold:
        return 'edit_item_gold';
      case FeatureKey.selfieBronze:
        return 'selfie_bronze';
      case FeatureKey.selfieSilver:
        return 'selfie_silver';
      case FeatureKey.selfieGold:
        return 'selfie_gold';
      case FeatureKey.multiOutfit:
        return 'multi_outfit';
    }
  }
}
