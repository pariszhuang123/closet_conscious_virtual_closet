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
      TypeData((context) => S.of(context).Spring, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Spring.png'),
      TypeData((context) => S.of(context).Summer, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Summer.png'),
      TypeData((context) => S.of(context).Autumn, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Autumn.png'),
      TypeData((context) => S.of(context).Winter, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Winter.png'),
      TypeData((context) => S.of(context).Multi, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/All_Temperature.png'),
    ];
  }

  static List<TypeData> clothingTypes(BuildContext context) {
    return [
      TypeData((context) => S.of(context).Top, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/t-shirt.png'),
      TypeData((context) => S.of(context).Bottom, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/long-pant.png'),
      TypeData((context) => S.of(context).OnePiece, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/long-sleeves-dress.png'),
    ];
  }

  static List<TypeData> clothingLayers(BuildContext context) {
    return [
      TypeData((context) => S.of(context).Base, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Base_Layer.png'),
      TypeData((context) => S.of(context).Mid, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Insulating_Layer.png'),
      TypeData((context) => S.of(context).Outer, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Outer_Layer.png'),
    ];
  }

  static List<TypeData> colors(BuildContext context) {
    return [
      TypeData((context) => S.of(context).Red, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/1.Red.svg'),
      TypeData((context) => S.of(context).Blue, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/3.Blue.svg'),
      TypeData((context) => S.of(context).Green, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/2.Green.svg'),
      TypeData((context) => S.of(context).Yellow, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/4.Yellow.svg'),
      TypeData((context) => S.of(context).Brown, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/5.Brown.svg'),
      TypeData((context) => S.of(context).Grey, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/6.Grey.svg'),
      TypeData((context) => S.of(context).Rainbow, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/Multi-Colour.png'),
      TypeData((context) => S.of(context).Black, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/Black.svg'),
      TypeData((context) => S.of(context).White, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/White.svg'),
    ];
  }

  static List<TypeData> colorVariations(BuildContext context) {
    return [
      TypeData((context) => S.of(context).Light, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Light.svg'),
      TypeData((context) => S.of(context).Medium, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Medium.svg'),
      TypeData((context) => S.of(context).Dark, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Dark.svg'),
    ];
  }

  static List<TypeData> accessoryTypes(BuildContext context) {
    return [
      TypeData((context) => S.of(context).Bag, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/5.shoulder-bag.png'),
      TypeData((context) => S.of(context).Belt, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/6.belt.png'),
      TypeData((context) => S.of(context).Eyewear, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/2.sunglasses.png'),
      TypeData((context) => S.of(context).Gloves, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/8.gloves.png'),
      TypeData((context) => S.of(context).Hat, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/1.hat.png'),
      TypeData((context) => S.of(context).Jewellery, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/7.ring.png'),
      TypeData((context) => S.of(context).Scarf, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/3.scarf.png'),
      TypeData((context) => S.of(context).Tie, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/4.tie.png'),
    ];
  }

  static List<TypeData> itemGeneralTypes(BuildContext context) {
    return [
      TypeData((context) => S.of(context).Clothing, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/shirt.png'),
      TypeData((context) => S.of(context).Shoes, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/Shoe.png'),
      TypeData((context) => S.of(context).Accessory, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/Accessory.png'),
    ];
  }

  static List<TypeData> shoeTypes(BuildContext context) {
    return [
      TypeData((context) => S.of(context).Boots, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/4.boot.png'),
      TypeData((context) => S.of(context).Everyday, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/1.sandals.png'),
      TypeData((context) => S.of(context).Athletic, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/2.running-shoe.png'),
      TypeData((context) => S.of(context).Formal, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/3.high-heels.png'),
      TypeData((context) => S.of(context).Niche, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/5.football.png'),
    ];
  }

  static List<TypeData> occasions(BuildContext context) {
    return [
      TypeData((context) => S.of(context).Active, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png'),
      TypeData((context) => S.of(context).Casual, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/casual.png'),
      TypeData((context) => S.of(context).Workplace, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/working-with-laptop.png'),
      TypeData((context) => S.of(context).Social, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/friends.png'),
      TypeData((context) => S.of(context).Event, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/flamenco-dancers-sexy-couple-silhouettes.png'),
    ];
  }

  static List<TypeData> upload(BuildContext context) {
    return [
      TypeData((context) => S.of(context).upload_upload, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Main/upload_item.svg'),
    ];
  }

  static List<TypeData> filter(BuildContext context) {
    return [
      TypeData((context) => S.of(context).filter_filter, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Main/filter_search.svg'),
    ];
  }

  static List<TypeData> addCloset(BuildContext context) {
    return [
      TypeData((context) => S.of(context).addCloset_addCloset, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Main/Closet_plus.svg'),
    ];
  }

  static List<TypeData> itemUploaded(BuildContext context) {
    return [
      TypeData((context) => S.of(context).itemUploaded_itemUploaded, 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Main/upload_item.svg'),
    ];
  }
}
