import '../../../generated/l10n.dart';
import 'package:flutter/material.dart';

class TypeData {
  final String Function(BuildContext) getName;
  final String? imageUrl;

  TypeData(this.getName, [this.imageUrl]);
}

class TypeDataList {
  static List<TypeData> seasons(BuildContext context) {
    return [
      TypeData((context) => S.of(context).seasons_spring, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Spring.png'),
      TypeData((context) => S.of(context).seasons_summer, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Summer.png'),
      TypeData((context) => S.of(context).seasons_autumn, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Autumn.png'),
      TypeData((context) => S.of(context).seasons_winter, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Winter.png'),
      TypeData((context) => S.of(context).seasons_multi, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/All_Temperature.png'),
    ];
  }

  static List<TypeData> clothingTypes(BuildContext context) {
    return [
      TypeData((context) => S.of(context).clothingTypes_top, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/t-shirt.png'),
      TypeData((context) => S.of(context).clothingTypes_bottom, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/long-pant.png'),
      TypeData((context) => S.of(context).clothingTypes_onePiece, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/long-sleeves-dress.png'),
    ];
  }

  static List<TypeData> clothingLayers(BuildContext context) {
    return [
      TypeData((context) => S.of(context).clothingLayers_base, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Base_Layer.png'),
      TypeData((context) => S.of(context).clothingLayers_mid, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Insulating_Layer.png'),
      TypeData((context) => S.of(context).clothingLayers_outer, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Outer_Layer.png'),
    ];
  }

  static List<TypeData> colors(BuildContext context) {
    return [
      TypeData((context) => S.of(context).colors_red, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/1.Red.svg'),
      TypeData((context) => S.of(context).colors_blue, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/3.Blue.svg'),
      TypeData((context) => S.of(context).colors_green, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/2.Green.svg'),
      TypeData((context) => S.of(context).colors_yellow, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/4.Yellow.svg'),
      TypeData((context) => S.of(context).colors_brown, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/5.Brown.svg'),
      TypeData((context) => S.of(context).colors_grey, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/6.Grey.svg'),
      TypeData((context) => S.of(context).colors_rainbow, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/Multi-Colour.png'),
      TypeData((context) => S.of(context).colors_black, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/Black.svg'),
      TypeData((context) => S.of(context).colors_white, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/White.svg'),
    ];
  }

  static List<TypeData> colorVariations(BuildContext context) {
    return [
      TypeData((context) => S.of(context).colorVariations_light, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Light.svg'),
      TypeData((context) => S.of(context).colorVariations_medium, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Medium.svg'),
      TypeData((context) => S.of(context).colorVariations_dark, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Dark.svg'),
    ];
  }

  static List<TypeData> accessoryTypes(BuildContext context) {
    return [
      TypeData((context) => S.of(context).accessoryTypes_bag, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/5.shoulder-bag.png'),
      TypeData((context) => S.of(context).accessoryTypes_belt, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/6.belt.png'),
      TypeData((context) => S.of(context).accessoryTypes_eyewear, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/2.sunglasses.png'),
      TypeData((context) => S.of(context).accessoryTypes_gloves, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/8.gloves.png'),
      TypeData((context) => S.of(context).accessoryTypes_hat, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/1.hat.png'),
      TypeData((context) => S.of(context).accessoryTypes_jewellery, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/7.ring.png'),
      TypeData((context) => S.of(context).accessoryTypes_scarf, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/3.scarf.png'),
      TypeData((context) => S.of(context).accessoryTypes_tie, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/4.tie.png'),
    ];
  }

  static List<TypeData> itemGeneralTypes(BuildContext context) {
    return [
      TypeData((context) => S.of(context).itemGeneralTypes_clothing, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/shirt.png'),
      TypeData((context) => S.of(context).itemGeneralTypes_shoes, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/Shoe.png'),
      TypeData((context) => S.of(context).itemGeneralTypes_accessory, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/Accessory.png'),
    ];
  }

  static List<TypeData> shoeTypes(BuildContext context) {
    return [
      TypeData((context) => S.of(context).shoeTypes_boots, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/4.boot.png'),
      TypeData((context) => S.of(context).shoeTypes_casual, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/1.sandals.png'),
      TypeData((context) => S.of(context).shoeTypes_athletic, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/2.running-shoe.png'),
      TypeData((context) => S.of(context).shoeTypes_formal, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/3.high-heels.png'),
      TypeData((context) => S.of(context).shoeTypes_niche, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/5.football.png'),
    ];
  }

  static List<TypeData> occasions(BuildContext context) {
    return [
      TypeData((context) => S.of(context).occasions_active, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png'),
      TypeData((context) => S.of(context).occasions_casual, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/casual.png'),
      TypeData((context) => S.of(context).occasions_workplace, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/working-with-laptop.png'),
      TypeData((context) => S.of(context).occasions_social, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/friends.png'),
      TypeData((context) => S.of(context).occasions_event, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/flamenco-dancers-sexy-couple-silhouettes.png'),
    ];
  }

  static List<TypeData> upload(BuildContext context) {
    return [
      TypeData((context) => S.of(context).upload_upload, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png'),
    ];
  }

  static List<TypeData> filter(BuildContext context) {
    return [
      TypeData((context) => S.of(context).filter_filter, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png'),
    ];
  }

  static List<TypeData> addCloset(BuildContext context) {
    return [
      TypeData((context) => S.of(context).addCloset_addCloset, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png'),
    ];
  }

  static List<TypeData> itemUploaded(BuildContext context) {
    return [
      TypeData((context) => S.of(context).itemUploaded_itemUploaded, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png'),
    ];
  }
}
