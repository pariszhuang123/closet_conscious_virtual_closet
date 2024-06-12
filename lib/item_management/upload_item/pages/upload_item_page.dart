import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/upload_basic_first_page.dart';
import '../widgets/upload_basic_second_page.dart';
import '../widgets/upload_basic_third_page.dart';
import '../presentation/utils/image_picker_helper.dart';
import '../presentation/utils/navigation_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user_management/authentication/presentation/bloc/authentication_bloc.dart';
import '../widgets/image_display_widget.dart';

String? itemName;
String? amount;
String? itemType;
String? occasion;
String? season;
String? color;
String? colorVariation;
String? clothingType;
String? clothingLayer;


class UploadItemPage extends StatefulWidget {
  const UploadItemPage({super.key});

  @override
  UploadItemPageState createState() => UploadItemPageState();
}

class UploadItemPageState extends State<UploadItemPage> {
  XFile? _image;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

  @override
  void initState() {
    super.initState();
    _takePhoto();
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _imagePickerHelper.takePhoto();
    setState(() {
      _image = photo;
    });
  }

  void _nextPage() {
    NavigationHelper.nextPage(
      context,
      _pageController,
      _currentPage,
          (int _) => true,  // Bypass validation by always returning true
          () => NavigationHelper.uploadAndNavigate(
        context,
        context.read<AuthBloc>(), // Get authBloc from context
        itemName,
        amount,
        itemType,
        occasion,
        season,
        color,
        colorVariation,
        clothingType,
        clothingLayer,
        _image?.path,
      ),
    );
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
          ImageDisplayWidget(
            imageFile: _image != null ? File(_image!.path) : null,
          ),
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
