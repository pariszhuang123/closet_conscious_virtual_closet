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
  editClosetBronze,
  editClosetSilver,
  editClosetGold,
  multiOutfit,
  customize,
  filter,
  multicloset
}

extension FeatureKeyExtension on FeatureKey {
  String get key {
    switch (this) {
      case FeatureKey.uploadItemBronze:
        return 'com.makinglifeeasie.closetconscious.bronzeuploaditem';
      case FeatureKey.uploadItemSilver:
        return 'com.makinglifeeasie.closetconscious.silveruploaditem';
      case FeatureKey.uploadItemGold:
        return 'com.makinglifeeasie.closetconscious.golduploaditem';
      case FeatureKey.editItemBronze:
        return 'com.makinglifeeasie.closetconscious.bronzeedititem';
      case FeatureKey.editItemSilver:
        return 'com.makinglifeeasie.closetconscious.silveredititem';
      case FeatureKey.editItemGold:
        return 'com.makinglifeeasie.closetconscious.goldedititem';
      case FeatureKey.selfieBronze:
        return 'com.makinglifeeasie.closetconscious.bronzeselfie';
      case FeatureKey.selfieSilver:
        return 'com.makinglifeeasie.closetconscious.silverselfie';
      case FeatureKey.selfieGold:
        return 'com.makinglifeeasie.closetconscious.goldselfie';
      case FeatureKey.editClosetBronze:
        return 'com.makinglifeeasie.closetconscious.bronzeclosetphoto';
      case FeatureKey.editClosetSilver:
        return 'com.makinglifeeasie.closetconscious.silverclosetphoto';
      case FeatureKey.editClosetGold:
        return 'com.makinglifeeasie.closetconscious.goldclosetphoto';
      case FeatureKey.multiOutfit:
        return 'com.makinglifeeasie.closetconscious.multipleoutfits';
      case FeatureKey.customize:
        return 'com.makinglifeeasie.closetconscious.arrange';
      case FeatureKey.filter:
        return 'com.makinglifeeasie.closetconscious.filter';
      case FeatureKey.multicloset:
        return 'com.makinglifeeasie.closetconscious.multicloset';
    }
  }
}
