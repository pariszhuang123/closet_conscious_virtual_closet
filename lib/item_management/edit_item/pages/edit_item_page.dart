import '../../upload_item/widgets/upload_images/type_data.dart';
import '../../upload_item/widgets/upload_images/type_button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/supabase_config.dart';
import '../../../core/utilities/logger.dart';
import '../../../core/utilities/routes.dart';

import '../../core/data/models/closet_item_detailed.dart';
import '../../upload_item/widgets/image_display_widget.dart';


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
        _amountSpentError = 'Please enter a valid amount (0 or greater).';
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
      '_item_type': selectedItemType,
      '_image_url': finalImageUrl,
      '_name': _itemNameController.text.trim(),
      '_amount_spent': double.tryParse(_amountSpentController.text) ?? 0.0,
      '_occasion': selectedOccasion,
      '_season': selectedSeason,
      '_colour': selectedColour,
      '_colour_variations': selectedColourVariation,
    };

    if (selectedItemType == 'Clothing') {
      params['_clothing_type'] = selectedSpecificType;
      params['_clothing_layer'] = selectedClothingLayer;
    } else if (selectedItemType == 'Shoes') {
      params['_shoes_type'] = selectedSpecificType;
    } else if (selectedItemType == 'Accessory') {
      params['_accessory_type'] = selectedSpecificType;
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
    }
  }

  List<Widget> _buildIconRows(List<TypeData> typeDataList, String? selectedLabel, void Function(String) onTap) {
    List<Widget> rows = [];
    int index = 0;
    while (index < typeDataList.length) {
      int end = (index + 5) > typeDataList.length ? typeDataList.length : (index + 5);
      List<TypeData> rowIcons = typeDataList.sublist(index, end);
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rowIcons.map((type) {
            return TypeButton(
              label: type.name,
              selectedLabel: selectedLabel ?? '',
              onPressed: () {
                setState(() {
                  onTap(type.name);
                });
              },
              imageUrl: type.imageUrl, // Use assetPath instead of imageUrl
            );
          }).toList(),
        ),
      );
      index = end;
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.myClosetTheme,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Top Section: Image Display
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: ImageDisplayWidget(
                      imageUrl: _imageUrl,
                      file: _imageFile, // Use the file if a new image is picked
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
                              labelText: 'Item Name',
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an item name';
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
                              labelText: 'Amount Spent',
                              hintText: 'Enter amount spent',
                              errorText: _amountSpentError,
                              labelStyle: Theme.of(context).textTheme.bodyMedium,
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
                          const Text(
                            'Select Item Type',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ..._buildIconRows(
                            TypeDataList.itemGeneralTypes,
                            selectedItemType,
                                (name) => setState(() {
                                  _isChanged = true;
                                  selectedItemType = name;
                              selectedSpecificType = null; // Reset specific type when general type changes
                            }),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Select Occasion',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          ..._buildIconRows(
                            TypeDataList.occasions,
                            selectedOccasion,
                                (name) => setState(() {
                                  _isChanged = true;
                                  selectedOccasion = name;
                            }),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Select Season',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          ..._buildIconRows(
                            TypeDataList.seasons,
                            selectedSeason,
                                (name) => setState(() {
                                  _isChanged = true;
                                  selectedSeason = name;
                            }),
                          ),
                          const SizedBox(height: 12),
                          if (selectedItemType == 'Shoes') ...[
                            const Text(
                              'Select Shoe Type',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ..._buildIconRows(
                              TypeDataList.shoeTypes,
                              selectedSpecificType,
                                  (name) => setState(() {
                                    _isChanged = true;
                                    selectedSpecificType = name;
                              }),
                            ),
                          ],
                          if (selectedItemType == 'Accessory') ...[
                            const Text(
                              'Select Accessory Type',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ..._buildIconRows(
                              TypeDataList.accessoryTypes,
                              selectedSpecificType,
                                  (name) => setState(() {
                                    _isChanged = true;
                                    selectedSpecificType = name;
                              }),
                            ),
                          ],
                          if (selectedItemType == 'Clothing') ...[
                            const Text(
                              'Select Clothing Type',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ..._buildIconRows(
                              TypeDataList.clothingTypes,
                              selectedSpecificType,
                                  (name) => setState(() {
                                    _isChanged = true;
                                    selectedSpecificType = name;
                              }),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Select Clothing Layer',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ..._buildIconRows(
                              TypeDataList.clothingLayers,
                              selectedClothingLayer,
                                  (name) => setState(() {
                                    _isChanged = true;
                                    selectedClothingLayer = name;
                              }),
                            ),
                          ],
                          const SizedBox(height: 12),
                          const Text(
                            'Select Colour',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          ..._buildIconRows(
                            TypeDataList.colors,
                            selectedColour,
                                (name) => setState(() {
                                  _isChanged = true;
                                  selectedColour = name;
                            }),
                          ),
                          if (selectedColour != 'Black' && selectedColour != 'White' && selectedColour != null) ...[
                            const SizedBox(height: 12),
                            const Text(
                              'Select Colour Variation',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            ..._buildIconRows(
                              TypeDataList.colorVariations,
                              selectedColourVariation,
                                  (name) => setState(() {
                                    _isChanged = true;
                                    selectedColourVariation = name;
                              }),
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
                  child: Text(_isChanged ? 'Update' : 'Archived'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
