import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/image_display_widget.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/utilities/logger.dart';
import '../../../core/utilities/routes.dart';
import '../../../core/theme/my_closet_theme.dart';

import '../widgets/upload_images/type_data.dart';
import '../widgets/upload_images/type_button.dart';

class UploadItemPage extends StatefulWidget {
  final ThemeData myClosetTheme;

  const UploadItemPage({super.key, required this.myClosetTheme});

  @override
  State<UploadItemPage> createState() => _UploadItemPageState();
}

class _UploadItemPageState extends State<UploadItemPage> {
  final _itemNameController = TextEditingController();
  final _amountSpentController = TextEditingController();
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

  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _formKeyPage1 = GlobalKey<FormState>();
  final _formKeyPage2 = GlobalKey<FormState>();
  final _formKeyPage3 = GlobalKey<FormState>();

  bool get _isFormValidPage1 {
    final amountSpentText = _amountSpentController.text;
    final amountSpent = double.tryParse(amountSpentText);
    return selectedItemType != null &&
        _itemNameController.text.isNotEmpty &&
        (amountSpentText.isEmpty || (amountSpent != null && amountSpent >= 0)) &&
        selectedOccasion != null;
  }

  bool get _isFormValidPage2 {
    return selectedSeason != null &&
        selectedSpecificType != null &&
        (selectedItemType != 'Clothing' || selectedClothingLayer != null);
  }

  bool get _isFormValidPage3 {
    if (selectedColour == null) {
      return false;
    }
    if (selectedColour != 'Black' && selectedColour != 'White' && selectedColourVariation == null) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _capturePhoto();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _amountSpentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _imageUrl = _imageFile!.path;
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

  Future<void> _saveData() async {
    if (!_validateAmountSpent()) return;

    _setColourVariationToNullIfBlackOrWhite();

    final logger = CustomLogger('UploadItemPage');
    final userId = SupabaseConfig.client.auth.currentUser!.id;
    String? finalImageUrl = _imageUrl;

    if (_imageFile != null) {
      final imageBytes = await _imageFile!.readAsBytes();
      final uuid = const Uuid().v4();
      final imagePath = '/$userId/$uuid.jpg';

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
            ? 'upload_clothing_metadata'
            : selectedItemType == 'Shoes'
            ? 'upload_shoes_metadata'
            : 'upload_accessory_metadata',
        params: params,
      );


      if (response == null || response.error == null) {
        if (!mounted) return;
        logger.i('Data inserted successfully');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your data has been saved')));
        Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
      } else {
        if (!mounted) return;
        final errorMessage = response.error?.message;
        logger.e('Error inserting data: $errorMessage');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
      }
    } catch (e) {
      if (!mounted) return;
      logger.e('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _handleNext() {
    if (_currentPage == 0) {
      if (_isFormValidPage1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = 1;
        });
      } else {
        _showSpecificErrorMessagesPage1();
      }
    } else if (_currentPage == 1) {
      if (_isFormValidPage2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = 2;
        });
      } else {
        _showSpecificErrorMessagesPage2();
      }
    } else if (_currentPage == 2) {
      if (_isFormValidPage3) {
        _handleUpload();
      } else {
        _showSpecificErrorMessagesPage3();
      }
    }
  }

  void _handleUpload() {
    if (_isFormValidPage3) {
      _saveData();
    } else {
      _showSpecificErrorMessagesPage3();
    }
  }

  void _showSpecificErrorMessagesPage1() {
    if (_itemNameController.text.isEmpty) {
      _showErrorMessage('Item Name field is not filled.');
    } else if (_amountSpentError != null) {
      _showErrorMessage('Amount Spent field is not valid.');
    } else if (selectedItemType == null) {
      _showErrorMessage('Item Type field is not filled.');
    } else if (selectedOccasion == null) {
      _showErrorMessage('Occasion field is not filled.');
    }
  }

  void _showSpecificErrorMessagesPage2() {
    if (selectedSeason == null) {
      _showErrorMessage('Season field is not filled.');
    } else if (selectedSpecificType == null) {
      _showErrorMessage('Specific Type field is not filled.');
    } else if (selectedItemType == 'Clothing' && selectedClothingLayer == null) {
      _showErrorMessage('Clothing Layer field is not filled.');
    }
  }

  void _showSpecificErrorMessagesPage3() {
    if (selectedColour == null) {
      _showErrorMessage('Colour field is not filled.');
    } else if (selectedColour != 'Black' && selectedColour != 'White' &&
        selectedColourVariation == null) {
      _showErrorMessage('Colour Variation field is not filled.');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: myClosetTheme.textTheme.bodyMedium,
      ),
      backgroundColor: myClosetTheme.colorScheme.error,
    ));
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
        child: PopScope(
        canPop: false, // Set to false to disable back navigation
        onPopInvoked: (didPop) async {
      // Custom logic to handle back button press
      if (didPop) {
        // Pop was successful
        Navigator.pushReplacementNamed(context, '/my_closet');
      } else {
        // Pop was not successful
        // Handle accordingly
      }
      return;
    },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Top Section: Image Display
              Padding(
                padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ImageDisplayWidget(
                    imageUrl: _imageUrl,
                  ),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // First Page
                    SingleChildScrollView(
                      child: Form(
                        key: _formKeyPage1,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                    (name) => selectedItemType = name,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Select Occasion',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              ..._buildIconRows(
                                TypeDataList.occasions,
                                selectedOccasion,
                                    (name) => selectedOccasion = name,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Second Page
                    SingleChildScrollView(
                      child: Form(
                        key: _formKeyPage2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Select Season',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              ..._buildIconRows(
                                TypeDataList.seasons,
                                selectedSeason,
                                    (name) => selectedSeason = name,
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
                                      (name) => selectedSpecificType = name,
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
                                      (name) => selectedSpecificType = name,
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
                                      (name) => selectedSpecificType = name,
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Select Clothing Layer',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                ..._buildIconRows(
                                  TypeDataList.clothingLayers,
                                  selectedClothingLayer,
                                      (name) => selectedClothingLayer = name,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Third Page
                    SingleChildScrollView(
                      child: Form(
                        key: _formKeyPage3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Select Colour',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              ..._buildIconRows(
                                TypeDataList.colors,
                                selectedColour,
                                    (name) => selectedColour = name,
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
                                      (name) => selectedColourVariation = name,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0, bottom: 70.0, left: 16.0, right: 16.0),
                child: ElevatedButton(
                  onPressed: _handleNext,
                  child: Text(_currentPage == 2 ? 'Upload' : 'Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
