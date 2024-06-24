import '../../../core/data/type_data.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/supabase_config.dart';
import '../../../core/utilities/logger.dart';
import '../../../core/utilities/routes.dart';

import '../../core/data/models/closet_item_detailed.dart';
import '../../upload_item/widgets/image_display_widget.dart';
import '../../../generated/l10n.dart';
import '../../../core/widgets/icon_row_builder.dart';


class EditPage extends StatefulWidget {
  final ClosetItemDetailed item;
  final ThemeData myClosetTheme;

  const EditPage({super.key, required this.item, required this.myClosetTheme});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final TextEditingController _itemNameController;
  late final TextEditingController _amountSpentController;
  File? _imageFile;
  String? _imageUrl;
  String? selectedItemType;
  String? selectedSpecificType;
  String? selectedClothingLayer;
  String? _amountSpentError;
  String? selectedOccasion;
  String? selectedSeason;
  String? selectedColour;
  String? selectedColourVariation;

  final _formKey = GlobalKey<FormState>();
  bool _isChanged = false;

  final ImagePicker _picker = ImagePicker();

  late final String initialName;
  late final double initialAmountSpent;
  late final String? initialImageUrl;
  late final String? initialItemType;
  late final String? initialSpecificType;
  late final String? initialClothingLayer;
  late final String? initialOccasion;
  late final String? initialSeason;
  late final String? initialColour;
  late final String? initialColourVariation;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.item.name);
    _amountSpentController = TextEditingController(text: widget.item.amountSpent.toString());
    _imageUrl = widget.item.imageUrl;
    selectedItemType = widget.item.runtimeType.toString().replaceAll('Item', '');
    selectedOccasion = widget.item.occasion;
    selectedSeason = widget.item.season;
    selectedColour = widget.item.colour;
    selectedColourVariation = widget.item.colourVariations;
    if (widget.item is ClothingItem) {
      final clothingItem = widget.item as ClothingItem;
      selectedSpecificType = clothingItem.clothingType;
      selectedClothingLayer = clothingItem.clothingLayer;
    } else if (widget.item is ShoesItem) {
      final shoesItem = widget.item as ShoesItem;
      selectedSpecificType = shoesItem.shoesType;
    } else if (widget.item is AccessoryItem) {
      final accessoryItem = widget.item as AccessoryItem;
      selectedSpecificType = accessoryItem.accessoryType;
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _amountSpentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isChanged = true;
      });
    }
  }

  bool _validateAmountSpent() {
    final amountSpentText = _amountSpentController.text;
    if (amountSpentText.isEmpty) {
      setState(() {
        _amountSpentError = null;
      });
      return true;
    }

    final amountSpent = double.tryParse(amountSpentText);
    if (amountSpent == null || amountSpent < 0) {
      setState(() {
        _amountSpentError = S.of(context).please_enter_valid_amount;
      });
      return false;
    }

    setState(() {
      _amountSpentError = null;
    });
    return true;
  }

  void _setColourVariationToNullIfBlackOrWhite() {
    if (selectedColour == 'Black' || selectedColour == 'White') {
      selectedColourVariation = null;
    }
  }

  bool get _isFormValid {
    final amountSpentText = _amountSpentController.text;
    final amountSpent = double.tryParse(amountSpentText);
    if (_itemNameController.text.isEmpty) return false;
    if (amountSpentText.isNotEmpty && (amountSpent == null || amountSpent < 0)) return false;
    if (selectedItemType == null) return false;
    if (selectedOccasion == null) return false;
    if (selectedSeason == null) return false;
    if (selectedSpecificType == null) return false;
    if (selectedItemType == 'Clothing' && selectedClothingLayer == null) return false;
    if (selectedColour == null) return false;
    if (selectedColour != 'Black' && selectedColour != 'White' && selectedColourVariation == null) return false;
    return true;
  }

  Future<void> _saveData() async {
    if (!_validateAmountSpent()) return;

    _setColourVariationToNullIfBlackOrWhite();

    final logger = CustomLogger('EditPage');
    String? finalImageUrl = _imageUrl;

    if (_imageFile != null) {
      final imageBytes = await _imageFile!.readAsBytes();
      final existingImagePath = Uri.parse(_imageUrl!).path; // Extract the existing image path
      final imagePath = existingImagePath.startsWith('/') ? existingImagePath.substring(1) : existingImagePath; // Ensure the path does not start with '/'

      try {
        await SupabaseConfig.client.storage.from('item_pics').uploadBinary(
          imagePath,
          imageBytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

        finalImageUrl = SupabaseConfig.client.storage.from('item_pics').getPublicUrl(imagePath);
        finalImageUrl = Uri.parse(finalImageUrl).replace(queryParameters: {
          't': DateTime.now().millisecondsSinceEpoch.toString()
        }).toString();
      } catch (e) {
        if (!mounted) return;
        logger.e('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        return;
      }
    }

    final Map<String, dynamic> params = {
      '_item_id': widget.item.itemId,
      if (finalImageUrl != initialImageUrl) '_image_url': finalImageUrl,
      if (_itemNameController.text.trim() != initialName) '_name': _itemNameController.text.trim(),
      if (double.tryParse(_amountSpentController.text) != initialAmountSpent)
        '_amount_spent': double.tryParse(_amountSpentController.text) ?? 0.0,
      if (selectedOccasion != initialOccasion) '_occasion': selectedOccasion,
      if (selectedSeason != initialSeason) '_season': selectedSeason,
      if (selectedColour != initialColour) '_colour': selectedColour,
      if (selectedColourVariation != initialColourVariation) '_colour_variations': selectedColourVariation,
    };

    if (selectedItemType == 'Clothing') {
      if (selectedSpecificType != initialSpecificType) params['_clothing_type'] = selectedSpecificType;
      if (selectedClothingLayer != initialClothingLayer) params['_clothing_layer'] = selectedClothingLayer;
    } else if (selectedItemType == 'Shoes') {
      if (selectedSpecificType != initialSpecificType) params['_shoes_type'] = selectedSpecificType;
    } else if (selectedItemType == 'Accessory') {
      if (selectedSpecificType != initialSpecificType) params['_accessory_type'] = selectedSpecificType;
    }

    try {
      final response = await SupabaseConfig.client.rpc(
        selectedItemType == 'Clothing'
            ? 'update_clothing_metadata'
            : selectedItemType == 'Shoes'
            ? 'update_shoes_metadata'
            : 'update_accessory_metadata',
        params: params,
      );

      if (response == null || response.error == null) {
        if (!mounted) return;
        logger.i('Data updated successfully');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your data has been updated')));
        Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
      } else {
        if (!mounted) return;
        final errorMessage = response.error?.message;
        logger.e('Error updating data: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
      }
    } catch (e) {
      if (!mounted) return;
      logger.e('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _handleUpload() {
    if (_formKey.currentState?.validate() ?? false) {
      _saveData();
    } else {
      _showSpecificErrorMessages();
    }
  }

  void _showSpecificErrorMessages() {
    if (_itemNameController.text.isEmpty) {
      _showErrorMessage(S.of(context).itemNameFieldNotFilled);
    } else if (_amountSpentError != null) {
      _showErrorMessage(S.of(context).amountSpentFieldNotValid);
    } else if (_amountSpentError == null) {
      _showErrorMessage(S.of(context).amountSpentFieldNotValid);
    } else if (selectedItemType == null) {
      _showErrorMessage(S.of(context).itemTypeFieldNotFilled);
    } else if (selectedOccasion == null) {
      _showErrorMessage(S.of(context).occasionFieldNotFilled);
    }
    if (selectedSeason == null) {
      _showErrorMessage(S.of(context).seasonFieldNotFilled);
    } else if (selectedSpecificType == null) {
      _showErrorMessage(S.of(context).specificTypeFieldNotFilled);
    } else if (selectedItemType == 'Clothing' && selectedClothingLayer == null) {
      _showErrorMessage(S.of(context).clothingLayerFieldNotFilled);
    }
    if (selectedColour == null) {
      _showErrorMessage(S.of(context).colourFieldNotFilled);
    } else if (selectedColour != 'Black' && selectedColour != 'White' && selectedColourVariation == null) {
      _showErrorMessage(S.of(context).colourVariationFieldNotFilled);
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: widget.myClosetTheme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).editPageTitle, style: widget.myClosetTheme.textTheme.titleMedium), // Assuming you have a localization key for "Edit Page"
          backgroundColor: widget.myClosetTheme.colorScheme.primaryContainer,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: widget.myClosetTheme.colorScheme.onPrimary),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Top Section: Image Display
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: ImageDisplayWidget(
                        imageUrl: _imageUrl,
                        file: _imageFile,
                      ),
                    ),
                  ),
                ),
              ),
              // Metadata Section
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _itemNameController,
                            decoration: InputDecoration(
                              labelText: S.of(context).item_name,
                              labelStyle: widget.myClosetTheme.textTheme.bodyMedium,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S.of(context).pleaseEnterItemName;
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _isChanged = true;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _amountSpentController,
                            decoration: InputDecoration(
                              labelText: S.of(context).amountSpentLabel,
                              hintText: S.of(context).enterAmountSpentHint,
                              errorText: _amountSpentError,
                              labelStyle: widget.myClosetTheme.textTheme.bodyMedium,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _validateAmountSpent();
                              setState(() {
                                _isChanged = true;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          Text(
                            S.of(context).selectItemType,
                            style: widget.myClosetTheme.textTheme.bodyMedium,
                          ),
                          ...buildIconRows(
                              TypeDataList.itemGeneralTypes(context),
                              selectedItemType,
                                  (name) => setState(() {
                                _isChanged = true;
                                selectedItemType = TypeDataList.itemGeneralTypes(context).firstWhere((item) => item.getName(context) == name).key;
                                selectedSpecificType = null;
                              }),
                              context
                          ),
                          const SizedBox(height: 12),
                          Text(
                            S.of(context).selectOccasion,
                            style: widget.myClosetTheme.textTheme.bodyMedium,
                          ),
                          ...buildIconRows(
                              TypeDataList.occasions(context),
                              selectedOccasion,
                                  (name) => setState(() {
                                _isChanged = true;
                                selectedOccasion = TypeDataList.occasions(context).firstWhere((item) => item.getName(context) == name).key;
                              }),
                              context
                          ),
                          const SizedBox(height: 12),
                          Text(
                            S.of(context).selectSeason,
                            style: widget.myClosetTheme.textTheme.bodyMedium,
                          ),
                          ...buildIconRows(
                              TypeDataList.seasons(context),
                              selectedSeason,
                                  (name) => setState(() {
                                _isChanged = true;
                                selectedSeason = TypeDataList.seasons(context).firstWhere((item) => item.getName(context) == name).key;
                              }),
                              context
                          ),
                          const SizedBox(height: 12),
                          if (selectedItemType == 'Shoes') ...[
                            Text(
                              S.of(context).selectShoeType,
                              style: widget.myClosetTheme.textTheme.bodyMedium,
                            ),
                            ...buildIconRows(
                                TypeDataList.shoeTypes(context),
                                selectedSpecificType,
                                    (name) => setState(() {
                                  _isChanged = true;
                                  selectedSpecificType = TypeDataList.shoeTypes(context).firstWhere((item) => item.getName(context) == name).key;
                                }),
                                context
                            ),
                          ],
                          if (selectedItemType == 'Accessory') ...[
                            Text(
                              S.of(context).selectAccessoryType,
                              style: widget.myClosetTheme.textTheme.bodyMedium,
                            ),
                            ...buildIconRows(
                                TypeDataList.accessoryTypes(context),
                                selectedSpecificType,
                                    (name) => setState(() {
                                  _isChanged = true;
                                  selectedSpecificType = TypeDataList.accessoryTypes(context).firstWhere((item) => item.getName(context) == name).key;
                                }),
                                context
                            ),
                          ],
                          if (selectedItemType == 'Clothing') ...[
                            Text(
                              S.of(context).selectClothingType,
                              style: widget.myClosetTheme.textTheme.bodyMedium,
                            ),
                            ...buildIconRows(
                                TypeDataList.clothingTypes(context),
                                selectedSpecificType,
                                    (name) => setState(() {
                                  _isChanged = true;
                                  selectedSpecificType = TypeDataList.clothingTypes(context).firstWhere((item) => item.getName(context) == name).key;
                                }),
                                context
                            ),
                            const SizedBox(height: 12),
                            Text(
                              S.of(context).selectClothingLayer,
                              style: widget.myClosetTheme.textTheme.bodyMedium,
                            ),
                            ...buildIconRows(
                                TypeDataList.clothingLayers(context),
                                selectedClothingLayer,
                                    (name) => setState(() {
                                  _isChanged = true;
                                  selectedClothingLayer = TypeDataList.clothingLayers(context).firstWhere((item) => item.getName(context) == name).key;
                                }),
                                context
                            ),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            S.of(context).selectColour,
                            style: widget.myClosetTheme.textTheme.bodyMedium,
                          ),
                          ...buildIconRows(
                              TypeDataList.colors(context),
                              selectedColour,
                                  (name) => setState(() {
                                _isChanged = true;
                                selectedColour = TypeDataList.colors(context).firstWhere((item) => item.getName(context) == name).key;
                              }),
                              context
                          ),
                          if (selectedColour != 'Black' && selectedColour != 'White' && selectedColour != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              S.of(context).selectColourVariation,
                              style: widget.myClosetTheme.textTheme.bodyMedium,
                            ),
                            ...buildIconRows(
                                TypeDataList.colorVariations(context),
                                selectedColourVariation,
                                    (name) => setState(() {
                                  _isChanged = true;
                                  selectedColourVariation = TypeDataList.colorVariations(context).firstWhere((item) => item.getName(context) == name).key;
                                }),
                                context
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom Section: Button
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 70.0, left: 16.0, right: 16.0),
                child: ElevatedButton(
                  onPressed: _isFormValid ? _handleUpload : null,
                  child: Text(_isChanged ? S.of(context).update : S.of(context).archived, style: widget.myClosetTheme.textTheme.labelLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}