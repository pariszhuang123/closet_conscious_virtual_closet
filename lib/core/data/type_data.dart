import '../../../generated/l10n.dart';
import 'package:flutter/material.dart';

class TypeData {
  final String key;
  final String Function(BuildContext) getName;
  final String assetPath;
  final VoidCallback? onPressed;
  final bool usePredefinedColor;

  TypeData(
      this.key,
      this.getName,
      this.assetPath,
      this.usePredefinedColor,
      {
        this.onPressed,
      });
}

class TypeDataList {
  static List<TypeData> seasons(BuildContext context) {
    return [
      TypeData('spring', (context) => S.of(context).spring, 'assets/icons/my_closet/upload/seasonal/spring.svg', false),
      TypeData('summer', (context) => S.of(context).summer, 'assets/icons/my_closet/upload/seasonal/summer.svg', false),
      TypeData('autumn', (context) => S.of(context).autumn, 'assets/icons/my_closet/upload/seasonal/autumn.svg', false),
      TypeData('winter', (context) => S.of(context).winter, 'assets/icons/my_closet/upload/seasonal/winter.svg', false),
      TypeData('multi', (context) => S.of(context).multi, 'assets/icons/my_closet/upload/seasonal/all_season.svg', false),
    ];
  }

  static List<TypeData> clothingTypes(BuildContext context) {
    return [
      TypeData('top', (context) => S.of(context).top, 'assets/icons/my_closet/upload/clothing_type/top.svg', false),
      TypeData('bottom', (context) => S.of(context).bottom, 'assets/icons/my_closet/upload/clothing_type/bottom.svg', false),
      TypeData('onePiece', (context) => S.of(context).onePiece, 'assets/icons/my_closet/upload/clothing_type/one_piece.svg', false),
    ];
  }

  static List<TypeData> clothingLayers(BuildContext context) {
    return [
      TypeData('base', (context) => S.of(context).base, 'assets/icons/my_closet/upload/clothing_layer/base_layer.svg', false),
      TypeData('mid', (context) => S.of(context).mid, 'assets/icons/my_closet/upload/clothing_layer/insulation_layer.svg', false),
      TypeData('outer', (context) => S.of(context).outer, 'assets/icons/my_closet/upload/clothing_layer/outer_layer.svg', false),
    ];
  }

  static List<TypeData> colour(BuildContext context) {
    return [
      TypeData('red', (context) => S.of(context).red, 'assets/icons/my_closet/upload/colouring/red.svg', true),
      TypeData('blue', (context) => S.of(context).blue, 'assets/icons/my_closet/upload/colouring/blue.svg', true),
      TypeData('green', (context) => S.of(context).green, 'assets/icons/my_closet/upload/colouring/green.svg', true),
      TypeData('yellow', (context) => S.of(context).yellow, 'assets/icons/my_closet/upload/colouring/yellow.svg', true),
      TypeData('brown', (context) => S.of(context).brown, 'assets/icons/my_closet/upload/colouring/brown.svg', true),
      TypeData('grey', (context) => S.of(context).grey, 'assets/icons/my_closet/upload/colouring/grey.svg', true),
      TypeData('black', (context) => S.of(context).black, 'assets/icons/my_closet/upload/colouring/black.svg', true),
      TypeData('white', (context) => S.of(context).white, 'assets/icons/my_closet/upload/colouring/white.svg', true),
      TypeData('rainbow', (context) => S.of(context).rainbow, 'assets/icons/my_closet/upload/colouring/rainbow.svg', true),
    ];
  }

  static List<TypeData> colourVariations(BuildContext context) {
    return [
      TypeData('light', (context) => S.of(context).light, 'assets/icons/my_closet/upload/colour_variation/light.svg', true),
      TypeData('medium', (context) => S.of(context).medium, 'assets/icons/my_closet/upload/colour_variation/medium.svg', true),
      TypeData('dark', (context) => S.of(context).dark, 'assets/icons/my_closet/upload/colour_variation/dark.svg', true),
    ];
  }

  static List<TypeData> accessoryTypes(BuildContext context) {
    return [
      TypeData('bag', (context) => S.of(context).bag, 'assets/icons/my_closet/upload/accessory_type/bag.svg', false),
      TypeData('belt', (context) => S.of(context).belt, 'assets/icons/my_closet/upload/accessory_type/belt.svg', false),
      TypeData('eyewear', (context) => S.of(context).eyewear, 'assets/icons/my_closet/upload/accessory_type/eyewear.svg', false),
      TypeData('gloves', (context) => S.of(context).gloves, 'assets/icons/my_closet/upload/accessory_type/gloves.svg', false),
      TypeData('hat', (context) => S.of(context).hat, 'assets/icons/my_closet/upload/accessory_type/hat.svg', false),
      TypeData('jewellery', (context) => S.of(context).jewellery, 'assets/icons/my_closet/upload/accessory_type/jewelery.svg', false),
      TypeData('scarf', (context) => S.of(context).scarf, 'assets/icons/my_closet/upload/accessory_type/scarf.svg', false),
      TypeData('tech', (context) => S.of(context).tech, 'assets/icons/my_closet/upload/accessory_type/tech.svg', false),
      TypeData('perfume', (context) => S.of(context).perfume, 'assets/icons/my_closet/upload/accessory_type/perfume.svg', false),
      TypeData('other', (context) => S.of(context).other, 'assets/icons/my_closet/upload/accessory_type/other.svg', false),
    ];
  }

  static List<TypeData> itemGeneralTypes(BuildContext context) {
    return [
      TypeData('clothing', (context) => S.of(context).clothing, 'assets/icons/my_closet/upload/general_type/clothing.svg', false),
      TypeData('shoes', (context) => S.of(context).shoes, 'assets/icons/my_closet/upload/general_type/shoes.svg', false),
      TypeData('accessory', (context) => S.of(context).accessory, 'assets/icons/my_closet/upload/general_type/accessory.svg', false),
    ];
  }

  static List<TypeData> shoeTypes(BuildContext context) {
    return [
      TypeData('boots', (context) => S.of(context).boots, 'assets/icons/my_closet/upload/shoes_type/boots.svg', false),
      TypeData('everyday', (context) => S.of(context).everyday, 'assets/icons/my_closet/upload/shoes_type/everyday.svg', false),
      TypeData('athletic', (context) => S.of(context).athletic, 'assets/icons/my_closet/upload/shoes_type/athletic.svg', false),
      TypeData('formal', (context) => S.of(context).formal, 'assets/icons/my_closet/upload/shoes_type/formal.svg', false),
      TypeData('niche', (context) => S.of(context).niche, 'assets/icons/my_closet/upload/shoes_type/niche.svg', false),
    ];
  }

  static List<TypeData> occasions(BuildContext context) {
    return [
      TypeData('active', (context) => S.of(context).active, 'assets/icons/my_closet/upload/occasion/active.svg', false),
      TypeData('casual', (context) => S.of(context).casual, 'assets/icons/my_closet/upload/occasion/casual.svg', false),
      TypeData('workplace', (context) => S.of(context).workplace, 'assets/icons/my_closet/upload/occasion/workplace.svg', false),
      TypeData('social', (context) => S.of(context).social, 'assets/icons/my_closet/upload/occasion/social.svg', false),
      TypeData('event', (context) => S.of(context).event, 'assets/icons/my_closet/upload/occasion/event.svg', false),
    ];
  }

  static TypeData upload(BuildContext context) {
    return TypeData('upload_upload', (context) => S.of(context).upload_upload, 'assets/icons/my_closet/upload/upload_item.svg', false);
  }

  static TypeData filter(BuildContext context) {
    return
      TypeData('filter_filter', (context) => S.of(context).filter_filter, 'assets/icons/general/filter_search.svg', false);
  }

  static TypeData arrange(BuildContext context) {
    return
      TypeData('arrange', (context) => S.of(context).arrange, 'assets/icons/general/arrange.svg', false);
  }

  static TypeData swapItem(BuildContext context) {
    return
      TypeData('swap_item', (context) => S.of(context).swap_item, 'assets/icons/general/qr_code.svg', false);
  }

  static TypeData metadata(BuildContext context) {
    return
      TypeData('metadata', (context) => S.of(context).metadata, 'assets/icons/my_closet/upload/more.svg', false);
  }

  static TypeData aistylist(BuildContext context) {
    return TypeData('AI Stylist', (context) => S.of(context).aistylist, 'assets/icons/my_outfit/additional_features/ai_stylist.svg', false);
  }

  static TypeData aiupload(BuildContext context) {
    return TypeData('AI Upload', (context) => S.of(context).aiupload, 'assets/icons/my_closet/upload/ai_upload.svg', false);
  }

  static TypeData outfitsUpload(BuildContext context) {
    return
      TypeData('outfits_upload', (context) => S.of(context).outfits_upload, 'assets/icons/my_outfit/additional_features/outfits_uploaded.svg', false);
  }

  static TypeData calendar(BuildContext context) {
    return
      TypeData('calendar', (context) => S.of(context).calendar, 'assets/icons/my_outfit/additional_features/calendar.svg', false);
  }

  static TypeData addCloset(BuildContext context) {
    return
      TypeData('addCloset_addCloset', (context) => S.of(context).addCloset_addCloset, 'assets/icons/general/add_closet.svg', false);
  }

  static TypeData createCloset(BuildContext context) {
    return
      TypeData('createCloset', (context) => S.of(context).createCloset, 'assets/icons/general/add_closet.svg', false);
  }

  static TypeData allClosets(BuildContext context) {
    return
      TypeData('allClosets', (context) => S.of(context).allClosets, 'assets/icons/general/all_closets.svg', false);
  }

  static TypeData publicCloset(BuildContext context) {
    return
      TypeData('public_closet', (context) => S.of(context).public_closet, 'assets/icons/general/public_closet.svg', false);
  }

  static TypeData archiveCloset(BuildContext context) {
    return
      TypeData('archive_closet', (context) => S.of(context).archiveCloset, 'assets/icons/general/archive.svg', false);
  }

  static TypeData itemUploaded(BuildContext context) {
    return TypeData('itemUploaded_itemUploaded', (context) => S.of(context).itemUploaded_itemUploaded, 'assets/icons/my_closet/stats/apparel.svg', false);
  }

  static TypeData declutterOptionsSell(BuildContext context) {
    return TypeData('sell', (context) => S.of(context).sell, 'assets/icons/my_closet/declutter/sell.svg', false);
  }

  static TypeData declutterOptionsSwap(BuildContext context) {
    return TypeData('swap', (context) => S.of(context).swap, 'assets/icons/my_closet/declutter/swap.svg', false);
  }

  static TypeData declutterOptionsGift(BuildContext context) {
    return TypeData('gift', (context) => S.of(context).gift, 'assets/icons/my_closet/declutter/gift.svg', false);
  }

  static TypeData declutterOptionsThrow(BuildContext context) {
    return TypeData('Throw', (context) => S.of(context).Throw, 'assets/icons/my_closet/declutter/throw.svg', false);
  }

  static TypeData drawerAchievements(BuildContext context) {
    return TypeData('Achievements', (context) => S.of(context).achievements, 'assets/icons/drawer/achievements.svg', false);
  }

  static TypeData drawerInsights(BuildContext context) {
    return TypeData('UsageInsights', (context) => S.of(context).usageInsights, 'assets/icons/drawer/analytics.svg', false);
  }

  static TypeData drawerInfoHub(BuildContext context) {
    return TypeData('Policy', (context) => S.of(context).infoHub, 'assets/icons/drawer/info_hub.svg', false);
  }

  static TypeData drawerContactUs(BuildContext context) {
    return TypeData('ContactUs', (context) => S.of(context).contactUs, 'assets/icons/drawer/contact_us.svg', false);
  }

  static TypeData drawerDeleteAccount(BuildContext context) {
    return TypeData('DeleteAccount', (context) => S.of(context).deleteAccount, 'assets/icons/drawer/delete_account.svg', false);
  }

  static TypeData drawerLogOut(BuildContext context) {
    return TypeData('LogOut', (context) => S.of(context).logOut, 'assets/icons/drawer/logout.svg', false);
  }

  static TypeData currentStreak(BuildContext context) {
    return TypeData('currentStreak', (context) => S.of(context).currentStreak, 'assets/icons/my_closet/stats/current_no_purchase_streak.svg', false);
  }

  static TypeData highestStreak(BuildContext context) {
    return TypeData('highestStreak', (context) => S.of(context).highestStreak, 'assets/icons/my_closet/stats/highest_no_purchase_streak.svg', false);
  }

  static TypeData costOfNewItems(BuildContext context) {
    return TypeData('costOfNewItems', (context) => S.of(context).costOfNewItems, 'assets/icons/my_closet/stats/money.svg', false);
  }

  static TypeData numberOfNewItems(BuildContext context) {
    return TypeData('numberOfNewItems', (context) => S.of(context).numberOfNewItems, 'assets/icons/my_closet/stats/new_clothing_purchase.svg', false);
  }

  static TypeData outfitClothingType(BuildContext context) {
    return TypeData('clothing', (context) => S.of(context).clothing, 'assets/icons/my_closet/upload/general_type/clothing.svg', false);
  }

  static TypeData outfitAccessoryType(BuildContext context) {
    return TypeData('accessory', (context) => S.of(context).accessory, 'assets/icons/my_closet/upload/general_type/accessory.svg', false);
  }

  static TypeData outfitShoesType(BuildContext context) {
    return TypeData('shoes', (context) => S.of(context).shoes, 'assets/icons/my_closet/upload/general_type/shoes.svg', false);
  }

  static TypeData outfitReviewLike(BuildContext context) {
    return TypeData('like', (context) => S.of(context).like, 'assets/icons/my_outfit/outfit_review/like.svg', false);
  }

  static TypeData outfitReviewAlright(BuildContext context) {
    return TypeData('alright', (context) => S.of(context).alright, 'assets/icons/my_outfit/outfit_review/alright.svg', false);
  }

  static TypeData outfitReviewDislike(BuildContext context) {
    return TypeData('dislike', (context) => S.of(context).dislike, 'assets/icons/my_outfit/outfit_review/dislike.svg', false);
  }

  static TypeData selfie(BuildContext context) {
    return TypeData('selfie', (context) => S.of(context).selfie, 'assets/icons/my_outfit/outfit_review/selfie.svg', false);
  }

  static TypeData share(BuildContext context) {
    return TypeData('share', (context) => S.of(context).share, 'assets/icons/my_outfit/outfit_review/share_outfit.svg', false);
  }

  static TypeData reset(BuildContext context) {
    return TypeData('reset', (context) => S.of(context).reset, 'assets/icons/general/restart.svg', false);
  }

  static TypeData selectAll(BuildContext context) {
    return TypeData('selectAll', (context) => S.of(context).selectAll, 'assets/icons/general/select_all.svg', false);
  }

  static TypeData focus(BuildContext context) {
    return TypeData('focus', (context) => S.of(context).focus, 'assets/icons/my_outfit/calendar/zoom_in.svg', false);
  }

  static TypeData summaryItemAnalytics(BuildContext context) {
    return TypeData('summaryItemAnalytics', (context) => S.of(context).summaryItemAnalytics, 'assets/icons/general/item_analytics.svg', false);
  }

  static TypeData summaryOutfitAnalytics(BuildContext context) {
    return TypeData('summaryOutfitAnalytics', (context) => S.of(context).summaryOutfitAnalytics, 'assets/icons/general/outfit_analytics.svg', false);
  }

  static TypeData previous(BuildContext context) {
    return TypeData('previous', (context) => S.of(context).previous, 'assets/icons/my_outfit/calendar/chevron_left.svg', false);
  }

  static TypeData next(BuildContext context) {
    return TypeData('next', (context) => S.of(context).next, 'assets/icons/my_outfit/calendar/chevron_right.svg', false);
  }

  static List<TypeData> gridSizes(BuildContext context) {
    return [
      TypeData('3', (context) => S.of(context).gridSize3, 'assets/icons/general/arrange/counter_3.svg', false),
      TypeData('5', (context) => S.of(context).gridSize5, 'assets/icons/general/arrange/counter_5.svg', false),
      TypeData('7', (context) => S.of(context).gridSize7, 'assets/icons/general/arrange/counter_7.svg', false),
    ];
  }
  static List<TypeData> sortCategories(BuildContext context) {
    return [
      TypeData('updated_at', (context) => S.of(context).updatedAt, 'assets/icons/general/arrange/updated_at.svg', false),
      TypeData('created_at', (context) => S.of(context).createdAt, 'assets/icons/general/arrange/created_at.svg', false),
      TypeData('amount_spent', (context) => S.of(context).amountSpent, 'assets/icons/general/arrange/amount_spent.svg', false),
      TypeData('item_last_worn', (context) => S.of(context).itemLastWorn, 'assets/icons/general/arrange/item_last_worn.svg', false),
      TypeData('worn_in_outfit', (context) => S.of(context).wornInOutfit, 'assets/icons/general/arrange/worn_in_outfit.svg', false),
      TypeData('price_per_wear', (context) => S.of(context).pricePerWear, 'assets/icons/general/arrange/price_per_wear.svg', false),
    ];
  }
  static List<TypeData> sortOrder(BuildContext context) {
    return [
      TypeData('ASC', (context) => S.of(context).ascending, 'assets/icons/drawer/analytics/ascending.svg', false),
      TypeData('DESC', (context) => S.of(context).descending, 'assets/icons/drawer/analytics/descending.svg', false),
    ];
  }
}