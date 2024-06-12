String? itemName;
String? amount;
String? itemType;
String? occasion;
String? season;
String? color;
String? colorVariation;
String? clothingType;
String? clothingLayer;

String? itemNameError;
String? amountError;
String? itemTypeError;
String? occasionError;
String? seasonError;
String? colorError;
String? colorVariationError;
String? clothingTypeError;
String? clothingLayerError;


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

  bool validateFields(
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
      Function(String?) setItemNameError,
      Function(String?) setAmountError,
      Function(String?) setItemTypeError,
      Function(String?) setOccasionError,
      Function(String?) setSeasonError,
      Function(String?) setColorError,
      Function(String?) setColorVariationError,
      Function(String?) setClothingTypeError,
      Function(String?) setClothingLayerError,
      ) {
    if (currentPage == 0) {
      setItemNameError(validateItemName(itemName));
      setAmountError(validateAmount(amount));
      setItemTypeError(validateItemType(itemType));
      return itemNameError == null && amountError == null && itemTypeError == null;
    } else if (currentPage == 1) {
      setOccasionError(validateOccasion(occasion));
      setSeasonError(validateSeason(season));
      setColorError(validateColor(color));
      return occasionError == null && seasonError == null && colorError == null;
    } else if (currentPage == 2) {
      setColorVariationError(validateColorVariation(colorVariation));
      setClothingTypeError(validateClothingType(clothingType));
      setClothingLayerError(validateClothingLayer(clothingLayer));
      return clothingTypeError == null && clothingLayerError == null;
    }

    return false;
  }
}
