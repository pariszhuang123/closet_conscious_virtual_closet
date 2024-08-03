import '../../../generated/l10n.dart';
import 'package:flutter/material.dart';

class TypeData {
  final String key;
  final String Function(BuildContext) getName;
  final String? imagePath;
  final bool isAsset;
  final VoidCallback? onPressed;

  TypeData(this.key, this.getName, this.imagePath, {this.isAsset = false, this.onPressed});
}

class TypeDataList {
  static List<TypeData> seasons(BuildContext context) {
    return [
      TypeData('spring', (context) => S.of(context).spring, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Spring.png'),
      TypeData('summer', (context) => S.of(context).summer, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Summer.png'),
      TypeData('autumn', (context) => S.of(context).autumn, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Autumn.png'),
      TypeData('winter', (context) => S.of(context).winter, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Winter.png'),
      TypeData('multi', (context) => S.of(context).multi, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/All_Temperature.png'),
    ];
  }

  static List<TypeData> clothingTypes(BuildContext context) {
    return [
      TypeData('top', (context) => S.of(context).top, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/t-shirt.png'),
      TypeData('bottom', (context) => S.of(context).bottom, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/long-pant.png'),
      TypeData('onePiece', (context) => S.of(context).onePiece, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/long-sleeves-dress.png'),
    ];
  }

  static List<TypeData> clothingLayers(BuildContext context) {
    return [
      TypeData('base', (context) => S.of(context).base, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Base_Layer.png'),
      TypeData('mid', (context) => S.of(context).mid, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Insulating_Layer.png'),
      TypeData('outer', (context) => S.of(context).outer, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Outer_Layer.png'),
    ];
  }

  static List<TypeData> colors(BuildContext context) {
    return [
      TypeData('red', (context) => S.of(context).red, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/1.Red.svg'),
      TypeData('blue', (context) => S.of(context).blue, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/3.Blue.svg'),
      TypeData('green', (context) => S.of(context).green, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/2.Green.svg'),
      TypeData('yellow', (context) => S.of(context).yellow, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/4.Yellow.svg'),
      TypeData('brown', (context) => S.of(context).brown, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/5.Brown.svg'),
      TypeData('grey', (context) => S.of(context).grey, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/6.Grey.svg'),
      TypeData('rainbow', (context) => S.of(context).rainbow, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/Multi-Colour.png'),
      TypeData('black', (context) => S.of(context).black, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/Black.svg'),
      TypeData('white', (context) => S.of(context).white, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/White.svg'),
    ];
  }

  static List<TypeData> colorVariations(BuildContext context) {
    return [
      TypeData('light', (context) => S.of(context).light, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Light.svg'),
      TypeData('medium', (context) => S.of(context).medium, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Medium.svg'),
      TypeData('dark', (context) => S.of(context).dark, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Dark.svg'),
    ];
  }

  static List<TypeData> accessoryTypes(BuildContext context) {
    return [
      TypeData('bag', (context) => S.of(context).bag, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/5.shoulder-bag.png'),
      TypeData('belt', (context) => S.of(context).belt, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/6.belt.png'),
      TypeData('eyewear', (context) => S.of(context).eyewear, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/2.sunglasses.png'),
      TypeData('gloves', (context) => S.of(context).gloves, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/8.gloves.png'),
      TypeData('hat', (context) => S.of(context).hat, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/1.hat.png'),
      TypeData('jewellery', (context) => S.of(context).jewellery, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/7.ring.png'),
      TypeData('scarf', (context) => S.of(context).scarf, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/3.scarf.png'),
      TypeData('tie', (context) => S.of(context).tie, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/4.tie.png'),
    ];
  }

  static List<TypeData> itemGeneralTypes(BuildContext context) {
    return [
      TypeData('clothing', (context) => S.of(context).clothing, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/shirt.png'),
      TypeData('shoes', (context) => S.of(context).shoes, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/Shoe.png'),
      TypeData('accessory', (context) => S.of(context).accessory, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/Accessory.png'),
    ];
  }

  static List<TypeData> shoeTypes(BuildContext context) {
    return [
      TypeData('boots', (context) => S.of(context).boots, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/4.boot.png'),
      TypeData('everyday', (context) => S.of(context).everyday, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/1.sandals.png'),
      TypeData('athletic', (context) => S.of(context).athletic, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/2.running-shoe.png'),
      TypeData('formal', (context) => S.of(context).formal, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/3.high-heels.png'),
      TypeData('niche', (context) => S.of(context).niche, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/5.football.png'),
    ];
  }

  static List<TypeData> occasions(BuildContext context) {
    return [
      TypeData('active', (context) => S.of(context).active, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png'),
      TypeData('casual', (context) => S.of(context).casual, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/casual.png'),
      TypeData('workplace', (context) => S.of(context).workplace, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/working-with-laptop.png'),
      TypeData('social', (context) => S.of(context).social, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/friends.png'),
      TypeData('event', (context) => S.of(context).event, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/flamenco-dancers-sexy-couple-silhouettes.png'),
    ];
  }

  static TypeData upload(BuildContext context) {
    return TypeData('upload_upload', (context) => S.of(context).upload_upload, 'assets/icons/my_closet/additional_features/upload_item.svg', isAsset: true);
  }

  static TypeData filter(BuildContext context) {
    return
      TypeData('filter_filter', (context) => S.of(context).filter_filter, 'assets/icons/my_closet/additional_features/filter_search.svg', isAsset: true);
  }

  static TypeData outfitsUpload(BuildContext context) {
    return
      TypeData('outfits_upload', (context) => S.of(context).outfits_upload, 'assets/icons/my_outfit/additional_features/outfits_uploaded.svg', isAsset: true);
  }

  static TypeData calendar(BuildContext context) {
    return
      TypeData('calendar', (context) => S.of(context).calendar, 'assets/icons/my_outfit/additional_features/calendar.svg', isAsset: true);
  }

  static TypeData addCloset(BuildContext context) {
    return
      TypeData('addCloset_addCloset', (context) => S.of(context).addCloset_addCloset, 'assets/icons/my_closet/additional_features/add_closet.svg', isAsset: true);
  }

  static TypeData itemUploaded(BuildContext context) {
    return TypeData('itemUploaded_itemUploaded', (context) => S.of(context).itemUploaded_itemUploaded, 'assets/icons/my_closet/additional_features/apparel.svg', isAsset: true);
  }

  static TypeData declutterOptionsSell(BuildContext context) {
    return TypeData('sell', (context) => S.of(context).sell, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Declutter/sell.png');
  }

  static TypeData declutterOptionsSwap(BuildContext context) {
    return TypeData('swap', (context) => S.of(context).swap, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Declutter/swap.png');
  }

  static TypeData declutterOptionsGift(BuildContext context) {
    return TypeData('gift', (context) => S.of(context).gift, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Declutter/pay_it_forward.png');
  }

  static TypeData declutterOptionsThrow(BuildContext context) {
    return TypeData('Throw', (context) => S.of(context).Throw, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Declutter/throw.png');
  }

  static TypeData drawerAchievements(BuildContext context) {
    return TypeData('Achievements', (context) => S.of(context).achievements, 'assets/icons/drawer/achievements.svg', isAsset: true);
  }

  static TypeData drawerInsights(BuildContext context) {
    return TypeData('UsageInsights', (context) => S.of(context).usageInsights, 'assets/icons/drawer/analytics.svg', isAsset: true);
  }

  static TypeData drawerInfoHub(BuildContext context) {
    return TypeData('Policy', (context) => S.of(context).infoHub, 'assets/icons/drawer/info_hub.svg', isAsset: true);
  }

  static TypeData drawerContactUs(BuildContext context) {
    return TypeData('ContactUs', (context) => S.of(context).contactUs, 'assets/icons/drawer/contact_us.svg', isAsset: true);
  }

  static TypeData drawerDeleteAccount(BuildContext context) {
    return TypeData('DeleteAccount', (context) => S.of(context).deleteAccount, 'assets/icons/drawer/delete_account.svg', isAsset: true);
  }

  static TypeData drawerLogOut(BuildContext context) {
    return TypeData('LogOut', (context) => S.of(context).logOut, 'assets/icons/drawer/logout.svg', isAsset: true);
  }

  static TypeData currentStreak(BuildContext context) {
    return TypeData('currentStreak', (context) => S.of(context).currentStreak, 'assets/icons/my_closet/gamification/closet_completed/current_no_purchase_streak.svg', isAsset: true);
  }

  static TypeData highestStreak(BuildContext context) {
    return TypeData('highestStreak', (context) => S.of(context).highestStreak, 'assets/icons/my_closet/gamification/closet_completed/highest_no_purchase_streak.svg', isAsset: true);
  }

  static TypeData costOfNewItems(BuildContext context) {
    return TypeData('costOfNewItems', (context) => S.of(context).costOfNewItems, 'assets/icons/my_closet/gamification/closet_completed/money.svg', isAsset: true);
  }

  static TypeData numberOfNewItems(BuildContext context) {
    return TypeData('numberOfNewItems', (context) => S.of(context).numberOfNewItems, 'assets/icons/my_closet/gamification/closet_completed/new_clothing_purchase.svg', isAsset: true);
  }

  static TypeData outfitClothingType(BuildContext context) {
    return TypeData('clothing', (context) => S.of(context).clothing, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/shirt.png');
  }

  static TypeData outfitAccessoryType(BuildContext context) {
    return TypeData('accessory', (context) => S.of(context).accessory, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/Accessory.png');
  }

  static TypeData outfitShoesType(BuildContext context) {
    return TypeData('shoes', (context) => S.of(context).shoes, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/Shoe.png');
  }

}