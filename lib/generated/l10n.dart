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

  /// `Item Name`
  String get ItemNameLabel {
    return Intl.message(
      'Item Name',
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

  /// `Got a name in mind?`
  String get ItemNameFilterHint {
    return Intl.message(
      'Got a name in mind?',
      name: 'ItemNameFilterHint',
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

  /// `Camera`
  String get cameraUpload {
    return Intl.message(
      'Camera',
      name: 'cameraUpload',
      desc: '',
      args: [],
    );
  }

  /// `Edit Item`
  String get editItem {
    return Intl.message(
      'Edit Item',
      name: 'editItem',
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

  /// `Choose Swap`
  String get chooseSwap {
    return Intl.message(
      'Choose Swap',
      name: 'chooseSwap',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Swap`
  String get confirmSwap {
    return Intl.message(
      'Confirm Swap',
      name: 'confirmSwap',
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

  /// `Create Closet`
  String get createCloset {
    return Intl.message(
      'Create Closet',
      name: 'createCloset',
      desc: '',
      args: [],
    );
  }

  /// `Edit All Closets`
  String get allClosets {
    return Intl.message(
      'Edit All Closets',
      name: 'allClosets',
      desc: '',
      args: [],
    );
  }

  /// `All Closets`
  String get allClosetShown {
    return Intl.message(
      'All Closets',
      name: 'allClosetShown',
      desc: '',
      args: [],
    );
  }

  /// `Single Closet`
  String get singleClosetShown {
    return Intl.message(
      'Single Closet',
      name: 'singleClosetShown',
      desc: '',
      args: [],
    );
  }

  /// `No closets found`
  String get noClosetsFound {
    return Intl.message(
      'No closets found',
      name: 'noClosetsFound',
      desc: '',
      args: [],
    );
  }

  /// `Public`
  String get public_closet {
    return Intl.message(
      'Public',
      name: 'public_closet',
      desc: '',
      args: [],
    );
  }

  /// `Error saving closet`
  String get errorSavingCloset {
    return Intl.message(
      'Error saving closet',
      name: 'errorSavingCloset',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching closets`
  String get errorFetchingClosets {
    return Intl.message(
      'Error fetching closets',
      name: 'errorFetchingClosets',
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

  /// `Main Closet`
  String get defaultClosetName {
    return Intl.message(
      'Main Closet',
      name: 'defaultClosetName',
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

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
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

  /// `Item Type field is not selected.`
  String get itemTypeFieldNotFilled {
    return Intl.message(
      'Item Type field is not selected.',
      name: 'itemTypeFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Occasion field is not selected.`
  String get occasionFieldNotFilled {
    return Intl.message(
      'Occasion field is not selected.',
      name: 'occasionFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Season field is not selected.`
  String get seasonFieldNotFilled {
    return Intl.message(
      'Season field is not selected.',
      name: 'seasonFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Specific Type field is not selected.`
  String get specificTypeFieldNotFilled {
    return Intl.message(
      'Specific Type field is not selected.',
      name: 'specificTypeFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Clothing Layer field is not selected.`
  String get clothingLayerFieldNotFilled {
    return Intl.message(
      'Clothing Layer field is not selected.',
      name: 'clothingLayerFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Colour field is not selected.`
  String get colourFieldNotFilled {
    return Intl.message(
      'Colour field is not selected.',
      name: 'colourFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Colour Variation field is not selected.`
  String get colourVariationFieldNotFilled {
    return Intl.message(
      'Colour Variation field is not selected.',
      name: 'colourVariationFieldNotFilled',
      desc: '',
      args: [],
    );
  }

  /// `Clothing type is not selected.`
  String get clothingTypeRequired {
    return Intl.message(
      'Clothing type is not selected.',
      name: 'clothingTypeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Accessory type is not selected.`
  String get accessoryTypeRequired {
    return Intl.message(
      'Accessory type is not selected.',
      name: 'accessoryTypeRequired',
      desc: '',
      args: [],
    );
  }

  /// `Shoes type is not selected.`
  String get shoesTypeRequired {
    return Intl.message(
      'Shoes type is not selected.',
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

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `Once you confirm, this item will disappear from your closet view permanently.\n\nHave you considered donating or upcycling instead?\n\n You could put it in a public closet, where people can buy / barter / swap with you for the item.`
  String get declutterThrowWarning {
    return Intl.message(
      'Once you confirm, this item will disappear from your closet view permanently.\n\nHave you considered donating or upcycling instead?\n\n You could put it in a public closet, where people can buy / barter / swap with you for the item.',
      name: 'declutterThrowWarning',
      desc: '',
      args: [],
    );
  }

  /// `Once you confirm, this item will disappear from your closet view permanently.`
  String get declutterGenericWarning {
    return Intl.message(
      'Once you confirm, this item will disappear from your closet view permanently.',
      name: 'declutterGenericWarning',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
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

  /// `Manage Your Multi-Closets`
  String get MultiClosetFeatureTitle {
    return Intl.message(
      'Manage Your Multi-Closets',
      name: 'MultiClosetFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Explore options for your multi-closets.\nYou can create a new multi-closet,\nedit items from all multi-closets,\nor make changes to a single multi-closet.`
  String get viewMultiClosetDescription {
    return Intl.message(
      'Explore options for your multi-closets.\nYou can create a new multi-closet,\nedit items from all multi-closets,\nor make changes to a single multi-closet.',
      name: 'viewMultiClosetDescription',
      desc: '',
      args: [],
    );
  }

  /// `Create a new multi-closet, organize items,\nand add metadata to keep your closets structured`
  String get createMultiClosetDescription {
    return Intl.message(
      'Create a new multi-closet, organize items,\nand add metadata to keep your closets structured',
      name: 'createMultiClosetDescription',
      desc: '',
      args: [],
    );
  }

  /// `Edit a single multi-closet.\nTransfer items to another closet,\nupdate metadata,\nchange the multi-closet image,\nor archive the closet.`
  String get editSingleMultiClosetDescription {
    return Intl.message(
      'Edit a single multi-closet.\nTransfer items to another closet,\nupdate metadata,\nchange the multi-closet image,\nor archive the closet.',
      name: 'editSingleMultiClosetDescription',
      desc: '',
      args: [],
    );
  }

  /// `Edit all multi-closets at once.\nTransfer items to a single closet and streamline your wardrobe.`
  String get editAllMultiClosetDescription {
    return Intl.message(
      'Edit all multi-closets at once.\nTransfer items to a single closet and streamline your wardrobe.',
      name: 'editAllMultiClosetDescription',
      desc: '',
      args: [],
    );
  }

  /// `Multi-Closet Management`
  String get multiClosetManagement {
    return Intl.message(
      'Multi-Closet Management',
      name: 'multiClosetManagement',
      desc: '',
      args: [],
    );
  }

  /// `Share Your Closet\nwith the Community`
  String get publicClosetFeatureTitle {
    return Intl.message(
      'Share Your Closet\nwith the Community',
      name: 'publicClosetFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `What if you could share items from your closet with neighbors and even host local sale events? Interested?`
  String get publicClosetFeatureDescription {
    return Intl.message(
      'What if you could share items from your closet with neighbors and even host local sale events? Interested?',
      name: 'publicClosetFeatureDescription',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a closet name`
  String get enterClosetName {
    return Intl.message(
      'Please enter a closet name',
      name: 'enterClosetName',
      desc: '',
      args: [],
    );
  }

  /// `Closet name cannot be empty`
  String get closetNameCannotBeEmpty {
    return Intl.message(
      'Closet name cannot be empty',
      name: 'closetNameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Months cannot be empty`
  String get monthsCannotBeEmpty {
    return Intl.message(
      'Months cannot be empty',
      name: 'monthsCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid months (enter a positive number)`
  String get invalidMonths {
    return Intl.message(
      'Invalid months (enter a positive number)',
      name: 'invalidMonths',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the number of months`
  String get enterMonths {
    return Intl.message(
      'Please enter the number of months',
      name: 'enterMonths',
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

  /// `Confirm Outfit`
  String get styleOn {
    return Intl.message(
      'Confirm Outfit',
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

  /// `Not sure\n🤷‍♀️`
  String get alright {
    return Intl.message(
      'Not sure\n🤷‍♀️',
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

  /// `OOTD`
  String get selfie {
    return Intl.message(
      'OOTD',
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

  /// `Tap the items you're unsure about.`
  String get alright_feedback_sentence {
    return Intl.message(
      'Tap the items you\'re unsure about.',
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

  /// `https://www.notion.so/Pricing-0b17492513594b7b8975ec686eac1adf?pvs=4#cf77b531351848ed9be7ef80e95d6c2a`
  String get streakBenefitsUrl {
    return Intl.message(
      'https://www.notion.so/Pricing-0b17492513594b7b8975ec686eac1adf?pvs=4#cf77b531351848ed9be7ef80e95d6c2a',
      name: 'streakBenefitsUrl',
      desc: '',
      args: [],
    );
  }

  /// `Your Streak, Your Style, Your Rewards`
  String get streakBenefitsTitle {
    return Intl.message(
      'Your Streak, Your Style, Your Rewards',
      name: 'streakBenefitsTitle',
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

  /// `This permission is\nrequired for the app\nto function properly.`
  String get permission_needed {
    return Intl.message(
      'This permission is\nrequired for the app\nto function properly.',
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

  /// `We need access to your camera for your stunning outfit!`
  String get camera_selfie_permission_explanation {
    return Intl.message(
      'We need access to your camera for your stunning outfit!',
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

  /// `We need access to your photo library so you can select and upload your favorite outfits.`
  String get photo_library_permission_explanation {
    return Intl.message(
      'We need access to your photo library so you can select and upload your favorite outfits.',
      name: 'photo_library_permission_explanation',
      desc: '',
      args: [],
    );
  }

  /// `We use notifications to gently remind you to upload items or create outfits. No spam, just a little nudge when it matters.`
  String get notification_permission_explanation {
    return Intl.message(
      'We use notifications to gently remind you to upload items or create outfits. No spam, just a little nudge when it matters.',
      name: 'notification_permission_explanation',
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

  /// `Bronze Plan - OOTD`
  String get selfieBronzeTitle {
    return Intl.message(
      'Bronze Plan - OOTD',
      name: 'selfieBronzeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Take 200 more OOTD and keep your style on point!`
  String get selfieBronzeDescription {
    return Intl.message(
      'Take 200 more OOTD and keep your style on point!',
      name: 'selfieBronzeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Silver Plan - OOTD`
  String get selfieSilverTitle {
    return Intl.message(
      'Silver Plan - OOTD',
      name: 'selfieSilverTitle',
      desc: '',
      args: [],
    );
  }

  /// `Take 700 more OOTD and show off your fashion progress!`
  String get selfieSilverDescription {
    return Intl.message(
      'Take 700 more OOTD and show off your fashion progress!',
      name: 'selfieSilverDescription',
      desc: '',
      args: [],
    );
  }

  /// `Gold Plan - OOTD`
  String get selfieGoldTitle {
    return Intl.message(
      'Gold Plan - OOTD',
      name: 'selfieGoldTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited OOTD! Capture your looks whenever inspiration strikes.`
  String get selfieGoldDescription {
    return Intl.message(
      'Unlimited OOTD! Capture your looks whenever inspiration strikes.',
      name: 'selfieGoldDescription',
      desc: '',
      args: [],
    );
  }

  /// `Bronze Plan - Edit Closet Images`
  String get editClosetBronzeTitle {
    return Intl.message(
      'Bronze Plan - Edit Closet Images',
      name: 'editClosetBronzeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Update and edit up to 200 closet photos to keep your digital closet organized and stylish.`
  String get editClosetBronzeDescription {
    return Intl.message(
      'Update and edit up to 200 closet photos to keep your digital closet organized and stylish.',
      name: 'editClosetBronzeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Silver Plan - Edit Closet Images`
  String get editClosetSilverTitle {
    return Intl.message(
      'Silver Plan - Edit Closet Images',
      name: 'editClosetSilverTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edit up to 700 closet photos and enhance your capsule closet management!`
  String get editClosetSilverDescription {
    return Intl.message(
      'Edit up to 700 closet photos and enhance your capsule closet management!',
      name: 'editClosetSilverDescription',
      desc: '',
      args: [],
    );
  }

  /// `Gold Plan - Edit Closet Images`
  String get editClosetGoldTitle {
    return Intl.message(
      'Gold Plan - Edit Closet Images',
      name: 'editClosetGoldTitle',
      desc: '',
      args: [],
    );
  }

  /// `Enjoy unlimited edits for your closet photos and create the perfect digital wardrobe experience.`
  String get editClosetGoldDescription {
    return Intl.message(
      'Enjoy unlimited edits for your closet photos and create the perfect digital wardrobe experience.',
      name: 'editClosetGoldDescription',
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

  /// `Personalized Closet View`
  String get customizeTitle {
    return Intl.message(
      'Personalized Closet View',
      name: 'customizeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Personalize your view with grid size, sort category, and sort order.`
  String get customizeDescription {
    return Intl.message(
      'Personalize your view with grid size, sort category, and sort order.',
      name: 'customizeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Browse your closet in a flexible grid, sorted by your chosen category and order.`
  String get customizeClosetPageDescription {
    return Intl.message(
      'Browse your closet in a flexible grid, sorted by your chosen category and order.',
      name: 'customizeClosetPageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Find items for your outfits in a flexible grid, sorted by category and order to make styling easy.`
  String get customizeOutfitPageDescription {
    return Intl.message(
      'Find items for your outfits in a flexible grid, sorted by category and order to make styling easy.',
      name: 'customizeOutfitPageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Find Your Favorites Faster`
  String get filterFeatureTitle {
    return Intl.message(
      'Find Your Favorites Faster',
      name: 'filterFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Quickly search by item name or, with multi-closet [premium feature], choose which closet to explore.`
  String get basicFilterDescription {
    return Intl.message(
      'Quickly search by item name or, with multi-closet [premium feature], choose which closet to explore.',
      name: 'basicFilterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Refine your search to fit your style! Filter by item type, occasion, season, and more for a closet view that’s all you.`
  String get advancedFilterDescription {
    return Intl.message(
      'Refine your search to fit your style! Filter by item type, occasion, season, and more for a closet view that’s all you.',
      name: 'advancedFilterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Sort your closet by color, type, and more to find just what you need.`
  String get filterClosetPageDescription {
    return Intl.message(
      'Sort your closet by color, type, and more to find just what you need.',
      name: 'filterClosetPageDescription',
      desc: '',
      args: [],
    );
  }

  /// `Focus on items that fit your style, mood, and plans.`
  String get filterOutfitPageDescription {
    return Intl.message(
      'Focus on items that fit your style, mood, and plans.',
      name: 'filterOutfitPageDescription',
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

  /// `Grid Size Picker`
  String get gridSizePickerTitle {
    return Intl.message(
      'Grid Size Picker',
      name: 'gridSizePickerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sort Category Picker`
  String get sortCategoryPickerTitle {
    return Intl.message(
      'Sort Category Picker',
      name: 'sortCategoryPickerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sort Order Picker`
  String get sortOrderPickerTitle {
    return Intl.message(
      'Sort Order Picker',
      name: 'sortOrderPickerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Filter Items`
  String get filterItemsTitle {
    return Intl.message(
      'Filter Items',
      name: 'filterItemsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Basic Filters`
  String get basicFiltersTab {
    return Intl.message(
      'Basic Filters',
      name: 'basicFiltersTab',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Filters`
  String get advancedFiltersTab {
    return Intl.message(
      'Advanced Filters',
      name: 'advancedFiltersTab',
      desc: '',
      args: [],
    );
  }

  /// `All Closet`
  String get allClosetLabel {
    return Intl.message(
      'All Closet',
      name: 'allClosetLabel',
      desc: '',
      args: [],
    );
  }

  /// `Select Closet`
  String get selectClosetLabel {
    return Intl.message(
      'Select Closet',
      name: 'selectClosetLabel',
      desc: '',
      args: [],
    );
  }

  /// `Only Unworn Items`
  String get onlyItemsUnworn {
    return Intl.message(
      'Only Unworn Items',
      name: 'onlyItemsUnworn',
      desc: '',
      args: [],
    );
  }

  /// `All Items`
  String get allItems {
    return Intl.message(
      'All Items',
      name: 'allItems',
      desc: '',
      args: [],
    );
  }

  /// `Save Filter`
  String get saveFilter {
    return Intl.message(
      'Save Filter',
      name: 'saveFilter',
      desc: '',
      args: [],
    );
  }

  /// `No closets available`
  String get noClosetsAvailable {
    return Intl.message(
      'No closets available',
      name: 'noClosetsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Closet Name`
  String get closetName {
    return Intl.message(
      'Closet Name',
      name: 'closetName',
      desc: '',
      args: [],
    );
  }

  /// `Closet Type`
  String get closetType {
    return Intl.message(
      'Closet Type',
      name: 'closetType',
      desc: '',
      args: [],
    );
  }

  /// `Permanent Closet`
  String get permanentCloset {
    return Intl.message(
      'Permanent Closet',
      name: 'permanentCloset',
      desc: '',
      args: [],
    );
  }

  /// `Disappearing Closet`
  String get disappearingCloset {
    return Intl.message(
      'Disappearing Closet',
      name: 'disappearingCloset',
      desc: '',
      args: [],
    );
  }

  /// `Public or Private`
  String get publicOrPrivate {
    return Intl.message(
      'Public or Private',
      name: 'publicOrPrivate',
      desc: '',
      args: [],
    );
  }

  /// `Public`
  String get public {
    return Intl.message(
      'Public',
      name: 'public',
      desc: '',
      args: [],
    );
  }

  /// `Private`
  String get private {
    return Intl.message(
      'Private',
      name: 'private',
      desc: '',
      args: [],
    );
  }

  /// `Hidden for`
  String get disappearAfterMonths {
    return Intl.message(
      'Hidden for',
      name: 'disappearAfterMonths',
      desc: '',
      args: [],
    );
  }

  /// `Months to disappear`
  String get months {
    return Intl.message(
      'Months to disappear',
      name: 'months',
      desc: '',
      args: [],
    );
  }

  /// `Closet created successfully!`
  String get closet_created_successfully {
    return Intl.message(
      'Closet created successfully!',
      name: 'closet_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Closet edited successfully!`
  String get closet_edited_successfully {
    return Intl.message(
      'Closet edited successfully!',
      name: 'closet_edited_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String error_creating_closet(Object error) {
    return Intl.message(
      'Error: $error',
      name: 'error_creating_closet',
      desc: '',
      args: [error],
    );
  }

  /// `Create Closet`
  String get create_closet {
    return Intl.message(
      'Create Closet',
      name: 'create_closet',
      desc: '',
      args: [],
    );
  }

  /// `Error found. Check your input.`
  String get validation_error {
    return Intl.message(
      'Error found. Check your input.',
      name: 'validation_error',
      desc: '',
      args: [],
    );
  }

  /// `Fix the errors to continue.`
  String get fix_validation_errors {
    return Intl.message(
      'Fix the errors to continue.',
      name: 'fix_validation_errors',
      desc: '',
      args: [],
    );
  }

  /// `'cc_closet' is a reserved name. Please choose another.`
  String get reservedClosetNameError {
    return Intl.message(
      '\'cc_closet\' is a reserved name. Please choose another.',
      name: 'reservedClosetNameError',
      desc: '',
      args: [],
    );
  }

  /// `Please select public or private for a permanent closet.`
  String get publicPrivateSelectionRequired {
    return Intl.message(
      'Please select public or private for a permanent closet.',
      name: 'publicPrivateSelectionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Enter number of months.`
  String get pleaseEnterMonths {
    return Intl.message(
      'Enter number of months.',
      name: 'pleaseEnterMonths',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid number of months.`
  String get pleaseEnterValidMonths {
    return Intl.message(
      'Please enter a valid number of months.',
      name: 'pleaseEnterValidMonths',
      desc: '',
      args: [],
    );
  }

  /// `reset`
  String get reset {
    return Intl.message(
      'reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Select a date`
  String get selectDate {
    return Intl.message(
      'Select a date',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  /// `Valid Date`
  String get validDate {
    return Intl.message(
      'Valid Date',
      name: 'validDate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid date`
  String get pleaseEnterValidDate {
    return Intl.message(
      'Please enter a valid date',
      name: 'pleaseEnterValidDate',
      desc: '',
      args: [],
    );
  }

  /// `Archive\nCloset`
  String get archiveCloset {
    return Intl.message(
      'Archive\nCloset',
      name: 'archiveCloset',
      desc: '',
      args: [],
    );
  }

  /// `Archive Closet`
  String get archiveClosetTitle {
    return Intl.message(
      'Archive Closet',
      name: 'archiveClosetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select All`
  String get selectAll {
    return Intl.message(
      'Select All',
      name: 'selectAll',
      desc: '',
      args: [],
    );
  }

  /// `The selected date cannot be today or earlier.`
  String get dateCannotBeTodayOrEarlier {
    return Intl.message(
      'The selected date cannot be today or earlier.',
      name: 'dateCannotBeTodayOrEarlier',
      desc: '',
      args: [],
    );
  }

  /// `Invalid value for months.`
  String get invalidMonthsValue {
    return Intl.message(
      'Invalid value for months.',
      name: 'invalidMonthsValue',
      desc: '',
      args: [],
    );
  }

  /// `Cannot exceed 12 months`
  String get monthsCannotExceed12 {
    return Intl.message(
      'Cannot exceed 12 months',
      name: 'monthsCannotExceed12',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Your closet has been archived successfully.\nAll items have been moved back to the main closet.`
  String get archiveSuccessMessage {
    return Intl.message(
      'Your closet has been archived successfully.\nAll items have been moved back to the main closet.',
      name: 'archiveSuccessMessage',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to archive this closet?\nAll items will be moved back to your main closet.`
  String get archiveWarning {
    return Intl.message(
      'Are you sure you want to archive this closet?\nAll items will be moved back to your main closet.',
      name: 'archiveWarning',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get archive {
    return Intl.message(
      'Archive',
      name: 'archive',
      desc: '',
      args: [],
    );
  }

  /// `Archiving this closet will return all items to your main closet.\n\nThis action cannot be undone.`
  String get archiveClosetDescription {
    return Intl.message(
      'Archiving this closet will return all items to your main closet.\n\nThis action cannot be undone.',
      name: 'archiveClosetDescription',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load closet metadata.\nPlease try again.`
  String get failedToLoadMetadata {
    return Intl.message(
      'Failed to load closet metadata.\nPlease try again.',
      name: 'failedToLoadMetadata',
      desc: '',
      args: [],
    );
  }

  /// `Closet Reappeared`
  String get closetReappearTitle {
    return Intl.message(
      'Closet Reappeared',
      name: 'closetReappearTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your disappearing closet '{closetName}' is now permanent. You can access all its items!`
  String closetReappearMessage(Object closetName) {
    return Intl.message(
      'Your disappearing closet \'$closetName\' is now permanent. You can access all its items!',
      name: 'closetReappearMessage',
      desc: '',
      args: [closetName],
    );
  }

  /// `View Closet Items`
  String get viewClosetItemsButton {
    return Intl.message(
      'View Closet Items',
      name: 'viewClosetItemsButton',
      desc: '',
      args: [],
    );
  }

  /// `View Closet`
  String get fetchReappearClosets {
    return Intl.message(
      'View Closet',
      name: 'fetchReappearClosets',
      desc: '',
      args: [],
    );
  }

  /// `No reappeared closets found.`
  String get noReappearClosets {
    return Intl.message(
      'No reappeared closets found.',
      name: 'noReappearClosets',
      desc: '',
      args: [],
    );
  }

  /// `Your Trial Has Ended`
  String get trialEndedTitle {
    return Intl.message(
      'Your Trial Has Ended',
      name: 'trialEndedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your premium trial period has ended.`
  String get trialEndedMessage {
    return Intl.message(
      'Your premium trial period has ended.',
      name: 'trialEndedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Premium features are now locked. Access them anytime by  making a one-time purchase.`
  String get trialEndedNextSteps {
    return Intl.message(
      'Premium features are now locked. Access them anytime by  making a one-time purchase.',
      name: 'trialEndedNextSteps',
      desc: '',
      args: [],
    );
  }

  /// `Explore Premium Benefits`
  String get trialStartedTitle {
    return Intl.message(
      'Explore Premium Benefits',
      name: 'trialStartedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Experience all the premium perks for 30 days. Totally free. No credit card needed.`
  String get trialStartedMessage {
    return Intl.message(
      'Experience all the premium perks for 30 days. Totally free. No credit card needed.',
      name: 'trialStartedMessage',
      desc: '',
      args: [],
    );
  }

  /// `You have successfully activated your premium features. All premium features are now available to enhance your experience.`
  String get trialStartedNextSteps {
    return Intl.message(
      'You have successfully activated your premium features. All premium features are now available to enhance your experience.',
      name: 'trialStartedNextSteps',
      desc: '',
      args: [],
    );
  }

  /// `Trial Activated!`
  String get trialStartedNextStepsTitle {
    return Intl.message(
      'Trial Activated!',
      name: 'trialStartedNextStepsTitle',
      desc: '',
      args: [],
    );
  }

  /// `What’s included in your trial`
  String get trialIncludedTitle {
    return Intl.message(
      'What’s included in your trial',
      name: 'trialIncludedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Easily find what you need with advanced filters.`
  String get trialIncludedFilter {
    return Intl.message(
      'Easily find what you need with advanced filters.',
      name: 'trialIncludedFilter',
      desc: '',
      args: [],
    );
  }

  /// `Customize your closet view – adjust grid size and sort by cost per wear, last worn, and more.`
  String get trialIncludedCustomize {
    return Intl.message(
      'Customize your closet view – adjust grid size and sort by cost per wear, last worn, and more.',
      name: 'trialIncludedCustomize',
      desc: '',
      args: [],
    );
  }

  /// `Create multiple closets – from permanent staples to seasonal disappearing wardrobes.`
  String get trialIncludedClosets {
    return Intl.message(
      'Create multiple closets – from permanent staples to seasonal disappearing wardrobes.',
      name: 'trialIncludedClosets',
      desc: '',
      args: [],
    );
  }

  /// `Style and save as many outfits as you like, every day.`
  String get trialIncludedOutfits {
    return Intl.message(
      'Style and save as many outfits as you like, every day.',
      name: 'trialIncludedOutfits',
      desc: '',
      args: [],
    );
  }

  /// `Look back at your outfits on a calendar and link them across your closets.`
  String get trialIncludedCalendar {
    return Intl.message(
      'Look back at your outfits on a calendar and link them across your closets.',
      name: 'trialIncludedCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Get smart insights into your wardrobe – track cost per wear and discover outfit ideas tailored to you.`
  String get trialIncludedDrawerInsights {
    return Intl.message(
      'Get smart insights into your wardrobe – track cost per wear and discover outfit ideas tailored to you.',
      name: 'trialIncludedDrawerInsights',
      desc: '',
      args: [],
    );
  }

  /// `Event Name`
  String get eventName {
    return Intl.message(
      'Event Name',
      name: 'eventName',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get allFeedback {
    return Intl.message(
      'All',
      name: 'allFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendarFeatureTitle {
    return Intl.message(
      'Calendar',
      name: 'calendarFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Outfit Details`
  String get calendarNotSelectable {
    return Intl.message(
      'Outfit Details',
      name: 'calendarNotSelectable',
      desc: '',
      args: [],
    );
  }

  /// `Focused Date`
  String get focusedDate {
    return Intl.message(
      'Focused Date',
      name: 'focusedDate',
      desc: '',
      args: [],
    );
  }

  /// `Create Closet`
  String get calendarSelectable {
    return Intl.message(
      'Create Closet',
      name: 'calendarSelectable',
      desc: '',
      args: [],
    );
  }

  /// `Active Outfits`
  String get outfitActive {
    return Intl.message(
      'Active Outfits',
      name: 'outfitActive',
      desc: '',
      args: [],
    );
  }

  /// `Inactive Outfits`
  String get outfitInactive {
    return Intl.message(
      'Inactive Outfits',
      name: 'outfitInactive',
      desc: '',
      args: [],
    );
  }

  /// `All Outfits`
  String get outfitsAll {
    return Intl.message(
      'All Outfits',
      name: 'outfitsAll',
      desc: '',
      args: [],
    );
  }

  /// `Outfit Status`
  String get outfitStatus {
    return Intl.message(
      'Outfit Status',
      name: 'outfitStatus',
      desc: '',
      args: [],
    );
  }

  /// `Filter by Event Name`
  String get filterEventName {
    return Intl.message(
      'Filter by Event Name',
      name: 'filterEventName',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `No outfits found in this month. You can create your first reviewed outfit or choose another date where you have reviewed your outfit.`
  String get noOutfitsInMonth {
    return Intl.message(
      'No outfits found in this month. You can create your first reviewed outfit or choose another date where you have reviewed your outfit.',
      name: 'noOutfitsInMonth',
      desc: '',
      args: [],
    );
  }

  /// `You haven’t reviewed any outfits yet. Start by reviewing your first outfit!`
  String get noReviewedOutfitMessage {
    return Intl.message(
      'You haven’t reviewed any outfits yet. Start by reviewing your first outfit!',
      name: 'noReviewedOutfitMessage',
      desc: '',
      args: [],
    );
  }

  /// `No outfits match your current filter. Adjust the filter to find reviewed outfits.`
  String get noFilteredOutfitMessage {
    return Intl.message(
      'No outfits match your current filter. Adjust the filter to find reviewed outfits.',
      name: 'noFilteredOutfitMessage',
      desc: '',
      args: [],
    );
  }

  /// `No outfit or item available`
  String get noOutfitsAvailable {
    return Intl.message(
      'No outfit or item available',
      name: 'noOutfitsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Day Focus`
  String get focus {
    return Intl.message(
      'Day Focus',
      name: 'focus',
      desc: '',
      args: [],
    );
  }

  /// `No comments available for this outfit.`
  String get noOutfitComments {
    return Intl.message(
      'No comments available for this outfit.',
      name: 'noOutfitComments',
      desc: '',
      args: [],
    );
  }

  /// `View all your outfits in a calendar format. Filter by event name, active outfit, and outfit feedback.`
  String get viewMonthlyCalendarDescription {
    return Intl.message(
      'View all your outfits in a calendar format. Filter by event name, active outfit, and outfit feedback.',
      name: 'viewMonthlyCalendarDescription',
      desc: '',
      args: [],
    );
  }

  /// `Select the outfits you want and see all related items to create a Closet.`
  String get createClosetCalendarDescription {
    return Intl.message(
      'Select the outfits you want and see all related items to create a Closet.',
      name: 'createClosetCalendarDescription',
      desc: '',
      args: [],
    );
  }

  /// `See all details of your outfit for the day, including event name, comments, and feedback.`
  String get viewDailyCalendarDescription {
    return Intl.message(
      'See all details of your outfit for the day, including event name, comments, and feedback.',
      name: 'viewDailyCalendarDescription',
      desc: '',
      args: [],
    );
  }

  /// `You haven’t added a comment for this outfit yet!`
  String get encourageComment {
    return Intl.message(
      'You haven’t added a comment for this outfit yet!',
      name: 'encourageComment',
      desc: '',
      args: [],
    );
  }

  /// `Start Free Trial`
  String get startFreeTrial {
    return Intl.message(
      'Start Free Trial',
      name: 'startFreeTrial',
      desc: '',
      args: [],
    );
  }

  /// `Closet Analytics`
  String get usageAnalyticsTitle {
    return Intl.message(
      'Closet Analytics',
      name: 'usageAnalyticsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Item Analytics`
  String get tabItemAnalytics {
    return Intl.message(
      'Item Analytics',
      name: 'tabItemAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Outfit Analytics`
  String get tabOutfitAnalytics {
    return Intl.message(
      'Outfit Analytics',
      name: 'tabOutfitAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Total Items`
  String get totalItems {
    return Intl.message(
      'Total Items',
      name: 'totalItems',
      desc: '',
      args: [],
    );
  }

  /// `Total Cost`
  String get totalCost {
    return Intl.message(
      'Total Cost',
      name: 'totalCost',
      desc: '',
      args: [],
    );
  }

  /// `Avg Cost Per Wear`
  String get avgPricePerWear {
    return Intl.message(
      'Avg Cost Per Wear',
      name: 'avgPricePerWear',
      desc: '',
      args: [],
    );
  }

  /// `See your closet in numbers—total cost, item count, and cost per wear, all at a glance.`
  String get viewSummaryItemAnalyticsDescription {
    return Intl.message(
      'See your closet in numbers—total cost, item count, and cost per wear, all at a glance.',
      name: 'viewSummaryItemAnalyticsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Discover your style story—track how often you love, feel unsure about, or rethink your outfits.`
  String get viewOutfitAnalyticsDescription {
    return Intl.message(
      'Discover your style story—track how often you love, feel unsure about, or rethink your outfits.',
      name: 'viewOutfitAnalyticsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Your Closet Insights`
  String get usageAnalyticsFeatureTitle {
    return Intl.message(
      'Your Closet Insights',
      name: 'usageAnalyticsFeatureTitle',
      desc: '',
      args: [],
    );
  }

  /// `Find new ways to wear what you own—similar outfit ideas based on your favorites.`
  String get outfitRelatedOutfitsDescription {
    return Intl.message(
      'Find new ways to wear what you own—similar outfit ideas based on your favorites.',
      name: 'outfitRelatedOutfitsDescription',
      desc: '',
      args: [],
    );
  }

  /// `See the outfits this item has brought to life—your style, your way.`
  String get itemWithRelatedOutfitsDescription {
    return Intl.message(
      'See the outfits this item has brought to life—your style, your way.',
      name: 'itemWithRelatedOutfitsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Build your dream capsule wardrobe with pieces you already love.`
  String get createClosetItemAnalyticsDescription {
    return Intl.message(
      'Build your dream capsule wardrobe with pieces you already love.',
      name: 'createClosetItemAnalyticsDescription',
      desc: '',
      args: [],
    );
  }

  /// `You have created {totalReviews} outfits in the last {daysTracked} days in {closetShown}.`
  String analyticsSummary(
      Object totalReviews, Object daysTracked, Object closetShown) {
    return Intl.message(
      'You have created $totalReviews outfits in the last $daysTracked days in $closetShown.',
      name: 'analyticsSummary',
      desc: '',
      args: [totalReviews, daysTracked, closetShown],
    );
  }

  /// `Item\nInsights`
  String get summaryItemAnalytics {
    return Intl.message(
      'Item\nInsights',
      name: 'summaryItemAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Outfit Insights`
  String get summaryOutfitAnalytics {
    return Intl.message(
      'Outfit Insights',
      name: 'summaryOutfitAnalytics',
      desc: '',
      args: [],
    );
  }

  /// `Related Outfits to above Item`
  String get relatedOutfitsToAboveItem {
    return Intl.message(
      'Related Outfits to above Item',
      name: 'relatedOutfitsToAboveItem',
      desc: '',
      args: [],
    );
  }

  /// `Related Outfits to above Outfit`
  String get relatedOutfitsToAboveOutfit {
    return Intl.message(
      'Related Outfits to above Outfit',
      name: 'relatedOutfitsToAboveOutfit',
      desc: '',
      args: [],
    );
  }

  /// `No related outfits reviewed yet.\n\nTry styling this outfit differently!`
  String get noRelatedOutfitsItem {
    return Intl.message(
      'No related outfits reviewed yet.\n\nTry styling this outfit differently!',
      name: 'noRelatedOutfitsItem',
      desc: '',
      args: [],
    );
  }

  /// `No related outfits reviewed yet.\n\nTry styling any of the above outfit items to create another outfit!`
  String get noRelatedOutfits {
    return Intl.message(
      'No related outfits reviewed yet.\n\nTry styling any of the above outfit items to create another outfit!',
      name: 'noRelatedOutfits',
      desc: '',
      args: [],
    );
  }

  /// `Create Outfit`
  String get createOutfit {
    return Intl.message(
      'Create Outfit',
      name: 'createOutfit',
      desc: '',
      args: [],
    );
  }

  /// `Failed to navigate the calendar.`
  String get calendarNavigationFailed {
    return Intl.message(
      'Failed to navigate the calendar.',
      name: 'calendarNavigationFailed',
      desc: '',
      args: [],
    );
  }

  /// `This item is retired and no longer part of your closet, but it stays in your past outfits.`
  String get itemInactiveMessage {
    return Intl.message(
      'This item is retired and no longer part of your closet, but it stays in your past outfits.',
      name: 'itemInactiveMessage',
      desc: '',
      args: [],
    );
  }

  /// `Bulk Upload`
  String get bulkUploadTitle {
    return Intl.message(
      'Bulk Upload',
      name: 'bulkUploadTitle',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get bulkUpload {
    return Intl.message(
      'Upload',
      name: 'bulkUpload',
      desc: '',
      args: [],
    );
  }

  /// `Here’s the total count of what you’ve selected! (This selection: total items)`
  String get totalItemsTooltip {
    return Intl.message(
      'Here’s the total count of what you’ve selected! (This selection: total items)',
      name: 'totalItemsTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Every piece is an investment—here’s what you've spent! (This selection: total cost)`
  String get totalCostTooltip {
    return Intl.message(
      'Every piece is an investment—here’s what you\'ve spent! (This selection: total cost)',
      name: 'totalCostTooltip',
      desc: '',
      args: [],
    );
  }

  /// `A lower cost per wear means you're getting great value! (Total cost ÷ times worn)`
  String get costPerWearTooltip {
    return Intl.message(
      'A lower cost per wear means you\'re getting great value! (Total cost ÷ times worn)',
      name: 'costPerWearTooltip',
      desc: '',
      args: [],
    );
  }

  /// `You can only select up to {maxAllowed} images.`
  String maxPendingItemsSnackbar(Object maxAllowed) {
    return Intl.message(
      'You can only select up to $maxAllowed images.',
      name: 'maxPendingItemsSnackbar',
      desc: '',
      args: [maxAllowed],
    );
  }

  /// `You can upload {maxAllowed} more. After that, you’ll reach your current limit.`
  String approachingLimitSnackbar(Object maxAllowed) {
    return Intl.message(
      'You can upload $maxAllowed more. After that, you’ll reach your current limit.',
      name: 'approachingLimitSnackbar',
      desc: '',
      args: [maxAllowed],
    );
  }

  /// `No photos found`
  String get noPhotosFound {
    return Intl.message(
      'No photos found',
      name: 'noPhotosFound',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load images`
  String get failedToLoadImages {
    return Intl.message(
      'Failed to load images',
      name: 'failedToLoadImages',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load more images`
  String get failedToLoadMoreImages {
    return Intl.message(
      'Failed to load more images',
      name: 'failedToLoadMoreImages',
      desc: '',
      args: [],
    );
  }

  /// `Upload Successful`
  String get uploadSuccessTitle {
    return Intl.message(
      'Upload Successful',
      name: 'uploadSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to upload more items from your photo library?`
  String get uploadSuccessContent {
    return Intl.message(
      'Would you like to upload more items from your photo library?',
      name: 'uploadSuccessContent',
      desc: '',
      args: [],
    );
  }

  /// `Update Successful`
  String get editPendingSuccessTitle {
    return Intl.message(
      'Update Successful',
      name: 'editPendingSuccessTitle',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to update more pending items from your photo library, so they can be used to create outfits in your closet?`
  String get editPendingSuccessContent {
    return Intl.message(
      'Would you like to update more pending items from your photo library, so they can be used to create outfits in your closet?',
      name: 'editPendingSuccessContent',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Machine`
  String get machine {
    return Intl.message(
      'Machine',
      name: 'machine',
      desc: '',
      args: [],
    );
  }

  /// `Dry Clean`
  String get dryClean {
    return Intl.message(
      'Dry Clean',
      name: 'dryClean',
      desc: '',
      args: [],
    );
  }

  /// `Hand Wash`
  String get handWash {
    return Intl.message(
      'Hand Wash',
      name: 'handWash',
      desc: '',
      args: [],
    );
  }

  /// `Do Not Wash`
  String get doNotWash {
    return Intl.message(
      'Do Not Wash',
      name: 'doNotWash',
      desc: '',
      args: [],
    );
  }

  /// `Natural`
  String get natural {
    return Intl.message(
      'Natural',
      name: 'natural',
      desc: '',
      args: [],
    );
  }

  /// `Blend`
  String get blend {
    return Intl.message(
      'Blend',
      name: 'blend',
      desc: '',
      args: [],
    );
  }

  /// `Semi-Synthetic`
  String get semiSynthetic {
    return Intl.message(
      'Semi-Synthetic',
      name: 'semiSynthetic',
      desc: '',
      args: [],
    );
  }

  /// `Synthetic`
  String get synthetic {
    return Intl.message(
      'Synthetic',
      name: 'synthetic',
      desc: '',
      args: [],
    );
  }

  /// `Brand New\nwith Tag`
  String get brandNewWithTag {
    return Intl.message(
      'Brand New\nwith Tag',
      name: 'brandNewWithTag',
      desc: '',
      args: [],
    );
  }

  /// `Brand New\nwithout Tag`
  String get brandNewWithoutTag {
    return Intl.message(
      'Brand New\nwithout Tag',
      name: 'brandNewWithoutTag',
      desc: '',
      args: [],
    );
  }

  /// `Like\nNew`
  String get likeNew {
    return Intl.message(
      'Like\nNew',
      name: 'likeNew',
      desc: '',
      args: [],
    );
  }

  /// `Gently\nUsed`
  String get gentlyUsed {
    return Intl.message(
      'Gently\nUsed',
      name: 'gentlyUsed',
      desc: '',
      args: [],
    );
  }

  /// `Well\nLoved`
  String get wellLoved {
    return Intl.message(
      'Well\nLoved',
      name: 'wellLoved',
      desc: '',
      args: [],
    );
  }

  /// `View Pending Upload`
  String get viewPendingUpload {
    return Intl.message(
      'View Pending Upload',
      name: 'viewPendingUpload',
      desc: '',
      args: [],
    );
  }

  /// `Rediscover My Style`
  String get personalStyle {
    return Intl.message(
      'Rediscover My Style',
      name: 'personalStyle',
      desc: '',
      args: [],
    );
  }

  /// `Start a New Chapter`
  String get lifeChange {
    return Intl.message(
      'Start a New Chapter',
      name: 'lifeChange',
      desc: '',
      args: [],
    );
  }

  /// `Create Memory Closet`
  String get parentMemories {
    return Intl.message(
      'Create Memory Closet',
      name: 'parentMemories',
      desc: '',
      args: [],
    );
  }

  /// `Why are you here today?`
  String get whyAreYouHereToday {
    return Intl.message(
      'Why are you here today?',
      name: 'whyAreYouHereToday',
      desc: '',
      args: [],
    );
  }

  /// `We’ll tailor your Closet Conscious experience based on what matters to you most right now.\n\nNot sure? Pick what feels right — you can always update it later.`
  String get tailorExperience {
    return Intl.message(
      'We’ll tailor your Closet Conscious experience based on what matters to you most right now.\n\nNot sure? Pick what feels right — you can always update it later.',
      name: 'tailorExperience',
      desc: '',
      args: [],
    );
  }

  /// `Give Full Access?`
  String get photoAccessDialogTitle {
    return Intl.message(
      'Give Full Access?',
      name: 'photoAccessDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `To see your entire photo library and avoid being asked again, grant full access in Settings.`
  String get photoAccessDialogContent {
    return Intl.message(
      'To see your entire photo library and avoid being asked again, grant full access in Settings.',
      name: 'photoAccessDialogContent',
      desc: '',
      args: [],
    );
  }

  /// `Upload your clothing into the closet`
  String get tutorialFreeUploadCameraUploadClothing {
    return Intl.message(
      'Upload your clothing into the closet',
      name: 'tutorialFreeUploadCameraUploadClothing',
      desc: '',
      args: [],
    );
  }

  /// `Declutter your items`
  String get tutorialFreeEditCameraDeclutterItems {
    return Intl.message(
      'Declutter your items',
      name: 'tutorialFreeEditCameraDeclutterItems',
      desc: '',
      args: [],
    );
  }

  /// `Process of creating outfits`
  String get tutorialFreeCreateOutfitCreateOutfitProcess {
    return Intl.message(
      'Process of creating outfits',
      name: 'tutorialFreeCreateOutfitCreateOutfitProcess',
      desc: '',
      args: [],
    );
  }

  /// `Review your daily outfit`
  String get tutorialFreeCreateOutfitReviewOutfit {
    return Intl.message(
      'Review your daily outfit',
      name: 'tutorialFreeCreateOutfitReviewOutfit',
      desc: '',
      args: [],
    );
  }

  /// `Not sure what to wear today?`
  String get tutorialFreeCreateOutfitOutfitSuggestion {
    return Intl.message(
      'Not sure what to wear today?',
      name: 'tutorialFreeCreateOutfitOutfitSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Find clothing in a huge closet`
  String get tutorialPaidFilterFindInCloset {
    return Intl.message(
      'Find clothing in a huge closet',
      name: 'tutorialPaidFilterFindInCloset',
      desc: '',
      args: [],
    );
  }

  /// `Sell unworn clothing`
  String get tutorialPaidFilterSellUnworn {
    return Intl.message(
      'Sell unworn clothing',
      name: 'tutorialPaidFilterSellUnworn',
      desc: '',
      args: [],
    );
  }

  /// `Don't lose track of filtering`
  String get tutorialPaidFilterTrackFiltering {
    return Intl.message(
      'Don\'t lose track of filtering',
      name: 'tutorialPaidFilterTrackFiltering',
      desc: '',
      args: [],
    );
  }

  /// `See all items in one glance`
  String get tutorialPaidCustomizeViewAllItems {
    return Intl.message(
      'See all items in one glance',
      name: 'tutorialPaidCustomizeViewAllItems',
      desc: '',
      args: [],
    );
  }

  /// `Customize your ordering`
  String get tutorialPaidCustomizeCustomizeOrder {
    return Intl.message(
      'Customize your ordering',
      name: 'tutorialPaidCustomizeCustomizeOrder',
      desc: '',
      args: [],
    );
  }

  /// `Create capsule closets`
  String get tutorialPaidMultiClosetCreateCapsule {
    return Intl.message(
      'Create capsule closets',
      name: 'tutorialPaidMultiClosetCreateCapsule',
      desc: '',
      args: [],
    );
  }

  /// `View items usable today`
  String get tutorialPaidMultiClosetViewUsableItems {
    return Intl.message(
      'View items usable today',
      name: 'tutorialPaidMultiClosetViewUsableItems',
      desc: '',
      args: [],
    );
  }

  /// `Create public closets for future sales`
  String get tutorialPaidMultiClosetCreatePublicClosets {
    return Intl.message(
      'Create public closets for future sales',
      name: 'tutorialPaidMultiClosetCreatePublicClosets',
      desc: '',
      args: [],
    );
  }

  /// `Delete excess closets`
  String get tutorialPaidMultiClosetDeleteClosets {
    return Intl.message(
      'Delete excess closets',
      name: 'tutorialPaidMultiClosetDeleteClosets',
      desc: '',
      args: [],
    );
  }

  /// `Swap items to another closet`
  String get tutorialPaidMultiClosetSwapClosets {
    return Intl.message(
      'Swap items to another closet',
      name: 'tutorialPaidMultiClosetSwapClosets',
      desc: '',
      args: [],
    );
  }

  /// `Track first experiences`
  String get tutorialPaidCalendarTrackFirstExperiences {
    return Intl.message(
      'Track first experiences',
      name: 'tutorialPaidCalendarTrackFirstExperiences',
      desc: '',
      args: [],
    );
  }

  /// `Easily create outfits for trip planning`
  String get tutorialPaidCalendarPlanTrips {
    return Intl.message(
      'Easily create outfits for trip planning',
      name: 'tutorialPaidCalendarPlanTrips',
      desc: '',
      args: [],
    );
  }

  /// `Know clothing cost per wear`
  String get tutorialPaidUsageAnalyticsCostPerWear {
    return Intl.message(
      'Know clothing cost per wear',
      name: 'tutorialPaidUsageAnalyticsCostPerWear',
      desc: '',
      args: [],
    );
  }

  /// `Figure out what to wear today`
  String get tutorialPaidUsageAnalyticsOutfitSuggestions {
    return Intl.message(
      'Figure out what to wear today',
      name: 'tutorialPaidUsageAnalyticsOutfitSuggestions',
      desc: '',
      args: [],
    );
  }

  /// `Get outfit inspiration for trips`
  String get tutorialPaidUsageAnalyticsInspirationForTrips {
    return Intl.message(
      'Get outfit inspiration for trips',
      name: 'tutorialPaidUsageAnalyticsInspirationForTrips',
      desc: '',
      args: [],
    );
  }

  /// `Sell unworn clothing`
  String get tutorialPaidUsageAnalyticsSellUnworn {
    return Intl.message(
      'Sell unworn clothing',
      name: 'tutorialPaidUsageAnalyticsSellUnworn',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong while saving your tutorial progress.`
  String get errorSavingTutorialProgress {
    return Intl.message(
      'Something went wrong while saving your tutorial progress.',
      name: 'errorSavingTutorialProgress',
      desc: '',
      args: [],
    );
  }

  /// `I'm ready`
  String get iAmReady {
    return Intl.message(
      'I\'m ready',
      name: 'iAmReady',
      desc: '',
      args: [],
    );
  }

  /// `Capture pieces, begin the story`
  String get tutorialFreeUploadCameraTitle {
    return Intl.message(
      'Capture pieces, begin the story',
      name: 'tutorialFreeUploadCameraTitle',
      desc: '',
      args: [],
    );
  }

  /// `Shape each piece into your narrative`
  String get tutorialFreeEditCameraTitle {
    return Intl.message(
      'Shape each piece into your narrative',
      name: 'tutorialFreeEditCameraTitle',
      desc: '',
      args: [],
    );
  }

  /// `Weave new looks from familiar threads`
  String get tutorialFreeCreateOutfitTitle {
    return Intl.message(
      'Weave new looks from familiar threads',
      name: 'tutorialFreeCreateOutfitTitle',
      desc: '',
      args: [],
    );
  }

  /// `Find what you need, when the moment calls`
  String get tutorialPaidFilterTitle {
    return Intl.message(
      'Find what you need, when the moment calls',
      name: 'tutorialPaidFilterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Arrange your closet, your way`
  String get tutorialPaidCustomizeTitle {
    return Intl.message(
      'Arrange your closet, your way',
      name: 'tutorialPaidCustomizeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Step into a new chapter, any time`
  String get tutorialPaidMultiClosetTitle {
    return Intl.message(
      'Step into a new chapter, any time',
      name: 'tutorialPaidMultiClosetTitle',
      desc: '',
      args: [],
    );
  }

  /// `Outfit stories, one day at a time`
  String get tutorialPaidCalendarTitle {
    return Intl.message(
      'Outfit stories, one day at a time',
      name: 'tutorialPaidCalendarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Trace your style, one day at a time`
  String get tutorialPaidUsageAnalyticsTitle {
    return Intl.message(
      'Trace your style, one day at a time',
      name: 'tutorialPaidUsageAnalyticsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Tutorials`
  String get tutorialHubTitle {
    return Intl.message(
      'Tutorials',
      name: 'tutorialHubTitle',
      desc: '',
      args: [],
    );
  }

  /// `Always Available Feature Tutorials`
  String get alwaysAvailableFeatures {
    return Intl.message(
      'Always Available Feature Tutorials',
      name: 'alwaysAvailableFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Premium Feature Tutorials`
  String get premiumFeatureTutorials {
    return Intl.message(
      'Premium Feature Tutorials',
      name: 'premiumFeatureTutorials',
      desc: '',
      args: [],
    );
  }

  /// `Scenario Tutorials`
  String get scenarioTutorials {
    return Intl.message(
      'Scenario Tutorials',
      name: 'scenarioTutorials',
      desc: '',
      args: [],
    );
  }

  /// `Remind Me Later`
  String get reminderDialogTitle {
    return Intl.message(
      'Remind Me Later',
      name: 'reminderDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Would you like me to remind you later to upload your closet?`
  String get reminderDialogContent {
    return Intl.message(
      'Would you like me to remind you later to upload your closet?',
      name: 'reminderDialogContent',
      desc: '',
      args: [],
    );
  }

  /// `Show More`
  String get showMore {
    return Intl.message(
      'Show More',
      name: 'showMore',
      desc: '',
      args: [],
    );
  }

  /// `Show Less`
  String get showLess {
    return Intl.message(
      'Show Less',
      name: 'showLess',
      desc: '',
      args: [],
    );
  }

  /// `Picking date & time…`
  String get pickingDateAndTime {
    return Intl.message(
      'Picking date & time…',
      name: 'pickingDateAndTime',
      desc: '',
      args: [],
    );
  }

  /// `Upload from Photo Library`
  String get tutorialFreePhotoLibraryTitle {
    return Intl.message(
      'Upload from Photo Library',
      name: 'tutorialFreePhotoLibraryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Closet Upload Tutorial`
  String get tutorialClosetUploadedTitle {
    return Intl.message(
      'Closet Upload Tutorial',
      name: 'tutorialClosetUploadedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Scenario Tutorial`
  String get tutorialScenarioTitle {
    return Intl.message(
      'Scenario Tutorial',
      name: 'tutorialScenarioTitle',
      desc: '',
      args: [],
    );
  }

  /// `You've worn every single item in your closet! You're mastering mindful fashion choices.`
  String get defaultAchievementAllClothesWornMessage {
    return Intl.message(
      'You\'ve worn every single item in your closet! You\'re mastering mindful fashion choices.',
      name: 'defaultAchievementAllClothesWornMessage',
      desc: '',
      args: [],
    );
  }

  /// `All Clothes, All You!`
  String get defaultAchievementAllClothesWornTitle {
    return Intl.message(
      'All Clothes, All You!',
      name: 'defaultAchievementAllClothesWornTitle',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations! You've uploaded all your items to your virtual closet. Now you can style like a pro!`
  String get defaultAchievementClosetUploadedMessage {
    return Intl.message(
      'Congratulations! You\'ve uploaded all your items to your virtual closet. Now you can style like a pro!',
      name: 'defaultAchievementClosetUploadedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Virtual Closet Complete!`
  String get defaultAchievementClosetUploadedTitle {
    return Intl.message(
      'Virtual Closet Complete!',
      name: 'defaultAchievementClosetUploadedTitle',
      desc: '',
      args: [],
    );
  }

  /// `You’ve gifted your first item! Your style is making someone else’s day brighter.`
  String get defaultAchievementFirstItemGiftedMessage {
    return Intl.message(
      'You’ve gifted your first item! Your style is making someone else’s day brighter.',
      name: 'defaultAchievementFirstItemGiftedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Generous Giver!`
  String get defaultAchievementFirstItemGiftedTitle {
    return Intl.message(
      'Generous Giver!',
      name: 'defaultAchievementFirstItemGiftedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your first item picture has been edited! Your closet is looking better than ever.`
  String get defaultAchievementFirstItemPicEditedMessage {
    return Intl.message(
      'Your first item picture has been edited! Your closet is looking better than ever.',
      name: 'defaultAchievementFirstItemPicEditedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Picture Perfect!`
  String get defaultAchievementFirstItemPicEditedTitle {
    return Intl.message(
      'Picture Perfect!',
      name: 'defaultAchievementFirstItemPicEditedTitle',
      desc: '',
      args: [],
    );
  }

  /// `You’ve sold your first item! Way to turn your closet into cash and make space for new looks.`
  String get defaultAchievementFirstItemSoldMessage {
    return Intl.message(
      'You’ve sold your first item! Way to turn your closet into cash and make space for new looks.',
      name: 'defaultAchievementFirstItemSoldMessage',
      desc: '',
      args: [],
    );
  }

  /// `Smart Seller!`
  String get defaultAchievementFirstItemSoldTitle {
    return Intl.message(
      'Smart Seller!',
      name: 'defaultAchievementFirstItemSoldTitle',
      desc: '',
      args: [],
    );
  }

  /// `You’ve swapped your first item! Your wardrobe just got a stylish and sustainable refresh.`
  String get defaultAchievementFirstItemSwapMessage {
    return Intl.message(
      'You’ve swapped your first item! Your wardrobe just got a stylish and sustainable refresh.',
      name: 'defaultAchievementFirstItemSwapMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sustainable Swapper!`
  String get defaultAchievementFirstItemSwapTitle {
    return Intl.message(
      'Sustainable Swapper!',
      name: 'defaultAchievementFirstItemSwapTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your first item is uploaded! Your virtual closet journey has begun!`
  String get defaultAchievementFirstItemUploadMessage {
    return Intl.message(
      'Your first item is uploaded! Your virtual closet journey has begun!',
      name: 'defaultAchievementFirstItemUploadMessage',
      desc: '',
      args: [],
    );
  }

  /// `Item Initiator!`
  String get defaultAchievementFirstItemUploadTitle {
    return Intl.message(
      'Item Initiator!',
      name: 'defaultAchievementFirstItemUploadTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your first outfit is ready! You're on your way to mastering your style.`
  String get defaultAchievementFirstOutfitCreatedMessage {
    return Intl.message(
      'Your first outfit is ready! You\'re on your way to mastering your style.',
      name: 'defaultAchievementFirstOutfitCreatedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Outfit Architect!`
  String get defaultAchievementFirstOutfitCreatedTitle {
    return Intl.message(
      'Outfit Architect!',
      name: 'defaultAchievementFirstOutfitCreatedTitle',
      desc: '',
      args: [],
    );
  }

  /// `You’ve taken your first OOTD! Show off your style and let your closet shine!`
  String get defaultAchievementFirstSelfieTakenMessage {
    return Intl.message(
      'You’ve taken your first OOTD! Show off your style and let your closet shine!',
      name: 'defaultAchievementFirstSelfieTakenMessage',
      desc: '',
      args: [],
    );
  }

  /// `OOTD Superstar!`
  String get defaultAchievementFirstSelfieTakenTitle {
    return Intl.message(
      'OOTD Superstar!',
      name: 'defaultAchievementFirstSelfieTakenTitle',
      desc: '',
      args: [],
    );
  }

  /// `1,215 days of intentional living! Your journey is inspiring others to follow in your footsteps.`
  String get defaultAchievementNoNewClothes1215Message {
    return Intl.message(
      '1,215 days of intentional living! Your journey is inspiring others to follow in your footsteps.',
      name: 'defaultAchievementNoNewClothes1215Message',
      desc: '',
      args: [],
    );
  }

  /// `Icon of Sustainability!`
  String get defaultAchievementNoNewClothes1215Title {
    return Intl.message(
      'Icon of Sustainability!',
      name: 'defaultAchievementNoNewClothes1215Title',
      desc: '',
      args: [],
    );
  }

  /// `1,575 days of embracing what you have. You're rewriting the rules of fashion!`
  String get defaultAchievementNoNewClothes1575Message {
    return Intl.message(
      '1,575 days of embracing what you have. You\'re rewriting the rules of fashion!',
      name: 'defaultAchievementNoNewClothes1575Message',
      desc: '',
      args: [],
    );
  }

  /// `Master of Minimalism!`
  String get defaultAchievementNoNewClothes1575Title {
    return Intl.message(
      'Master of Minimalism!',
      name: 'defaultAchievementNoNewClothes1575Title',
      desc: '',
      args: [],
    );
  }

  /// `1,980 days of dedication to mindful choices! You're a shining example of sustainable living and an inspiration to us all. ✨🌏`
  String get defaultAchievementNoNewClothes1980Message {
    return Intl.message(
      '1,980 days of dedication to mindful choices! You\'re a shining example of sustainable living and an inspiration to us all. ✨🌏',
      name: 'defaultAchievementNoNewClothes1980Message',
      desc: '',
      args: [],
    );
  }

  /// `Beacon of Sustainability!`
  String get defaultAchievementNoNewClothes1980Title {
    return Intl.message(
      'Beacon of Sustainability!',
      name: 'defaultAchievementNoNewClothes1980Title',
      desc: '',
      args: [],
    );
  }

  /// `225 days and counting! Your closet is thriving, and so is the planet. 🌍`
  String get defaultAchievementNoNewClothes225Message {
    return Intl.message(
      '225 days and counting! Your closet is thriving, and so is the planet. 🌍',
      name: 'defaultAchievementNoNewClothes225Message',
      desc: '',
      args: [],
    );
  }

  /// `Eco-Warrior in the Making!`
  String get defaultAchievementNoNewClothes225Title {
    return Intl.message(
      'Eco-Warrior in the Making!',
      name: 'defaultAchievementNoNewClothes225Title',
      desc: '',
      args: [],
    );
  }

  /// `405 days strong! Your commitment to conscious fashion is an inspiration.`
  String get defaultAchievementNoNewClothes405Message {
    return Intl.message(
      '405 days strong! Your commitment to conscious fashion is an inspiration.',
      name: 'defaultAchievementNoNewClothes405Message',
      desc: '',
      args: [],
    );
  }

  /// `Champion of Conscious Choices!`
  String get defaultAchievementNoNewClothes405Title {
    return Intl.message(
      'Champion of Conscious Choices!',
      name: 'defaultAchievementNoNewClothes405Title',
      desc: '',
      args: [],
    );
  }

  /// `630 days without new clothes—you're leading by example! Keep going!`
  String get defaultAchievementNoNewClothes630Message {
    return Intl.message(
      '630 days without new clothes—you\'re leading by example! Keep going!',
      name: 'defaultAchievementNoNewClothes630Message',
      desc: '',
      args: [],
    );
  }

  /// `Sustainability Leader!`
  String get defaultAchievementNoNewClothes630Title {
    return Intl.message(
      'Sustainability Leader!',
      name: 'defaultAchievementNoNewClothes630Title',
      desc: '',
      args: [],
    );
  }

  /// `900 days of conscious choices! You’re setting trends and making waves in sustainability!`
  String get defaultAchievementNoNewClothes900Message {
    return Intl.message(
      '900 days of conscious choices! You’re setting trends and making waves in sustainability!',
      name: 'defaultAchievementNoNewClothes900Message',
      desc: '',
      args: [],
    );
  }

  /// `Trailblazer of Change!`
  String get defaultAchievementNoNewClothes900Title {
    return Intl.message(
      'Trailblazer of Change!',
      name: 'defaultAchievementNoNewClothes900Title',
      desc: '',
      args: [],
    );
  }

  /// `You’ve hit 90 days without new clothes! Keep building those eco-friendly habits! 🌱`
  String get defaultAchievementNoNewClothes90Message {
    return Intl.message(
      'You’ve hit 90 days without new clothes! Keep building those eco-friendly habits! 🌱',
      name: 'defaultAchievementNoNewClothes90Message',
      desc: '',
      args: [],
    );
  }

  /// `Sustainable Start!`
  String get defaultAchievementNoNewClothes90Title {
    return Intl.message(
      'Sustainable Start!',
      name: 'defaultAchievementNoNewClothes90Title',
      desc: '',
      args: [],
    );
  }

  /// `The little things matter.\nCapture them now, find them later.`
  String get memoryTutorialFreeUploadCameraUploadClothing {
    return Intl.message(
      'The little things matter.\nCapture them now, find them later.',
      name: 'memoryTutorialFreeUploadCameraUploadClothing',
      desc: '',
      args: [],
    );
  }

  /// `You’ve saved the moments—now sort the memories.\nOne tap brings each piece into their story.`
  String get memoryTutorialFreePhotoLibraryUploadClothing {
    return Intl.message(
      'You’ve saved the moments—now sort the memories.\nOne tap brings each piece into their story.',
      name: 'memoryTutorialFreePhotoLibraryUploadClothing',
      desc: '',
      args: [],
    );
  }

  /// `They’re growing.\nSo are the stories behind what they wore.`
  String get memoryTutorialFreeEditCameraDeclutterItems {
    return Intl.message(
      'They’re growing.\nSo are the stories behind what they wore.',
      name: 'memoryTutorialFreeEditCameraDeclutterItems',
      desc: '',
      args: [],
    );
  }

  /// `One outfit. One day. One memory.\nSnap it. Note it. Feel it again tomorrow.`
  String get memoryTutorialFreeCreateOutfitProcess {
    return Intl.message(
      'One outfit. One day. One memory.\nSnap it. Note it. Feel it again tomorrow.',
      name: 'memoryTutorialFreeCreateOutfitProcess',
      desc: '',
      args: [],
    );
  }

  /// `Life moves fast.\nTheir closet keeps up.\nFind what you need—right when you need it.`
  String get memoryTutorialPaidFilterFindInCloset {
    return Intl.message(
      'Life moves fast.\nTheir closet keeps up.\nFind what you need—right when you need it.',
      name: 'memoryTutorialPaidFilterFindInCloset',
      desc: '',
      args: [],
    );
  }

  /// `Your closet, your way.\nZoom in. Sort by love.\nOne tap brings it all back.`
  String get memoryTutorialPaidCustomizeViewAllItems {
    return Intl.message(
      'Your closet, your way.\nZoom in. Sort by love.\nOne tap brings it all back.',
      name: 'memoryTutorialPaidCustomizeViewAllItems',
      desc: '',
      args: [],
    );
  }

  /// `Some closets hold the past.\nSome, the present.\nAll of them—pieces of your story.`
  String get memoryTutorialPaidMultiClosetCreateCapsule {
    return Intl.message(
      'Some closets hold the past.\nSome, the present.\nAll of them—pieces of your story.',
      name: 'memoryTutorialPaidMultiClosetCreateCapsule',
      desc: '',
      args: [],
    );
  }

  /// `What you wore.How it felt.\nIt’s all here—ready to remember, ready to reuse.`
  String get memoryTutorialPaidCalendarTrackFirstExperiences {
    return Intl.message(
      'What you wore.How it felt.\nIt’s all here—ready to remember, ready to reuse.',
      name: 'memoryTutorialPaidCalendarTrackFirstExperiences',
      desc: '',
      args: [],
    );
  }

  /// `They outgrew the clothes—\nbut not the moments you lived in them.\nSee what mattered. Feel it again.`
  String get memoryTutorialPaidUsageAnalyticsCostPerWear {
    return Intl.message(
      'They outgrew the clothes—\nbut not the moments you lived in them.\nSee what mattered. Feel it again.',
      name: 'memoryTutorialPaidUsageAnalyticsCostPerWear',
      desc: '',
      args: [],
    );
  }

  /// `Use what they have.\nBuild the streak.\nUnlock more—just by choosing less.`
  String get memoryTutorialClosetUploaded {
    return Intl.message(
      'Use what they have.\nBuild the streak.\nUnlock more—just by choosing less.',
      name: 'memoryTutorialClosetUploaded',
      desc: '',
      args: [],
    );
  }

  /// `You thought you’d remember it all.\nNow you can.\n\nTheir story lives on—one outfit at a time.`
  String get memoryScenarioTutorial {
    return Intl.message(
      'You thought you’d remember it all.\nNow you can.\n\nTheir story lives on—one outfit at a time.',
      name: 'memoryScenarioTutorial',
      desc: '',
      args: [],
    );
  }

  /// `Narrow your closet by name, item type to create your memory quickly.`
  String get memoryTrialFilter {
    return Intl.message(
      'Narrow your closet by name, item type to create your memory quickly.',
      name: 'memoryTrialFilter',
      desc: '',
      args: [],
    );
  }

  /// `Arrange your items like memory shelves—what mattered most stays visible.`
  String get memoryTrialCustomize {
    return Intl.message(
      'Arrange your items like memory shelves—what mattered most stays visible.',
      name: 'memoryTrialCustomize',
      desc: '',
      args: [],
    );
  }

  /// `Group life chapters into closets—each with a story of its own.`
  String get memoryTrialClosets {
    return Intl.message(
      'Group life chapters into closets—each with a story of its own.',
      name: 'memoryTrialClosets',
      desc: '',
      args: [],
    );
  }

  /// `Create outfits from pieces that carry your favorite memories.`
  String get memoryTrialOutfits {
    return Intl.message(
      'Create outfits from pieces that carry your favorite memories.',
      name: 'memoryTrialOutfits',
      desc: '',
      args: [],
    );
  }

  /// `Look back by date—see the outfits that shaped your seasons.`
  String get memoryTrialCalendar {
    return Intl.message(
      'Look back by date—see the outfits that shaped your seasons.',
      name: 'memoryTrialCalendar',
      desc: '',
      args: [],
    );
  }

  /// `See which items showed up in your story most—by use, by love, by time.`
  String get memoryTrialInsights {
    return Intl.message(
      'See which items showed up in your story most—by use, by love, by time.',
      name: 'memoryTrialInsights',
      desc: '',
      args: [],
    );
  }

  /// `You've worn all your pieces, each with its unique story.`
  String get memoryAchievementAllClothesWornMessage {
    return Intl.message(
      'You\'ve worn all your pieces, each with its unique story.',
      name: 'memoryAchievementAllClothesWornMessage',
      desc: '',
      args: [],
    );
  }

  /// `Every Memory Worn!`
  String get memoryAchievementAllClothesWornTitle {
    return Intl.message(
      'Every Memory Worn!',
      name: 'memoryAchievementAllClothesWornTitle',
      desc: '',
      args: [],
    );
  }

  /// `You’ve uploaded everything you own. Now every choice is intentional—your mindful journey begins.`
  String get memoryAchievementClosetUploadedMessage {
    return Intl.message(
      'You’ve uploaded everything you own. Now every choice is intentional—your mindful journey begins.',
      name: 'memoryAchievementClosetUploadedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Closet Counted!`
  String get memoryAchievementClosetUploadedTitle {
    return Intl.message(
      'Closet Counted!',
      name: 'memoryAchievementClosetUploadedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your gifted item carries memories forward, enriching someone else's story.`
  String get memoryAchievementFirstItemGiftedMessage {
    return Intl.message(
      'Your gifted item carries memories forward, enriching someone else\'s story.',
      name: 'memoryAchievementFirstItemGiftedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Memory Passed On!`
  String get memoryAchievementFirstItemGiftedTitle {
    return Intl.message(
      'Memory Passed On!',
      name: 'memoryAchievementFirstItemGiftedTitle',
      desc: '',
      args: [],
    );
  }

  /// `First edit complete—your memories clearer and brighter than ever.`
  String get memoryAchievementFirstItemPicEditedMessage {
    return Intl.message(
      'First edit complete—your memories clearer and brighter than ever.',
      name: 'memoryAchievementFirstItemPicEditedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Memory Enhanced!`
  String get memoryAchievementFirstItemPicEditedTitle {
    return Intl.message(
      'Memory Enhanced!',
      name: 'memoryAchievementFirstItemPicEditedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your item sold—letting go, but memories linger and live on.`
  String get memoryAchievementFirstItemSoldMessage {
    return Intl.message(
      'Your item sold—letting go, but memories linger and live on.',
      name: 'memoryAchievementFirstItemSoldMessage',
      desc: '',
      args: [],
    );
  }

  /// `Memory Shared!`
  String get memoryAchievementFirstItemSoldTitle {
    return Intl.message(
      'Memory Shared!',
      name: 'memoryAchievementFirstItemSoldTitle',
      desc: '',
      args: [],
    );
  }

  /// `First swap done—new memories await with your refreshed closet.`
  String get memoryAchievementFirstItemSwapMessage {
    return Intl.message(
      'First swap done—new memories await with your refreshed closet.',
      name: 'memoryAchievementFirstItemSwapMessage',
      desc: '',
      args: [],
    );
  }

  /// `Memory Refreshed!`
  String get memoryAchievementFirstItemSwapTitle {
    return Intl.message(
      'Memory Refreshed!',
      name: 'memoryAchievementFirstItemSwapTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your first memory item is safely stored—ready for future reminiscing.`
  String get memoryAchievementFirstItemUploadMessage {
    return Intl.message(
      'Your first memory item is safely stored—ready for future reminiscing.',
      name: 'memoryAchievementFirstItemUploadMessage',
      desc: '',
      args: [],
    );
  }

  /// `Memory Preserved!`
  String get memoryAchievementFirstItemUploadTitle {
    return Intl.message(
      'Memory Preserved!',
      name: 'memoryAchievementFirstItemUploadTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your first outfit saved—a moment you'll cherish forever.`
  String get memoryAchievementFirstOutfitCreatedMessage {
    return Intl.message(
      'Your first outfit saved—a moment you\'ll cherish forever.',
      name: 'memoryAchievementFirstOutfitCreatedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Milestone Marked!`
  String get memoryAchievementFirstOutfitCreatedTitle {
    return Intl.message(
      'Milestone Marked!',
      name: 'memoryAchievementFirstOutfitCreatedTitle',
      desc: '',
      args: [],
    );
  }

  /// `First OOTD taken—holding onto memories one picture at a time.`
  String get memoryAchievementFirstSelfieTakenMessage {
    return Intl.message(
      'First OOTD taken—holding onto memories one picture at a time.',
      name: 'memoryAchievementFirstSelfieTakenMessage',
      desc: '',
      args: [],
    );
  }

  /// `Moment Captured!`
  String get memoryAchievementFirstSelfieTakenTitle {
    return Intl.message(
      'Moment Captured!',
      name: 'memoryAchievementFirstSelfieTakenTitle',
      desc: '',
      args: [],
    );
  }

  /// `1,215 days preserving the stories held by each outfit. Your closet is a living scrapbook of memories.`
  String get memoryAchievementNoNewClothes1215Message {
    return Intl.message(
      '1,215 days preserving the stories held by each outfit. Your closet is a living scrapbook of memories.',
      name: 'memoryAchievementNoNewClothes1215Message',
      desc: '',
      args: [],
    );
  }

  /// `Guardian of Moments!`
  String get memoryAchievementNoNewClothes1215Title {
    return Intl.message(
      'Guardian of Moments!',
      name: 'memoryAchievementNoNewClothes1215Title',
      desc: '',
      args: [],
    );
  }

  /// `1,575 days of mindful living—your wardrobe is a gallery of life's most meaningful moments.`
  String get memoryAchievementNoNewClothes1575Message {
    return Intl.message(
      '1,575 days of mindful living—your wardrobe is a gallery of life\'s most meaningful moments.',
      name: 'memoryAchievementNoNewClothes1575Message',
      desc: '',
      args: [],
    );
  }

  /// `Memory Masterpiece!`
  String get memoryAchievementNoNewClothes1575Title {
    return Intl.message(
      'Memory Masterpiece!',
      name: 'memoryAchievementNoNewClothes1575Title',
      desc: '',
      args: [],
    );
  }

  /// `1,980 days of treasuring memories through clothes. Your closet narrates your beautiful, evolving story.`
  String get memoryAchievementNoNewClothes1980Message {
    return Intl.message(
      '1,980 days of treasuring memories through clothes. Your closet narrates your beautiful, evolving story.',
      name: 'memoryAchievementNoNewClothes1980Message',
      desc: '',
      args: [],
    );
  }

  /// `Legend of Legacy!`
  String get memoryAchievementNoNewClothes1980Title {
    return Intl.message(
      'Legend of Legacy!',
      name: 'memoryAchievementNoNewClothes1980Title',
      desc: '',
      args: [],
    );
  }

  /// `225 days honoring memories, one outfit at a time. Your wardrobe is full of moments worth remembering.`
  String get memoryAchievementNoNewClothes225Message {
    return Intl.message(
      '225 days honoring memories, one outfit at a time. Your wardrobe is full of moments worth remembering.',
      name: 'memoryAchievementNoNewClothes225Message',
      desc: '',
      args: [],
    );
  }

  /// `Keeper of Memories!`
  String get memoryAchievementNoNewClothes225Title {
    return Intl.message(
      'Keeper of Memories!',
      name: 'memoryAchievementNoNewClothes225Title',
      desc: '',
      args: [],
    );
  }

  /// `405 days living through your wardrobe—each piece a reminder of life's precious moments.`
  String get memoryAchievementNoNewClothes405Message {
    return Intl.message(
      '405 days living through your wardrobe—each piece a reminder of life\'s precious moments.',
      name: 'memoryAchievementNoNewClothes405Message',
      desc: '',
      args: [],
    );
  }

  /// `Story Collector!`
  String get memoryAchievementNoNewClothes405Title {
    return Intl.message(
      'Story Collector!',
      name: 'memoryAchievementNoNewClothes405Title',
      desc: '',
      args: [],
    );
  }

  /// `630 days weaving life's stories through your clothes—you're curating a beautiful narrative.`
  String get memoryAchievementNoNewClothes630Message {
    return Intl.message(
      '630 days weaving life\'s stories through your clothes—you\'re curating a beautiful narrative.',
      name: 'memoryAchievementNoNewClothes630Message',
      desc: '',
      args: [],
    );
  }

  /// `Memory Maestro!`
  String get memoryAchievementNoNewClothes630Title {
    return Intl.message(
      'Memory Maestro!',
      name: 'memoryAchievementNoNewClothes630Title',
      desc: '',
      args: [],
    );
  }

  /// `900 days celebrating your life's journey through clothes. Every outfit tells a cherished story.`
  String get memoryAchievementNoNewClothes900Message {
    return Intl.message(
      '900 days celebrating your life\'s journey through clothes. Every outfit tells a cherished story.',
      name: 'memoryAchievementNoNewClothes900Message',
      desc: '',
      args: [],
    );
  }

  /// `Historian of the Heart!`
  String get memoryAchievementNoNewClothes900Title {
    return Intl.message(
      'Historian of the Heart!',
      name: 'memoryAchievementNoNewClothes900Title',
      desc: '',
      args: [],
    );
  }

  /// `90 days cherishing your wardrobe memories. Every piece worn carries a precious story.`
  String get memoryAchievementNoNewClothes90Message {
    return Intl.message(
      '90 days cherishing your wardrobe memories. Every piece worn carries a precious story.',
      name: 'memoryAchievementNoNewClothes90Message',
      desc: '',
      args: [],
    );
  }

  /// `90 Days of Moments!`
  String get memoryAchievementNoNewClothes90Title {
    return Intl.message(
      '90 Days of Moments!',
      name: 'memoryAchievementNoNewClothes90Title',
      desc: '',
      args: [],
    );
  }

  /// `Start identifying your personal style by uploading pieces you already wear. Each piece tells a story about your taste.`
  String get personalStyleTutorialFreeUploadCameraUploadClothing {
    return Intl.message(
      'Start identifying your personal style by uploading pieces you already wear. Each piece tells a story about your taste.',
      name: 'personalStyleTutorialFreeUploadCameraUploadClothing',
      desc: '',
      args: [],
    );
  }

  /// `Upload up to 5 items at once to quickly surface what reflects your style.`
  String get personalStyleTutorialFreePhotoLibraryUploadClothing {
    return Intl.message(
      'Upload up to 5 items at once to quickly surface what reflects your style.',
      name: 'personalStyleTutorialFreePhotoLibraryUploadClothing',
      desc: '',
      args: [],
    );
  }

  /// `Remove what doesn’t align with your evolving style. It’s not just about less—it’s about the *right* items.`
  String get personalStyleTutorialFreeEditCameraDeclutterItems {
    return Intl.message(
      'Remove what doesn’t align with your evolving style. It’s not just about less—it’s about the *right* items.',
      name: 'personalStyleTutorialFreeEditCameraDeclutterItems',
      desc: '',
      args: [],
    );
  }

  /// `Put your pieces together to see what looks like ‘you’. We’re building your signature style.`
  String get personalStyleTutorialFreeCreateOutfitProcess {
    return Intl.message(
      'Put your pieces together to see what looks like ‘you’. We’re building your signature style.',
      name: 'personalStyleTutorialFreeCreateOutfitProcess',
      desc: '',
      args: [],
    );
  }

  /// `Find pieces that match your vibe today. Use filters to spot hidden gems.`
  String get personalStyleTutorialPaidFilterFindInCloset {
    return Intl.message(
      'Find pieces that match your vibe today. Use filters to spot hidden gems.',
      name: 'personalStyleTutorialPaidFilterFindInCloset',
      desc: '',
      args: [],
    );
  }

  /// `Visualize your wardrobe in different ways to surface forgotten favorites.`
  String get personalStyleTutorialPaidCustomizeViewAllItems {
    return Intl.message(
      'Visualize your wardrobe in different ways to surface forgotten favorites.',
      name: 'personalStyleTutorialPaidCustomizeViewAllItems',
      desc: '',
      args: [],
    );
  }

  /// `Create style capsules for different parts of your identity—work, weekend, or wild.`
  String get personalStyleTutorialPaidMultiClosetCreateCapsule {
    return Intl.message(
      'Create style capsules for different parts of your identity—work, weekend, or wild.',
      name: 'personalStyleTutorialPaidMultiClosetCreateCapsule',
      desc: '',
      args: [],
    );
  }

  /// `Track your outfits to discover which ones feel most like ‘you’.`
  String get personalStyleTutorialPaidCalendarTrackFirstExperiences {
    return Intl.message(
      'Track your outfits to discover which ones feel most like ‘you’.',
      name: 'personalStyleTutorialPaidCalendarTrackFirstExperiences',
      desc: '',
      args: [],
    );
  }

  /// `See what you're actually wearing—your style speaks through repetition.`
  String get personalStyleTutorialPaidUsageAnalyticsCostPerWear {
    return Intl.message(
      'See what you\'re actually wearing—your style speaks through repetition.',
      name: 'personalStyleTutorialPaidUsageAnalyticsCostPerWear',
      desc: '',
      args: [],
    );
  }

  /// `Track your streaks and unlock features—just by using what you already own.`
  String get personalStyleTutorialClosetUploaded {
    return Intl.message(
      'Track your streaks and unlock features—just by using what you already own.',
      name: 'personalStyleTutorialClosetUploaded',
      desc: '',
      args: [],
    );
  }

  /// `You’re not starting from scratch. Your closet already has clues. Let’s figure out your personal style.`
  String get personalStyleScenarioTutorial {
    return Intl.message(
      'You’re not starting from scratch. Your closet already has clues. Let’s figure out your personal style.',
      name: 'personalStyleScenarioTutorial',
      desc: '',
      args: [],
    );
  }

  /// `Narrow your closet by name, item type to define your unique look.`
  String get personalStyleTrialFilter {
    return Intl.message(
      'Narrow your closet by name, item type to define your unique look.',
      name: 'personalStyleTrialFilter',
      desc: '',
      args: [],
    );
  }

  /// `Reorganize your layout to reflect what feels like you right now.`
  String get personalStyleTrialCustomize {
    return Intl.message(
      'Reorganize your layout to reflect what feels like you right now.',
      name: 'personalStyleTrialCustomize',
      desc: '',
      args: [],
    );
  }

  /// `Make themed closets that mirror your personal aesthetic.`
  String get personalStyleTrialClosets {
    return Intl.message(
      'Make themed closets that mirror your personal aesthetic.',
      name: 'personalStyleTrialClosets',
      desc: '',
      args: [],
    );
  }

  /// `Mix and match across days to discover your evolving style.`
  String get personalStyleTrialOutfits {
    return Intl.message(
      'Mix and match across days to discover your evolving style.',
      name: 'personalStyleTrialOutfits',
      desc: '',
      args: [],
    );
  }

  /// `Watch your style change over time, one day at a time.`
  String get personalStyleTrialCalendar {
    return Intl.message(
      'Watch your style change over time, one day at a time.',
      name: 'personalStyleTrialCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Reveal your most-used items, favorite outfits, and style patterns.`
  String get personalStyleTrialInsights {
    return Intl.message(
      'Reveal your most-used items, favorite outfits, and style patterns.',
      name: 'personalStyleTrialInsights',
      desc: '',
      args: [],
    );
  }

  /// `You've confidently worn every piece you own! Keep embracing your personal style.`
  String get personalStyleAchievementAllClothesWornMessage {
    return Intl.message(
      'You\'ve confidently worn every piece you own! Keep embracing your personal style.',
      name: 'personalStyleAchievementAllClothesWornMessage',
      desc: '',
      args: [],
    );
  }

  /// `Fully You!`
  String get personalStyleAchievementAllClothesWornTitle {
    return Intl.message(
      'Fully You!',
      name: 'personalStyleAchievementAllClothesWornTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your closet upload is complete. Confidence awaits in every combination.`
  String get personalStyleAchievementClosetUploadedMessage {
    return Intl.message(
      'Your closet upload is complete. Confidence awaits in every combination.',
      name: 'personalStyleAchievementClosetUploadedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Your Closet, Curated!`
  String get personalStyleAchievementClosetUploadedTitle {
    return Intl.message(
      'Your Closet, Curated!',
      name: 'personalStyleAchievementClosetUploadedTitle',
      desc: '',
      args: [],
    );
  }

  /// `You've passed along a piece of your style. Confidence looks good on both of you!`
  String get personalStyleAchievementFirstItemGiftedMessage {
    return Intl.message(
      'You\'ve passed along a piece of your style. Confidence looks good on both of you!',
      name: 'personalStyleAchievementFirstItemGiftedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Style Shared!`
  String get personalStyleAchievementFirstItemGiftedTitle {
    return Intl.message(
      'Style Shared!',
      name: 'personalStyleAchievementFirstItemGiftedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your item's picture is updated—your closet matches your confidence.`
  String get personalStyleAchievementFirstItemPicEditedMessage {
    return Intl.message(
      'Your item\'s picture is updated—your closet matches your confidence.',
      name: 'personalStyleAchievementFirstItemPicEditedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Styled to Perfection!`
  String get personalStyleAchievementFirstItemPicEditedTitle {
    return Intl.message(
      'Styled to Perfection!',
      name: 'personalStyleAchievementFirstItemPicEditedTitle',
      desc: '',
      args: [],
    );
  }

  /// `You’ve sold your first item, refining your closet to what truly feels good.`
  String get personalStyleAchievementFirstItemSoldMessage {
    return Intl.message(
      'You’ve sold your first item, refining your closet to what truly feels good.',
      name: 'personalStyleAchievementFirstItemSoldMessage',
      desc: '',
      args: [],
    );
  }

  /// `Curator of Confidence!`
  String get personalStyleAchievementFirstItemSoldTitle {
    return Intl.message(
      'Curator of Confidence!',
      name: 'personalStyleAchievementFirstItemSoldTitle',
      desc: '',
      args: [],
    );
  }

  /// `You’ve swapped your first piece. Keep discovering what makes you feel best.`
  String get personalStyleAchievementFirstItemSwapMessage {
    return Intl.message(
      'You’ve swapped your first piece. Keep discovering what makes you feel best.',
      name: 'personalStyleAchievementFirstItemSwapMessage',
      desc: '',
      args: [],
    );
  }

  /// `Confidence Exchange!`
  String get personalStyleAchievementFirstItemSwapTitle {
    return Intl.message(
      'Confidence Exchange!',
      name: 'personalStyleAchievementFirstItemSwapTitle',
      desc: '',
      args: [],
    );
  }

  /// `You've uploaded your first item. Let's discover the styles that feel uniquely you.`
  String get personalStyleAchievementFirstItemUploadMessage {
    return Intl.message(
      'You\'ve uploaded your first item. Let\'s discover the styles that feel uniquely you.',
      name: 'personalStyleAchievementFirstItemUploadMessage',
      desc: '',
      args: [],
    );
  }

  /// `Confidence Unlocked!`
  String get personalStyleAchievementFirstItemUploadTitle {
    return Intl.message(
      'Confidence Unlocked!',
      name: 'personalStyleAchievementFirstItemUploadTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your first outfit is crafted. Revisit this look to feel great anytime.`
  String get personalStyleAchievementFirstOutfitCreatedMessage {
    return Intl.message(
      'Your first outfit is crafted. Revisit this look to feel great anytime.',
      name: 'personalStyleAchievementFirstOutfitCreatedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Signature Look Set!`
  String get personalStyleAchievementFirstOutfitCreatedTitle {
    return Intl.message(
      'Signature Look Set!',
      name: 'personalStyleAchievementFirstOutfitCreatedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your first OOTD captured! Celebrate your style journey.`
  String get personalStyleAchievementFirstSelfieTakenMessage {
    return Intl.message(
      'Your first OOTD captured! Celebrate your style journey.',
      name: 'personalStyleAchievementFirstSelfieTakenMessage',
      desc: '',
      args: [],
    );
  }

  /// `Own Your Style!`
  String get personalStyleAchievementFirstSelfieTakenTitle {
    return Intl.message(
      'Own Your Style!',
      name: 'personalStyleAchievementFirstSelfieTakenTitle',
      desc: '',
      args: [],
    );
  }

  /// `1,215 days proving true style is timeless! You're a role model of authentic self-expression.`
  String get personalStyleAchievementNoNewClothes1215Message {
    return Intl.message(
      '1,215 days proving true style is timeless! You\'re a role model of authentic self-expression.',
      name: 'personalStyleAchievementNoNewClothes1215Message',
      desc: '',
      args: [],
    );
  }

  /// `Legendary Style!`
  String get personalStyleAchievementNoNewClothes1215Title {
    return Intl.message(
      'Legendary Style!',
      name: 'personalStyleAchievementNoNewClothes1215Title',
      desc: '',
      args: [],
    );
  }

  /// `1,575 days curating a closet of confidence—your style speaks volumes without saying a word.`
  String get personalStyleAchievementNoNewClothes1575Message {
    return Intl.message(
      '1,575 days curating a closet of confidence—your style speaks volumes without saying a word.',
      name: 'personalStyleAchievementNoNewClothes1575Message',
      desc: '',
      args: [],
    );
  }

  /// `Architect of Authenticity!`
  String get personalStyleAchievementNoNewClothes1575Title {
    return Intl.message(
      'Architect of Authenticity!',
      name: 'personalStyleAchievementNoNewClothes1575Title',
      desc: '',
      args: [],
    );
  }

  /// `1,980 days embodying your unique identity through fashion. You're redefining what it means to dress confidently.`
  String get personalStyleAchievementNoNewClothes1980Message {
    return Intl.message(
      '1,980 days embodying your unique identity through fashion. You\'re redefining what it means to dress confidently.',
      name: 'personalStyleAchievementNoNewClothes1980Message',
      desc: '',
      args: [],
    );
  }

  /// `Pinnacle of Personal Style!`
  String get personalStyleAchievementNoNewClothes1980Title {
    return Intl.message(
      'Pinnacle of Personal Style!',
      name: 'personalStyleAchievementNoNewClothes1980Title',
      desc: '',
      args: [],
    );
  }

  /// `225 days of rediscovering your wardrobe! You're defining confidence on your own terms.`
  String get personalStyleAchievementNoNewClothes225Message {
    return Intl.message(
      '225 days of rediscovering your wardrobe! You\'re defining confidence on your own terms.',
      name: 'personalStyleAchievementNoNewClothes225Message',
      desc: '',
      args: [],
    );
  }

  /// `Style Setter!`
  String get personalStyleAchievementNoNewClothes225Title {
    return Intl.message(
      'Style Setter!',
      name: 'personalStyleAchievementNoNewClothes225Title',
      desc: '',
      args: [],
    );
  }

  /// `405 days mastering the art of personal style—your closet reflects your true self beautifully.`
  String get personalStyleAchievementNoNewClothes405Message {
    return Intl.message(
      '405 days mastering the art of personal style—your closet reflects your true self beautifully.',
      name: 'personalStyleAchievementNoNewClothes405Message',
      desc: '',
      args: [],
    );
  }

  /// `Wardrobe Whisperer!`
  String get personalStyleAchievementNoNewClothes405Title {
    return Intl.message(
      'Wardrobe Whisperer!',
      name: 'personalStyleAchievementNoNewClothes405Title',
      desc: '',
      args: [],
    );
  }

  /// `630 days confidently dressing from your own closet—you're inspiring others with your unique style.`
  String get personalStyleAchievementNoNewClothes630Message {
    return Intl.message(
      '630 days confidently dressing from your own closet—you\'re inspiring others with your unique style.',
      name: 'personalStyleAchievementNoNewClothes630Message',
      desc: '',
      args: [],
    );
  }

  /// `Confidence Creator!`
  String get personalStyleAchievementNoNewClothes630Title {
    return Intl.message(
      'Confidence Creator!',
      name: 'personalStyleAchievementNoNewClothes630Title',
      desc: '',
      args: [],
    );
  }

  /// `900 days of personal style mastery—your confidence is contagious and transformative!`
  String get personalStyleAchievementNoNewClothes900Message {
    return Intl.message(
      '900 days of personal style mastery—your confidence is contagious and transformative!',
      name: 'personalStyleAchievementNoNewClothes900Message',
      desc: '',
      args: [],
    );
  }

  /// `Style Icon!`
  String get personalStyleAchievementNoNewClothes900Title {
    return Intl.message(
      'Style Icon!',
      name: 'personalStyleAchievementNoNewClothes900Title',
      desc: '',
      args: [],
    );
  }

  /// `You've styled yourself confidently for 90 days using what you own—your personal style is thriving!`
  String get personalStyleAchievementNoNewClothes90Message {
    return Intl.message(
      'You\'ve styled yourself confidently for 90 days using what you own—your personal style is thriving!',
      name: 'personalStyleAchievementNoNewClothes90Message',
      desc: '',
      args: [],
    );
  }

  /// `90 Days Confident!`
  String get personalStyleAchievementNoNewClothes90Title {
    return Intl.message(
      '90 Days Confident!',
      name: 'personalStyleAchievementNoNewClothes90Title',
      desc: '',
      args: [],
    );
  }

  /// `Start fresh by uploading what’s still with you. Your style can shift—and so can you.`
  String get lifeChangeTutorialFreeUploadCameraUploadClothing {
    return Intl.message(
      'Start fresh by uploading what’s still with you. Your style can shift—and so can you.',
      name: 'lifeChangeTutorialFreeUploadCameraUploadClothing',
      desc: '',
      args: [],
    );
  }

  /// `Quickly upload what you’ve worn recently to reflect your current reality.`
  String get lifeChangeTutorialFreePhotoLibraryUploadClothing {
    return Intl.message(
      'Quickly upload what you’ve worn recently to reflect your current reality.',
      name: 'lifeChangeTutorialFreePhotoLibraryUploadClothing',
      desc: '',
      args: [],
    );
  }

  /// `Let go of what no longer fits your life. Keep what supports who you are now.`
  String get lifeChangeTutorialFreeEditCameraDeclutterItems {
    return Intl.message(
      'Let go of what no longer fits your life. Keep what supports who you are now.',
      name: 'lifeChangeTutorialFreeEditCameraDeclutterItems',
      desc: '',
      args: [],
    );
  }

  /// `Try on combinations that meet you where you are today. Feel grounded in your choices.`
  String get lifeChangeTutorialFreeCreateOutfitProcess {
    return Intl.message(
      'Try on combinations that meet you where you are today. Feel grounded in your choices.',
      name: 'lifeChangeTutorialFreeCreateOutfitProcess',
      desc: '',
      args: [],
    );
  }

  /// `Filter your wardrobe to find what works for this season of your life.`
  String get lifeChangeTutorialPaidFilterFindInCloset {
    return Intl.message(
      'Filter your wardrobe to find what works for this season of your life.',
      name: 'lifeChangeTutorialPaidFilterFindInCloset',
      desc: '',
      args: [],
    );
  }

  /// `See your wardrobe in a new light. Sometimes a new view brings clarity.`
  String get lifeChangeTutorialPaidCustomizeViewAllItems {
    return Intl.message(
      'See your wardrobe in a new light. Sometimes a new view brings clarity.',
      name: 'lifeChangeTutorialPaidCustomizeViewAllItems',
      desc: '',
      args: [],
    );
  }

  /// `Create closets that fit different aspects of your life—work, home, change, or celebration.`
  String get lifeChangeTutorialPaidMultiClosetCreateCapsule {
    return Intl.message(
      'Create closets that fit different aspects of your life—work, home, change, or celebration.',
      name: 'lifeChangeTutorialPaidMultiClosetCreateCapsule',
      desc: '',
      args: [],
    );
  }

  /// `Track outfits during new beginnings. These memories matter.`
  String get lifeChangeTutorialPaidCalendarTrackFirstExperiences {
    return Intl.message(
      'Track outfits during new beginnings. These memories matter.',
      name: 'lifeChangeTutorialPaidCalendarTrackFirstExperiences',
      desc: '',
      args: [],
    );
  }

  /// `See what you’re reaching for now. It’s okay if your go-tos have changed.`
  String get lifeChangeTutorialPaidUsageAnalyticsCostPerWear {
    return Intl.message(
      'See what you’re reaching for now. It’s okay if your go-tos have changed.',
      name: 'lifeChangeTutorialPaidUsageAnalyticsCostPerWear',
      desc: '',
      args: [],
    );
  }

  /// `This is your reset. Use what you already have to adapt, feel at home, and move forward.`
  String get lifeChangeTutorialClosetUploaded {
    return Intl.message(
      'This is your reset. Use what you already have to adapt, feel at home, and move forward.',
      name: 'lifeChangeTutorialClosetUploaded',
      desc: '',
      args: [],
    );
  }

  /// `Big changes affect how you dress and feel. Let’s shape a wardrobe that supports where you are now.`
  String get lifeChangeScenarioTutorial {
    return Intl.message(
      'Big changes affect how you dress and feel. Let’s shape a wardrobe that supports where you are now.',
      name: 'lifeChangeScenarioTutorial',
      desc: '',
      args: [],
    );
  }

  /// `Quickly find what suits your new routines, roles, and realities.`
  String get lifeChangeTrialFilter {
    return Intl.message(
      'Quickly find what suits your new routines, roles, and realities.',
      name: 'lifeChangeTrialFilter',
      desc: '',
      args: [],
    );
  }

  /// `Update your closet layout to fit what matters today.`
  String get lifeChangeTrialCustomize {
    return Intl.message(
      'Update your closet layout to fit what matters today.',
      name: 'lifeChangeTrialCustomize',
      desc: '',
      args: [],
    );
  }

  /// `Create closets for transitions—travel, work, motherhood, or pause.`
  String get lifeChangeTrialClosets {
    return Intl.message(
      'Create closets for transitions—travel, work, motherhood, or pause.',
      name: 'lifeChangeTrialClosets',
      desc: '',
      args: [],
    );
  }

  /// `Build outfits that support your day-to-day changes.`
  String get lifeChangeTrialOutfits {
    return Intl.message(
      'Build outfits that support your day-to-day changes.',
      name: 'lifeChangeTrialOutfits',
      desc: '',
      args: [],
    );
  }

  /// `Track your outfits during life shifts. See what worked and when.`
  String get lifeChangeTrialCalendar {
    return Intl.message(
      'Track your outfits during life shifts. See what worked and when.',
      name: 'lifeChangeTrialCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Understand what truly served you during change—by use and by season.`
  String get lifeChangeTrialInsights {
    return Intl.message(
      'Understand what truly served you during change—by use and by season.',
      name: 'lifeChangeTrialInsights',
      desc: '',
      args: [],
    );
  }

  /// `Every item worn—embracing your evolving identity wholeheartedly.`
  String get lifeChangeAchievementAllClothesWornMessage {
    return Intl.message(
      'Every item worn—embracing your evolving identity wholeheartedly.',
      name: 'lifeChangeAchievementAllClothesWornMessage',
      desc: '',
      args: [],
    );
  }

  /// `Fully Transformed!`
  String get lifeChangeAchievementAllClothesWornTitle {
    return Intl.message(
      'Fully Transformed!',
      name: 'lifeChangeAchievementAllClothesWornTitle',
      desc: '',
      args: [],
    );
  }

  /// `Closet uploaded—ready to support this exciting new life phase.`
  String get lifeChangeAchievementClosetUploadedMessage {
    return Intl.message(
      'Closet uploaded—ready to support this exciting new life phase.',
      name: 'lifeChangeAchievementClosetUploadedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Life Updated!`
  String get lifeChangeAchievementClosetUploadedTitle {
    return Intl.message(
      'Life Updated!',
      name: 'lifeChangeAchievementClosetUploadedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Gifted your first item—clearing space for the new you.`
  String get lifeChangeAchievementFirstItemGiftedMessage {
    return Intl.message(
      'Gifted your first item—clearing space for the new you.',
      name: 'lifeChangeAchievementFirstItemGiftedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Forward Focused!`
  String get lifeChangeAchievementFirstItemGiftedTitle {
    return Intl.message(
      'Forward Focused!',
      name: 'lifeChangeAchievementFirstItemGiftedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Edited your first item's picture—reflecting your current life beautifully.`
  String get lifeChangeAchievementFirstItemPicEditedMessage {
    return Intl.message(
      'Edited your first item\'s picture—reflecting your current life beautifully.',
      name: 'lifeChangeAchievementFirstItemPicEditedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Ready for Renewal!`
  String get lifeChangeAchievementFirstItemPicEditedTitle {
    return Intl.message(
      'Ready for Renewal!',
      name: 'lifeChangeAchievementFirstItemPicEditedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sold your first item, making room for what truly suits you now.`
  String get lifeChangeAchievementFirstItemSoldMessage {
    return Intl.message(
      'Sold your first item, making room for what truly suits you now.',
      name: 'lifeChangeAchievementFirstItemSoldMessage',
      desc: '',
      args: [],
    );
  }

  /// `Old to New!`
  String get lifeChangeAchievementFirstItemSoldTitle {
    return Intl.message(
      'Old to New!',
      name: 'lifeChangeAchievementFirstItemSoldTitle',
      desc: '',
      args: [],
    );
  }

  /// `Swapped your first item—your wardrobe matches your life's shift.`
  String get lifeChangeAchievementFirstItemSwapMessage {
    return Intl.message(
      'Swapped your first item—your wardrobe matches your life\'s shift.',
      name: 'lifeChangeAchievementFirstItemSwapMessage',
      desc: '',
      args: [],
    );
  }

  /// `Freshly Swapped!`
  String get lifeChangeAchievementFirstItemSwapTitle {
    return Intl.message(
      'Freshly Swapped!',
      name: 'lifeChangeAchievementFirstItemSwapTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your first item uploaded, symbolizing a fresh start in your journey.`
  String get lifeChangeAchievementFirstItemUploadMessage {
    return Intl.message(
      'Your first item uploaded, symbolizing a fresh start in your journey.',
      name: 'lifeChangeAchievementFirstItemUploadMessage',
      desc: '',
      args: [],
    );
  }

  /// `New Chapter Begins!`
  String get lifeChangeAchievementFirstItemUploadTitle {
    return Intl.message(
      'New Chapter Begins!',
      name: 'lifeChangeAchievementFirstItemUploadTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your first outfit recorded—perfect for embracing your new phase.`
  String get lifeChangeAchievementFirstOutfitCreatedMessage {
    return Intl.message(
      'Your first outfit recorded—perfect for embracing your new phase.',
      name: 'lifeChangeAchievementFirstOutfitCreatedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Transition Tracked!`
  String get lifeChangeAchievementFirstOutfitCreatedTitle {
    return Intl.message(
      'Transition Tracked!',
      name: 'lifeChangeAchievementFirstOutfitCreatedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your first OOTD marks this moment—reflecting your evolving story.`
  String get lifeChangeAchievementFirstSelfieTakenMessage {
    return Intl.message(
      'Your first OOTD marks this moment—reflecting your evolving story.',
      name: 'lifeChangeAchievementFirstSelfieTakenMessage',
      desc: '',
      args: [],
    );
  }

  /// `Change Documented!`
  String get lifeChangeAchievementFirstSelfieTakenTitle {
    return Intl.message(
      'Change Documented!',
      name: 'lifeChangeAchievementFirstSelfieTakenTitle',
      desc: '',
      args: [],
    );
  }

  /// `1,215 days crafting your wardrobe to fit life's transformations. Your adaptability inspires!`
  String get lifeChangeAchievementNoNewClothes1215Message {
    return Intl.message(
      '1,215 days crafting your wardrobe to fit life\'s transformations. Your adaptability inspires!',
      name: 'lifeChangeAchievementNoNewClothes1215Message',
      desc: '',
      args: [],
    );
  }

  /// `Architect of Change!`
  String get lifeChangeAchievementNoNewClothes1215Title {
    return Intl.message(
      'Architect of Change!',
      name: 'lifeChangeAchievementNoNewClothes1215Title',
      desc: '',
      args: [],
    );
  }

  /// `1,575 days gracefully navigating life's shifts. Your wardrobe reflects wisdom and growth.`
  String get lifeChangeAchievementNoNewClothes1575Message {
    return Intl.message(
      '1,575 days gracefully navigating life\'s shifts. Your wardrobe reflects wisdom and growth.',
      name: 'lifeChangeAchievementNoNewClothes1575Message',
      desc: '',
      args: [],
    );
  }

  /// `Seasoned Transformer!`
  String get lifeChangeAchievementNoNewClothes1575Title {
    return Intl.message(
      'Seasoned Transformer!',
      name: 'lifeChangeAchievementNoNewClothes1575Title',
      desc: '',
      args: [],
    );
  }

  /// `1,980 days redefining your style through life's changes—your story and wardrobe are beautifully aligned.`
  String get lifeChangeAchievementNoNewClothes1980Message {
    return Intl.message(
      '1,980 days redefining your style through life\'s changes—your story and wardrobe are beautifully aligned.',
      name: 'lifeChangeAchievementNoNewClothes1980Message',
      desc: '',
      args: [],
    );
  }

  /// `Master of Life's Chapters!`
  String get lifeChangeAchievementNoNewClothes1980Title {
    return Intl.message(
      'Master of Life\'s Chapters!',
      name: 'lifeChangeAchievementNoNewClothes1980Title',
      desc: '',
      args: [],
    );
  }

  /// `225 days of intentional transformation—your closet is evolving with your life.`
  String get lifeChangeAchievementNoNewClothes225Message {
    return Intl.message(
      '225 days of intentional transformation—your closet is evolving with your life.',
      name: 'lifeChangeAchievementNoNewClothes225Message',
      desc: '',
      args: [],
    );
  }

  /// `Change Champion!`
  String get lifeChangeAchievementNoNewClothes225Title {
    return Intl.message(
      'Change Champion!',
      name: 'lifeChangeAchievementNoNewClothes225Title',
      desc: '',
      args: [],
    );
  }

  /// `405 days navigating life's changes stylishly—you're gracefully moving forward, wardrobe and all.`
  String get lifeChangeAchievementNoNewClothes405Message {
    return Intl.message(
      '405 days navigating life\'s changes stylishly—you\'re gracefully moving forward, wardrobe and all.',
      name: 'lifeChangeAchievementNoNewClothes405Message',
      desc: '',
      args: [],
    );
  }

  /// `Adapting with Style!`
  String get lifeChangeAchievementNoNewClothes405Title {
    return Intl.message(
      'Adapting with Style!',
      name: 'lifeChangeAchievementNoNewClothes405Title',
      desc: '',
      args: [],
    );
  }

  /// `630 days of aligning your style with your life's transitions—you're thriving in every chapter.`
  String get lifeChangeAchievementNoNewClothes630Message {
    return Intl.message(
      '630 days of aligning your style with your life\'s transitions—you\'re thriving in every chapter.',
      name: 'lifeChangeAchievementNoNewClothes630Message',
      desc: '',
      args: [],
    );
  }

  /// `Transformation Trailblazer!`
  String get lifeChangeAchievementNoNewClothes630Title {
    return Intl.message(
      'Transformation Trailblazer!',
      name: 'lifeChangeAchievementNoNewClothes630Title',
      desc: '',
      args: [],
    );
  }

  /// `900 days mastering change—your closet confidently mirrors your evolving journey.`
  String get lifeChangeAchievementNoNewClothes900Message {
    return Intl.message(
      '900 days mastering change—your closet confidently mirrors your evolving journey.',
      name: 'lifeChangeAchievementNoNewClothes900Message',
      desc: '',
      args: [],
    );
  }

  /// `Reinvention Leader!`
  String get lifeChangeAchievementNoNewClothes900Title {
    return Intl.message(
      'Reinvention Leader!',
      name: 'lifeChangeAchievementNoNewClothes900Title',
      desc: '',
      args: [],
    );
  }

  /// `90 days embracing change! Your wardrobe beautifully reflects your life's new chapter.`
  String get lifeChangeAchievementNoNewClothes90Message {
    return Intl.message(
      '90 days embracing change! Your wardrobe beautifully reflects your life\'s new chapter.',
      name: 'lifeChangeAchievementNoNewClothes90Message',
      desc: '',
      args: [],
    );
  }

  /// `90-Day Evolution!`
  String get lifeChangeAchievementNoNewClothes90Title {
    return Intl.message(
      '90-Day Evolution!',
      name: 'lifeChangeAchievementNoNewClothes90Title',
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
