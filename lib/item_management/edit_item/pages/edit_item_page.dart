import '../../../core/data/type_data.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/supabase_config.dart';
import '../../../core/utilities/logger.dart';
import '../../../core/utilities/routes.dart';

import '../../upload_item/widgets/image_display_widget.dart';
import '../../../generated/l10n.dart';
import '../../../core/widgets/icon_row_builder.dart';
import '../widgets/declutter_options_bottom_sheet.dart';
import '../../../core/data/services/supabase/fetch_service.dart';


class EditItemPage extends StatefulWidget {
  final ThemeData myClosetTheme;
  final String itemId;

  const EditItemPage({super.key, required this.myClosetTheme, required this.itemId});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
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
  bool isLoading = true;

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
    _itemNameController = TextEditingController();
    _amountSpentController = TextEditingController();
    _fetchItemDetailsAndInitialize(widget.itemId);
  }

  Future<void> _fetchItemDetailsAndInitialize(String itemId) async {
    try {
      final item = await fetchItemDetails(itemId);

      if (mounted) {
        setState(() {
          _itemNameController.text = item.name;
          _amountSpentController.text = item.amountSpent.toString();
          _imageUrl = item.imageUrl;
          selectedItemType = item.itemType;
          selectedOccasion = item.occasion;
          selectedSeason = item.season;
          selectedColour = item.colour;
          selectedColourVariation = item.colourVariations;

          if (item.itemType == 'Clothing') {
            selectedSpecificType = item.clothingType;
            selectedClothingLayer = item.clothingLayer;
          } else if (item.itemType == 'Shoes') {
            selectedSpecificType = item.shoesType;
          } else if (item.itemType == 'Accessory') {
            selectedSpecificType = item.accessoryType;
          }
        });
      }
    } catch (error) {
      // Handle the error appropriately, e.g., show a snackbar or alert
      logger.e('Error initializing item details: $error');
    }
  }


  @override
  void dispose() {
    _itemNameController.dispose();
    _amountSpentController.dispose();
    super.dispose();
  }

  Future<void> _showDeclutterOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const DeclutterOptionsBottomSheet(isFromMyCloset: true);
      },
    );
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

  Future<void> _updateItemData() async {
    if (!_validateAmountSpent()) return;

    _setColourVariationToNullIfBlackOrWhite();

    final logger = CustomLogger('EditPage');
    String? finalImageUrl = _imageUrl;

    if (_imageFile != null) {
      final imageBytes = await _imageFile!.readAsBytes();
      final existingImagePath = Uri.parse(_imageUrl ?? '').path; // Extract the existing image path
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
      '_item_id': widget.itemId,
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).dataUpdatedSuccessfully)));
        Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
      } else {
        if (!mounted) return;
        final errorMessage = response.error?.message;
        logger.e('Error updating data: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${S.of(context).error}: $errorMessage')));
      }
    } catch (e) {
      if (!mounted) return;
      logger.e('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _handleUpdate() {
    if (_formKey.currentState?.validate() ?? false) {
      _updateItemData();
    } else {
      _showSpecificErrorMessages();
    }
  }

  void _showSpecificErrorMessages() {
    if (_itemNameController.text.isEmpty) {
      _showErrorMessage(S.of(context).itemNameFieldNotFilled);
    } else if (_amountSpentController.text.isEmpty) {
      _showErrorMessage(S.of(context).amountSpentFieldNotFilled);
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
        backgroundColor: widget.myClosetTheme.colorScheme.surface,
        appBar: AppBar(
          title: Text(S.of(context).editPageTitle, style: widget.myClosetTheme.textTheme.titleMedium),
          backgroundColor: widget.myClosetTheme.colorScheme.secondary,
          leading: _isChanged
              ? null
              : IconButton(
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
                                (dataKey) => setState(() {
                              _isChanged = true;
                              selectedItemType = dataKey;
                              selectedSpecificType = null;
                              selectedClothingLayer = null;
                            }),
                            context,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            S.of(context).selectOccasion,
                            style: widget.myClosetTheme.textTheme.bodyMedium,
                          ),
                          ...buildIconRows(
                            TypeDataList.occasions(context),
                            selectedOccasion,
                                (dataKey) => setState(() {
                              _isChanged = true;
                              selectedOccasion = dataKey;
                            }),
                            context,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            S.of(context).selectSeason,
                            style: widget.myClosetTheme.textTheme.bodyMedium,
                          ),
                          ...buildIconRows(
                            TypeDataList.seasons(context),
                            selectedSeason,
                                (dataKey) => setState(() {
                              _isChanged = true;
                              selectedSeason = dataKey;
                            }),
                            context,
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
                                  (dataKey) => setState(() {
                                _isChanged = true;
                                selectedSpecificType = dataKey;
                              }),
                              context,
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
                                  (dataKey) => setState(() {
                                _isChanged = true;
                                selectedSpecificType = dataKey;
                              }),
                              context,
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
                                  (dataKey) => setState(() {
                                _isChanged = true;
                                selectedSpecificType = dataKey;
                              }),
                              context,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              S.of(context).selectClothingLayer,
                              style: widget.myClosetTheme.textTheme.bodyMedium,
                            ),
                            ...buildIconRows(
                              TypeDataList.clothingLayers(context),
                              selectedClothingLayer,
                                  (dataKey) => setState(() {
                                _isChanged = true;
                                selectedClothingLayer = dataKey;
                              }),
                              context,
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
                                (dataKey) => setState(() {
                              _isChanged = true;
                              selectedColour = dataKey;
                            }),
                            context,
                          ),
                          if (selectedColour != 'Black' &&
                              selectedColour != 'White' &&
                              selectedColour != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              S.of(context).selectColourVariation,
                              style: widget.myClosetTheme.textTheme.bodyMedium,
                            ),
                            ...buildIconRows(
                              TypeDataList.colorVariations(context),
                              selectedColourVariation,
                                  (dataKey) => setState(() {
                                _isChanged = true;
                                selectedColourVariation = dataKey;
                              }),
                              context,
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
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 70.0, left: 16.0, right: 16.0),
                child: ElevatedButton(
                  onPressed: _isFormValid
                      ? _isChanged
                      ? _handleUpdate
                      : _showDeclutterOptions
                      : null,
                  child: Text(
                      _isChanged
                          ? S.of(context).update
                          : S.of(context).declutter,
                      style: widget.myClosetTheme.textTheme.labelLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
