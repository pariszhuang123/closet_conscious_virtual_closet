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

  /// `Closet\nConscious 🌱`
  String get AppName {
    return Intl.message(
      'Closet\nConscious 🌱',
      name: 'AppName',
      desc: '',
      args: [],
    );
  }

  /// `Shop Your Closet\nLove Your Style!`
  String get tagline {
    return Intl.message(
      'Shop Your Closet\nLove Your Style!',
      name: 'tagline',
      desc: '',
      args: [],
    );
  }

  /// `Shop Your Closet`
  String get shortTagline {
    return Intl.message(
      'Shop Your Closet',
      name: 'shortTagline',
      desc: '',
      args: [],
    );
  }

  /// `Uh-oh, You're Offline!`
  String get noInternetTitle {
    return Intl.message(
      'Uh-oh, You\'re Offline!',
      name: 'noInternetTitle',
      desc: '',
      args: [],
    );
  }

  /// `We're on a coffee break ☕\nReconnect soon to keep rocking those eco-friendly looks!`
  String get noInternetMessage {
    return Intl.message(
      'We\'re on a coffee break ☕\nReconnect soon to keep rocking those eco-friendly looks!',
      name: 'noInternetMessage',
      desc: '',
      args: [],
    );
  }

  /// `Still offline, but your closet’s worth the wait! ✨`
  String get noInternetSnackBar {
    return Intl.message(
      'Still offline, but your closet’s worth the wait! ✨',
      name: 'noInternetSnackBar',
      desc: '',
      args: [],
    );
  }

  /// `Try Again? 🚀`
  String get retryConnection {
    return Intl.message(
      'Try Again? 🚀',
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

  /// `What’s this fabulous piece called?`
  String get ItemNameHint {
    return Intl.message(
      'What’s this fabulous piece called?',
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

  /// `How much did this beauty cost?`
  String get AmountHint {
    return Intl.message(
      'How much did this beauty cost?',
      name: 'AmountHint',
      desc: '',
      args: [],
    );
  }

  /// `Occasion`
  String get ItemOccasionLabel {
    return Intl.message(
      'Occasion',
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
  String get spring {
    return Intl.message(
      'Spring',
      name: 'spring',
      desc: '',
      args: [],
    );
  }

  /// `Summer`
  String get summer {
    return Intl.message(
      'Summer',
      name: 'summer',
      desc: '',
      args: [],
    );
  }

  /// `Autumn`
  String get autumn {
    return Intl.message(
      'Autumn',
      name: 'autumn',
      desc: '',
      args: [],
    );
  }

  /// `Winter`
  String get winter {
    return Intl.message(
      'Winter',
      name: 'winter',
      desc: '',
      args: [],
    );
  }

  /// `Multi`
  String get multi {
    return Intl.message(
      'Multi',
      name: 'multi',
      desc: '',
      args: [],
    );
  }

  /// `Top`
  String get top {
    return Intl.message(
      'Top',
      name: 'top',
      desc: '',
      args: [],
    );
  }

  /// `Bottom`
  String get bottom {
    return Intl.message(
      'Bottom',
      name: 'bottom',
      desc: '',
      args: [],
    );
  }

  /// `One Piece`
  String get onePiece {
    return Intl.message(
      'One Piece',
      name: 'onePiece',
      desc: '',
      args: [],
    );
  }

  /// `Base`
  String get base {
    return Intl.message(
      'Base',
      name: 'base',
      desc: '',
      args: [],
    );
  }

  /// `Mid`
  String get mid {
    return Intl.message(
      'Mid',
      name: 'mid',
      desc: '',
      args: [],
    );
  }

  /// `Outer`
  String get outer {
    return Intl.message(
      'Outer',
      name: 'outer',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get red {
    return Intl.message(
      'Red',
      name: 'red',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get blue {
    return Intl.message(
      'Blue',
      name: 'blue',
      desc: '',
      args: [],
    );
  }

  /// `Green`
  String get green {
    return Intl.message(
      'Green',
      name: 'green',
      desc: '',
      args: [],
    );
  }

  /// `Yellow`
  String get yellow {
    return Intl.message(
      'Yellow',
      name: 'yellow',
      desc: '',
      args: [],
    );
  }

  /// `Brown`
  String get brown {
    return Intl.message(
      'Brown',
      name: 'brown',
      desc: '',
      args: [],
    );
  }

  /// `Grey`
  String get grey {
    return Intl.message(
      'Grey',
      name: 'grey',
      desc: '',
      args: [],
    );
  }

  /// `Multicolour`
  String get rainbow {
    return Intl.message(
      'Multicolour',
      name: 'rainbow',
      desc: '',
      args: [],
    );
  }

  /// `Black`
  String get black {
    return Intl.message(
      'Black',
      name: 'black',
      desc: '',
      args: [],
    );
  }

  /// `White`
  String get white {
    return Intl.message(
      'White',
      name: 'white',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get medium {
    return Intl.message(
      'Medium',
      name: 'medium',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Bag`
  String get bag {
    return Intl.message(
      'Bag',
      name: 'bag',
      desc: '',
      args: [],
    );
  }

  /// `Belt`
  String get belt {
    return Intl.message(
      'Belt',
      name: 'belt',
      desc: '',
      args: [],
    );
  }

  /// `Eyewear`
  String get eyewear {
    return Intl.message(
      'Eyewear',
      name: 'eyewear',
      desc: '',
      args: [],
    );
  }

  /// `Gloves`
  String get gloves {
    return Intl.message(
      'Gloves',
      name: 'gloves',
      desc: '',
      args: [],
    );
  }

  /// `Hat`
  String get hat {
    return Intl.message(
      'Hat',
      name: 'hat',
      desc: '',
      args: [],
    );
  }

  /// `Jewellery`
  String get jewellery {
    return Intl.message(
      'Jewellery',
      name: 'jewellery',
      desc: '',
      args: [],
    );
  }

  /// `Scarf`
  String get scarf {
    return Intl.message(
      'Scarf',
      name: 'scarf',
      desc: '',
      args: [],
    );
  }

  /// `Tech`
  String get tech {
    return Intl.message(
      'Tech',
      name: 'tech',
      desc: '',
      args: [],
    );
  }

  /// `Misc`
  String get other {
    return Intl.message(
      'Misc',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Cosmetic`
  String get perfume {
    return Intl.message(
      'Cosmetic',
      name: 'perfume',
      desc: '',
      args: [],
    );
  }

  /// `Clothing`
  String get clothing {
    return Intl.message(
      'Clothing',
      name: 'clothing',
      desc: '',
      args: [],
    );
  }

  /// `Shoes`
  String get shoes {
    return Intl.message(
      'Shoes',
      name: 'shoes',
      desc: '',
      args: [],
    );
  }

  /// `Accessory`
  String get accessory {
    return Intl.message(
      'Accessory',
      name: 'accessory',
      desc: '',
      args: [],
    );
  }

  /// `Boots`
  String get boots {
    return Intl.message(
      'Boots',
      name: 'boots',
      desc: '',
      args: [],
    );
  }

  /// `Everyday`
  String get everyday {
    return Intl.message(
      'Everyday',
      name: 'everyday',
      desc: '',
      args: [],
    );
  }

  /// `Athletic`
  String get athletic {
    return Intl.message(
      'Athletic',
      name: 'athletic',
      desc: '',
      args: [],
    );
  }

  /// `Formal`
  String get formal {
    return Intl.message(
      'Formal',
      name: 'formal',
      desc: '',
      args: [],
    );
  }

  /// `Niche`
  String get niche {
    return Intl.message(
      'Niche',
      name: 'niche',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `Casual`
  String get casual {
    return Intl.message(
      'Casual',
      name: 'casual',
      desc: '',
      args: [],
    );
  }

  /// `Workplace`
  String get workplace {
    return Intl.message(
      'Workplace',
      name: 'workplace',
      desc: '',
      args: [],
    );
  }

  /// `Social`
  String get social {
    return Intl.message(
      'Social',
      name: 'social',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get event {
    return Intl.message(
      'Event',
      name: 'event',
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

  /// `Swap QR`
  String get swap_item {
    return Intl.message(
      'Swap QR',
      name: 'swap_item',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get metadata {
    return Intl.message(
      'More',
      name: 'metadata',
      desc: '',
      args: [],
    );
  }

  /// `Multi Closet`
  String get addCloset_addCloset {
    return Intl.message(
      'Multi Closet',
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

  /// `Create My Outfit`
  String get myOutfitTitle {
    return Intl.message(
      'Create My Outfit',
      name: 'myOutfitTitle',
      desc: '',
      args: [],
    );
  }

  /// `I uploaded my closet`
  String get closetUploadComplete {
    return Intl.message(
      'I uploaded my closet',
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

  /// `Please enter a valid amount (0 or greater).`
  String get please_enter_valid_amount {
    return Intl.message(
      'Please enter a valid amount (0 or greater).',
      name: 'please_enter_valid_amount',
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

  /// `Declutter`
  String get declutter {
    return Intl.message(
      'Declutter',
      name: 'declutter',
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

  /// `Item Name field is not filled.`
  String get itemNameFieldNotFilled {
    return Intl.message(
      'Item Name field is not filled.',
      name: 'itemNameFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Amount Spent field is not filled.`
  String get amountSpentFieldNotFilled {
    return Intl.message(
      'Amount Spent field is not filled.',
      name: 'amountSpentFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Item Type field is not filled.`
  String get itemTypeFieldNotFilled {
    return Intl.message(
      'Item Type field is not filled.',
      name: 'itemTypeFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Occasion field is not filled.`
  String get occasionFieldNotFilled {
    return Intl.message(
      'Occasion field is not filled.',
      name: 'occasionFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Season field is not filled.`
  String get seasonFieldNotFilled {
    return Intl.message(
      'Season field is not filled.',
      name: 'seasonFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Specific Type field is not filled.`
  String get specificTypeFieldNotFilled {
    return Intl.message(
      'Specific Type field is not filled.',
      name: 'specificTypeFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Clothing Layer field is not filled.`
  String get clothingLayerFieldNotFilled {
    return Intl.message(
      'Clothing Layer field is not filled.',
      name: 'clothingLayerFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Colour field is not filled.`
  String get colourFieldNotFilled {
    return Intl.message(
      'Colour field is not filled.',
      name: 'colourFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Colour Variation field is not filled.`
  String get colourVariationFieldNotFilled {
    return Intl.message(
      'Colour Variation field is not filled.',
      name: 'colourVariationFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Clothing type is required.`
  String get clothingTypeRequired {
    return Intl.message(
      'Clothing type is required.',
      name: 'clothingTypeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Accessory type is required.`
  String get accessoryTypeRequired {
    return Intl.message(
      'Accessory type is required.',
      name: 'accessoryTypeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Shoes type is required.`
  String get shoesTypeRequired {
    return Intl.message(
      'Shoes type is required.',
      name: 'shoesTypeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please correct the errors in the form.`
  String get pleaseCorrectTheErrors {
    return Intl.message(
      'Please correct the errors in the form.',
      name: 'pleaseCorrectTheErrors',
      desc: '',
      args: [],
    );
  }

  /// `Interested`
  String get interested {
    return Intl.message(
      'Interested',
      name: 'interested',
      desc: '',
      args: [],
    );
  }

  /// `Edit Item`
  String get editPageTitle {
    return Intl.message(
      'Edit Item',
      name: 'editPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Thank You!`
  String get thankYou {
    return Intl.message(
      'Thank You!',
      name: 'thankYou',
      desc: '',
      args: [],
    );
  }

  /// `Got it! We’ve noted your interest—stay tuned for updates! 🎉`
  String get interestAcknowledged {
    return Intl.message(
      'Got it! We’ve noted your interest—stay tuned for updates! 🎉',
      name: 'interestAcknowledged',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get sell {
    return Intl.message(
      'Sell',
      name: 'sell',
      desc: '',
      args: [],
    );
  }

  /// `Swap`
  String get swap {
    return Intl.message(
      'Swap',
      name: 'swap',
      desc: '',
      args: [],
    );
  }

  /// `Gift`
  String get gift {
    return Intl.message(
      'Gift',
      name: 'gift',
      desc: '',
      args: [],
    );
  }

  /// `Throw`
  String get Throw {
    return Intl.message(
      'Throw',
      name: 'Throw',
      desc: '',
      args: [],
    );
  }

  /// `What would you like to do?`
  String get declutterOptions {
    return Intl.message(
      'What would you like to do?',
      name: 'declutterOptions',
      desc: '',
      args: [],
    );
  }

  /// `Number of items you've uploaded to your conscious closet`
  String get itemsUploadedTooltip {
    return Intl.message(
      'Number of items you\'ve uploaded to your conscious closet',
      name: 'itemsUploadedTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Your current streak of no purchases`
  String get currentStreakTooltip {
    return Intl.message(
      'Your current streak of no purchases',
      name: 'currentStreakTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Your highest no-purchase streak ever!`
  String get highestStreakTooltip {
    return Intl.message(
      'Your highest no-purchase streak ever!',
      name: 'highestStreakTooltip',
      desc: '',
      args: [],
    );
  }

  /// `How much you’ve spent on new items so far`
  String get spendingTooltip {
    return Intl.message(
      'How much you’ve spent on new items so far',
      name: 'spendingTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Number of new items you have purchased`
  String get newItemsTooltip {
    return Intl.message(
      'Number of new items you have purchased',
      name: 'newItemsTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileSection {
    return Intl.message(
      'Profile',
      name: 'profileSection',
      desc: '',
      args: [],
    );
  }

  /// `Achievements`
  String get achievements {
    return Intl.message(
      'Achievements',
      name: 'achievements',
      desc: '',
      args: [],
    );
  }

  /// `Usage Insights`
  String get usageInsights {
    return Intl.message(
      'Usage Insights',
      name: 'usageInsights',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `Number of outfits uploaded`
  String get outfits_upload {
    return Intl.message(
      'Number of outfits uploaded',
      name: 'outfits_upload',
      desc: '',
      args: [],
    );
  }

  /// `App Information`
  String get appInformationSection {
    return Intl.message(
      'App Information',
      name: 'appInformationSection',
      desc: '',
      args: [],
    );
  }

  /// `Info Hub`
  String get infoHub {
    return Intl.message(
      'Info Hub',
      name: 'infoHub',
      desc: '',
      args: [],
    );
  }

  /// `Support & Assistance`
  String get supportAssistanceSection {
    return Intl.message(
      'Support & Assistance',
      name: 'supportAssistanceSection',
      desc: '',
      args: [],
    );
  }

  /// `Become an Ambassador`
  String get becomeAmbassador {
    return Intl.message(
      'Become an Ambassador',
      name: 'becomeAmbassador',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message(
      'Log Out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Data updated successfully!`
  String get dataUpdatedSuccessfully {
    return Intl.message(
      'Data updated successfully!',
      name: 'dataUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Oops, something went wrong.`
  String get error {
    return Intl.message(
      'Oops, something went wrong.',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Data saved! You're all set.`
  String get dataInsertedSuccessfully {
    return Intl.message(
      'Data saved! You\'re all set.',
      name: 'dataInsertedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Success! Your closet just got a little more stylish! 🎉`
  String get upload_successful {
    return Intl.message(
      'Success! Your closet just got a little more stylish! 🎉',
      name: 'upload_successful',
      desc: '',
      args: [],
    );
  }

  /// `Oops! Looks like something went off the rails. Try again? 🚂`
  String get upload_failed {
    return Intl.message(
      'Oops! Looks like something went off the rails. Try again? 🚂',
      name: 'upload_failed',
      desc: '',
      args: [],
    );
  }

  /// `Oops! We couldn’t record your interest. Please try again!`
  String get errorIncrement {
    return Intl.message(
      'Oops! We couldn’t record your interest. Please try again!',
      name: 'errorIncrement',
      desc: '',
      args: [],
    );
  }

  /// `Well done! Your closet just took a breather! 😌`
  String get declutterAcknowledged {
    return Intl.message(
      'Well done! Your closet just took a breather! 😌',
      name: 'declutterAcknowledged',
      desc: '',
      args: [],
    );
  }

  /// `We couldn’t declutter right now, but don’t worry—we’ll try again soon! 🌿`
  String get errorDeclutter {
    return Intl.message(
      'We couldn’t declutter right now, but don’t worry—we’ll try again soon! 🌿',
      name: 'errorDeclutter',
      desc: '',
      args: [],
    );
  }

  /// `Declutter Your Closet`
  String get declutterFeatureTitle {
    return Intl.message(
      'Declutter Your Closet',
      name: 'declutterFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Easily organize and clean up your closet by removing unwanted items. Simplify your wardrobe and make room for new styles.`
  String get declutterFeatureDescription {
    return Intl.message(
      'Easily organize and clean up your closet by removing unwanted items. Simplify your wardrobe and make room for new styles.',
      name: 'declutterFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Hmm, that was unexpected. Please try again or contact support.`
  String get unexpectedResponseFormat {
    return Intl.message(
      'Hmm, that was unexpected. Please try again or contact support.',
      name: 'unexpectedResponseFormat',
      desc: '',
      args: [],
    );
  }

  /// `Yikes! Something went wrong. Please try again later or contact support if it persists.`
  String get unexpectedErrorOccurred {
    return Intl.message(
      'Yikes! Something went wrong. Please try again later or contact support if it persists.',
      name: 'unexpectedErrorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Closet Completion`
  String get uploadConfirmationTitle {
    return Intl.message(
      'Confirm Closet Completion',
      name: 'uploadConfirmationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your closet upload! New items with a price will count as fresh additions, affecting your no-buy streak!`
  String get uploadConfirmationDescription {
    return Intl.message(
      'Confirm your closet upload! New items with a price will count as fresh additions, affecting your no-buy streak!',
      name: 'uploadConfirmationDescription',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Achievement`
  String get confirmUpload {
    return Intl.message(
      'Confirm Achievement',
      name: 'confirmUpload',
      desc: '',
      args: [],
    );
  }

  /// `Your current no-buy streak.`
  String get currentStreak {
    return Intl.message(
      'Your current no-buy streak.',
      name: 'currentStreak',
      desc: '',
      args: [],
    );
  }

  /// `Your all-time record of no new clothes!`
  String get highestStreak {
    return Intl.message(
      'Your all-time record of no new clothes!',
      name: 'highestStreak',
      desc: '',
      args: [],
    );
  }

  /// `Cost of new items you've added`
  String get costOfNewItems {
    return Intl.message(
      'Cost of new items you\'ve added',
      name: 'costOfNewItems',
      desc: '',
      args: [],
    );
  }

  /// `Number of new items in your closet`
  String get numberOfNewItems {
    return Intl.message(
      'Number of new items in your closet',
      name: 'numberOfNewItems',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccountTitle {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccountTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure? This action cannot be undone.`
  String get deleteAccountImpact {
    return Intl.message(
      'Are you sure? This action cannot be undone.',
      name: 'deleteAccountImpact',
      desc: '',
      args: [],
    );
  }

  /// `\n\nAll your data and access to paid features will be permanently removed. Deletion will occur in 48 hours.`
  String get deleteAccountConfirmation {
    return Intl.message(
      '\n\nAll your data and access to paid features will be permanently removed. Deletion will occur in 48 hours.',
      name: 'deleteAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Your request has been received. We’ll delete your account within 48 hours.`
  String get accountDeletedSuccess {
    return Intl.message(
      'Your request has been received. We’ll delete your account within 48 hours.',
      name: 'accountDeletedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Please select the category above`
  String get please_select_the_category_above {
    return Intl.message(
      'Please select the category above',
      name: 'please_select_the_category_above',
      desc: '',
      args: [],
    );
  }

  /// `No achievements yet—start unlocking them today!`
  String get noAchievementFound {
    return Intl.message(
      'No achievements yet—start unlocking them today!',
      name: 'noAchievementFound',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations! 🎉`
  String get congratulations {
    return Intl.message(
      'Congratulations! 🎉',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `You’ve unlocked a new achievement:`
  String get achievementMessage {
    return Intl.message(
      'You’ve unlocked a new achievement:',
      name: 'achievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Customize`
  String get arrange {
    return Intl.message(
      'Customize',
      name: 'arrange',
      desc: '',
      args: [],
    );
  }

  /// `Customize Your\nCloset Layout`
  String get arrangeFeatureTitle {
    return Intl.message(
      'Customize Your\nCloset Layout',
      name: 'arrangeFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to organize your closet by cost per wear or date added? Let us know!`
  String get arrangeFeatureDescription {
    return Intl.message(
      'Would you like to organize your closet by cost per wear or date added? Let us know!',
      name: 'arrangeFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Filters?`
  String get filterSearchPremiumFeature {
    return Intl.message(
      'Advanced Filters?',
      name: 'filterSearchPremiumFeature',
      desc: '',
      args: [],
    );
  }

  /// `We’re thinking about adding advanced filters to help you find your items more easily. Sound good?`
  String get quicklyFindItems {
    return Intl.message(
      'We’re thinking about adding advanced filters to help you find your items more easily. Sound good?',
      name: 'quicklyFindItems',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Closets?`
  String get multiClosetFeatureTitle {
    return Intl.message(
      'Multiple Closets?',
      name: 'multiClosetFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `We’re exploring adding multiple closets (permanent, disappearing)—would you use this?`
  String get multiClosetFeatureDescription {
    return Intl.message(
      'We’re exploring adding multiple closets (permanent, disappearing)—would you use this?',
      name: 'multiClosetFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `More Item Details?`
  String get metadataFeatureTitle {
    return Intl.message(
      'More Item Details?',
      name: 'metadataFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Want to add extra details to your items for better organization? Let us know!`
  String get metadataFeatureDescription {
    return Intl.message(
      'Want to add extra details to your items for better organization? Let us know!',
      name: 'metadataFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Calendar View?`
  String get calendarPremiumFeature {
    return Intl.message(
      'Calendar View?',
      name: 'calendarPremiumFeature',
      desc: '',
      args: [],
    );
  }

  /// `We’re considering a calendar view for your outfits. Would this help you stay organized?`
  String get reviewOutfitsInCalendar {
    return Intl.message(
      'We’re considering a calendar view for your outfits. Would this help you stay organized?',
      name: 'reviewOutfitsInCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Swap Items?`
  String get swapFeatureTitle {
    return Intl.message(
      'Swap Items?',
      name: 'swapFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Interested in swapping items or getting notified about swap events nearby? We’re thinking about this feature—what do you think?`
  String get swapFeatureDescription {
    return Intl.message(
      'Interested in swapping items or getting notified about swap events nearby? We’re thinking about this feature—what do you think?',
      name: 'swapFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Track Your Analytics?`
  String get AnalyticsSearchPremiumFeature {
    return Intl.message(
      'Track Your Analytics?',
      name: 'AnalyticsSearchPremiumFeature',
      desc: '',
      args: [],
    );
  }

  /// `Track your cost per wear and get personalized outfit insights. Would this be helpful?`
  String get trackAnalyticsDescription {
    return Intl.message(
      'Track your cost per wear and get personalized outfit insights. Would this be helpful?',
      name: 'trackAnalyticsDescription',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Outfit of the Day`
  String get OutfitDay {
    return Intl.message(
      'Outfit of the Day',
      name: 'OutfitDay',
      desc: '',
      args: [],
    );
  }

  /// `Your outfit canvas is waiting!\nAdd items to your closet or adjust filters to see more.`
  String get noItemsInOutfitCategory {
    return Intl.message(
      'Your outfit canvas is waiting!\nAdd items to your closet or adjust filters to see more.',
      name: 'noItemsInOutfitCategory',
      desc: '',
      args: [],
    );
  }

  /// `No items yet!\nAdd to your closet or change filters to explore.`
  String get noItemsInCloset {
    return Intl.message(
      'No items yet!\nAdd to your closet or change filters to explore.',
      name: 'noItemsInCloset',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong! 😱`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong! 😱',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load items. Please try again!`
  String get failedToLoadItems {
    return Intl.message(
      'Failed to load items. Please try again!',
      name: 'failedToLoadItems',
      desc: '',
      args: [],
    );
  }

  /// `My Outfit of the Day`
  String get myOutfitOfTheDay {
    return Intl.message(
      'My Outfit of the Day',
      name: 'myOutfitOfTheDay',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `No items found.`
  String get noItemsFound {
    return Intl.message(
      'No items found.',
      name: 'noItemsFound',
      desc: '',
      args: [],
    );
  }

  /// `Review Outfit`
  String get styleOn {
    return Intl.message(
      'Review Outfit',
      name: 'styleOn',
      desc: '',
      args: [],
    );
  }

  /// `Love it!\n😍`
  String get like {
    return Intl.message(
      'Love it!\n😍',
      name: 'like',
      desc: '',
      args: [],
    );
  }

  /// `It’s alright\n🤷‍♀️`
  String get alright {
    return Intl.message(
      'It’s alright\n🤷‍♀️',
      name: 'alright',
      desc: '',
      args: [],
    );
  }

  /// `Not quite\nmy vibe 🤔`
  String get dislike {
    return Intl.message(
      'Not quite\nmy vibe 🤔',
      name: 'dislike',
      desc: '',
      args: [],
    );
  }

  /// `Selfie`
  String get selfie {
    return Intl.message(
      'Selfie',
      name: 'selfie',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Outfit Review`
  String get OutfitReview {
    return Intl.message(
      'Outfit Review',
      name: 'OutfitReview',
      desc: '',
      args: [],
    );
  }

  /// `Effortless Outfit Sharing`
  String get shareFeatureTitle {
    return Intl.message(
      'Effortless Outfit Sharing',
      name: 'shareFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Share your Outfit of the Day with one tap across all your social media. Elevate your style and inspire others effortlessly.`
  String get shareFeatureDescription {
    return Intl.message(
      'Share your Outfit of the Day with one tap across all your social media. Elevate your style and inspire others effortlessly.',
      name: 'shareFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Add your comments`
  String get addYourComments {
    return Intl.message(
      'Add your comments',
      name: 'addYourComments',
      desc: '',
      args: [],
    );
  }

  /// `I have read the `
  String get termsAcknowledgement {
    return Intl.message(
      'I have read the ',
      name: 'termsAcknowledgement',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Terms`
  String get privacyTerms {
    return Intl.message(
      'Privacy Terms',
      name: 'privacyTerms',
      desc: '',
      args: [],
    );
  }

  /// ` and the `
  String get and {
    return Intl.message(
      ' and the ',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Tap the items that don’t quite fit this outfit.`
  String get alright_feedback_sentence {
    return Intl.message(
      'Tap the items that don’t quite fit this outfit.',
      name: 'alright_feedback_sentence',
      desc: '',
      args: [],
    );
  }

  /// `Tap the items that didn’t work in this outfit.`
  String get dislike_feedback_sentence {
    return Intl.message(
      'Tap the items that didn’t work in this outfit.',
      name: 'dislike_feedback_sentence',
      desc: '',
      args: [],
    );
  }

  /// `Outfit Review Submitted`
  String get outfitReviewTitle {
    return Intl.message(
      'Outfit Review Submitted',
      name: 'outfitReviewTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your outfit review has been submitted successfully!`
  String get outfitReviewContent {
    return Intl.message(
      'Your outfit review has been submitted successfully!',
      name: 'outfitReviewContent',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one item you didn’t like.`
  String get pleaseSelectAtLeastOneItem {
    return Intl.message(
      'Please select at least one item you didn’t like.',
      name: 'pleaseSelectAtLeastOneItem',
      desc: '',
      args: [],
    );
  }

  /// `Style On!`
  String get outfitCreationSuccessTitle {
    return Intl.message(
      'Style On!',
      name: 'outfitCreationSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Outfit ready. Go Slay the World, Fashionista! 🦸‍♀️`
  String get outfitCreationSuccessContent {
    return Intl.message(
      'Outfit ready. Go Slay the World, Fashionista! 🦸‍♀️',
      name: 'outfitCreationSuccessContent',
      desc: '',
      args: [],
    );
  }

  /// `Support Request`
  String get supportEmailSubject {
    return Intl.message(
      'Support Request',
      name: 'supportEmailSubject',
      desc: '',
      args: [],
    );
  }

  /// `Describe your issue here`
  String get supportEmailBody {
    return Intl.message(
      'Describe your issue here',
      name: 'supportEmailBody',
      desc: '',
      args: [],
    );
  }

  /// `We Love Your Feedback!`
  String get npsReviewEmailSubject {
    return Intl.message(
      'We Love Your Feedback!',
      name: 'npsReviewEmailSubject',
      desc: '',
      args: [],
    );
  }

  /// `Could you share some details on how we can improve?`
  String get npsReviewEmailBody {
    return Intl.message(
      'Could you share some details on how we can improve?',
      name: 'npsReviewEmailBody',
      desc: '',
      args: [],
    );
  }

  /// `https://inky-twill-3ab.notion.site/8bca4fd6945f4f808a32cbb5ad28400c`
  String get infoHubUrl {
    return Intl.message(
      'https://inky-twill-3ab.notion.site/8bca4fd6945f4f808a32cbb5ad28400c',
      name: 'infoHubUrl',
      desc: '',
      args: [],
    );
  }

  /// `https://www.notion.so/Privacy-Policy-9f21c7664efe4b03a8965252495dc1a6`
  String get privacyTermsUrl {
    return Intl.message(
      'https://www.notion.so/Privacy-Policy-9f21c7664efe4b03a8965252495dc1a6',
      name: 'privacyTermsUrl',
      desc: '',
      args: [],
    );
  }

  /// `https://www.notion.so/Service-Term-1a1b8f68ebba48158c0f42e19a135c6e`
  String get termsAndConditionsUrl {
    return Intl.message(
      'https://www.notion.so/Service-Term-1a1b8f68ebba48158c0f42e19a135c6e',
      name: 'termsAndConditionsUrl',
      desc: '',
      args: [],
    );
  }

  /// `Unable to retrieve user ID. Please sign in again.`
  String get unableToRetrieveUserId {
    return Intl.message(
      'Unable to retrieve user ID. Please sign in again.',
      name: 'unableToRetrieveUserId',
      desc: '',
      args: [],
    );
  }

  /// `Failed to submit score.`
  String get failedToSubmitScore {
    return Intl.message(
      'Failed to submit score.',
      name: 'failedToSubmitScore',
      desc: '',
      args: [],
    );
  }

  /// `How likely are you to recommend Closet Conscious to a friend?`
  String get recommendClosetConscious {
    return Intl.message(
      'How likely are you to recommend Closet Conscious to a friend?',
      name: 'recommendClosetConscious',
      desc: '',
      args: [],
    );
  }

  /// `On a scale from 0 to 10:\n0: Not at all likely\n10: Extremely likely`
  String get npsExplanation {
    return Intl.message(
      'On a scale from 0 to 10:\n0: Not at all likely\n10: Extremely likely',
      name: 'npsExplanation',
      desc: '',
      args: [],
    );
  }

  /// `You need to accept the terms and conditions before signing in.`
  String get termsNotAcceptedMessage {
    return Intl.message(
      'You need to accept the terms and conditions before signing in.',
      name: 'termsNotAcceptedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Uh-oh, something went wrong. Please try again later!`
  String get unknownError {
    return Intl.message(
      'Uh-oh, something went wrong. Please try again later!',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `This permission is required for the app to function properly.`
  String get permission_needed {
    return Intl.message(
      'This permission is required for the app to function properly.',
      name: 'permission_needed',
      desc: '',
      args: [],
    );
  }

  /// `We need camera access to help you upload photos of your clothes.`
  String get camera_upload_item_permission_explanation {
    return Intl.message(
      'We need camera access to help you upload photos of your clothes.',
      name: 'camera_upload_item_permission_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Let us use your camera to update your item photos.`
  String get camera_edit_item_permission_explanation {
    return Intl.message(
      'Let us use your camera to update your item photos.',
      name: 'camera_edit_item_permission_explanation',
      desc: '',
      args: [],
    );
  }

  /// `We need access to your camera for your stunning outfit selfies!`
  String get camera_selfie_permission_explanation {
    return Intl.message(
      'We need access to your camera for your stunning outfit selfies!',
      name: 'camera_selfie_permission_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Camera access is required to take photos.`
  String get camera_permission_explanation {
    return Intl.message(
      'Camera access is required to take photos.',
      name: 'camera_permission_explanation',
      desc: '',
      args: [],
    );
  }

  /// `We need this permission to make the app work properly.`
  String get general_permission_explanation {
    return Intl.message(
      'We need this permission to make the app work properly.',
      name: 'general_permission_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get open_settings {
    return Intl.message(
      'Open Settings',
      name: 'open_settings',
      desc: '',
      args: [],
    );
  }

  /// `No Image Available`
  String get noImage {
    return Intl.message(
      'No Image Available',
      name: 'noImage',
      desc: '',
      args: [],
    );
  }

  /// `AI Stylist`
  String get aistylist {
    return Intl.message(
      'AI Stylist',
      name: 'aistylist',
      desc: '',
      args: [],
    );
  }

  /// `AI Stylist Usage Feature`
  String get aiStylistFeatureTitle {
    return Intl.message(
      'AI Stylist Usage Feature',
      name: 'aiStylistFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unlock AI-powered outfit suggestions and receive personalized recommendations based on your unique style.`
  String get aiStylistFeatureDescription {
    return Intl.message(
      'Unlock AI-powered outfit suggestions and receive personalized recommendations based on your unique style.',
      name: 'aiStylistFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Smart\nUpload`
  String get aiupload {
    return Intl.message(
      'Smart\nUpload',
      name: 'aiupload',
      desc: '',
      args: [],
    );
  }

  /// `Smart Upload Usage Feature`
  String get aiUploadFeatureTitle {
    return Intl.message(
      'Smart Upload Usage Feature',
      name: 'aiUploadFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Easily upload items with automatic metadata tagging. Let AI handle the details!`
  String get aiUploadFeatureDescription {
    return Intl.message(
      'Easily upload items with automatic metadata tagging. Let AI handle the details!',
      name: 'aiUploadFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Select items to create your outfit.`
  String get selectItemsToCreateOutfit {
    return Intl.message(
      'Select items to create your outfit.',
      name: 'selectItemsToCreateOutfit',
      desc: '',
      args: [],
    );
  }

  /// `You have unsaved changes. Please save or discard them before selecting a photo.`
  String get unsavedChangesMessage {
    return Intl.message(
      'You have unsaved changes. Please save or discard them before selecting a photo.',
      name: 'unsavedChangesMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sustainable Start!`
  String get noNewClothes90Achievement {
    return Intl.message(
      'Sustainable Start!',
      name: 'noNewClothes90Achievement',
      desc: '',
      args: [],
    );
  }

  /// `You’ve hit 90 days without new clothes! Keep building those eco-friendly habits! 🌱`
  String get noNewClothes90AchievementMessage {
    return Intl.message(
      'You’ve hit 90 days without new clothes! Keep building those eco-friendly habits! 🌱',
      name: 'noNewClothes90AchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Eco-Warrior in the Making!`
  String get noNewClothes225Achievement {
    return Intl.message(
      'Eco-Warrior in the Making!',
      name: 'noNewClothes225Achievement',
      desc: '',
      args: [],
    );
  }

  /// `225 days and counting! Your closet is thriving, and so is the planet. 🌍`
  String get noNewClothes225AchievementMessage {
    return Intl.message(
      '225 days and counting! Your closet is thriving, and so is the planet. 🌍',
      name: 'noNewClothes225AchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Champion of Conscious Choices!`
  String get noNewClothes405Achievement {
    return Intl.message(
      'Champion of Conscious Choices!',
      name: 'noNewClothes405Achievement',
      desc: '',
      args: [],
    );
  }

  /// `405 days strong! Your commitment to conscious fashion is an inspiration.`
  String get noNewClothes405AchievementMessage {
    return Intl.message(
      '405 days strong! Your commitment to conscious fashion is an inspiration.',
      name: 'noNewClothes405AchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sustainability Leader!`
  String get noNewClothes630Achievement {
    return Intl.message(
      'Sustainability Leader!',
      name: 'noNewClothes630Achievement',
      desc: '',
      args: [],
    );
  }

  /// `630 days without new clothes—you're leading by example! Keep going!`
  String get noNewClothes630AchievementMessage {
    return Intl.message(
      '630 days without new clothes—you\'re leading by example! Keep going!',
      name: 'noNewClothes630AchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Trailblazer of Change!`
  String get noNewClothes900Achievement {
    return Intl.message(
      'Trailblazer of Change!',
      name: 'noNewClothes900Achievement',
      desc: '',
      args: [],
    );
  }

  /// `900 days of conscious choices! You’re setting trends and making waves in sustainability!`
  String get noNewClothes900AchievementMessage {
    return Intl.message(
      '900 days of conscious choices! You’re setting trends and making waves in sustainability!',
      name: 'noNewClothes900AchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Icon of Sustainability!`
  String get noNewClothes1215Achievement {
    return Intl.message(
      'Icon of Sustainability!',
      name: 'noNewClothes1215Achievement',
      desc: '',
      args: [],
    );
  }

  /// `1,215 days of intentional living! Your journey is inspiring others to follow in your footsteps.`
  String get noNewClothes1215AchievementMessage {
    return Intl.message(
      '1,215 days of intentional living! Your journey is inspiring others to follow in your footsteps.',
      name: 'noNewClothes1215AchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Master of Minimalism!`
  String get noNewClothes1575Achievement {
    return Intl.message(
      'Master of Minimalism!',
      name: 'noNewClothes1575Achievement',
      desc: '',
      args: [],
    );
  }

  /// `1,575 days of embracing what you have. You're rewriting the rules of fashion!`
  String get noNewClothes1575AchievementMessage {
    return Intl.message(
      '1,575 days of embracing what you have. You\'re rewriting the rules of fashion!',
      name: 'noNewClothes1575AchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `All Clothes, All You!`
  String get allClothesWornAchievement {
    return Intl.message(
      'All Clothes, All You!',
      name: 'allClothesWornAchievement',
      desc: '',
      args: [],
    );
  }

  /// `You've worn every single item in your closet! You're mastering mindful fashion choices.`
  String get allClothesWornAchievementMessage {
    return Intl.message(
      'You\'ve worn every single item in your closet! You\'re mastering mindful fashion choices.',
      name: 'allClothesWornAchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Virtual Closet Complete!`
  String get closetUploadAchievement {
    return Intl.message(
      'Virtual Closet Complete!',
      name: 'closetUploadAchievement',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations! You've uploaded all your items to your virtual closet. Now you can style like a pro!`
  String get closetUploadAchievementMessage {
    return Intl.message(
      'Congratulations! You\'ve uploaded all your items to your virtual closet. Now you can style like a pro!',
      name: 'closetUploadAchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Selfie Superstar!`
  String get firstSelfieTakenAchievement {
    return Intl.message(
      'Selfie Superstar!',
      name: 'firstSelfieTakenAchievement',
      desc: '',
      args: [],
    );
  }

  /// `You’ve taken your first selfie! Show off your style and let your closet shine!`
  String get firstSelfieTakenAchievementMessage {
    return Intl.message(
      'You’ve taken your first selfie! Show off your style and let your closet shine!',
      name: 'firstSelfieTakenAchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Outfit Architect!`
  String get firstOutfitCreatedAchievement {
    return Intl.message(
      'Outfit Architect!',
      name: 'firstOutfitCreatedAchievement',
      desc: '',
      args: [],
    );
  }

  /// `Your first outfit is ready! You're on your way to mastering your style.`
  String get firstOutfitCreatedAchievementMessage {
    return Intl.message(
      'Your first outfit is ready! You\'re on your way to mastering your style.',
      name: 'firstOutfitCreatedAchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Generous Giver!`
  String get firstItemGiftedAchievement {
    return Intl.message(
      'Generous Giver!',
      name: 'firstItemGiftedAchievement',
      desc: '',
      args: [],
    );
  }

  /// `You’ve gifted your first item! Your style is making someone else’s day brighter.`
  String get firstItemGiftedAchievementMessage {
    return Intl.message(
      'You’ve gifted your first item! Your style is making someone else’s day brighter.',
      name: 'firstItemGiftedAchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Picture Perfect!`
  String get firstItemPicEditedAchievement {
    return Intl.message(
      'Picture Perfect!',
      name: 'firstItemPicEditedAchievement',
      desc: '',
      args: [],
    );
  }

  /// `Your first item picture has been edited! Your closet is looking better than ever.`
  String get firstItemPicEditedAchievementMessage {
    return Intl.message(
      'Your first item picture has been edited! Your closet is looking better than ever.',
      name: 'firstItemPicEditedAchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Smart Seller!`
  String get firstItemSoldAchievement {
    return Intl.message(
      'Smart Seller!',
      name: 'firstItemSoldAchievement',
      desc: '',
      args: [],
    );
  }

  /// `You’ve sold your first item! Way to turn your closet into cash and make space for new looks.`
  String get firstItemSoldAchievementMessage {
    return Intl.message(
      'You’ve sold your first item! Way to turn your closet into cash and make space for new looks.',
      name: 'firstItemSoldAchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sustainable Swapper!`
  String get firstItemSwapAchievement {
    return Intl.message(
      'Sustainable Swapper!',
      name: 'firstItemSwapAchievement',
      desc: '',
      args: [],
    );
  }

  /// `You’ve swapped your first item! Your wardrobe just got a stylish and sustainable refresh.`
  String get firstItemSwapAchievementMessage {
    return Intl.message(
      'You’ve swapped your first item! Your wardrobe just got a stylish and sustainable refresh.',
      name: 'firstItemSwapAchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Item Initiator!`
  String get firstItemUploadAchievement {
    return Intl.message(
      'Item Initiator!',
      name: 'firstItemUploadAchievement',
      desc: '',
      args: [],
    );
  }

  /// `Your first item is uploaded! Your virtual closet journey has begun!`
  String get firstItemUploadAchievementMessage {
    return Intl.message(
      'Your first item is uploaded! Your virtual closet journey has begun!',
      name: 'firstItemUploadAchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Achievement Unlocked!`
  String get defaultAchievementTitle {
    return Intl.message(
      'Achievement Unlocked!',
      name: 'defaultAchievementTitle',
      desc: '',
      args: [],
    );
  }

  /// `You’ve reached a new milestone! Keep up the great work as you continue your journey towards mindful fashion.`
  String get defaultAchievementMessage {
    return Intl.message(
      'You’ve reached a new milestone! Keep up the great work as you continue your journey towards mindful fashion.',
      name: 'defaultAchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `We’re unable to process your account deletion right now. Could you kindly email us at support@example.com for assistance?`
  String get unableToProcessAccountDeletion {
    return Intl.message(
      'We’re unable to process your account deletion right now. Could you kindly email us at support@example.com for assistance?',
      name: 'unableToProcessAccountDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Bronze Plan - Upload Items`
  String get uploadItemBronzeTitle {
    return Intl.message(
      'Bronze Plan - Upload Items',
      name: 'uploadItemBronzeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Upload 200 more items to keep building your sustainable wardrobe!`
  String get uploadItemBronzeDescription {
    return Intl.message(
      'Upload 200 more items to keep building your sustainable wardrobe!',
      name: 'uploadItemBronzeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Silver Plan - Upload Items`
  String get uploadItemSilverTitle {
    return Intl.message(
      'Silver Plan - Upload Items',
      name: 'uploadItemSilverTitle',
      desc: '',
      args: [],
    );
  }

  /// `Upload 700 more items and keep your closet thriving!`
  String get uploadItemSilverDescription {
    return Intl.message(
      'Upload 700 more items and keep your closet thriving!',
      name: 'uploadItemSilverDescription',
      desc: '',
      args: [],
    );
  }

  /// `Gold Plan - Upload Items`
  String get uploadItemGoldTitle {
    return Intl.message(
      'Gold Plan - Upload Items',
      name: 'uploadItemGoldTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited uploads! Add as many items as you like to your conscious closet.`
  String get uploadItemGoldDescription {
    return Intl.message(
      'Unlimited uploads! Add as many items as you like to your conscious closet.',
      name: 'uploadItemGoldDescription',
      desc: '',
      args: [],
    );
  }

  /// `Bronze Plan - Edit Item Images`
  String get editItemBronzeTitle {
    return Intl.message(
      'Bronze Plan - Edit Item Images',
      name: 'editItemBronzeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit 200 more item images to keep your closet fresh.`
  String get editItemBronzeDescription {
    return Intl.message(
      'Edit 200 more item images to keep your closet fresh.',
      name: 'editItemBronzeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Silver Plan - Edit Item Images`
  String get editItemSilverTitle {
    return Intl.message(
      'Silver Plan - Edit Item Images',
      name: 'editItemSilverTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit 700 more item images and elevate your closet game!`
  String get editItemSilverDescription {
    return Intl.message(
      'Edit 700 more item images and elevate your closet game!',
      name: 'editItemSilverDescription',
      desc: '',
      args: [],
    );
  }

  /// `Gold Plan - Edit Item Images`
  String get editItemGoldTitle {
    return Intl.message(
      'Gold Plan - Edit Item Images',
      name: 'editItemGoldTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited image edits! Keep refining your closet to perfection.`
  String get editItemGoldDescription {
    return Intl.message(
      'Unlimited image edits! Keep refining your closet to perfection.',
      name: 'editItemGoldDescription',
      desc: '',
      args: [],
    );
  }

  /// `Bronze Plan - Selfie`
  String get selfieBronzeTitle {
    return Intl.message(
      'Bronze Plan - Selfie',
      name: 'selfieBronzeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Take 200 more selfies and keep your style on point!`
  String get selfieBronzeDescription {
    return Intl.message(
      'Take 200 more selfies and keep your style on point!',
      name: 'selfieBronzeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Silver Plan - Selfie`
  String get selfieSilverTitle {
    return Intl.message(
      'Silver Plan - Selfie',
      name: 'selfieSilverTitle',
      desc: '',
      args: [],
    );
  }

  /// `Take 700 more selfies and show off your fashion progress!`
  String get selfieSilverDescription {
    return Intl.message(
      'Take 700 more selfies and show off your fashion progress!',
      name: 'selfieSilverDescription',
      desc: '',
      args: [],
    );
  }

  /// `Gold Plan - Selfie`
  String get selfieGoldTitle {
    return Intl.message(
      'Gold Plan - Selfie',
      name: 'selfieGoldTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited selfies! Capture your looks whenever inspiration strikes.`
  String get selfieGoldDescription {
    return Intl.message(
      'Unlimited selfies! Capture your looks whenever inspiration strikes.',
      name: 'selfieGoldDescription',
      desc: '',
      args: [],
    );
  }

  /// `Multi Outfit Premium Feature`
  String get multiOutfitTitle {
    return Intl.message(
      'Multi Outfit Premium Feature',
      name: 'multiOutfitTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create multiple outfits a day and keep experimenting with your style!`
  String get multiOutfitDescription {
    return Intl.message(
      'Create multiple outfits a day and keep experimenting with your style!',
      name: 'multiOutfitDescription',
      desc: '',
      args: [],
    );
  }

  /// `Unlock Now`
  String get purchase_button {
    return Intl.message(
      'Unlock Now',
      name: 'purchase_button',
      desc: '',
      args: [],
    );
  }

  /// `Loading... Fashion magic in progress 🧙‍♂️✨`
  String get loading_text {
    return Intl.message(
      'Loading... Fashion magic in progress 🧙‍♂️✨',
      name: 'loading_text',
      desc: '',
      args: [],
    );
  }

  /// `Congrats! 200 More Items to Your Conscious Closet`
  String get uploadItemBronzeSuccessTitle {
    return Intl.message(
      'Congrats! 200 More Items to Your Conscious Closet',
      name: 'uploadItemBronzeSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `You've unlocked space for 200 more items!\nKeep adding thoughtfully to build a sustainable wardrobe that reflects your unique style.`
  String get uploadItemBronzeSuccessMessage {
    return Intl.message(
      'You\'ve unlocked space for 200 more items!\nKeep adding thoughtfully to build a sustainable wardrobe that reflects your unique style.',
      name: 'uploadItemBronzeSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Amazing! 700 More Items to Express Your Style`
  String get uploadItemSilverSuccessTitle {
    return Intl.message(
      'Amazing! 700 More Items to Express Your Style',
      name: 'uploadItemSilverSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your closet just got bigger!\nYou can now add 700 more items. Keep refining your personal style while making eco-conscious choices.`
  String get uploadItemSilverSuccessMessage {
    return Intl.message(
      'Your closet just got bigger!\nYou can now add 700 more items. Keep refining your personal style while making eco-conscious choices.',
      name: 'uploadItemSilverSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Limitless! Your Closet is Now Boundless`
  String get uploadItemGoldSuccessTitle {
    return Intl.message(
      'Limitless! Your Closet is Now Boundless',
      name: 'uploadItemGoldSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `You’ve unlocked unlimited space! Add as many items as you want and let your sustainable wardrobe reflect the best of your personal style.`
  String get uploadItemGoldSuccessMessage {
    return Intl.message(
      'You’ve unlocked unlimited space! Add as many items as you want and let your sustainable wardrobe reflect the best of your personal style.',
      name: 'uploadItemGoldSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Click Upload button to upload your first item in the closet.`
  String get clickUploadItemInCloset {
    return Intl.message(
      'Click Upload button to upload your first item in the closet.',
      name: 'clickUploadItemInCloset',
      desc: '',
      args: [],
    );
  }

  /// `What's the occasion?`
  String get enterEventName {
    return Intl.message(
      'What\'s the occasion?',
      name: 'enterEventName',
      desc: '',
      args: [],
    );
  }

  /// `Enter the event or special moment.`
  String get hintEventName {
    return Intl.message(
      'Enter the event or special moment.',
      name: 'hintEventName',
      desc: '',
      args: [],
    );
  }

  /// `Time to Refresh!`
  String get update_required_title {
    return Intl.message(
      'Time to Refresh!',
      name: 'update_required_title',
      desc: '',
      args: [],
    );
  }

  /// `We’ve made some improvements you’ll love! Update now to keep your wardrobe fresh and sustainable.`
  String get update_required_content {
    return Intl.message(
      'We’ve made some improvements you’ll love! Update now to keep your wardrobe fresh and sustainable.',
      name: 'update_required_content',
      desc: '',
      args: [],
    );
  }

  /// `Let’s Do It!`
  String get update_button_text {
    return Intl.message(
      'Let’s Do It!',
      name: 'update_button_text',
      desc: '',
      args: [],
    );
  }

  /// `Failed to save outfit. Please try again.`
  String get failedToSaveOutfit {
    return Intl.message(
      'Failed to save outfit. Please try again.',
      name: 'failedToSaveOutfit',
      desc: '',
      args: [],
    );
  }

  /// `3 items per row`
  String get gridSize3 {
    return Intl.message(
      '3 items per row',
      name: 'gridSize3',
      desc: '',
      args: [],
    );
  }

  /// `5 items per row`
  String get gridSize5 {
    return Intl.message(
      '5 items per row',
      name: 'gridSize5',
      desc: '',
      args: [],
    );
  }

  /// `7 items per row`
  String get gridSize7 {
    return Intl.message(
      '7 items per row',
      name: 'gridSize7',
      desc: '',
      args: [],
    );
  }

  /// `Updated At`
  String get updatedAt {
    return Intl.message(
      'Updated At',
      name: 'updatedAt',
      desc: '',
      args: [],
    );
  }

  /// `Created At`
  String get createdAt {
    return Intl.message(
      'Created At',
      name: 'createdAt',
      desc: '',
      args: [],
    );
  }

  /// `Amount Spent`
  String get amountSpent {
    return Intl.message(
      'Amount Spent',
      name: 'amountSpent',
      desc: '',
      args: [],
    );
  }

  /// `Last Worn`
  String get itemLastWorn {
    return Intl.message(
      'Last Worn',
      name: 'itemLastWorn',
      desc: '',
      args: [],
    );
  }

  /// `Worn in Outfit`
  String get wornInOutfit {
    return Intl.message(
      'Worn in Outfit',
      name: 'wornInOutfit',
      desc: '',
      args: [],
    );
  }

  /// `Price Per Wear`
  String get pricePerWear {
    return Intl.message(
      'Price Per Wear',
      name: 'pricePerWear',
      desc: '',
      args: [],
    );
  }

  /// `Ascending`
  String get ascending {
    return Intl.message(
      'Ascending',
      name: 'ascending',
      desc: '',
      args: [],
    );
  }

  /// `Descending`
  String get descending {
    return Intl.message(
      'Descending',
      name: 'descending',
      desc: '',
      args: [],
    );
  }

  /// `Customize Closet View`
  String get customizeClosetView {
    return Intl.message(
      'Customize Closet View',
      name: 'customizeClosetView',
      desc: '',
      args: [],
    );
  }

  /// `Reset to Default`
  String get resetToDefault {
    return Intl.message(
      'Reset to Default',
      name: 'resetToDefault',
      desc: '',
      args: [],
    );
  }

  /// `Save Customization`
  String get saveCustomization {
    return Intl.message(
      'Save Customization',
      name: 'saveCustomization',
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
