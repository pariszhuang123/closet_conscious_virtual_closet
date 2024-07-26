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

  /// `ClosetConscious`
  String get AppName {
    return Intl.message(
      'ClosetConscious',
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
  String get Spring {
    return Intl.message(
      'Spring',
      name: 'Spring',
      desc: '',
      args: [],
    );
  }

  /// `Summer`
  String get Summer {
    return Intl.message(
      'Summer',
      name: 'Summer',
      desc: '',
      args: [],
    );
  }

  /// `Autumn`
  String get Autumn {
    return Intl.message(
      'Autumn',
      name: 'Autumn',
      desc: '',
      args: [],
    );
  }

  /// `Winter`
  String get Winter {
    return Intl.message(
      'Winter',
      name: 'Winter',
      desc: '',
      args: [],
    );
  }

  /// `Multi`
  String get Multi {
    return Intl.message(
      'Multi',
      name: 'Multi',
      desc: '',
      args: [],
    );
  }

  /// `Top`
  String get Top {
    return Intl.message(
      'Top',
      name: 'Top',
      desc: '',
      args: [],
    );
  }

  /// `Bottom`
  String get Bottom {
    return Intl.message(
      'Bottom',
      name: 'Bottom',
      desc: '',
      args: [],
    );
  }

  /// `One Piece`
  String get OnePiece {
    return Intl.message(
      'One Piece',
      name: 'OnePiece',
      desc: '',
      args: [],
    );
  }

  /// `Base`
  String get Base {
    return Intl.message(
      'Base',
      name: 'Base',
      desc: '',
      args: [],
    );
  }

  /// `Mid`
  String get Mid {
    return Intl.message(
      'Mid',
      name: 'Mid',
      desc: '',
      args: [],
    );
  }

  /// `Outer`
  String get Outer {
    return Intl.message(
      'Outer',
      name: 'Outer',
      desc: '',
      args: [],
    );
  }

  /// `Red`
  String get Red {
    return Intl.message(
      'Red',
      name: 'Red',
      desc: '',
      args: [],
    );
  }

  /// `Blue`
  String get Blue {
    return Intl.message(
      'Blue',
      name: 'Blue',
      desc: '',
      args: [],
    );
  }

  /// `Green`
  String get Green {
    return Intl.message(
      'Green',
      name: 'Green',
      desc: '',
      args: [],
    );
  }

  /// `Yellow`
  String get Yellow {
    return Intl.message(
      'Yellow',
      name: 'Yellow',
      desc: '',
      args: [],
    );
  }

  /// `Brown`
  String get Brown {
    return Intl.message(
      'Brown',
      name: 'Brown',
      desc: '',
      args: [],
    );
  }

  /// `Grey`
  String get Grey {
    return Intl.message(
      'Grey',
      name: 'Grey',
      desc: '',
      args: [],
    );
  }

  /// `Rainbow`
  String get Rainbow {
    return Intl.message(
      'Rainbow',
      name: 'Rainbow',
      desc: '',
      args: [],
    );
  }

  /// `Black`
  String get Black {
    return Intl.message(
      'Black',
      name: 'Black',
      desc: '',
      args: [],
    );
  }

  /// `White`
  String get White {
    return Intl.message(
      'White',
      name: 'White',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get Light {
    return Intl.message(
      'Light',
      name: 'Light',
      desc: '',
      args: [],
    );
  }

  /// `Medium`
  String get Medium {
    return Intl.message(
      'Medium',
      name: 'Medium',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get Dark {
    return Intl.message(
      'Dark',
      name: 'Dark',
      desc: '',
      args: [],
    );
  }

  /// `Bag`
  String get Bag {
    return Intl.message(
      'Bag',
      name: 'Bag',
      desc: '',
      args: [],
    );
  }

  /// `Belt`
  String get Belt {
    return Intl.message(
      'Belt',
      name: 'Belt',
      desc: '',
      args: [],
    );
  }

  /// `Eyewear`
  String get Eyewear {
    return Intl.message(
      'Eyewear',
      name: 'Eyewear',
      desc: '',
      args: [],
    );
  }

  /// `Gloves`
  String get Gloves {
    return Intl.message(
      'Gloves',
      name: 'Gloves',
      desc: '',
      args: [],
    );
  }

  /// `Hat`
  String get Hat {
    return Intl.message(
      'Hat',
      name: 'Hat',
      desc: '',
      args: [],
    );
  }

  /// `Jewellery`
  String get Jewellery {
    return Intl.message(
      'Jewellery',
      name: 'Jewellery',
      desc: '',
      args: [],
    );
  }

  /// `Scarf`
  String get Scarf {
    return Intl.message(
      'Scarf',
      name: 'Scarf',
      desc: '',
      args: [],
    );
  }

  /// `Tie`
  String get Tie {
    return Intl.message(
      'Tie',
      name: 'Tie',
      desc: '',
      args: [],
    );
  }

  /// `Clothing`
  String get Clothing {
    return Intl.message(
      'Clothing',
      name: 'Clothing',
      desc: '',
      args: [],
    );
  }

  /// `Shoes`
  String get Shoes {
    return Intl.message(
      'Shoes',
      name: 'Shoes',
      desc: '',
      args: [],
    );
  }

  /// `Accessory`
  String get Accessory {
    return Intl.message(
      'Accessory',
      name: 'Accessory',
      desc: '',
      args: [],
    );
  }

  /// `Boots`
  String get Boots {
    return Intl.message(
      'Boots',
      name: 'Boots',
      desc: '',
      args: [],
    );
  }

  /// `Everyday`
  String get Everyday {
    return Intl.message(
      'Everyday',
      name: 'Everyday',
      desc: '',
      args: [],
    );
  }

  /// `Athletic`
  String get Athletic {
    return Intl.message(
      'Athletic',
      name: 'Athletic',
      desc: '',
      args: [],
    );
  }

  /// `Formal`
  String get Formal {
    return Intl.message(
      'Formal',
      name: 'Formal',
      desc: '',
      args: [],
    );
  }

  /// `Niche`
  String get Niche {
    return Intl.message(
      'Niche',
      name: 'Niche',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get Active {
    return Intl.message(
      'Active',
      name: 'Active',
      desc: '',
      args: [],
    );
  }

  /// `Casual`
  String get Casual {
    return Intl.message(
      'Casual',
      name: 'Casual',
      desc: '',
      args: [],
    );
  }

  /// `Workplace`
  String get Workplace {
    return Intl.message(
      'Workplace',
      name: 'Workplace',
      desc: '',
      args: [],
    );
  }

  /// `Social`
  String get Social {
    return Intl.message(
      'Social',
      name: 'Social',
      desc: '',
      args: [],
    );
  }

  /// `Event`
  String get Event {
    return Intl.message(
      'Event',
      name: 'Event',
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

  /// `Filter & Search Premium Feature`
  String get filterSearchPremiumFeature {
    return Intl.message(
      'Filter & Search Premium Feature',
      name: 'filterSearchPremiumFeature',
      desc: '',
      args: [],
    );
  }

  /// `Quickly find items with filter and search options, saving time and staying organized.`
  String get quicklyFindItems {
    return Intl.message(
      'Quickly find items with filter and search options, saving time and staying organized.',
      name: 'quicklyFindItems',
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

  /// `Discover Our New Multi-Closet Feature`
  String get multiClosetFeatureTitle {
    return Intl.message(
      'Discover Our New Multi-Closet Feature',
      name: 'multiClosetFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage multiple closets effortlessly with our upcoming multi-closet feature. Interested?`
  String get multiClosetFeatureDescription {
    return Intl.message(
      'Manage multiple closets effortlessly with our upcoming multi-closet feature. Interested?',
      name: 'multiClosetFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Register for Style Analytics Premium Feature`
  String get AnalyticsSearchPremiumFeature {
    return Intl.message(
      'Register for Style Analytics Premium Feature',
      name: 'AnalyticsSearchPremiumFeature',
      desc: '',
      args: [],
    );
  }

  /// `Gain deep insights into your wardrobe, helping you optimize usage, track spending, and discover your personal style.`
  String get trackAnalyticsDescription {
    return Intl.message(
      'Gain deep insights into your wardrobe, helping you optimize usage, track spending, and discover your personal style.',
      name: 'trackAnalyticsDescription',
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

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get Sell {
    return Intl.message(
      'Sell',
      name: 'Sell',
      desc: '',
      args: [],
    );
  }

  /// `Swap`
  String get Swap {
    return Intl.message(
      'Swap',
      name: 'Swap',
      desc: '',
      args: [],
    );
  }

  /// `Pay It Forward`
  String get Gift {
    return Intl.message(
      'Pay It Forward',
      name: 'Gift',
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

  /// `This shows the number of items you have uploaded`
  String get outfitsUploadedTooltip {
    return Intl.message(
      'This shows the number of items you have uploaded',
      name: 'outfitsUploadedTooltip',
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

  /// `Current streak for number of days you have not bought any clothing`
  String get currentStreak {
    return Intl.message(
      'Current streak for number of days you have not bought any clothing',
      name: 'currentStreak',
      desc: '',
      args: [],
    );
  }

  /// `Highest streak for number of days you have not bought any clothing`
  String get highestStreak {
    return Intl.message(
      'Highest streak for number of days you have not bought any clothing',
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
