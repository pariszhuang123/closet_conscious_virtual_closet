import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/image_display_widget.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/utilities/logger.dart';
import '../../../core/utilities/routes.dart';

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
        (amountSpentText.isEmpty || (amountSpent != null && amountSpent >= 0));
  }

  bool get _isFormValidPage2 {
    return selectedOccasion != null &&
        selectedSeason != null &&
        selectedSpecificType != null &&
        (selectedItemType != 'clothing' || selectedClothingLayer != null);
  }

  bool get _isFormValidPage3 {
    if (selectedColour == null) {
      return false;
    }
    if (selectedColour != 'black' && selectedColour != 'white' && selectedColourVariation == null) {
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
        _amountSpentError = null; // Clear the error if the field is empty
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

  Future<void> _saveData() async {
    if (!_validateAmountSpent()) return;

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

    if (selectedItemType == 'clothing') {
      params['_clothing_type'] = selectedSpecificType;
      params['_clothing_layer'] = selectedClothingLayer;
    } else if (selectedItemType == 'shoes') {
      params['_shoes_type'] = selectedSpecificType;
    } else if (selectedItemType == 'accessory') {
      params['_accessory_type'] = selectedSpecificType;
    }

    try {
      final response = await SupabaseConfig.client.rpc(
        selectedItemType == 'clothing'
            ? 'upload_clothing_metadata'
            : selectedItemType == 'shoes'
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
    } else if (_amountSpentError == null) {
      _showErrorMessage('Amount Spent field is not filled.');
    } else if (selectedItemType == null) {
      _showErrorMessage('Item Type field is not filled.');
    }
  }

  void _showSpecificErrorMessagesPage2() {
    if (selectedOccasion == null) {
      _showErrorMessage('Occasion field is not filled.');
    } else if (selectedSeason == null) {
      _showErrorMessage('Season field is not filled.');
    } else if (selectedSpecificType == null) {
      _showErrorMessage('Item Type field is not filled.');
    } else if (selectedItemType == 'clothing' && selectedClothingLayer == null) {
      _showErrorMessage('Clothing Layer field is not filled.');
    }
  }

  void _showSpecificErrorMessagesPage3() {
    if (selectedColour == null) {
      _showErrorMessage('Colour field is not filled.');
    } else if (selectedColour != 'black' && selectedColour != 'white' && selectedColourVariation == null) {
      _showErrorMessage('Colour Variation field is not filled.');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.myClosetTheme,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Top Section: Image Display
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ImageDisplayWidget(
                    imageUrl: _imageUrl,
                  ),
                ),
                // Middle Section: Metadata Pages
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // First Page
                      Form(
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
                              Wrap(
                                spacing: 8.0,
                                children: TypeDataList.itemGeneralTypes.map((type) {
                                  return TypeButton(
                                    label: type.name,
                                    selectedLabel: selectedItemType ?? '',
                                    onPressed: () {
                                      setState(() {
                                        selectedItemType = type.name;
                                      });
                                    },
                                    imageUrl: type.imageUrl,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Second Page
                      Form(
                        key: _formKeyPage2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Select Occasion',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Wrap(
                                spacing: 8.0,
                                children: TypeDataList.occasions.map((occasion) {
                                  return TypeButton(
                                    label: occasion.name,
                                    selectedLabel: selectedOccasion ?? '',
                                    onPressed: () {
                                      setState(() {
                                        selectedOccasion = occasion.name;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Select Season',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Wrap(
                                spacing: 8.0,
                                children: TypeDataList.seasons.map((season) {
                                  return TypeButton(
                                    label: season.name,
                                    selectedLabel: selectedSeason ?? '',
                                    onPressed: () {
                                      setState(() {
                                        selectedSeason = season.name;
                                      });
                                    },
                                    imageUrl: season.imageUrl,
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 12),
                              if (selectedItemType == 'shoes') ...[
                                const Text(
                                  'Select Shoe Type',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Wrap(
                                  spacing: 8.0,
                                  children: TypeDataList.shoeTypes.map((shoeType) {
                                    return TypeButton(
                                      label: shoeType.name,
                                      selectedLabel: selectedSpecificType ?? '',
                                      onPressed: () {
                                        setState(() {
                                          selectedSpecificType = shoeType.name;
                                        });
                                      },
                                      imageUrl: shoeType.imageUrl,
                                    );
                                  }).toList(),
                                ),
                              ],
                              if (selectedItemType == 'accessory') ...[
                                const Text(
                                  'Select Accessory Type',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Wrap(
                                  spacing: 8.0,
                                  children: TypeDataList.accessoryTypes.map((accessoryType) {
                                    return TypeButton(
                                      label: accessoryType.name,
                                      selectedLabel: selectedSpecificType ?? '',
                                      onPressed: () {
                                        setState(() {
                                          selectedSpecificType = accessoryType.name;
                                        });
                                      },
                                      imageUrl: accessoryType.imageUrl,
                                    );
                                  }).toList(),
                                ),
                              ],
                              if (selectedItemType == 'clothing') ...[
                                const Text(
                                  'Select Clothing Type',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Wrap(
                                  spacing: 8.0,
                                  children: TypeDataList.clothingTypes.map((clothingType) {
                                    return TypeButton(
                                      label: clothingType.name,
                                      selectedLabel: selectedSpecificType ?? '',
                                      onPressed: () {
                                        setState(() {
                                          selectedSpecificType = clothingType.name;
                                        });
                                      },
                                      imageUrl: clothingType.imageUrl,
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Select Clothing Layer',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Wrap(
                                  spacing: 8.0,
                                  children: TypeDataList.clothingLayers.map((clothingLayer) {
                                    return TypeButton(
                                      label: clothingLayer.name,
                                      selectedLabel: selectedClothingLayer ?? '',
                                      onPressed: () {
                                        setState(() {
                                          selectedClothingLayer = clothingLayer.name;
                                        });
                                      },
                                      imageUrl: clothingLayer.imageUrl,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      // Third Page
                      Form(
                        key: _formKeyPage3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Select Colour',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Wrap(
                                spacing: 8.0,
                                children: TypeDataList.colors.map((color) {
                                  return TypeButton(
                                    label: color.name,
                                    selectedLabel: selectedColour ?? '',
                                    onPressed: () {
                                      setState(() {
                                        selectedColour = color.name;
                                      });
                                    },
                                    imageUrl: color.imageUrl,
                                  );
                                }).toList(),
                              ),
                              if (selectedColour != 'black' && selectedColour != 'white' && selectedColour != null) ...[
                                const SizedBox(height: 12),
                                const Text(
                                  'Select Colour Variation',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Wrap(
                                  spacing: 8.0,
                                  children: TypeDataList.colorVariations.map((variation) {
                                    return TypeButton(
                                      label: variation.name,
                                      selectedLabel: selectedColourVariation ?? '',
                                      onPressed: () {
                                        setState(() {
                                          selectedColourVariation = variation.name;
                                        });
                                      },
                                      imageUrl: variation.imageUrl,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bottom Section: Navigation and Submission Button
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0, left: 16.0, right: 16.0),
                  child: ElevatedButton(
                    onPressed: _currentPage == 0
                        ? _handleNext
                        : _currentPage == 1
                        ? _handleNext
                        : _handleUpload,
                    child: Text(_currentPage == 0
                        ? 'Next'
                        : _currentPage == 1
                        ? 'Next'
                        : 'Upload'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
