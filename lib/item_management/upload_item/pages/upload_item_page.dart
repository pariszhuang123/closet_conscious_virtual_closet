import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';  // Make sure this import is used correctly
import '../widgets/upload_basic_first_page.dart';
import '../widgets/upload_basic_second_page.dart';
import '../widgets/upload_basic_third_page.dart';
import '../../../screens/my_closet.dart'; // Import the MyClosetPage
import '../../../core/config/supabase_config.dart';

class UploadItemPage extends StatefulWidget {
  const UploadItemPage({super.key});

  @override
  UploadItemPageState createState() => UploadItemPageState();
}

class UploadItemPageState extends State<UploadItemPage> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String? itemName;
  String? amount;
  String? itemType;
  String? occasion;
  String? season;
  String? color;
  String? colorVariation;
  String? clothingType;
  String? clothingLayer;

  String? itemNameError;
  String? amountError;
  String? itemTypeError;
  String? occasionError;
  String? seasonError;
  String? colorError;
  String? colorVariationError;
  String? clothingTypeError;
  String? clothingLayerError;

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = photo;
    });
  }

  @override
  void initState() {
    super.initState();
    _takePhoto();
  }

  void _nextPage() {
    if (_validateFields(_currentPage)) {
      if (_currentPage < 2) {
        setState(() {
          _currentPage++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        _uploadAndNavigate();
      }
    }
  }

  bool _validateFields(int currentPage) {
    setState(() {
      if (currentPage == 0) {
        itemNameError = itemName == null || itemName!.isEmpty ? 'Item Name is required' : null;
        amountError = amount == null || amount!.isEmpty ? 'Amount is required' : null;
        itemTypeError = itemType == null ? 'Item Type is required' : null;
      } else if (currentPage == 1) {
        occasionError = occasion == null ? 'Occasion is required' : null;
        seasonError = season == null ? 'Season is required' : null;
        colorError = color == null ? 'Color is required' : null;
      } else if (currentPage == 2) {
        colorVariationError = colorVariation == null ? 'Color Variation is required' : null;
        clothingTypeError = clothingType == null ? 'Clothing Type is required' : null;
        clothingLayerError = clothingLayer == null ? 'Clothing Layer is required' : null;
      }
    });

    if (currentPage == 0) {
      return itemNameError == null && amountError == null && itemTypeError == null;
    } else if (currentPage == 1) {
      return occasionError == null && seasonError == null && colorError == null;
    } else if (currentPage == 2) {
      return colorVariationError == null && clothingTypeError == null && clothingLayerError == null;
    }

    return false;
  }

  Future<void> _uploadAndNavigate() async {
    // Validate that all required data is present
    if (itemName != null &&
        amount != null &&
        itemType != null &&
        occasion != null &&
        season != null &&
        color != null &&
        colorVariation != null &&
        clothingType != null &&
        clothingLayer != null) {
      final response = await SupabaseConfig.client
          .from('items')
          .insert({
        'name': itemName,
        'amount': amount,
        'item_type': itemType,
        'occasion': occasion,
        'season': season,
        'color': color,
        'color_variation': colorVariation,
        'clothing_type': clothingType,
        'clothing_layer': clothingLayer,
      });

      if (!mounted) return; // Check if the widget is still mounted

      if (response.error != null) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${response.error!.message}'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data uploaded successfully'),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to MyClosetPage
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyClosetPage()),
          );
        }
      }
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onDataChanged(String newItemName, String newAmount, String newItemType) {
    setState(() {
      itemName = newItemName;
      amount = newAmount;
      itemType = newItemType;
    });
  }

  void _onOccasionChanged(String newOccasion) {
    setState(() {
      occasion = newOccasion;
    });
  }

  void _onSeasonChanged(String newSeason) {
    setState(() {
      season = newSeason;
    });
  }

  void _onColorChanged(String newColor) {
    setState(() {
      color = newColor;
    });
  }

  void _onColorVariationChanged(String newColorVariation) {
    setState(() {
      colorVariation = newColorVariation;
    });
  }

  void _onClothingTypeChanged(String newClothingType) {
    setState(() {
      clothingType = newClothingType;
    });
  }

  void _onClothingLayerChanged(String newClothingLayer) {
    setState(() {
      clothingLayer = newClothingLayer;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Item'),
      ),
      body: _image == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _image != null
              ? Image.file(
            File(_image!.path),  // Use the File constructor from dart:io
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          )
              : const Text('No image selected.'),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                UploadBasicFirstPage(onDataChanged: _onDataChanged),
                UploadSecondPage(
                  onOccasionChanged: _onOccasionChanged,
                  onSeasonChanged: _onSeasonChanged,
                  onColorChanged: _onColorChanged,
                ),
                UploadReviewThirdPage(
                  onColorVariationChanged: _onColorVariationChanged,
                  onClothingTypeChanged: _onClothingTypeChanged,
                  onClothingLayerChanged: _onClothingLayerChanged,
                ),
              ],
            ),
          ),
          if (itemNameError != null)
            Text(
              itemNameError!,
              style: const TextStyle(color: Colors.red),
            ),
          if (amountError != null)
            Text(
              amountError!,
              style: const TextStyle(color: Colors.red),
            ),
          if (itemTypeError != null)
            Text(
              itemTypeError!,
              style: const TextStyle(color: Colors.red),
            ),
          if (occasionError != null)
            Text(
              occasionError!,
              style: const TextStyle(color: Colors.red),
            ),
          if (seasonError != null)
            Text(
              seasonError!,
              style: const TextStyle(color: Colors.red),
            ),
          if (colorError != null)
            Text(
              colorError!,
              style: const TextStyle(color: Colors.red),
            ),
          if (colorVariationError != null)
            Text(
              colorVariationError!,
              style: const TextStyle(color: Colors.red),
            ),
          if (clothingTypeError != null)
            Text(
              clothingTypeError!,
              style: const TextStyle(color: Colors.red),
            ),
          if (clothingLayerError != null)
            Text(
              clothingLayerError!,
              style: const TextStyle(color: Colors.red),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _nextPage,
              child: Text(
                _currentPage == 2 ? 'Upload' : 'Next',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
