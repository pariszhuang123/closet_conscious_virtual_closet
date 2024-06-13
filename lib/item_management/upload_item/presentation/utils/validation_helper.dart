class ValidationHelper {
  String? validateItemName(String? itemName) {
    return itemName == null || itemName.isEmpty ? 'Item Name is required' : null;
  }

  String? validateAmount(String? amount) {
    return amount == null || amount.isEmpty ? 'Amount is required' : null;
  }

  String? validateItemType(String? itemType) {
    return itemType == null ? 'Item Type is required' : null;
  }

  String? validateOccasion(String? occasion) {
    return occasion == null ? 'Occasion is required' : null;
  }

  String? validateSeason(String? season) {
    return season == null ? 'Season is required' : null;
  }

  String? validateColor(String? color) {
    return color == null ? 'Color is required' : null;
  }

  String? validateColorVariation(String? colorVariation) {
    return colorVariation == null ? 'Color Variation is required' : null;
  }

  String? validateClothingType(String? clothingType) {
    return clothingType == null ? 'Clothing Type is required' : null;
  }

  String? validateClothingLayer(String? clothingLayer) {
    return clothingLayer == null ? 'Clothing Layer is required' : null;
  }

  Map<String, String?> validateFields(
      int currentPage,
      String? itemName,
      String? amount,
      String? itemType,
      String? occasion,
      String? season,
      String? color,
      String? colorVariation,
      String? clothingType,
      String? clothingLayer,
      ) {
    final errors = <String, String?>{};

    if (currentPage == 0) {
      errors['itemNameError'] = validateItemName(itemName);
      errors['amountError'] = validateAmount(amount);
      errors['itemTypeError'] = validateItemType(itemType);
    } else if (currentPage == 1) {
      errors['occasionError'] = validateOccasion(occasion);
      errors['seasonError'] = validateSeason(season);
      errors['colorError'] = validateColor(color);
    } else if (currentPage == 2) {
      errors['colorVariationError'] = validateColorVariation(colorVariation);
      errors['clothingTypeError'] = validateClothingType(clothingType);
      errors['clothingLayerError'] = validateClothingLayer(clothingLayer);
    }

    return errors;
  }
}
