// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(totalReviews, daysTracked, closetShown) =>
      "You have created ${totalReviews} outfits in the last ${daysTracked} days in ${closetShown}.";

  static String m1(maxAllowed) =>
      "You can upload ${maxAllowed} more. After that, you’ll reach your current limit.";

  static String m2(closetName) =>
      "Your disappearing closet \'${closetName}\' is now permanent. You can access all its items!";

  static String m3(error) => "Error: ${error}";

  static String m4(maxAllowed) =>
      "You can only select up to ${maxAllowed} images.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AmountHint": MessageLookupByLibrary.simpleMessage(
            "How much did this beauty cost?"),
        "AmountLabel": MessageLookupByLibrary.simpleMessage("Amount"),
        "AnalyticsSearchPremiumFeature":
            MessageLookupByLibrary.simpleMessage("Track Your Analytics?"),
        "AppName": MessageLookupByLibrary.simpleMessage("Closet\nConscious 🌱"),
        "ItemClothingLayerLabel":
            MessageLookupByLibrary.simpleMessage("Clothing Layer"),
        "ItemClothingTypeLabel":
            MessageLookupByLibrary.simpleMessage("Clothing Type"),
        "ItemColourLabel": MessageLookupByLibrary.simpleMessage("Colour"),
        "ItemColourVariationLabel":
            MessageLookupByLibrary.simpleMessage("Colour Variation"),
        "ItemNameFilterHint":
            MessageLookupByLibrary.simpleMessage("Got a name in mind?"),
        "ItemNameHint": MessageLookupByLibrary.simpleMessage(
            "What’s this fabulous piece called?"),
        "ItemNameLabel": MessageLookupByLibrary.simpleMessage("Item Name"),
        "ItemOccasionLabel": MessageLookupByLibrary.simpleMessage("Occasion"),
        "ItemSeasonLabel": MessageLookupByLibrary.simpleMessage("Season"),
        "MultiClosetFeatureTitle":
            MessageLookupByLibrary.simpleMessage("Manage Your Multi-Closets"),
        "OutfitDay": MessageLookupByLibrary.simpleMessage("Outfit of the Day"),
        "OutfitReview": MessageLookupByLibrary.simpleMessage("Outfit Review"),
        "Throw": MessageLookupByLibrary.simpleMessage("Throw"),
        "accessory": MessageLookupByLibrary.simpleMessage("Accessory"),
        "accessoryTypeRequired": MessageLookupByLibrary.simpleMessage(
            "Accessory type is not selected."),
        "accountDeletedSuccess": MessageLookupByLibrary.simpleMessage(
            "Your request has been received. We’ll delete your account within 48 hours."),
        "achievementMessage": MessageLookupByLibrary.simpleMessage(
            "You’ve unlocked a new achievement:"),
        "achievements": MessageLookupByLibrary.simpleMessage("Achievements"),
        "active": MessageLookupByLibrary.simpleMessage("Active"),
        "addCloset_addCloset":
            MessageLookupByLibrary.simpleMessage("Multi Closet"),
        "addYourComments":
            MessageLookupByLibrary.simpleMessage("Add your comments"),
        "advancedFilterDescription": MessageLookupByLibrary.simpleMessage(
            "Refine your search to fit your style! Filter by item type, occasion, season, and more for a closet view that’s all you."),
        "advancedFiltersTab":
            MessageLookupByLibrary.simpleMessage("Advanced Filters"),
        "aiStylistFeatureDescription": MessageLookupByLibrary.simpleMessage(
            "Unlock AI-powered outfit suggestions and receive personalized recommendations based on your unique style."),
        "aiStylistFeatureTitle":
            MessageLookupByLibrary.simpleMessage("AI Stylist Usage Feature"),
        "aiUploadFeatureDescription": MessageLookupByLibrary.simpleMessage(
            "Easily upload items with automatic metadata tagging. Let AI handle the details!"),
        "aiUploadFeatureTitle":
            MessageLookupByLibrary.simpleMessage("Smart Upload Usage Feature"),
        "aistylist": MessageLookupByLibrary.simpleMessage("AI Stylist"),
        "aiupload": MessageLookupByLibrary.simpleMessage("Smart\nUpload"),
        "allClosetLabel": MessageLookupByLibrary.simpleMessage("All Closet"),
        "allClosetShown": MessageLookupByLibrary.simpleMessage("All Closets"),
        "allClosets": MessageLookupByLibrary.simpleMessage("Edit All Closets"),
        "allFeedback": MessageLookupByLibrary.simpleMessage("All"),
        "allItems": MessageLookupByLibrary.simpleMessage("All Items"),
        "alright": MessageLookupByLibrary.simpleMessage("Not sure\n🤷‍♀️"),
        "alright_feedback_sentence": MessageLookupByLibrary.simpleMessage(
            "Tap the items you\'re unsure about."),
        "alwaysAvailableFeatures": MessageLookupByLibrary.simpleMessage(
            "Always Available Feature Tutorials"),
        "amountSpent": MessageLookupByLibrary.simpleMessage("Amount Spent"),
        "amountSpentFieldNotFilled": MessageLookupByLibrary.simpleMessage(
            "Amount Spent field is not filled."),
        "amountSpentLabel":
            MessageLookupByLibrary.simpleMessage("Amount Spent"),
        "analyticsSummary": m0,
        "and": MessageLookupByLibrary.simpleMessage(" and the "),
        "appInformationSection":
            MessageLookupByLibrary.simpleMessage("App Information"),
        "approachingLimitSnackbar": m1,
        "archive": MessageLookupByLibrary.simpleMessage("Archive"),
        "archiveCloset":
            MessageLookupByLibrary.simpleMessage("Archive\nCloset"),
        "archiveClosetDescription": MessageLookupByLibrary.simpleMessage(
            "Archiving this closet will return all items to your main closet.\n\nThis action cannot be undone."),
        "archiveClosetTitle":
            MessageLookupByLibrary.simpleMessage("Archive Closet"),
        "archiveSuccessMessage": MessageLookupByLibrary.simpleMessage(
            "Your closet has been archived successfully.\nAll items have been moved back to the main closet."),
        "archiveWarning": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to archive this closet?\nAll items will be moved back to your main closet."),
        "areYouSure": MessageLookupByLibrary.simpleMessage("Are you sure?"),
        "arrange": MessageLookupByLibrary.simpleMessage("Customize"),
        "arrangeFeatureDescription": MessageLookupByLibrary.simpleMessage(
            "Would you like to organize your closet by cost per wear or date added? Let us know!"),
        "arrangeFeatureTitle": MessageLookupByLibrary.simpleMessage(
            "Customize Your\nCloset Layout"),
        "ascending": MessageLookupByLibrary.simpleMessage("Ascending"),
        "athletic": MessageLookupByLibrary.simpleMessage("Athletic"),
        "autumn": MessageLookupByLibrary.simpleMessage("Autumn"),
        "avgPricePerWear":
            MessageLookupByLibrary.simpleMessage("Avg Cost Per Wear"),
        "bag": MessageLookupByLibrary.simpleMessage("Bag"),
        "base": MessageLookupByLibrary.simpleMessage("Base"),
        "basicFilterDescription": MessageLookupByLibrary.simpleMessage(
            "Quickly search by item name or, with multi-closet [premium feature], choose which closet to explore."),
        "basicFiltersTab":
            MessageLookupByLibrary.simpleMessage("Basic Filters"),
        "becomeAmbassador":
            MessageLookupByLibrary.simpleMessage("Become an Ambassador"),
        "belt": MessageLookupByLibrary.simpleMessage("Belt"),
        "black": MessageLookupByLibrary.simpleMessage("Black"),
        "blend": MessageLookupByLibrary.simpleMessage("Blend"),
        "blue": MessageLookupByLibrary.simpleMessage("Blue"),
        "boots": MessageLookupByLibrary.simpleMessage("Boots"),
        "bottom": MessageLookupByLibrary.simpleMessage("Bottom"),
        "brandNewWithTag":
            MessageLookupByLibrary.simpleMessage("Brand New\nwith Tag"),
        "brandNewWithoutTag":
            MessageLookupByLibrary.simpleMessage("Brand New\nwithout Tag"),
        "brown": MessageLookupByLibrary.simpleMessage("Brown"),
        "bulkUpload": MessageLookupByLibrary.simpleMessage("Upload"),
        "bulkUploadTitle": MessageLookupByLibrary.simpleMessage("Bulk Upload"),
        "calendar": MessageLookupByLibrary.simpleMessage("Calendar"),
        "calendarFeatureTitle":
            MessageLookupByLibrary.simpleMessage("Calendar"),
        "calendarNavigationFailed": MessageLookupByLibrary.simpleMessage(
            "Failed to navigate the calendar."),
        "calendarNotSelectable":
            MessageLookupByLibrary.simpleMessage("Outfit Details"),
        "calendarPremiumFeature":
            MessageLookupByLibrary.simpleMessage("Calendar View?"),
        "calendarSelectable":
            MessageLookupByLibrary.simpleMessage("Create Closet"),
        "cameraUpload": MessageLookupByLibrary.simpleMessage("Camera"),
        "camera_edit_item_permission_explanation":
            MessageLookupByLibrary.simpleMessage(
                "Let us use your camera to update your item photos."),
        "camera_permission_explanation": MessageLookupByLibrary.simpleMessage(
            "Camera access is required to take photos."),
        "camera_selfie_permission_explanation":
            MessageLookupByLibrary.simpleMessage(
                "We need access to your camera for your stunning outfit selfies!"),
        "camera_upload_item_permission_explanation":
            MessageLookupByLibrary.simpleMessage(
                "We need camera access to help you upload photos of your clothes."),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "casual": MessageLookupByLibrary.simpleMessage("Casual"),
        "chooseSwap": MessageLookupByLibrary.simpleMessage("Choose Swap"),
        "clickUploadItemInCloset": MessageLookupByLibrary.simpleMessage(
            "Click Upload button to upload your first item in the closet."),
        "closetLabel": MessageLookupByLibrary.simpleMessage("Closet"),
        "closetName": MessageLookupByLibrary.simpleMessage("Closet Name"),
        "closetNameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Closet name cannot be empty"),
        "closetReappearMessage": m2,
        "closetReappearTitle":
            MessageLookupByLibrary.simpleMessage("Closet Reappeared"),
        "closetType": MessageLookupByLibrary.simpleMessage("Closet Type"),
        "closetUploadComplete":
            MessageLookupByLibrary.simpleMessage("I uploaded my closet"),
        "closet_created_successfully": MessageLookupByLibrary.simpleMessage(
            "Closet created successfully!"),
        "closet_edited_successfully":
            MessageLookupByLibrary.simpleMessage("Closet edited successfully!"),
        "clothing": MessageLookupByLibrary.simpleMessage("Clothing"),
        "clothingLayerFieldNotFilled": MessageLookupByLibrary.simpleMessage(
            "Clothing Layer field is not selected."),
        "clothingTypeRequired": MessageLookupByLibrary.simpleMessage(
            "Clothing type is not selected."),
        "colourFieldNotFilled": MessageLookupByLibrary.simpleMessage(
            "Colour field is not selected."),
        "colourVariationFieldNotFilled": MessageLookupByLibrary.simpleMessage(
            "Colour Variation field is not selected."),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "confirmSwap": MessageLookupByLibrary.simpleMessage("Confirm Swap"),
        "confirmUpload":
            MessageLookupByLibrary.simpleMessage("Confirm Achievement"),
        "congratulations":
            MessageLookupByLibrary.simpleMessage("Congratulations! 🎉"),
        "contactUs": MessageLookupByLibrary.simpleMessage("Contact Us"),
        "costOfNewItems": MessageLookupByLibrary.simpleMessage(
            "Cost of new items you\'ve added"),
        "costPerWearTooltip": MessageLookupByLibrary.simpleMessage(
            "A lower cost per wear means you\'re getting great value! (Total cost ÷ times worn)"),
        "createCloset": MessageLookupByLibrary.simpleMessage("Create Closet"),
        "createClosetCalendarDescription": MessageLookupByLibrary.simpleMessage(
            "Select the outfits you want and see all related items to create a Closet."),
        "createClosetItemAnalyticsDescription":
            MessageLookupByLibrary.simpleMessage(
                "Build your dream capsule wardrobe with pieces you already love."),
        "createMultiClosetDescription": MessageLookupByLibrary.simpleMessage(
            "Create a new multi-closet, organize items,\nand add metadata to keep your closets structured"),
        "createOutfit": MessageLookupByLibrary.simpleMessage("Create Outfit"),
        "create_closet": MessageLookupByLibrary.simpleMessage("Create Closet"),
        "createdAt": MessageLookupByLibrary.simpleMessage("Created At"),
        "currentStreak":
            MessageLookupByLibrary.simpleMessage("Your current no-buy streak."),
        "currentStreakTooltip": MessageLookupByLibrary.simpleMessage(
            "Your current streak of no purchases"),
        "customizeClosetPageDescription": MessageLookupByLibrary.simpleMessage(
            "Browse your closet in a flexible grid, sorted by your chosen category and order."),
        "customizeClosetView":
            MessageLookupByLibrary.simpleMessage("Customize Closet View"),
        "customizeDescription": MessageLookupByLibrary.simpleMessage(
            "Personalize your view with grid size, sort category, and sort order."),
        "customizeOutfitPageDescription": MessageLookupByLibrary.simpleMessage(
            "Find items for your outfits in a flexible grid, sorted by category and order to make styling easy."),
        "customizeTitle":
            MessageLookupByLibrary.simpleMessage("Personalized Closet View"),
        "dark": MessageLookupByLibrary.simpleMessage("Dark"),
        "dataInsertedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Data saved! You\'re all set."),
        "dataUpdatedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Data updated successfully!"),
        "date": MessageLookupByLibrary.simpleMessage("Date"),
        "dateCannotBeTodayOrEarlier": MessageLookupByLibrary.simpleMessage(
            "The selected date cannot be today or earlier."),
        "declutter": MessageLookupByLibrary.simpleMessage("Declutter"),
        "declutterAcknowledged": MessageLookupByLibrary.simpleMessage(
            "Well done! Your closet just took a breather! 😌"),
        "declutterFeatureDescription": MessageLookupByLibrary.simpleMessage(
            "Easily organize and clean up your closet by removing unwanted items. Simplify your wardrobe and make room for new styles."),
        "declutterFeatureTitle":
            MessageLookupByLibrary.simpleMessage("Declutter Your Closet"),
        "declutterGenericWarning": MessageLookupByLibrary.simpleMessage(
            "Once you confirm, this item will disappear from your closet view permanently."),
        "declutterOptions":
            MessageLookupByLibrary.simpleMessage("What would you like to do?"),
        "declutterThrowWarning": MessageLookupByLibrary.simpleMessage(
            "Once you confirm, this item will disappear from your closet view permanently.\n\nHave you considered donating or upcycling instead?\n\n You could put it in a public closet, where people can buy / barter / swap with you for the item."),
        "defaultAchievementAllClothesWornMessage":
            MessageLookupByLibrary.simpleMessage(
                "You\'ve worn every single item in your closet! You\'re mastering mindful fashion choices."),
        "defaultAchievementAllClothesWornTitle":
            MessageLookupByLibrary.simpleMessage("All Clothes, All You!"),
        "defaultAchievementClosetUploadedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Congratulations! You\'ve uploaded all your items to your virtual closet. Now you can style like a pro!"),
        "defaultAchievementClosetUploadedTitle":
            MessageLookupByLibrary.simpleMessage("Virtual Closet Complete!"),
        "defaultAchievementFirstItemGiftedMessage":
            MessageLookupByLibrary.simpleMessage(
                "You’ve gifted your first item! Your style is making someone else’s day brighter."),
        "defaultAchievementFirstItemGiftedTitle":
            MessageLookupByLibrary.simpleMessage("Generous Giver!"),
        "defaultAchievementFirstItemPicEditedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your first item picture has been edited! Your closet is looking better than ever."),
        "defaultAchievementFirstItemPicEditedTitle":
            MessageLookupByLibrary.simpleMessage("Picture Perfect!"),
        "defaultAchievementFirstItemSoldMessage":
            MessageLookupByLibrary.simpleMessage(
                "You’ve sold your first item! Way to turn your closet into cash and make space for new looks."),
        "defaultAchievementFirstItemSoldTitle":
            MessageLookupByLibrary.simpleMessage("Smart Seller!"),
        "defaultAchievementFirstItemSwapMessage":
            MessageLookupByLibrary.simpleMessage(
                "You’ve swapped your first item! Your wardrobe just got a stylish and sustainable refresh."),
        "defaultAchievementFirstItemSwapTitle":
            MessageLookupByLibrary.simpleMessage("Sustainable Swapper!"),
        "defaultAchievementFirstItemUploadMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your first item is uploaded! Your virtual closet journey has begun!"),
        "defaultAchievementFirstItemUploadTitle":
            MessageLookupByLibrary.simpleMessage("Item Initiator!"),
        "defaultAchievementFirstOutfitCreatedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your first outfit is ready! You\'re on your way to mastering your style."),
        "defaultAchievementFirstOutfitCreatedTitle":
            MessageLookupByLibrary.simpleMessage("Outfit Architect!"),
        "defaultAchievementFirstSelfieTakenMessage":
            MessageLookupByLibrary.simpleMessage(
                "You’ve taken your first selfie! Show off your style and let your closet shine!"),
        "defaultAchievementFirstSelfieTakenTitle":
            MessageLookupByLibrary.simpleMessage("Selfie Superstar!"),
        "defaultAchievementMessage": MessageLookupByLibrary.simpleMessage(
            "You’ve reached a new milestone! Keep up the great work as you continue your journey towards mindful fashion."),
        "defaultAchievementNoNewClothes1215Message":
            MessageLookupByLibrary.simpleMessage(
                "1,215 days of intentional living! Your journey is inspiring others to follow in your footsteps."),
        "defaultAchievementNoNewClothes1215Title":
            MessageLookupByLibrary.simpleMessage("Icon of Sustainability!"),
        "defaultAchievementNoNewClothes1575Message":
            MessageLookupByLibrary.simpleMessage(
                "1,575 days of embracing what you have. You\'re rewriting the rules of fashion!"),
        "defaultAchievementNoNewClothes1575Title":
            MessageLookupByLibrary.simpleMessage("Master of Minimalism!"),
        "defaultAchievementNoNewClothes1980Message":
            MessageLookupByLibrary.simpleMessage(
                "1,980 days of dedication to mindful choices! You\'re a shining example of sustainable living and an inspiration to us all. ✨🌏"),
        "defaultAchievementNoNewClothes1980Title":
            MessageLookupByLibrary.simpleMessage("Beacon of Sustainability!"),
        "defaultAchievementNoNewClothes225Message":
            MessageLookupByLibrary.simpleMessage(
                "225 days and counting! Your closet is thriving, and so is the planet. 🌍"),
        "defaultAchievementNoNewClothes225Title":
            MessageLookupByLibrary.simpleMessage("Eco-Warrior in the Making!"),
        "defaultAchievementNoNewClothes405Message":
            MessageLookupByLibrary.simpleMessage(
                "405 days strong! Your commitment to conscious fashion is an inspiration."),
        "defaultAchievementNoNewClothes405Title":
            MessageLookupByLibrary.simpleMessage(
                "Champion of Conscious Choices!"),
        "defaultAchievementNoNewClothes630Message":
            MessageLookupByLibrary.simpleMessage(
                "630 days without new clothes—you\'re leading by example! Keep going!"),
        "defaultAchievementNoNewClothes630Title":
            MessageLookupByLibrary.simpleMessage("Sustainability Leader!"),
        "defaultAchievementNoNewClothes900Message":
            MessageLookupByLibrary.simpleMessage(
                "900 days of conscious choices! You’re setting trends and making waves in sustainability!"),
        "defaultAchievementNoNewClothes900Title":
            MessageLookupByLibrary.simpleMessage("Trailblazer of Change!"),
        "defaultAchievementNoNewClothes90Message":
            MessageLookupByLibrary.simpleMessage(
                "You’ve hit 90 days without new clothes! Keep building those eco-friendly habits! 🌱"),
        "defaultAchievementNoNewClothes90Title":
            MessageLookupByLibrary.simpleMessage("Sustainable Start!"),
        "defaultAchievementTitle":
            MessageLookupByLibrary.simpleMessage("Achievement Unlocked!"),
        "defaultClosetName":
            MessageLookupByLibrary.simpleMessage("Main Closet"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete Account"),
        "deleteAccountConfirmation": MessageLookupByLibrary.simpleMessage(
            "\n\nAll your data and access to paid features will be permanently removed. Deletion will occur in 48 hours."),
        "deleteAccountImpact": MessageLookupByLibrary.simpleMessage(
            "Are you sure? This action cannot be undone."),
        "deleteAccountTitle":
            MessageLookupByLibrary.simpleMessage("Delete Account"),
        "descending": MessageLookupByLibrary.simpleMessage("Descending"),
        "disappearAfterMonths":
            MessageLookupByLibrary.simpleMessage("Hidden for"),
        "disappearingCloset":
            MessageLookupByLibrary.simpleMessage("Disappearing Closet"),
        "dislike":
            MessageLookupByLibrary.simpleMessage("Not quite\nmy vibe 🤔"),
        "dislike_feedback_sentence": MessageLookupByLibrary.simpleMessage(
            "Tap the items that didn’t work in this outfit."),
        "doNotWash": MessageLookupByLibrary.simpleMessage("Do Not Wash"),
        "dryClean": MessageLookupByLibrary.simpleMessage("Dry Clean"),
        "editAllMultiClosetDescription": MessageLookupByLibrary.simpleMessage(
            "Edit all multi-closets at once.\nTransfer items to a single closet and streamline your wardrobe."),
        "editClosetBronzeDescription": MessageLookupByLibrary.simpleMessage(
            "Update and edit up to 200 closet photos to keep your digital closet organized and stylish."),
        "editClosetBronzeTitle": MessageLookupByLibrary.simpleMessage(
            "Bronze Plan - Edit Closet Images"),
        "editClosetGoldDescription": MessageLookupByLibrary.simpleMessage(
            "Enjoy unlimited edits for your closet photos and create the perfect digital wardrobe experience."),
        "editClosetGoldTitle": MessageLookupByLibrary.simpleMessage(
            "Gold Plan - Edit Closet Images"),
        "editClosetSilverDescription": MessageLookupByLibrary.simpleMessage(
            "Edit up to 700 closet photos and enhance your capsule closet management!"),
        "editClosetSilverTitle": MessageLookupByLibrary.simpleMessage(
            "Silver Plan - Edit Closet Images"),
        "editItem": MessageLookupByLibrary.simpleMessage("Edit Item"),
        "editItemBronzeDescription": MessageLookupByLibrary.simpleMessage(
            "Edit 200 more item images to keep your closet fresh."),
        "editItemBronzeTitle": MessageLookupByLibrary.simpleMessage(
            "Bronze Plan - Edit Item Images"),
        "editItemGoldDescription": MessageLookupByLibrary.simpleMessage(
            "Unlimited image edits! Keep refining your closet to perfection."),
        "editItemGoldTitle": MessageLookupByLibrary.simpleMessage(
            "Gold Plan - Edit Item Images"),
        "editItemSilverDescription": MessageLookupByLibrary.simpleMessage(
            "Edit 700 more item images and elevate your closet game!"),
        "editItemSilverTitle": MessageLookupByLibrary.simpleMessage(
            "Silver Plan - Edit Item Images"),
        "editPageTitle": MessageLookupByLibrary.simpleMessage("Edit Item"),
        "editPendingSuccessContent": MessageLookupByLibrary.simpleMessage(
            "Would you like to update more pending items from your photo library, so they can be used to create outfits in your closet?"),
        "editPendingSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Update Successful"),
        "editSingleMultiClosetDescription": MessageLookupByLibrary.simpleMessage(
            "Edit a single multi-closet.\nTransfer items to another closet,\nupdate metadata,\nchange the multi-closet image,\nor archive the closet."),
        "encourageComment": MessageLookupByLibrary.simpleMessage(
            "You haven’t added a comment for this outfit yet!"),
        "enterAmountSpentHint":
            MessageLookupByLibrary.simpleMessage("Enter amount spent"),
        "enterClosetName":
            MessageLookupByLibrary.simpleMessage("Please enter a closet name"),
        "enterEventName":
            MessageLookupByLibrary.simpleMessage("What\'s the occasion?"),
        "enterMonths": MessageLookupByLibrary.simpleMessage(
            "Please enter the number of months"),
        "error":
            MessageLookupByLibrary.simpleMessage("Oops, something went wrong."),
        "errorDeclutter": MessageLookupByLibrary.simpleMessage(
            "We couldn’t declutter right now, but don’t worry—we’ll try again soon! 🌿"),
        "errorFetchingClosets":
            MessageLookupByLibrary.simpleMessage("Error fetching closets"),
        "errorIncrement": MessageLookupByLibrary.simpleMessage(
            "Oops! We couldn’t record your interest. Please try again!"),
        "errorSavingCloset":
            MessageLookupByLibrary.simpleMessage("Error saving closet"),
        "errorSavingTutorialProgress": MessageLookupByLibrary.simpleMessage(
            "Something went wrong while saving your tutorial progress."),
        "error_creating_closet": m3,
        "event": MessageLookupByLibrary.simpleMessage("Event"),
        "eventName": MessageLookupByLibrary.simpleMessage("Event Name"),
        "everyday": MessageLookupByLibrary.simpleMessage("Everyday"),
        "eyewear": MessageLookupByLibrary.simpleMessage("Eyewear"),
        "failedToLoadImages":
            MessageLookupByLibrary.simpleMessage("Failed to load images"),
        "failedToLoadItems": MessageLookupByLibrary.simpleMessage(
            "Failed to load items. Please try again!"),
        "failedToLoadMetadata": MessageLookupByLibrary.simpleMessage(
            "Failed to load closet metadata.\nPlease try again."),
        "failedToLoadMoreImages":
            MessageLookupByLibrary.simpleMessage("Failed to load more images"),
        "failedToSaveOutfit": MessageLookupByLibrary.simpleMessage(
            "Failed to save outfit. Please try again."),
        "failedToSubmitScore":
            MessageLookupByLibrary.simpleMessage("Failed to submit score."),
        "feedback": MessageLookupByLibrary.simpleMessage("Feedback"),
        "fetchReappearClosets":
            MessageLookupByLibrary.simpleMessage("View Closet"),
        "filterClosetPageDescription": MessageLookupByLibrary.simpleMessage(
            "Sort your closet by color, type, and more to find just what you need."),
        "filterEventName":
            MessageLookupByLibrary.simpleMessage("Filter by Event Name"),
        "filterFeatureTitle":
            MessageLookupByLibrary.simpleMessage("Find Your Favorites Faster"),
        "filterItemsTitle":
            MessageLookupByLibrary.simpleMessage("Filter Items"),
        "filterOutfitPageDescription": MessageLookupByLibrary.simpleMessage(
            "Focus on items that fit your style, mood, and plans."),
        "filterSearchPremiumFeature":
            MessageLookupByLibrary.simpleMessage("Advanced Filters?"),
        "filter_filter": MessageLookupByLibrary.simpleMessage("Filter"),
        "fix_validation_errors":
            MessageLookupByLibrary.simpleMessage("Fix the errors to continue."),
        "focus": MessageLookupByLibrary.simpleMessage("Day Focus"),
        "focusedDate": MessageLookupByLibrary.simpleMessage("Focused Date"),
        "formal": MessageLookupByLibrary.simpleMessage("Formal"),
        "general_permission_explanation": MessageLookupByLibrary.simpleMessage(
            "We need this permission to make the app work properly."),
        "gentlyUsed": MessageLookupByLibrary.simpleMessage("Gently\nUsed"),
        "gift": MessageLookupByLibrary.simpleMessage("Gift"),
        "gloves": MessageLookupByLibrary.simpleMessage("Gloves"),
        "green": MessageLookupByLibrary.simpleMessage("Green"),
        "grey": MessageLookupByLibrary.simpleMessage("Grey"),
        "gridSize3": MessageLookupByLibrary.simpleMessage("3 items per row"),
        "gridSize5": MessageLookupByLibrary.simpleMessage("5 items per row"),
        "gridSize7": MessageLookupByLibrary.simpleMessage("7 items per row"),
        "gridSizePickerTitle":
            MessageLookupByLibrary.simpleMessage("Grid Size Picker"),
        "handWash": MessageLookupByLibrary.simpleMessage("Hand Wash"),
        "hat": MessageLookupByLibrary.simpleMessage("Hat"),
        "highestStreak": MessageLookupByLibrary.simpleMessage(
            "Your all-time record of no new clothes!"),
        "highestStreakTooltip": MessageLookupByLibrary.simpleMessage(
            "Your highest no-purchase streak ever!"),
        "hintEventName": MessageLookupByLibrary.simpleMessage(
            "Enter the event or special moment."),
        "iAmReady": MessageLookupByLibrary.simpleMessage("I\'m ready"),
        "infoHub": MessageLookupByLibrary.simpleMessage("Info Hub"),
        "infoHubUrl": MessageLookupByLibrary.simpleMessage(
            "https://inky-twill-3ab.notion.site/8bca4fd6945f4f808a32cbb5ad28400c"),
        "interestAcknowledged": MessageLookupByLibrary.simpleMessage(
            "Got it! We’ve noted your interest—stay tuned for updates! 🎉"),
        "interested": MessageLookupByLibrary.simpleMessage("Interested"),
        "invalidMonths": MessageLookupByLibrary.simpleMessage(
            "Invalid months (enter a positive number)"),
        "invalidMonthsValue":
            MessageLookupByLibrary.simpleMessage("Invalid value for months."),
        "itemInactiveMessage": MessageLookupByLibrary.simpleMessage(
            "This item is retired and no longer part of your closet, but it stays in your past outfits."),
        "itemLastWorn": MessageLookupByLibrary.simpleMessage("Last Worn"),
        "itemNameFieldNotFilled": MessageLookupByLibrary.simpleMessage(
            "Item Name field is not filled."),
        "itemNameLabel": MessageLookupByLibrary.simpleMessage("Item Name"),
        "itemTypeFieldNotFilled": MessageLookupByLibrary.simpleMessage(
            "Item Type field is not selected."),
        "itemUploaded_itemUploaded":
            MessageLookupByLibrary.simpleMessage("Item Uploaded"),
        "itemWithRelatedOutfitsDescription": MessageLookupByLibrary.simpleMessage(
            "See the outfits this item has brought to life—your style, your way."),
        "item_name": MessageLookupByLibrary.simpleMessage("Item Name"),
        "itemsUploadedTooltip": MessageLookupByLibrary.simpleMessage(
            "Number of items you\'ve uploaded to your conscious closet"),
        "jewellery": MessageLookupByLibrary.simpleMessage("Jewellery"),
        "lifeChange":
            MessageLookupByLibrary.simpleMessage("Start a New Chapter"),
        "lifeChangeAchievementAllClothesWornMessage":
            MessageLookupByLibrary.simpleMessage(
                "Every item worn—embracing your evolving identity wholeheartedly."),
        "lifeChangeAchievementAllClothesWornTitle":
            MessageLookupByLibrary.simpleMessage("Fully Transformed!"),
        "lifeChangeAchievementClosetUploadedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Closet uploaded—ready to support this exciting new life phase."),
        "lifeChangeAchievementClosetUploadedTitle":
            MessageLookupByLibrary.simpleMessage("Life Updated!"),
        "lifeChangeAchievementFirstItemGiftedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Gifted your first item—clearing space for the new you."),
        "lifeChangeAchievementFirstItemGiftedTitle":
            MessageLookupByLibrary.simpleMessage("Forward Focused!"),
        "lifeChangeAchievementFirstItemPicEditedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Edited your first item\'s picture—reflecting your current life beautifully."),
        "lifeChangeAchievementFirstItemPicEditedTitle":
            MessageLookupByLibrary.simpleMessage("Ready for Renewal!"),
        "lifeChangeAchievementFirstItemSoldMessage":
            MessageLookupByLibrary.simpleMessage(
                "Sold your first item, making room for what truly suits you now."),
        "lifeChangeAchievementFirstItemSoldTitle":
            MessageLookupByLibrary.simpleMessage("Old to New!"),
        "lifeChangeAchievementFirstItemSwapMessage":
            MessageLookupByLibrary.simpleMessage(
                "Swapped your first item—your wardrobe matches your life\'s shift."),
        "lifeChangeAchievementFirstItemSwapTitle":
            MessageLookupByLibrary.simpleMessage("Freshly Swapped!"),
        "lifeChangeAchievementFirstItemUploadMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your first item uploaded, symbolizing a fresh start in your journey."),
        "lifeChangeAchievementFirstItemUploadTitle":
            MessageLookupByLibrary.simpleMessage("New Chapter Begins!"),
        "lifeChangeAchievementFirstOutfitCreatedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your first outfit recorded—perfect for embracing your new phase."),
        "lifeChangeAchievementFirstOutfitCreatedTitle":
            MessageLookupByLibrary.simpleMessage("Transition Tracked!"),
        "lifeChangeAchievementFirstSelfieTakenMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your first selfie marks this moment—reflecting your evolving story."),
        "lifeChangeAchievementFirstSelfieTakenTitle":
            MessageLookupByLibrary.simpleMessage("Change Documented!"),
        "lifeChangeAchievementNoNewClothes1215Message":
            MessageLookupByLibrary.simpleMessage(
                "1,215 days crafting your wardrobe to fit life\'s transformations. Your adaptability inspires!"),
        "lifeChangeAchievementNoNewClothes1215Title":
            MessageLookupByLibrary.simpleMessage("Architect of Change!"),
        "lifeChangeAchievementNoNewClothes1575Message":
            MessageLookupByLibrary.simpleMessage(
                "1,575 days gracefully navigating life\'s shifts. Your wardrobe reflects wisdom and growth."),
        "lifeChangeAchievementNoNewClothes1575Title":
            MessageLookupByLibrary.simpleMessage("Seasoned Transformer!"),
        "lifeChangeAchievementNoNewClothes1980Message":
            MessageLookupByLibrary.simpleMessage(
                "1,980 days redefining your style through life\'s changes—your story and wardrobe are beautifully aligned."),
        "lifeChangeAchievementNoNewClothes1980Title":
            MessageLookupByLibrary.simpleMessage("Master of Life\'s Chapters!"),
        "lifeChangeAchievementNoNewClothes225Message":
            MessageLookupByLibrary.simpleMessage(
                "225 days of intentional transformation—your closet is evolving with your life."),
        "lifeChangeAchievementNoNewClothes225Title":
            MessageLookupByLibrary.simpleMessage("Change Champion!"),
        "lifeChangeAchievementNoNewClothes405Message":
            MessageLookupByLibrary.simpleMessage(
                "405 days navigating life\'s changes stylishly—you\'re gracefully moving forward, wardrobe and all."),
        "lifeChangeAchievementNoNewClothes405Title":
            MessageLookupByLibrary.simpleMessage("Adapting with Style!"),
        "lifeChangeAchievementNoNewClothes630Message":
            MessageLookupByLibrary.simpleMessage(
                "630 days of aligning your style with your life\'s transitions—you\'re thriving in every chapter."),
        "lifeChangeAchievementNoNewClothes630Title":
            MessageLookupByLibrary.simpleMessage("Transformation Trailblazer!"),
        "lifeChangeAchievementNoNewClothes900Message":
            MessageLookupByLibrary.simpleMessage(
                "900 days mastering change—your closet confidently mirrors your evolving journey."),
        "lifeChangeAchievementNoNewClothes900Title":
            MessageLookupByLibrary.simpleMessage("Reinvention Leader!"),
        "lifeChangeAchievementNoNewClothes90Message":
            MessageLookupByLibrary.simpleMessage(
                "90 days embracing change! Your wardrobe beautifully reflects your life\'s new chapter."),
        "lifeChangeAchievementNoNewClothes90Title":
            MessageLookupByLibrary.simpleMessage("90-Day Evolution!"),
        "lifeChangeTrialCalendar": MessageLookupByLibrary.simpleMessage(
            "Track your outfits during life shifts. See what worked and when."),
        "lifeChangeTrialClosets": MessageLookupByLibrary.simpleMessage(
            "Create closets for transitions—travel, work, motherhood, or pause."),
        "lifeChangeTrialCustomize": MessageLookupByLibrary.simpleMessage(
            "Update your closet layout to fit what matters today."),
        "lifeChangeTrialFilter": MessageLookupByLibrary.simpleMessage(
            "Quickly find what suits your new routines, roles, and realities."),
        "lifeChangeTrialInsights": MessageLookupByLibrary.simpleMessage(
            "Understand what truly served you during change—by use and by season."),
        "lifeChangeTrialOutfits": MessageLookupByLibrary.simpleMessage(
            "Build outfits that support your day-to-day changes."),
        "light": MessageLookupByLibrary.simpleMessage("Light"),
        "like": MessageLookupByLibrary.simpleMessage("Love it!\n😍"),
        "likeNew": MessageLookupByLibrary.simpleMessage("Like\nNew"),
        "loading_text": MessageLookupByLibrary.simpleMessage(
            "Loading... Fashion magic in progress 🧙‍♂️✨"),
        "logOut": MessageLookupByLibrary.simpleMessage("Log Out"),
        "machine": MessageLookupByLibrary.simpleMessage("Machine"),
        "maxPendingItemsSnackbar": m4,
        "medium": MessageLookupByLibrary.simpleMessage("Medium"),
        "memoryAchievementAllClothesWornMessage":
            MessageLookupByLibrary.simpleMessage(
                "You\'ve worn all your pieces, each with its unique story."),
        "memoryAchievementAllClothesWornTitle":
            MessageLookupByLibrary.simpleMessage("Every Memory Worn!"),
        "memoryAchievementClosetUploadedMessage":
            MessageLookupByLibrary.simpleMessage(
                "You’ve uploaded everything you own. Now every choice is intentional—your mindful journey begins."),
        "memoryAchievementClosetUploadedTitle":
            MessageLookupByLibrary.simpleMessage("Closet Counted!"),
        "memoryAchievementFirstItemGiftedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your gifted item carries memories forward, enriching someone else\'s story."),
        "memoryAchievementFirstItemGiftedTitle":
            MessageLookupByLibrary.simpleMessage("Memory Passed On!"),
        "memoryAchievementFirstItemPicEditedMessage":
            MessageLookupByLibrary.simpleMessage(
                "First edit complete—your memories clearer and brighter than ever."),
        "memoryAchievementFirstItemPicEditedTitle":
            MessageLookupByLibrary.simpleMessage("Memory Enhanced!"),
        "memoryAchievementFirstItemSoldMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your item sold—letting go, but memories linger and live on."),
        "memoryAchievementFirstItemSoldTitle":
            MessageLookupByLibrary.simpleMessage("Memory Shared!"),
        "memoryAchievementFirstItemSwapMessage":
            MessageLookupByLibrary.simpleMessage(
                "First swap done—new memories await with your refreshed closet."),
        "memoryAchievementFirstItemSwapTitle":
            MessageLookupByLibrary.simpleMessage("Memory Refreshed!"),
        "memoryAchievementFirstItemUploadMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your first memory item is safely stored—ready for future reminiscing."),
        "memoryAchievementFirstItemUploadTitle":
            MessageLookupByLibrary.simpleMessage("Memory Preserved!"),
        "memoryAchievementFirstOutfitCreatedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your first outfit saved—a moment you\'ll cherish forever."),
        "memoryAchievementFirstOutfitCreatedTitle":
            MessageLookupByLibrary.simpleMessage("Milestone Marked!"),
        "memoryAchievementFirstSelfieTakenMessage":
            MessageLookupByLibrary.simpleMessage(
                "First selfie taken—holding onto memories one picture at a time."),
        "memoryAchievementFirstSelfieTakenTitle":
            MessageLookupByLibrary.simpleMessage("Moment Captured!"),
        "memoryAchievementNoNewClothes1215Message":
            MessageLookupByLibrary.simpleMessage(
                "1,215 days preserving the stories held by each outfit. Your closet is a living scrapbook of memories."),
        "memoryAchievementNoNewClothes1215Title":
            MessageLookupByLibrary.simpleMessage("Guardian of Moments!"),
        "memoryAchievementNoNewClothes1575Message":
            MessageLookupByLibrary.simpleMessage(
                "1,575 days of mindful living—your wardrobe is a gallery of life\'s most meaningful moments."),
        "memoryAchievementNoNewClothes1575Title":
            MessageLookupByLibrary.simpleMessage("Memory Masterpiece!"),
        "memoryAchievementNoNewClothes1980Message":
            MessageLookupByLibrary.simpleMessage(
                "1,980 days of treasuring memories through clothes. Your closet narrates your beautiful, evolving story."),
        "memoryAchievementNoNewClothes1980Title":
            MessageLookupByLibrary.simpleMessage("Legend of Legacy!"),
        "memoryAchievementNoNewClothes225Message":
            MessageLookupByLibrary.simpleMessage(
                "225 days honoring memories, one outfit at a time. Your wardrobe is full of moments worth remembering."),
        "memoryAchievementNoNewClothes225Title":
            MessageLookupByLibrary.simpleMessage("Keeper of Memories!"),
        "memoryAchievementNoNewClothes405Message":
            MessageLookupByLibrary.simpleMessage(
                "405 days living through your wardrobe—each piece a reminder of life\'s precious moments."),
        "memoryAchievementNoNewClothes405Title":
            MessageLookupByLibrary.simpleMessage("Story Collector!"),
        "memoryAchievementNoNewClothes630Message":
            MessageLookupByLibrary.simpleMessage(
                "630 days weaving life\'s stories through your clothes—you\'re curating a beautiful narrative."),
        "memoryAchievementNoNewClothes630Title":
            MessageLookupByLibrary.simpleMessage("Memory Maestro!"),
        "memoryAchievementNoNewClothes900Message":
            MessageLookupByLibrary.simpleMessage(
                "900 days celebrating your life\'s journey through clothes. Every outfit tells a cherished story."),
        "memoryAchievementNoNewClothes900Title":
            MessageLookupByLibrary.simpleMessage("Historian of the Heart!"),
        "memoryAchievementNoNewClothes90Message":
            MessageLookupByLibrary.simpleMessage(
                "90 days cherishing your wardrobe memories. Every piece worn carries a precious story."),
        "memoryAchievementNoNewClothes90Title":
            MessageLookupByLibrary.simpleMessage("90 Days of Moments!"),
        "memoryScenarioTutorial": MessageLookupByLibrary.simpleMessage(
            "You thought you’d remember it all.\nNow you can.\n\nTheir story lives on—one outfit at a time."),
        "memoryTrialCalendar": MessageLookupByLibrary.simpleMessage(
            "Look back by date—see the outfits that shaped your seasons."),
        "memoryTrialClosets": MessageLookupByLibrary.simpleMessage(
            "Group life chapters into closets—each with a story of its own."),
        "memoryTrialCustomize": MessageLookupByLibrary.simpleMessage(
            "Arrange your items like memory shelves—what mattered most stays visible."),
        "memoryTrialFilter": MessageLookupByLibrary.simpleMessage(
            "Narrow your closet by name, item type to create your memory quickly."),
        "memoryTrialInsights": MessageLookupByLibrary.simpleMessage(
            "See which items showed up in your story most—by use, by love, by time."),
        "memoryTrialOutfits": MessageLookupByLibrary.simpleMessage(
            "Create outfits from pieces that carry your favorite memories."),
        "memoryTutorialClosetUploaded": MessageLookupByLibrary.simpleMessage(
            "Use what they have.\nBuild the streak.\nUnlock more—just by choosing less."),
        "memoryTutorialFreeCreateOutfitCreateOutfitProcess":
            MessageLookupByLibrary.simpleMessage(
                "One outfit. One day. One memory.\nSnap it. Note it. Feel it again tomorrow."),
        "memoryTutorialFreeEditCameraDeclutterItems":
            MessageLookupByLibrary.simpleMessage(
                "They’re growing.\nSo are the stories behind what they wore."),
        "memoryTutorialFreePhotoLibraryUploadClothing":
            MessageLookupByLibrary.simpleMessage(
                "You’ve saved the moments—now sort the memories.\nOne tap brings each piece into their story."),
        "memoryTutorialFreeUploadCameraUploadClothing":
            MessageLookupByLibrary.simpleMessage(
                "The little things matter.\nCapture them now, find them later."),
        "memoryTutorialPaidCalendarTrackFirstExperiences":
            MessageLookupByLibrary.simpleMessage(
                "What you wore.How it felt.\nIt’s all here—ready to remember, ready to reuse."),
        "memoryTutorialPaidCustomizeViewAllItems":
            MessageLookupByLibrary.simpleMessage(
                "Your closet, your way.\nZoom in. Sort by love.\nOne tap brings it all back."),
        "memoryTutorialPaidFilterFindInCloset":
            MessageLookupByLibrary.simpleMessage(
                "Life moves fast.\nTheir closet keeps up.\nFind what you need—right when you need it."),
        "memoryTutorialPaidMultiClosetCreateCapsule":
            MessageLookupByLibrary.simpleMessage(
                "Some closets hold the past.\nSome, the present.\nAll of them—pieces of your story."),
        "memoryTutorialPaidUsageAnalyticsCostPerWear":
            MessageLookupByLibrary.simpleMessage(
                "They outgrew the clothes—\nbut not the moments you lived in them.\nSee what mattered. Feel it again."),
        "metadata": MessageLookupByLibrary.simpleMessage("More"),
        "metadataFeatureDescription": MessageLookupByLibrary.simpleMessage(
            "Want to add extra details to your items for better organization? Let us know!"),
        "metadataFeatureTitle":
            MessageLookupByLibrary.simpleMessage("More Item Details?"),
        "mid": MessageLookupByLibrary.simpleMessage("Mid"),
        "months": MessageLookupByLibrary.simpleMessage("Months to disappear"),
        "monthsCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Months cannot be empty"),
        "monthsCannotExceed12":
            MessageLookupByLibrary.simpleMessage("Cannot exceed 12 months"),
        "multi": MessageLookupByLibrary.simpleMessage("Multi"),
        "multiClosetFeatureDescription": MessageLookupByLibrary.simpleMessage(
            "We’re exploring adding multiple closets (permanent, disappearing)—would you use this?"),
        "multiClosetFeatureTitle":
            MessageLookupByLibrary.simpleMessage("Multiple Closets?"),
        "multiClosetManagement":
            MessageLookupByLibrary.simpleMessage("Multi-Closet Management"),
        "multiOutfitDescription": MessageLookupByLibrary.simpleMessage(
            "Create multiple outfits a day and keep experimenting with your style!"),
        "multiOutfitTitle": MessageLookupByLibrary.simpleMessage(
            "Multi Outfit Premium Feature"),
        "myClosetTitle": MessageLookupByLibrary.simpleMessage("My Closet"),
        "myOutfitOfTheDay":
            MessageLookupByLibrary.simpleMessage("My Outfit of the Day"),
        "myOutfitTitle":
            MessageLookupByLibrary.simpleMessage("Create My Outfit"),
        "natural": MessageLookupByLibrary.simpleMessage("Natural"),
        "newItemsTooltip": MessageLookupByLibrary.simpleMessage(
            "Number of new items you have purchased"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "niche": MessageLookupByLibrary.simpleMessage("Niche"),
        "noAchievementFound": MessageLookupByLibrary.simpleMessage(
            "No achievements yet—start unlocking them today!"),
        "noClosetsAvailable":
            MessageLookupByLibrary.simpleMessage("No closets available"),
        "noClosetsFound":
            MessageLookupByLibrary.simpleMessage("No closets found"),
        "noFilteredOutfitMessage": MessageLookupByLibrary.simpleMessage(
            "No outfits match your current filter. Adjust the filter to find reviewed outfits."),
        "noImage": MessageLookupByLibrary.simpleMessage("No Image Available"),
        "noInternetMessage": MessageLookupByLibrary.simpleMessage(
            "We\'re on a coffee break ☕\nReconnect soon to keep rocking those eco-friendly looks!"),
        "noInternetSnackBar": MessageLookupByLibrary.simpleMessage(
            "Still offline, but your closet’s worth the wait! ✨"),
        "noInternetTitle":
            MessageLookupByLibrary.simpleMessage("Uh-oh, You\'re Offline!"),
        "noItemsFound": MessageLookupByLibrary.simpleMessage("No items found."),
        "noItemsInCloset": MessageLookupByLibrary.simpleMessage(
            "No items yet!\nAdd to your closet or change filters to explore."),
        "noItemsInOutfitCategory": MessageLookupByLibrary.simpleMessage(
            "Your outfit canvas is waiting!\nAdd items to your closet or adjust filters to see more."),
        "noOutfitComments": MessageLookupByLibrary.simpleMessage(
            "No comments available for this outfit."),
        "noOutfitsAvailable":
            MessageLookupByLibrary.simpleMessage("No outfit or item available"),
        "noOutfitsInMonth": MessageLookupByLibrary.simpleMessage(
            "No outfits found in this month. You can create your first reviewed outfit or choose another date where you have reviewed your outfit."),
        "noPhotosFound":
            MessageLookupByLibrary.simpleMessage("No photos found"),
        "noReappearClosets": MessageLookupByLibrary.simpleMessage(
            "No reappeared closets found."),
        "noRelatedOutfits": MessageLookupByLibrary.simpleMessage(
            "No related outfits reviewed yet.\n\nTry styling any of the above outfit items to create another outfit!"),
        "noRelatedOutfitsItem": MessageLookupByLibrary.simpleMessage(
            "No related outfits reviewed yet.\n\nTry styling this outfit differently!"),
        "noReviewedOutfitMessage": MessageLookupByLibrary.simpleMessage(
            "You haven’t reviewed any outfits yet. Start by reviewing your first outfit!"),
        "notification_permission_explanation": MessageLookupByLibrary.simpleMessage(
            "We use notifications to gently remind you to upload items or create outfits. No spam, just a little nudge when it matters."),
        "npsExplanation": MessageLookupByLibrary.simpleMessage(
            "On a scale from 0 to 10:\n0: Not at all likely\n10: Extremely likely"),
        "npsReviewEmailBody": MessageLookupByLibrary.simpleMessage(
            "Could you share some details on how we can improve?"),
        "npsReviewEmailSubject":
            MessageLookupByLibrary.simpleMessage("We Love Your Feedback!"),
        "numberOfNewItems": MessageLookupByLibrary.simpleMessage(
            "Number of new items in your closet"),
        "occasionFieldNotFilled": MessageLookupByLibrary.simpleMessage(
            "Occasion field is not selected."),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "onePiece": MessageLookupByLibrary.simpleMessage("One Piece"),
        "onlyItemsUnworn":
            MessageLookupByLibrary.simpleMessage("Only Unworn Items"),
        "open_settings": MessageLookupByLibrary.simpleMessage("Open Settings"),
        "other": MessageLookupByLibrary.simpleMessage("Misc"),
        "outer": MessageLookupByLibrary.simpleMessage("Outer"),
        "outfitActive": MessageLookupByLibrary.simpleMessage("Active Outfits"),
        "outfitCreationSuccessContent": MessageLookupByLibrary.simpleMessage(
            "Outfit ready. Go Slay the World, Fashionista! 🦸‍♀️"),
        "outfitCreationSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Style On!"),
        "outfitInactive":
            MessageLookupByLibrary.simpleMessage("Inactive Outfits"),
        "outfitLabel": MessageLookupByLibrary.simpleMessage("Outfit"),
        "outfitRelatedOutfitsDescription": MessageLookupByLibrary.simpleMessage(
            "Find new ways to wear what you own—similar outfit ideas based on your favorites."),
        "outfitReviewContent": MessageLookupByLibrary.simpleMessage(
            "Your outfit review has been submitted successfully!"),
        "outfitReviewTitle":
            MessageLookupByLibrary.simpleMessage("Outfit Review Submitted"),
        "outfitStatus": MessageLookupByLibrary.simpleMessage("Outfit Status"),
        "outfitsAll": MessageLookupByLibrary.simpleMessage("All Outfits"),
        "outfits_upload":
            MessageLookupByLibrary.simpleMessage("Number of outfits uploaded"),
        "parentMemories":
            MessageLookupByLibrary.simpleMessage("Create Memory Closet"),
        "perfume": MessageLookupByLibrary.simpleMessage("Cosmetic"),
        "permanentCloset":
            MessageLookupByLibrary.simpleMessage("Permanent Closet"),
        "permission_needed": MessageLookupByLibrary.simpleMessage(
            "This permission is\nrequired for the app\nto function properly."),
        "personalStyle":
            MessageLookupByLibrary.simpleMessage("Rediscover My Style"),
        "personalStyleAchievementAllClothesWornMessage":
            MessageLookupByLibrary.simpleMessage(
                "You\'ve confidently worn every piece you own! Keep embracing your personal style."),
        "personalStyleAchievementAllClothesWornTitle":
            MessageLookupByLibrary.simpleMessage("Fully You!"),
        "personalStyleAchievementClosetUploadedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your closet upload is complete. Confidence awaits in every combination."),
        "personalStyleAchievementClosetUploadedTitle":
            MessageLookupByLibrary.simpleMessage("Your Closet, Curated!"),
        "personalStyleAchievementFirstItemGiftedMessage":
            MessageLookupByLibrary.simpleMessage(
                "You\'ve passed along a piece of your style. Confidence looks good on both of you!"),
        "personalStyleAchievementFirstItemGiftedTitle":
            MessageLookupByLibrary.simpleMessage("Style Shared!"),
        "personalStyleAchievementFirstItemPicEditedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your item\'s picture is updated—your closet matches your confidence."),
        "personalStyleAchievementFirstItemPicEditedTitle":
            MessageLookupByLibrary.simpleMessage("Styled to Perfection!"),
        "personalStyleAchievementFirstItemSoldMessage":
            MessageLookupByLibrary.simpleMessage(
                "You’ve sold your first item, refining your closet to what truly feels good."),
        "personalStyleAchievementFirstItemSoldTitle":
            MessageLookupByLibrary.simpleMessage("Curator of Confidence!"),
        "personalStyleAchievementFirstItemSwapMessage":
            MessageLookupByLibrary.simpleMessage(
                "You’ve swapped your first piece. Keep discovering what makes you feel best."),
        "personalStyleAchievementFirstItemSwapTitle":
            MessageLookupByLibrary.simpleMessage("Confidence Exchange!"),
        "personalStyleAchievementFirstItemUploadMessage":
            MessageLookupByLibrary.simpleMessage(
                "You\'ve uploaded your first item. Let\'s discover the styles that feel uniquely you."),
        "personalStyleAchievementFirstItemUploadTitle":
            MessageLookupByLibrary.simpleMessage("Confidence Unlocked!"),
        "personalStyleAchievementFirstOutfitCreatedMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your first outfit is crafted. Revisit this look to feel great anytime."),
        "personalStyleAchievementFirstOutfitCreatedTitle":
            MessageLookupByLibrary.simpleMessage("Signature Look Set!"),
        "personalStyleAchievementFirstSelfieTakenMessage":
            MessageLookupByLibrary.simpleMessage(
                "Your first selfie captured! Celebrate your style journey."),
        "personalStyleAchievementFirstSelfieTakenTitle":
            MessageLookupByLibrary.simpleMessage("Own Your Style!"),
        "personalStyleAchievementNoNewClothes1215Message":
            MessageLookupByLibrary.simpleMessage(
                "1,215 days proving true style is timeless! You\'re a role model of authentic self-expression."),
        "personalStyleAchievementNoNewClothes1215Title":
            MessageLookupByLibrary.simpleMessage("Legendary Style!"),
        "personalStyleAchievementNoNewClothes1575Message":
            MessageLookupByLibrary.simpleMessage(
                "1,575 days curating a closet of confidence—your style speaks volumes without saying a word."),
        "personalStyleAchievementNoNewClothes1575Title":
            MessageLookupByLibrary.simpleMessage("Architect of Authenticity!"),
        "personalStyleAchievementNoNewClothes1980Message":
            MessageLookupByLibrary.simpleMessage(
                "1,980 days embodying your unique identity through fashion. You\'re redefining what it means to dress confidently."),
        "personalStyleAchievementNoNewClothes1980Title":
            MessageLookupByLibrary.simpleMessage("Pinnacle of Personal Style!"),
        "personalStyleAchievementNoNewClothes225Message":
            MessageLookupByLibrary.simpleMessage(
                "225 days of rediscovering your wardrobe! You\'re defining confidence on your own terms."),
        "personalStyleAchievementNoNewClothes225Title":
            MessageLookupByLibrary.simpleMessage("Style Setter!"),
        "personalStyleAchievementNoNewClothes405Message":
            MessageLookupByLibrary.simpleMessage(
                "405 days mastering the art of personal style—your closet reflects your true self beautifully."),
        "personalStyleAchievementNoNewClothes405Title":
            MessageLookupByLibrary.simpleMessage("Wardrobe Whisperer!"),
        "personalStyleAchievementNoNewClothes630Message":
            MessageLookupByLibrary.simpleMessage(
                "630 days confidently dressing from your own closet—you\'re inspiring others with your unique style."),
        "personalStyleAchievementNoNewClothes630Title":
            MessageLookupByLibrary.simpleMessage("Confidence Creator!"),
        "personalStyleAchievementNoNewClothes900Message":
            MessageLookupByLibrary.simpleMessage(
                "900 days of personal style mastery—your confidence is contagious and transformative!"),
        "personalStyleAchievementNoNewClothes900Title":
            MessageLookupByLibrary.simpleMessage("Style Icon!"),
        "personalStyleAchievementNoNewClothes90Message":
            MessageLookupByLibrary.simpleMessage(
                "You\'ve styled yourself confidently for 90 days using what you own—your personal style is thriving!"),
        "personalStyleAchievementNoNewClothes90Title":
            MessageLookupByLibrary.simpleMessage("90 Days Confident!"),
        "personalStyleTrialCalendar": MessageLookupByLibrary.simpleMessage(
            "Watch your style change over time, one day at a time."),
        "personalStyleTrialClosets": MessageLookupByLibrary.simpleMessage(
            "Make themed closets that mirror your personal aesthetic."),
        "personalStyleTrialCustomize": MessageLookupByLibrary.simpleMessage(
            "Reorganize your layout to reflect what feels like you right now."),
        "personalStyleTrialFilter": MessageLookupByLibrary.simpleMessage(
            "Narrow your closet by name, item type to define your unique look."),
        "personalStyleTrialInsights": MessageLookupByLibrary.simpleMessage(
            "Reveal your most-used items, favorite outfits, and style patterns."),
        "personalStyleTrialOutfits": MessageLookupByLibrary.simpleMessage(
            "Mix and match across days to discover your evolving style."),
        "photoAccessDialogContent": MessageLookupByLibrary.simpleMessage(
            "To see your entire photo library and avoid being asked again, grant full access in Settings."),
        "photoAccessDialogTitle":
            MessageLookupByLibrary.simpleMessage("Give Full Access?"),
        "photo_library_permission_explanation":
            MessageLookupByLibrary.simpleMessage(
                "We need access to your photo library so you can select and upload your favorite outfits."),
        "pleaseCorrectTheErrors": MessageLookupByLibrary.simpleMessage(
            "Please correct the errors in the form."),
        "pleaseEnterItemName":
            MessageLookupByLibrary.simpleMessage("Please enter an item name"),
        "pleaseEnterMonths":
            MessageLookupByLibrary.simpleMessage("Enter number of months."),
        "pleaseEnterValidDate":
            MessageLookupByLibrary.simpleMessage("Please enter a valid date"),
        "pleaseEnterValidMonths": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid number of months."),
        "pleaseSelectAtLeastOneItem": MessageLookupByLibrary.simpleMessage(
            "Please select at least one item you didn’t like."),
        "please_enter_valid_amount": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid amount (0 or greater)."),
        "please_select_the_category_above":
            MessageLookupByLibrary.simpleMessage(
                "Please select the category above"),
        "premiumFeatureTutorials":
            MessageLookupByLibrary.simpleMessage("Premium Feature Tutorials"),
        "previous": MessageLookupByLibrary.simpleMessage("Previous"),
        "pricePerWear": MessageLookupByLibrary.simpleMessage("Price Per Wear"),
        "privacyTerms": MessageLookupByLibrary.simpleMessage("Privacy Terms"),
        "privacyTermsUrl": MessageLookupByLibrary.simpleMessage(
            "https://www.notion.so/Privacy-Policy-9f21c7664efe4b03a8965252495dc1a6"),
        "private": MessageLookupByLibrary.simpleMessage("Private"),
        "profileSection": MessageLookupByLibrary.simpleMessage("Profile"),
        "public": MessageLookupByLibrary.simpleMessage("Public"),
        "publicClosetFeatureDescription": MessageLookupByLibrary.simpleMessage(
            "What if you could share items from your closet with neighbors and even host local sale events? Interested?"),
        "publicClosetFeatureTitle": MessageLookupByLibrary.simpleMessage(
            "Share Your Closet\nwith the Community"),
        "publicOrPrivate":
            MessageLookupByLibrary.simpleMessage("Public or Private"),
        "publicPrivateSelectionRequired": MessageLookupByLibrary.simpleMessage(
            "Please select public or private for a permanent closet."),
        "public_closet": MessageLookupByLibrary.simpleMessage("Public"),
        "purchase_button": MessageLookupByLibrary.simpleMessage("Unlock Now"),
        "quicklyFindItems": MessageLookupByLibrary.simpleMessage(
            "We’re thinking about adding advanced filters to help you find your items more easily. Sound good?"),
        "rainbow": MessageLookupByLibrary.simpleMessage("Multicolour"),
        "recommendClosetConscious": MessageLookupByLibrary.simpleMessage(
            "How likely are you to recommend Closet Conscious to a friend?"),
        "red": MessageLookupByLibrary.simpleMessage("Red"),
        "relatedOutfits":
            MessageLookupByLibrary.simpleMessage("Related Outfits"),
        "reminderDialogContent": MessageLookupByLibrary.simpleMessage(
            "Would you like me to remind you later to upload your closet?"),
        "reminderDialogTitle":
            MessageLookupByLibrary.simpleMessage("Remind Me Later"),
        "reservedClosetNameError": MessageLookupByLibrary.simpleMessage(
            "\'cc_closet\' is a reserved name. Please choose another."),
        "reset": MessageLookupByLibrary.simpleMessage("reset"),
        "resetToDefault":
            MessageLookupByLibrary.simpleMessage("Reset to Default"),
        "retryConnection":
            MessageLookupByLibrary.simpleMessage("Try Again? 🚀"),
        "reviewOutfitsInCalendar": MessageLookupByLibrary.simpleMessage(
            "We’re considering a calendar view for your outfits. Would this help you stay organized?"),
        "saveCustomization":
            MessageLookupByLibrary.simpleMessage("Save Customization"),
        "saveFilter": MessageLookupByLibrary.simpleMessage("Save Filter"),
        "scarf": MessageLookupByLibrary.simpleMessage("Scarf"),
        "scenarioTutorials":
            MessageLookupByLibrary.simpleMessage("Scenario Tutorials"),
        "seasonFieldNotFilled": MessageLookupByLibrary.simpleMessage(
            "Season field is not selected."),
        "selectAccessoryType":
            MessageLookupByLibrary.simpleMessage("Select Accessory Type"),
        "selectAll": MessageLookupByLibrary.simpleMessage("Select All"),
        "selectClosetLabel":
            MessageLookupByLibrary.simpleMessage("Select Closet"),
        "selectClothingLayer":
            MessageLookupByLibrary.simpleMessage("Select Clothing Layer"),
        "selectClothingType":
            MessageLookupByLibrary.simpleMessage("Select Clothing Type"),
        "selectColour": MessageLookupByLibrary.simpleMessage("Select Colour"),
        "selectColourVariation":
            MessageLookupByLibrary.simpleMessage("Select Colour Variation"),
        "selectDate": MessageLookupByLibrary.simpleMessage("Select a date"),
        "selectItemType":
            MessageLookupByLibrary.simpleMessage("Select Item Type"),
        "selectItemsToCreateOutfit": MessageLookupByLibrary.simpleMessage(
            "Select items to create your outfit."),
        "selectOccasion":
            MessageLookupByLibrary.simpleMessage("Select Occasion"),
        "selectSeason": MessageLookupByLibrary.simpleMessage("Select Season"),
        "selectShoeType":
            MessageLookupByLibrary.simpleMessage("Select Shoe Type"),
        "selfie": MessageLookupByLibrary.simpleMessage("Selfie"),
        "selfieBronzeDescription": MessageLookupByLibrary.simpleMessage(
            "Take 200 more selfies and keep your style on point!"),
        "selfieBronzeTitle":
            MessageLookupByLibrary.simpleMessage("Bronze Plan - Selfie"),
        "selfieGoldDescription": MessageLookupByLibrary.simpleMessage(
            "Unlimited selfies! Capture your looks whenever inspiration strikes."),
        "selfieGoldTitle":
            MessageLookupByLibrary.simpleMessage("Gold Plan - Selfie"),
        "selfieSilverDescription": MessageLookupByLibrary.simpleMessage(
            "Take 700 more selfies and show off your fashion progress!"),
        "selfieSilverTitle":
            MessageLookupByLibrary.simpleMessage("Silver Plan - Selfie"),
        "sell": MessageLookupByLibrary.simpleMessage("Sell"),
        "semiSynthetic": MessageLookupByLibrary.simpleMessage("Semi-Synthetic"),
        "share": MessageLookupByLibrary.simpleMessage("Share"),
        "shareFeatureDescription": MessageLookupByLibrary.simpleMessage(
            "Share your Outfit of the Day with one tap across all your social media. Elevate your style and inspire others effortlessly."),
        "shareFeatureTitle":
            MessageLookupByLibrary.simpleMessage("Effortless Outfit Sharing"),
        "shoes": MessageLookupByLibrary.simpleMessage("Shoes"),
        "shoesTypeRequired":
            MessageLookupByLibrary.simpleMessage("Shoes type is not selected."),
        "shortTagline":
            MessageLookupByLibrary.simpleMessage("Shop Your Closet"),
        "singleClosetShown":
            MessageLookupByLibrary.simpleMessage("Single Closet"),
        "social": MessageLookupByLibrary.simpleMessage("Social"),
        "somethingWentWrong":
            MessageLookupByLibrary.simpleMessage("Something went wrong! 😱"),
        "sortCategoryPickerTitle":
            MessageLookupByLibrary.simpleMessage("Sort Category Picker"),
        "sortOrderPickerTitle":
            MessageLookupByLibrary.simpleMessage("Sort Order Picker"),
        "specificTypeFieldNotFilled": MessageLookupByLibrary.simpleMessage(
            "Specific Type field is not selected."),
        "spendingTooltip": MessageLookupByLibrary.simpleMessage(
            "How much you’ve spent on new items so far"),
        "spring": MessageLookupByLibrary.simpleMessage("Spring"),
        "startFreeTrial":
            MessageLookupByLibrary.simpleMessage("Start Free Trial"),
        "streakBenefitsTitle": MessageLookupByLibrary.simpleMessage(
            "Your Streak, Your Style, Your Rewards"),
        "streakBenefitsUrl": MessageLookupByLibrary.simpleMessage(
            "https://www.notion.so/Pricing-0b17492513594b7b8975ec686eac1adf?pvs=4#cf77b531351848ed9be7ef80e95d6c2a"),
        "styleOn": MessageLookupByLibrary.simpleMessage("Review Outfit"),
        "success": MessageLookupByLibrary.simpleMessage("Success"),
        "summaryItemAnalytics":
            MessageLookupByLibrary.simpleMessage("Item\nInsights"),
        "summaryOutfitAnalytics":
            MessageLookupByLibrary.simpleMessage("Outfit Insights"),
        "summer": MessageLookupByLibrary.simpleMessage("Summer"),
        "supportAssistanceSection":
            MessageLookupByLibrary.simpleMessage("Support & Assistance"),
        "supportEmailBody":
            MessageLookupByLibrary.simpleMessage("Describe your issue here"),
        "supportEmailSubject":
            MessageLookupByLibrary.simpleMessage("Support Request"),
        "swap": MessageLookupByLibrary.simpleMessage("Swap"),
        "swapFeatureDescription": MessageLookupByLibrary.simpleMessage(
            "Interested in swapping items or getting notified about swap events nearby? We’re thinking about this feature—what do you think?"),
        "swapFeatureTitle": MessageLookupByLibrary.simpleMessage("Swap Items?"),
        "swap_item": MessageLookupByLibrary.simpleMessage("Swap QR"),
        "synthetic": MessageLookupByLibrary.simpleMessage("Synthetic"),
        "tabItemAnalytics":
            MessageLookupByLibrary.simpleMessage("Item Analytics"),
        "tabOutfitAnalytics":
            MessageLookupByLibrary.simpleMessage("Outfit Analytics"),
        "tagline": MessageLookupByLibrary.simpleMessage(
            "Shop Your Closet\nLove Your Style!"),
        "tailorExperience": MessageLookupByLibrary.simpleMessage(
            "We’ll tailor your Closet Conscious experience based on what matters to you most right now.\n\nNot sure? Pick what feels right — you can always update it later."),
        "tech": MessageLookupByLibrary.simpleMessage("Tech"),
        "termsAcknowledgement":
            MessageLookupByLibrary.simpleMessage("I have read the "),
        "termsAndConditions":
            MessageLookupByLibrary.simpleMessage("Terms and Conditions"),
        "termsAndConditionsUrl": MessageLookupByLibrary.simpleMessage(
            "https://www.notion.so/Service-Term-1a1b8f68ebba48158c0f42e19a135c6e"),
        "termsNotAcceptedMessage": MessageLookupByLibrary.simpleMessage(
            "You need to accept the terms and conditions before signing in."),
        "thankYou": MessageLookupByLibrary.simpleMessage("Thank You!"),
        "top": MessageLookupByLibrary.simpleMessage("Top"),
        "totalCost": MessageLookupByLibrary.simpleMessage("Total Cost"),
        "totalCostTooltip": MessageLookupByLibrary.simpleMessage(
            "Every piece is an investment—here’s what you\'ve spent! (This selection: total cost)"),
        "totalItems": MessageLookupByLibrary.simpleMessage("Total Items"),
        "totalItemsTooltip": MessageLookupByLibrary.simpleMessage(
            "Here’s the total count of what you’ve selected! (This selection: total items)"),
        "trackAnalyticsDescription": MessageLookupByLibrary.simpleMessage(
            "Track your cost per wear and get personalized outfit insights. Would this be helpful?"),
        "trialEndedMessage": MessageLookupByLibrary.simpleMessage(
            "Your premium trial period has ended."),
        "trialEndedNextSteps": MessageLookupByLibrary.simpleMessage(
            "Premium features are now locked. Access them anytime by  making a one-time purchase."),
        "trialEndedTitle":
            MessageLookupByLibrary.simpleMessage("Your Trial Has Ended"),
        "trialIncludedCalendar": MessageLookupByLibrary.simpleMessage(
            "Look back at your outfits on a calendar and link them across your closets."),
        "trialIncludedClosets": MessageLookupByLibrary.simpleMessage(
            "Create multiple closets – from permanent staples to seasonal disappearing wardrobes."),
        "trialIncludedCustomize": MessageLookupByLibrary.simpleMessage(
            "Customize your closet view – adjust grid size and sort by cost per wear, last worn, and more."),
        "trialIncludedDrawerInsights": MessageLookupByLibrary.simpleMessage(
            "Get smart insights into your wardrobe – track cost per wear and discover outfit ideas tailored to you."),
        "trialIncludedFilter": MessageLookupByLibrary.simpleMessage(
            "Easily find what you need with advanced filters."),
        "trialIncludedOutfits": MessageLookupByLibrary.simpleMessage(
            "Style and save as many outfits as you like, every day."),
        "trialIncludedTitle": MessageLookupByLibrary.simpleMessage(
            "What’s included in your trial"),
        "trialStartedMessage": MessageLookupByLibrary.simpleMessage(
            "Experience all the premium perks for 30 days. Totally free. No credit card needed."),
        "trialStartedNextSteps": MessageLookupByLibrary.simpleMessage(
            "You have successfully activated your premium features. All premium features are now available to enhance your experience."),
        "trialStartedNextStepsTitle":
            MessageLookupByLibrary.simpleMessage("Trial Activated!"),
        "trialStartedTitle":
            MessageLookupByLibrary.simpleMessage("Explore Premium Benefits"),
        "tutorialClosetUploadedTitle":
            MessageLookupByLibrary.simpleMessage("Closet Upload Tutorial"),
        "tutorialFreeCreateOutfitCreateOutfitProcess":
            MessageLookupByLibrary.simpleMessage("Process of creating outfits"),
        "tutorialFreeCreateOutfitOutfitSuggestion":
            MessageLookupByLibrary.simpleMessage(
                "Not sure what to wear today?"),
        "tutorialFreeCreateOutfitReviewOutfit":
            MessageLookupByLibrary.simpleMessage("Review your daily outfit"),
        "tutorialFreeCreateOutfitTitle": MessageLookupByLibrary.simpleMessage(
            "Weave new looks from familiar threads"),
        "tutorialFreeEditCameraDeclutterItems":
            MessageLookupByLibrary.simpleMessage("Declutter your items"),
        "tutorialFreeEditCameraTitle": MessageLookupByLibrary.simpleMessage(
            "Shape each piece into your narrative"),
        "tutorialFreePhotoLibraryTitle":
            MessageLookupByLibrary.simpleMessage("Upload from Photo Library"),
        "tutorialFreeUploadCameraTitle": MessageLookupByLibrary.simpleMessage(
            "Capture pieces, begin the story"),
        "tutorialFreeUploadCameraUploadClothing":
            MessageLookupByLibrary.simpleMessage(
                "Upload your clothing into the closet"),
        "tutorialHubTitle": MessageLookupByLibrary.simpleMessage("Tutorials"),
        "tutorialPaidCalendarPlanTrips": MessageLookupByLibrary.simpleMessage(
            "Easily create outfits for trip planning"),
        "tutorialPaidCalendarTitle": MessageLookupByLibrary.simpleMessage(
            "Outfit stories, one day at a time"),
        "tutorialPaidCalendarTrackFirstExperiences":
            MessageLookupByLibrary.simpleMessage("Track first experiences"),
        "tutorialPaidCustomizeCustomizeOrder":
            MessageLookupByLibrary.simpleMessage("Customize your ordering"),
        "tutorialPaidCustomizeTitle": MessageLookupByLibrary.simpleMessage(
            "Arrange your closet, your way"),
        "tutorialPaidCustomizeViewAllItems":
            MessageLookupByLibrary.simpleMessage("See all items in one glance"),
        "tutorialPaidFilterFindInCloset": MessageLookupByLibrary.simpleMessage(
            "Find clothing in a huge closet"),
        "tutorialPaidFilterSellUnworn":
            MessageLookupByLibrary.simpleMessage("Sell unworn clothing"),
        "tutorialPaidFilterTitle": MessageLookupByLibrary.simpleMessage(
            "Find what you need, when the moment calls"),
        "tutorialPaidFilterTrackFiltering":
            MessageLookupByLibrary.simpleMessage(
                "Don\'t lose track of filtering"),
        "tutorialPaidMultiClosetCreateCapsule":
            MessageLookupByLibrary.simpleMessage("Create capsule closets"),
        "tutorialPaidMultiClosetCreatePublicClosets":
            MessageLookupByLibrary.simpleMessage(
                "Create public closets for future sales"),
        "tutorialPaidMultiClosetDeleteClosets":
            MessageLookupByLibrary.simpleMessage("Delete excess closets"),
        "tutorialPaidMultiClosetSwapClosets":
            MessageLookupByLibrary.simpleMessage(
                "Swap items to another closet"),
        "tutorialPaidMultiClosetTitle": MessageLookupByLibrary.simpleMessage(
            "Step into a new chapter, any time"),
        "tutorialPaidMultiClosetViewUsableItems":
            MessageLookupByLibrary.simpleMessage("View items usable today"),
        "tutorialPaidUsageAnalyticsCostPerWear":
            MessageLookupByLibrary.simpleMessage("Know clothing cost per wear"),
        "tutorialPaidUsageAnalyticsInspirationForTrips":
            MessageLookupByLibrary.simpleMessage(
                "Get outfit inspiration for trips"),
        "tutorialPaidUsageAnalyticsOutfitSuggestions":
            MessageLookupByLibrary.simpleMessage(
                "Figure out what to wear today"),
        "tutorialPaidUsageAnalyticsSellUnworn":
            MessageLookupByLibrary.simpleMessage("Sell unworn clothing"),
        "tutorialPaidUsageAnalyticsTitle": MessageLookupByLibrary.simpleMessage(
            "Trace your style, one day at a time"),
        "tutorialScenarioTitle":
            MessageLookupByLibrary.simpleMessage("Scenario Tutorial"),
        "unableToProcessAccountDeletion": MessageLookupByLibrary.simpleMessage(
            "We’re unable to process your account deletion right now. Could you kindly email us at support@example.com for assistance?"),
        "unableToRetrieveUserId": MessageLookupByLibrary.simpleMessage(
            "Unable to retrieve user ID. Please sign in again."),
        "unexpectedErrorOccurred": MessageLookupByLibrary.simpleMessage(
            "Yikes! Something went wrong. Please try again later or contact support if it persists."),
        "unexpectedResponseFormat": MessageLookupByLibrary.simpleMessage(
            "Hmm, that was unexpected. Please try again or contact support."),
        "unknownError": MessageLookupByLibrary.simpleMessage(
            "Uh-oh, something went wrong. Please try again later!"),
        "unsavedChangesMessage": MessageLookupByLibrary.simpleMessage(
            "You have unsaved changes. Please save or discard them before selecting a photo."),
        "update": MessageLookupByLibrary.simpleMessage("Update"),
        "update_button_text":
            MessageLookupByLibrary.simpleMessage("Let’s Do It!"),
        "update_required_content": MessageLookupByLibrary.simpleMessage(
            "We’ve made some improvements you’ll love! Update now to keep your wardrobe fresh and sustainable."),
        "update_required_title":
            MessageLookupByLibrary.simpleMessage("Time to Refresh!"),
        "updatedAt": MessageLookupByLibrary.simpleMessage("Updated At"),
        "upload": MessageLookupByLibrary.simpleMessage("Upload"),
        "uploadConfirmationDescription": MessageLookupByLibrary.simpleMessage(
            "Confirm your closet upload! New items with a price will count as fresh additions, affecting your no-buy streak!"),
        "uploadConfirmationTitle":
            MessageLookupByLibrary.simpleMessage("Confirm Closet Completion"),
        "uploadItemBronzeDescription": MessageLookupByLibrary.simpleMessage(
            "Upload 200 more items to keep building your sustainable wardrobe!"),
        "uploadItemBronzeSuccessMessage": MessageLookupByLibrary.simpleMessage(
            "You\'ve unlocked space for 200 more items!\nKeep adding thoughtfully to build a sustainable wardrobe that reflects your unique style."),
        "uploadItemBronzeSuccessTitle": MessageLookupByLibrary.simpleMessage(
            "Congrats! 200 More Items to Your Conscious Closet"),
        "uploadItemBronzeTitle":
            MessageLookupByLibrary.simpleMessage("Bronze Plan - Upload Items"),
        "uploadItemGoldDescription": MessageLookupByLibrary.simpleMessage(
            "Unlimited uploads! Add as many items as you like to your conscious closet."),
        "uploadItemGoldSuccessMessage": MessageLookupByLibrary.simpleMessage(
            "You’ve unlocked unlimited space! Add as many items as you want and let your sustainable wardrobe reflect the best of your personal style."),
        "uploadItemGoldSuccessTitle": MessageLookupByLibrary.simpleMessage(
            "Limitless! Your Closet is Now Boundless"),
        "uploadItemGoldTitle":
            MessageLookupByLibrary.simpleMessage("Gold Plan - Upload Items"),
        "uploadItemSilverDescription": MessageLookupByLibrary.simpleMessage(
            "Upload 700 more items and keep your closet thriving!"),
        "uploadItemSilverSuccessMessage": MessageLookupByLibrary.simpleMessage(
            "Your closet just got bigger!\nYou can now add 700 more items. Keep refining your personal style while making eco-conscious choices."),
        "uploadItemSilverSuccessTitle": MessageLookupByLibrary.simpleMessage(
            "Amazing! 700 More Items to Express Your Style"),
        "uploadItemSilverTitle":
            MessageLookupByLibrary.simpleMessage("Silver Plan - Upload Items"),
        "uploadSuccessContent": MessageLookupByLibrary.simpleMessage(
            "Would you like to upload more items from your photo library?"),
        "uploadSuccessTitle":
            MessageLookupByLibrary.simpleMessage("Upload Successful"),
        "upload_failed": MessageLookupByLibrary.simpleMessage(
            "Oops! Looks like something went off the rails. Try again? 🚂"),
        "upload_successful": MessageLookupByLibrary.simpleMessage(
            "Success! Your closet just got a little more stylish! 🎉"),
        "usageAnalyticsFeatureTitle":
            MessageLookupByLibrary.simpleMessage("Your Closet Insights"),
        "usageAnalyticsTitle":
            MessageLookupByLibrary.simpleMessage("Usage Analytics"),
        "usageInsights": MessageLookupByLibrary.simpleMessage("Usage Insights"),
        "validDate": MessageLookupByLibrary.simpleMessage("Valid Date"),
        "validation_error": MessageLookupByLibrary.simpleMessage(
            "Error found. Check your input."),
        "viewClosetItemsButton":
            MessageLookupByLibrary.simpleMessage("View Closet Items"),
        "viewDailyCalendarDescription": MessageLookupByLibrary.simpleMessage(
            "See all details of your outfit for the day, including event name, comments, and feedback."),
        "viewMonthlyCalendarDescription": MessageLookupByLibrary.simpleMessage(
            "View all your outfits in a calendar format. Filter by event name, active outfit, and outfit feedback."),
        "viewMultiClosetDescription": MessageLookupByLibrary.simpleMessage(
            "Explore options for your multi-closets.\nYou can create a new multi-closet,\nedit items from all multi-closets,\nor make changes to a single multi-closet."),
        "viewOutfitAnalyticsDescription": MessageLookupByLibrary.simpleMessage(
            "Discover your style story—track how often you love, feel unsure about, or rethink your outfits."),
        "viewPendingUpload":
            MessageLookupByLibrary.simpleMessage("View Pending Upload"),
        "viewSummaryItemAnalyticsDescription": MessageLookupByLibrary.simpleMessage(
            "See your closet in numbers—total cost, item count, and cost per wear, all at a glance."),
        "warning": MessageLookupByLibrary.simpleMessage("Warning"),
        "wellLoved": MessageLookupByLibrary.simpleMessage("Well\nLoved"),
        "white": MessageLookupByLibrary.simpleMessage("White"),
        "whyAreYouHereToday":
            MessageLookupByLibrary.simpleMessage("Why are you here today?"),
        "winter": MessageLookupByLibrary.simpleMessage("Winter"),
        "workplace": MessageLookupByLibrary.simpleMessage("Workplace"),
        "wornInOutfit": MessageLookupByLibrary.simpleMessage("Worn in Outfit"),
        "yellow": MessageLookupByLibrary.simpleMessage("Yellow"),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
