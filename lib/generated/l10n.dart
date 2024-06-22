// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Closet Conscious`
  String get AppName {
    return Intl.message(
      'Closet Conscious',
      name: 'AppName',
      desc: '',
      args: [],
    );
  }

  /// `You are currently offline`
  String get offlineStatus {
    return Intl.message(
      'You are currently offline',
      name: 'offlineStatus',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retryConnection {
    return Intl.message(
      'Retry',
      name: 'retryConnection',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get ItemNameLabel {
    return Intl.message(
      'Name',
      name: 'ItemNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `'What is the name of your item?`
  String get ItemNameHint {
    return Intl.message(
      '\'What is the name of your item?',
      name: 'ItemNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get AmountLabel {
    return Intl.message(
      'Amount',
      name: 'AmountLabel',
      desc: '',
      args: [],
    );
  }

  /// `'How much did the item cost?`
  String get AmountHint {
    return Intl.message(
      '\'How much did the item cost?',
      name: 'AmountHint',
      desc: '',
      args: [],
    );
  }

  /// `Occassion`
  String get ItemOccasionLabel {
    return Intl.message(
      'Occassion',
      name: 'ItemOccasionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Season`
  String get ItemSeasonLabel {
    return Intl.message(
      'Season',
      name: 'ItemSeasonLabel',
      desc: '',
      args: [],
    );
  }

  /// `Colour`
  String get ItemColourLabel {
    return Intl.message(
      'Colour',
      name: 'ItemColourLabel',
      desc: '',
      args: [],
    );
  }

  /// `Colour Variation`
  String get ItemColourVariationLabel {
    return Intl.message(
      'Colour Variation',
      name: 'ItemColourVariationLabel',
      desc: '',
      args: [],
    );
  }

  /// `Clothing Type`
  String get ItemClothingTypeLabel {
    return Intl.message(
      'Clothing Type',
      name: 'ItemClothingTypeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Clothing Layer`
  String get ItemClothingLayerLabel {
    return Intl.message(
      'Clothing Layer',
      name: 'ItemClothingLayerLabel',
      desc: '',
      args: [],
    );
  }

  /// `Spring`
  String get seasons_spring {
    return Intl.message(
      'Spring',
      name: 'seasons_spring',
      desc: '',
      args: [],
    );
  }

  /// `Summer`
  String get seasons_summer {
    return Intl.message(
      'Summer',
      name: 'seasons_summer',
      desc: '',
      args: [],
    );
  }

  /// `Autumn`
  String get seasons_autumn {
    return Intl.message(
      'Autumn',
      name: 'seasons_autumn',
      desc: '',
      args: [],
    );
  }

  /// `Winter`
  String get seasons_winter {
    return Intl.message(
      'Winter',
      name: 'seasons_winter',
      desc: '',
      args: [],
    );
  }

  /// `Multi`
  String get seasons_multi {
    return Intl.message(
      'Multi',
      name: 'seasons_multi',
      desc: '',
      args: [],
    );
  }

  /// `Top`
  String get clothingTypes_top {
    return Intl.message(
      'Top',
      name: 'clothingTypes_top',
      desc: '',
      args: [],
    );
  }

  /// `Bottom`
  String get clothingTypes_bottom {
    return Intl.message(
      'Bottom',
      name: 'clothingTypes_bottom',
      desc: '',
      args: [],
    );
  }

  /// `One Piece`
  String get clothingTypes_onePiece {
    return Intl.message(
      'One Piece',
      name: 'clothingTypes_onePiece',
      desc: '',
      args: [],
    );
  }

  /// `Base`
  String get clothingLayers_base {
    return Intl.message(
      'Base',
      name: 'clothingLayers_base',
      desc: '',
      args: [],
    );
  }

  /// `Mid`
  String get clothingLayers_mid {
    return Intl.message(
      'Mid',
      name: 'clothingLayers_mid',
      desc: '',
      args: [],
    );
  }

  /// `Outer`
  String get clothingLayers_outer {
    return Intl.message(
      'Outer',
      name: 'clothingLayers_outer',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get colors_red {
    return Intl.message(
      'Red',
      name: 'colors_red',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get colors_blue {
    return Intl.message(
      'Blue',
      name: 'colors_blue',
      desc: '',
      args: [],
    );
  }

  /// `Green`
  String get colors_green {
    return Intl.message(
      'Green',
      name: 'colors_green',
      desc: '',
      args: [],
    );
  }

  /// `Yellow`
  String get colors_yellow {
    return Intl.message(
      'Yellow',
      name: 'colors_yellow',
      desc: '',
      args: [],
    );
  }

  /// `Brown`
  String get colors_brown {
    return Intl.message(
      'Brown',
      name: 'colors_brown',
      desc: '',
      args: [],
    );
  }

  /// `Grey`
  String get colors_grey {
    return Intl.message(
      'Grey',
      name: 'colors_grey',
      desc: '',
      args: [],
    );
  }

  /// `Rainbow`
  String get colors_rainbow {
    return Intl.message(
      'Rainbow',
      name: 'colors_rainbow',
      desc: '',
      args: [],
    );
  }

  /// `Black`
  String get colors_black {
    return Intl.message(
      'Black',
      name: 'colors_black',
      desc: '',
      args: [],
    );
  }

  /// `White`
  String get colors_white {
    return Intl.message(
      'White',
      name: 'colors_white',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get colorVariations_light {
    return Intl.message(
      'Light',
      name: 'colorVariations_light',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get colorVariations_medium {
    return Intl.message(
      'Medium',
      name: 'colorVariations_medium',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get colorVariations_dark {
    return Intl.message(
      'Dark',
      name: 'colorVariations_dark',
      desc: '',
      args: [],
    );
  }

  /// `Bag`
  String get accessoryTypes_bag {
    return Intl.message(
      'Bag',
      name: 'accessoryTypes_bag',
      desc: '',
      args: [],
    );
  }

  /// `Belt`
  String get accessoryTypes_belt {
    return Intl.message(
      'Belt',
      name: 'accessoryTypes_belt',
      desc: '',
      args: [],
    );
  }

  /// `Eyewear`
  String get accessoryTypes_eyewear {
    return Intl.message(
      'Eyewear',
      name: 'accessoryTypes_eyewear',
      desc: '',
      args: [],
    );
  }

  /// `Gloves`
  String get accessoryTypes_gloves {
    return Intl.message(
      'Gloves',
      name: 'accessoryTypes_gloves',
      desc: '',
      args: [],
    );
  }

  /// `Hat`
  String get accessoryTypes_hat {
    return Intl.message(
      'Hat',
      name: 'accessoryTypes_hat',
      desc: '',
      args: [],
    );
  }

  /// `Jewellery`
  String get accessoryTypes_jewellery {
    return Intl.message(
      'Jewellery',
      name: 'accessoryTypes_jewellery',
      desc: '',
      args: [],
    );
  }

  /// `Scarf`
  String get accessoryTypes_scarf {
    return Intl.message(
      'Scarf',
      name: 'accessoryTypes_scarf',
      desc: '',
      args: [],
    );
  }

  /// `Tie`
  String get accessoryTypes_tie {
    return Intl.message(
      'Tie',
      name: 'accessoryTypes_tie',
      desc: '',
      args: [],
    );
  }

  /// `Clothing`
  String get itemGeneralTypes_clothing {
    return Intl.message(
      'Clothing',
      name: 'itemGeneralTypes_clothing',
      desc: '',
      args: [],
    );
  }

  /// `Shoes`
  String get itemGeneralTypes_shoes {
    return Intl.message(
      'Shoes',
      name: 'itemGeneralTypes_shoes',
      desc: '',
      args: [],
    );
  }

  /// `Accessory`
  String get itemGeneralTypes_accessory {
    return Intl.message(
      'Accessory',
      name: 'itemGeneralTypes_accessory',
      desc: '',
      args: [],
    );
  }

  /// `Boots`
  String get shoeTypes_boots {
    return Intl.message(
      'Boots',
      name: 'shoeTypes_boots',
      desc: '',
      args: [],
    );
  }

  /// `Casual`
  String get shoeTypes_casual {
    return Intl.message(
      'Casual',
      name: 'shoeTypes_casual',
      desc: '',
      args: [],
    );
  }

  /// `Athletic`
  String get shoeTypes_athletic {
    return Intl.message(
      'Athletic',
      name: 'shoeTypes_athletic',
      desc: '',
      args: [],
    );
  }

  /// `Formal`
  String get shoeTypes_formal {
    return Intl.message(
      'Formal',
      name: 'shoeTypes_formal',
      desc: '',
      args: [],
    );
  }

  /// `Niche`
  String get shoeTypes_niche {
    return Intl.message(
      'Niche',
      name: 'shoeTypes_niche',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get occasions_active {
    return Intl.message(
      'Active',
      name: 'occasions_active',
      desc: '',
      args: [],
    );
  }

  /// `Casual`
  String get occasions_casual {
    return Intl.message(
      'Casual',
      name: 'occasions_casual',
      desc: '',
      args: [],
    );
  }

  /// `Workplace`
  String get occasions_workplace {
    return Intl.message(
      'Workplace',
      name: 'occasions_workplace',
      desc: '',
      args: [],
    );
  }

  /// `Social`
  String get occasions_social {
    return Intl.message(
      'Social',
      name: 'occasions_social',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get occasions_event {
    return Intl.message(
      'Event',
      name: 'occasions_event',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload_upload {
    return Intl.message(
      'Upload',
      name: 'upload_upload',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter_filter {
    return Intl.message(
      'Filter',
      name: 'filter_filter',
      desc: '',
      args: [],
    );
  }

  /// `Add Closet`
  String get addCloset_addCloset {
    return Intl.message(
      'Add Closet',
      name: 'addCloset_addCloset',
      desc: '',
      args: [],
    );
  }

  /// `Item Uploaded`
  String get itemUploaded_itemUploaded {
    return Intl.message(
      'Item Uploaded',
      name: 'itemUploaded_itemUploaded',
      desc: '',
      args: [],
    );
  }

  /// `My Closet`
  String get myClosetTitle {
    return Intl.message(
      'My Closet',
      name: 'myClosetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Closet Upload Complete`
  String get closetUploadComplete {
    return Intl.message(
      'Closet Upload Complete',
      name: 'closetUploadComplete',
      desc: '',
      args: [],
    );
  }

  /// `Closet`
  String get closetLabel {
    return Intl.message(
      'Closet',
      name: 'closetLabel',
      desc: '',
      args: [],
    );
  }

  /// `Outfit`
  String get outfitLabel {
    return Intl.message(
      'Outfit',
      name: 'outfitLabel',
      desc: '',
      args: [],
    );
  }

  /// `Item Name`
  String get itemNameLabel {
    return Intl.message(
      'Item Name',
      name: 'itemNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an item name`
  String get pleaseEnterItemName {
    return Intl.message(
      'Please enter an item name',
      name: 'pleaseEnterItemName',
      desc: '',
      args: [],
    );
  }

  /// `Amount Spent`
  String get amountSpentLabel {
    return Intl.message(
      'Amount Spent',
      name: 'amountSpentLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter amount spent`
  String get enterAmountSpentHint {
    return Intl.message(
      'Enter amount spent',
      name: 'enterAmountSpentHint',
      desc: '',
      args: [],
    );
  }

  /// `Select Item Type`
  String get selectItemType {
    return Intl.message(
      'Select Item Type',
      name: 'selectItemType',
      desc: '',
      args: [],
    );
  }

  /// `Select Occasion`
  String get selectOccasion {
    return Intl.message(
      'Select Occasion',
      name: 'selectOccasion',
      desc: '',
      args: [],
    );
  }

  /// `Select Season`
  String get selectSeason {
    return Intl.message(
      'Select Season',
      name: 'selectSeason',
      desc: '',
      args: [],
    );
  }

  /// `Select Shoe Type`
  String get selectShoeType {
    return Intl.message(
      'Select Shoe Type',
      name: 'selectShoeType',
      desc: '',
      args: [],
    );
  }

  /// `Select Accessory Type`
  String get selectAccessoryType {
    return Intl.message(
      'Select Accessory Type',
      name: 'selectAccessoryType',
      desc: '',
      args: [],
    );
  }

  /// `Select Clothing Type`
  String get selectClothingType {
    return Intl.message(
      'Select Clothing Type',
      name: 'selectClothingType',
      desc: '',
      args: [],
    );
  }

  /// `Select Clothing Layer`
  String get selectClothingLayer {
    return Intl.message(
      'Select Clothing Layer',
      name: 'selectClothingLayer',
      desc: '',
      args: [],
    );
  }

  /// `Select Colour`
  String get selectColour {
    return Intl.message(
      'Select Colour',
      name: 'selectColour',
      desc: '',
      args: [],
    );
  }

  /// `Select Colour Variation`
  String get selectColourVariation {
    return Intl.message(
      'Select Colour Variation',
      name: 'selectColourVariation',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Archived`
  String get archived {
    return Intl.message(
      'Archived',
      name: 'archived',
      desc: '',
      args: [],
    );
  }

  /// `Item Name`
  String get item_name {
    return Intl.message(
      'Item Name',
      name: 'item_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter an item name`
  String get please_enter_item_name {
    return Intl.message(
      'Please enter an item name',
      name: 'please_enter_item_name',
      desc: '',
      args: [],
    );
  }

  /// `Amount Spent`
  String get amount_spent {
    return Intl.message(
      'Amount Spent',
      name: 'amount_spent',
      desc: '',
      args: [],
    );
  }

  /// `Enter amount spent`
  String get enter_amount_spent {
    return Intl.message(
      'Enter amount spent',
      name: 'enter_amount_spent',
      desc: '',
      args: [],
    );
  }

  /// `Select Item Type`
  String get select_item_type {
    return Intl.message(
      'Select Item Type',
      name: 'select_item_type',
      desc: '',
      args: [],
    );
  }

  /// `Select Occasion`
  String get select_occasion {
    return Intl.message(
      'Select Occasion',
      name: 'select_occasion',
      desc: '',
      args: [],
    );
  }

  /// `Select Season`
  String get select_season {
    return Intl.message(
      'Select Season',
      name: 'select_season',
      desc: '',
      args: [],
    );
  }

  /// `Select Shoe Type`
  String get select_shoe_type {
    return Intl.message(
      'Select Shoe Type',
      name: 'select_shoe_type',
      desc: '',
      args: [],
    );
  }

  /// `Select Accessory Type`
  String get select_accessory_type {
    return Intl.message(
      'Select Accessory Type',
      name: 'select_accessory_type',
      desc: '',
      args: [],
    );
  }

  /// `Select Clothing Type`
  String get select_clothing_type {
    return Intl.message(
      'Select Clothing Type',
      name: 'select_clothing_type',
      desc: '',
      args: [],
    );
  }

  /// `Select Clothing Layer`
  String get select_clothing_layer {
    return Intl.message(
      'Select Clothing Layer',
      name: 'select_clothing_layer',
      desc: '',
      args: [],
    );
  }

  /// `Select Colour`
  String get select_colour {
    return Intl.message(
      'Select Colour',
      name: 'select_colour',
      desc: '',
      args: [],
    );
  }

  /// `Select Colour Variation`
  String get select_colour_variation {
    return Intl.message(
      'Select Colour Variation',
      name: 'select_colour_variation',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid amount (0 or greater).`
  String get please_enter_valid_amount {
    return Intl.message(
      'Please enter a valid amount (0 or greater).',
      name: 'please_enter_valid_amount',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
