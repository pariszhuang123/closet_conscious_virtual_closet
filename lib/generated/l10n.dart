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

  /// `Closet\nConscious`
  String get AppName {
    return Intl.message(
      'Closet\nConscious',
      name: 'AppName',
      desc: '',
      args: [],
    );
  }

  /// `ShopYourCloset`
  String get tagline {
    return Intl.message(
      'ShopYourCloset',
      name: 'tagline',
      desc: '',
      args: [],
    );
  }

  /// `Oops, No Connection!`
  String get noInternetTitle {
    return Intl.message(
      'Oops, No Connection!',
      name: 'noInternetTitle',
      desc: '',
      args: [],
    );
  }

  /// `We’re just taking a little break\nReconnect soon to keep styling sustainably!`
  String get noInternetMessage {
    return Intl.message(
      'We’re just taking a little break\nReconnect soon to keep styling sustainably!',
      name: 'noInternetMessage',
      desc: '',
      args: [],
    );
  }

  /// `Still no connection, but your closet’s worth the wait!`
  String get noInternetSnackBar {
    return Intl.message(
      'Still no connection, but your closet’s worth the wait!',
      name: 'noInternetSnackBar',
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

  /// `Perfume`
  String get perfume {
    return Intl.message(
      'Perfume',
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

  /// `Your interest has been noted. Stay tuned for updates.`
  String get interestAcknowledged {
    return Intl.message(
      'Your interest has been noted. Stay tuned for updates.',
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

  /// `This shows the number of items you have uploaded`
  String get itemsUploadedTooltip {
    return Intl.message(
      'This shows the number of items you have uploaded',
      name: 'itemsUploadedTooltip',
      desc: '',
      args: [],
    );
  }

  /// `This shows your current streak of no purchase`
  String get currentStreakTooltip {
    return Intl.message(
      'This shows your current streak of no purchase',
      name: 'currentStreakTooltip',
      desc: '',
      args: [],
    );
  }

  /// `This shows your highest score of no purchase`
  String get highestStreakTooltip {
    return Intl.message(
      'This shows your highest score of no purchase',
      name: 'highestStreakTooltip',
      desc: '',
      args: [],
    );
  }

  /// `This shows how much you have spent on new items`
  String get spendingTooltip {
    return Intl.message(
      'This shows how much you have spent on new items',
      name: 'spendingTooltip',
      desc: '',
      args: [],
    );
  }

  /// `This shows how many new items you have purchased`
  String get newItemsTooltip {
    return Intl.message(
      'This shows how many new items you have purchased',
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

  /// `This shows the number of outfits you have uploaded`
  String get outfits_upload {
    return Intl.message(
      'This shows the number of outfits you have uploaded',
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

  /// `Your data has been updated`
  String get dataUpdatedSuccessfully {
    return Intl.message(
      'Your data has been updated',
      name: 'dataUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Your data has been saved`
  String get dataInsertedSuccessfully {
    return Intl.message(
      'Your data has been saved',
      name: 'dataInsertedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Upload successful!`
  String get upload_successful {
    return Intl.message(
      'Upload successful!',
      name: 'upload_successful',
      desc: '',
      args: [],
    );
  }

  /// `Upload failed: {error}`
  String upload_failed(Object error) {
    return Intl.message(
      'Upload failed: $error',
      name: 'upload_failed',
      desc: '',
      args: [error],
    );
  }

  /// `We are sorry, we can't record your interest`
  String get errorIncrement {
    return Intl.message(
      'We are sorry, we can\'t record your interest',
      name: 'errorIncrement',
      desc: '',
      args: [],
    );
  }

  /// `Your closet has being decluttered!`
  String get declutterAcknowledged {
    return Intl.message(
      'Your closet has being decluttered!',
      name: 'declutterAcknowledged',
      desc: '',
      args: [],
    );
  }

  /// `We are sorry, we can't declutter your closet`
  String get errorDeclutter {
    return Intl.message(
      'We are sorry, we can\'t declutter your closet',
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

  /// `Unexpected response format. Please try again later or contact support if the issue persists.`
  String get unexpectedResponseFormat {
    return Intl.message(
      'Unexpected response format. Please try again later or contact support if the issue persists.',
      name: 'unexpectedResponseFormat',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred. Please try again later or contact support if the issue persists.`
  String get unexpectedErrorOccurred {
    return Intl.message(
      'An unexpected error occurred. Please try again later or contact support if the issue persists.',
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

  /// `Have you finished uploading all your existing items to your closet? Once confirmed, any new uploads with price will be marked as new additions to your wardrobe.`
  String get uploadConfirmationDescription {
    return Intl.message(
      'Have you finished uploading all your existing items to your closet? Once confirmed, any new uploads with price will be marked as new additions to your wardrobe.',
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

  /// `Your current record of days without buying clothes.`
  String get currentStreak {
    return Intl.message(
      'Your current record of days without buying clothes.',
      name: 'currentStreak',
      desc: '',
      args: [],
    );
  }

  /// `Your top record of days without buying clothes.`
  String get highestStreak {
    return Intl.message(
      'Your top record of days without buying clothes.',
      name: 'highestStreak',
      desc: '',
      args: [],
    );
  }

  /// `Cost of the new items you have purchased`
  String get costOfNewItems {
    return Intl.message(
      'Cost of the new items you have purchased',
      name: 'costOfNewItems',
      desc: '',
      args: [],
    );
  }

  /// `Number of new items you have purchased`
  String get numberOfNewItems {
    return Intl.message(
      'Number of new items you have purchased',
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

  /// `Warning: Deleting your account is irreversible.\n`
  String get deleteAccountImpact {
    return Intl.message(
      'Warning: Deleting your account is irreversible.\n',
      name: 'deleteAccountImpact',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?\nAll your data and your paid features access will be permanently removed.\nThe data will be deleted in 48 hours`
  String get deleteAccountConfirmation {
    return Intl.message(
      'Are you sure you want to delete your account?\nAll your data and your paid features access will be permanently removed.\nThe data will be deleted in 48 hours',
      name: 'deleteAccountConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Your request has been received. We will delete your account within 48 hours.`
  String get accountDeletedSuccess {
    return Intl.message(
      'Your request has been received. We will delete your account within 48 hours.',
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

  /// `No achievement badges found`
  String get noAchievementFound {
    return Intl.message(
      'No achievement badges found',
      name: 'noAchievementFound',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations!`
  String get congratulations {
    return Intl.message(
      'Congratulations!',
      name: 'congratulations',
      desc: '',
      args: [],
    );
  }

  /// `Here is your achievement:`
  String get achievementMessage {
    return Intl.message(
      'Here is your achievement:',
      name: 'achievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `Interested in Usage Analytics?`
  String get AnalyticsSearchPremiumFeature {
    return Intl.message(
      'Interested in Usage Analytics?',
      name: 'AnalyticsSearchPremiumFeature',
      desc: '',
      args: [],
    );
  }

  /// `We're exploring a premium feature to analyze your items' cost per wear and provide personalized outfit insights.`
  String get trackAnalyticsDescription {
    return Intl.message(
      'We\'re exploring a premium feature to analyze your items\' cost per wear and provide personalized outfit insights.',
      name: 'trackAnalyticsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Interested in Calendar View?`
  String get calendarPremiumFeature {
    return Intl.message(
      'Interested in Calendar View?',
      name: 'calendarPremiumFeature',
      desc: '',
      args: [],
    );
  }

  /// `We're considering adding a premium feature to view previous outfits in a calendar format and integrate with multi-closet.`
  String get reviewOutfitsInCalendar {
    return Intl.message(
      'We\'re considering adding a premium feature to view previous outfits in a calendar format and integrate with multi-closet.',
      name: 'reviewOutfitsInCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Interested in Advanced Filters?`
  String get filterSearchPremiumFeature {
    return Intl.message(
      'Interested in Advanced Filters?',
      name: 'filterSearchPremiumFeature',
      desc: '',
      args: [],
    );
  }

  /// `We’re thinking about offering a premium feature to help you filter your items more easily.`
  String get quicklyFindItems {
    return Intl.message(
      'We’re thinking about offering a premium feature to help you filter your items more easily.',
      name: 'quicklyFindItems',
      desc: '',
      args: [],
    );
  }

  /// `Want to Add More Details?`
  String get metadataFeatureTitle {
    return Intl.message(
      'Want to Add More Details?',
      name: 'metadataFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `We’re thinking about offering a premium feature to let you add extra details to your items.`
  String get metadataFeatureDescription {
    return Intl.message(
      'We’re thinking about offering a premium feature to let you add extra details to your items.',
      name: 'metadataFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Interested in Multi-Closet?`
  String get multiClosetFeatureTitle {
    return Intl.message(
      'Interested in Multi-Closet?',
      name: 'multiClosetFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `We're considering adding a premium feature to create multiple closets, including temporary and disappearing closets.`
  String get multiClosetFeatureDescription {
    return Intl.message(
      'We\'re considering adding a premium feature to create multiple closets, including temporary and disappearing closets.',
      name: 'multiClosetFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Interested in Swapping Items?`
  String get swapFeatureTitle {
    return Intl.message(
      'Interested in Swapping Items?',
      name: 'swapFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `We're considering adding a premium feature for digitally swapping items and getting notified about nearby swap events.`
  String get swapFeatureDescription {
    return Intl.message(
      'We\'re considering adding a premium feature for digitally swapping items and getting notified about nearby swap events.',
      name: 'swapFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Arrange`
  String get arrange {
    return Intl.message(
      'Arrange',
      name: 'arrange',
      desc: '',
      args: [],
    );
  }

  /// `Interested in Customizing Your Closet Layout?`
  String get arrangeFeatureTitle {
    return Intl.message(
      'Interested in Customizing Your Closet Layout?',
      name: 'arrangeFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `We're considering adding a feature that lets you customize grid sizes and sort items by cost per wear, updated date, and more.`
  String get arrangeFeatureDescription {
    return Intl.message(
      'We\'re considering adding a feature that lets you customize grid sizes and sort items by cost per wear, updated date, and more.',
      name: 'arrangeFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `ok`
  String get ok {
    return Intl.message(
      'ok',
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

  /// `Please upload your items in my closet`
  String get noItemsInCategory {
    return Intl.message(
      'Please upload your items in my closet',
      name: 'noItemsInCategory',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong!`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong!',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load items`
  String get failedToLoadItems {
    return Intl.message(
      'Failed to load items',
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

  /// `No items found`
  String get noItemsFound {
    return Intl.message(
      'No items found',
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

  /// `love it`
  String get like {
    return Intl.message(
      'love it',
      name: 'like',
      desc: '',
      args: [],
    );
  }

  /// `It's okay`
  String get alright {
    return Intl.message(
      'It\'s okay',
      name: 'alright',
      desc: '',
      args: [],
    );
  }

  /// `Not for me`
  String get dislike {
    return Intl.message(
      'Not for me',
      name: 'dislike',
      desc: '',
      args: [],
    );
  }

  /// `selfie`
  String get selfie {
    return Intl.message(
      'selfie',
      name: 'selfie',
      desc: '',
      args: [],
    );
  }

  /// `share`
  String get share {
    return Intl.message(
      'share',
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

  /// `Tap the items that don't quite fit this outfit.`
  String get alright_feedback_sentence {
    return Intl.message(
      'Tap the items that don\'t quite fit this outfit.',
      name: 'alright_feedback_sentence',
      desc: '',
      args: [],
    );
  }

  /// `Tap the items that didn't work in this outfit.`
  String get dislike_feedback_sentence {
    return Intl.message(
      'Tap the items that didn\'t work in this outfit.',
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

  /// `Your outfit review has been successfully submitted!`
  String get outfitReviewContent {
    return Intl.message(
      'Your outfit review has been successfully submitted!',
      name: 'outfitReviewContent',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one item you didn't like.`
  String get pleaseSelectAtLeastOneItem {
    return Intl.message(
      'Please select at least one item you didn\'t like.',
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

  /// `Outfit ready. Go Slay the World!`
  String get outfitCreationSuccessContent {
    return Intl.message(
      'Outfit ready. Go Slay the World!',
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

  /// `We will Love Your Feedback`
  String get npsReviewEmailSubject {
    return Intl.message(
      'We will Love Your Feedback',
      name: 'npsReviewEmailSubject',
      desc: '',
      args: [],
    );
  }

  /// `Could you please share more details on how we can improve?`
  String get npsReviewEmailBody {
    return Intl.message(
      'Could you please share more details on how we can improve?',
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

  /// `How likely will you recommend Closet Conscious to a friend?`
  String get recommendClosetConscious {
    return Intl.message(
      'How likely will you recommend Closet Conscious to a friend?',
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

  /// `Something went wrong. Please try again later.`
  String get unknownError {
    return Intl.message(
      'Something went wrong. Please try again later.',
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

  /// `Allow access to your camera to upload photos of your clothes for easier closet management.`
  String get camera_upload_item_permission_explanation {
    return Intl.message(
      'Allow access to your camera to upload photos of your clothes for easier closet management.',
      name: 'camera_upload_item_permission_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Allow access to update item photos with your camera.`
  String get camera_edit_item_permission_explanation {
    return Intl.message(
      'Allow access to update item photos with your camera.',
      name: 'camera_edit_item_permission_explanation',
      desc: '',
      args: [],
    );
  }

  /// `Allow access to your camera to take selfies with your outfits.`
  String get camera_selfie_permission_explanation {
    return Intl.message(
      'Allow access to your camera to take selfies with your outfits.',
      name: 'camera_selfie_permission_explanation',
      desc: '',
      args: [],
    );
  }

  /// `We need access to your camera to take photos.`
  String get camera_permission_explanation {
    return Intl.message(
      'We need access to your camera to take photos.',
      name: 'camera_permission_explanation',
      desc: '',
      args: [],
    );
  }

  /// `This permission is needed to use this feature.`
  String get general_permission_explanation {
    return Intl.message(
      'This permission is needed to use this feature.',
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

  /// `No Image`
  String get noImage {
    return Intl.message(
      'No Image',
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

  /// `Unlock AI-powered outfit suggestions. Review 90 outfits to get personalized recommendations based on your style.`
  String get aiStylistFeatureDescription {
    return Intl.message(
      'Unlock AI-powered outfit suggestions. Review 90 outfits to get personalized recommendations based on your style.',
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

  /// `Easily upload items with automatic metadata tagging. The AI helps you save time by filling in details such as category, color, and more.`
  String get aiUploadFeatureDescription {
    return Intl.message(
      'Easily upload items with automatic metadata tagging. The AI helps you save time by filling in details such as category, color, and more.',
      name: 'aiUploadFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please select items to create your outfit.`
  String get selectItemsToCreateOutfit {
    return Intl.message(
      'Please select items to create your outfit.',
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

  /// `You've reached 90 days of no new clothes! You're building powerful habits for a greener future. Keep it up!`
  String get noNewClothes90AchievementMessage {
    return Intl.message(
      'You\'ve reached 90 days of no new clothes! You\'re building powerful habits for a greener future. Keep it up!',
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

  /// `225 days and counting! You're making waves in sustainability, and your closet is thriving. Amazing effort!`
  String get noNewClothes225AchievementMessage {
    return Intl.message(
      '225 days and counting! You\'re making waves in sustainability, and your closet is thriving. Amazing effort!',
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

  /// `405 days strong! Your commitment to cherishing what you have is an inspiration. You're a role model for thoughtful living.`
  String get noNewClothes405AchievementMessage {
    return Intl.message(
      '405 days strong! Your commitment to cherishing what you have is an inspiration. You\'re a role model for thoughtful living.',
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

  /// `630 days without new clothes—you're leading by example! Your dedication is making a real impact on the planet.`
  String get noNewClothes630AchievementMessage {
    return Intl.message(
      '630 days without new clothes—you\'re leading by example! Your dedication is making a real impact on the planet.',
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

  /// `Wow! 900 days of choosing wisely. Your influence is inspiring others to rethink their habits. Keep blazing the trail for sustainability!`
  String get noNewClothes900AchievementMessage {
    return Intl.message(
      'Wow! 900 days of choosing wisely. Your influence is inspiring others to rethink their habits. Keep blazing the trail for sustainability!',
      name: 'noNewClothes900AchievementMessage',
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

  /// `1,575 days of embracing what you already own. Your journey is nothing short of legendary. You're rewriting the rules of fashion!`
  String get noNewClothes1575AchievementMessage {
    return Intl.message(
      '1,575 days of embracing what you already own. Your journey is nothing short of legendary. You\'re rewriting the rules of fashion!',
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

  /// `You've worn every single item in your closet! You're mastering mindful fashion choices. Great job!`
  String get allClothesWornAchievementMessage {
    return Intl.message(
      'You\'ve worn every single item in your closet! You\'re mastering mindful fashion choices. Great job!',
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

  /// `Congratulations! You've uploaded all your items to your virtual closet. Now you're ready to make the most of what you own!`
  String get closetUploadAchievementMessage {
    return Intl.message(
      'Congratulations! You\'ve uploaded all your items to your virtual closet. Now you\'re ready to make the most of what you own!',
      name: 'closetUploadAchievementMessage',
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

  /// `You've reached a new milestone! Keep up the great work as you continue your journey towards mindful fashion.`
  String get defaultAchievementMessage {
    return Intl.message(
      'You\'ve reached a new milestone! Keep up the great work as you continue your journey towards mindful fashion.',
      name: 'defaultAchievementMessage',
      desc: '',
      args: [],
    );
  }

  /// `We are unable to process your account deletion request at the moment. Would you kindly email us at support@example.com for assistance?`
  String get unableToProcessAccountDeletion {
    return Intl.message(
      'We are unable to process your account deletion request at the moment. Would you kindly email us at support@example.com for assistance?',
      name: 'unableToProcessAccountDeletion',
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
