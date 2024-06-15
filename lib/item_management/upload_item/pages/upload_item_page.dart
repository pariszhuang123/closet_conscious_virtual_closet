import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import 'avatar.dart';
import '../../../core/config/supabase_config.dart';
import '../../../core/utilities/logger.dart';
import '../../../core/utilities/routes.dart';

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

  bool get _isFormValid {
    final amountSpentText = _amountSpentController.text;
    final amountSpent = double.tryParse(amountSpentText);
    return selectedItemType != null &&
        selectedSpecificType != null &&
        (selectedItemType != 'clothing' || selectedClothingLayer != null) &&
        selectedOccasion != null &&
        selectedSeason != null &&
        selectedColour != null &&
        _itemNameController.text.isNotEmpty &&
        (amountSpentText.isEmpty || (amountSpent != null && amountSpent >= 0));
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
        logger.e('Error uploading image: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
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
        logger.i('Data inserted successfully');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your data has been saved')));
          Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
        }
      } else {
        final errorMessage = response.error?.message;
        logger.e('Error inserting data: $errorMessage');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
        }
      }
    } catch (e) {
      logger.e('Unexpected error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Widget _buildTypeButton(String type, String selectedType, Function() onPressed) {
    bool isSelected = selectedType == type;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({MaterialState.selected})
            : Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}),
        foregroundColor: isSelected
            ? Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({MaterialState.selected})
            : Theme.of(context).elevatedButtonTheme.style?.foregroundColor?.resolve({}),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(type),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.myClosetTheme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Item'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Avatar(
              imageUrl: _imageUrl,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _itemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTypeButton('clothing', selectedItemType ?? '', () {
                  setState(() {
                    selectedItemType = 'clothing';
                  });
                }),
                const SizedBox(width: 10),
                _buildTypeButton('shoes', selectedItemType ?? '', () {
                  setState(() {
                    selectedItemType = 'shoes';
                  });
                }),
                const SizedBox(width: 10),
                _buildTypeButton('accessory', selectedItemType ?? '', () {
                  setState(() {
                    selectedItemType = 'accessory';
                  });
                }),
              ],
            ),
            const SizedBox(height: 12),
            if (selectedItemType == 'shoes') ...[
              const Text(
                'Select Shoe Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildTypeButton('boots', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'boots';
                    });
                  }),
                  _buildTypeButton('casual shoes', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'casual shoes';
                    });
                  }),
                  _buildTypeButton('running shoes', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'running shoes';
                    });
                  }),
                  _buildTypeButton('dress shoes', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'dress shoes';
                    });
                  }),
                  _buildTypeButton('speciality shoes', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'speciality shoes';
                    });
                  }),
                ],
              ),
            ],
            if (selectedItemType == 'accessory') ...[
              const Text(
                'Select Accessory Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildTypeButton('bag', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'bag';
                    });
                  }),
                  _buildTypeButton('belt', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'belt';
                    });
                  }),
                  _buildTypeButton('eyewear', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'eyewear';
                    });
                  }),
                  _buildTypeButton('gloves', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'gloves';
                    });
                  }),
                  _buildTypeButton('hat', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'hat';
                    });
                  }),
                  _buildTypeButton('jewellery', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'jewellery';
                    });
                  }),
                  _buildTypeButton('scarf and wrap', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'scarf and wrap';
                    });
                  }),
                  _buildTypeButton('tie & bowtie', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'tie & bowtie';
                    });
                  }),
                ],
              ),
            ],
            if (selectedItemType == 'clothing') ...[
              const Text(
                'Select Clothing Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildTypeButton('top', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'top';
                    });
                  }),
                  _buildTypeButton('bottom', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'bottom';
                    });
                  }),
                  _buildTypeButton('full-length', selectedSpecificType ?? '', () {
                    setState(() {
                      selectedSpecificType = 'full-length';
                    });
                  }),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Select Clothing Layer',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildTypeButton('base_layer', selectedClothingLayer ?? '', () {
                    setState(() {
                      selectedClothingLayer = 'base_layer';
                    });
                  }),
                  _buildTypeButton('insulating_layer', selectedClothingLayer ?? '', () {
                    setState(() {
                      selectedClothingLayer = 'insulating_layer';
                    });
                  }),
                  _buildTypeButton('outer_layer', selectedClothingLayer ?? '', () {
                    setState(() {
                      selectedClothingLayer = 'outer_layer';
                    });
                  }),
                ],
              ),
            ],
            const SizedBox(height: 12),
            const Text(
              'Select Occasion',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: [
                _buildTypeButton('active', selectedOccasion ?? '', () {
                  setState(() {
                    selectedOccasion = 'active';
                  });
                }),
                _buildTypeButton('casual', selectedOccasion ?? '', () {
                  setState(() {
                    selectedOccasion = 'casual';
                  });
                }),
                _buildTypeButton('workplace', selectedOccasion ?? '', () {
                  setState(() {
                    selectedOccasion = 'workplace';
                  });
                }),
                _buildTypeButton('social', selectedOccasion ?? '', () {
                  setState(() {
                    selectedOccasion = 'social';
                  });
                }),
                _buildTypeButton('event', selectedOccasion ?? '', () {
                  setState(() {
                    selectedOccasion = 'event';
                  });
                }),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Select Season',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: [
                _buildTypeButton('spring', selectedSeason ?? '', () {
                  setState(() {
                    selectedSeason = 'spring';
                  });
                }),
                _buildTypeButton('summer', selectedSeason ?? '', () {
                  setState(() {
                    selectedSeason = 'summer';
                  });
                }),
                _buildTypeButton('autumn', selectedSeason ?? '', () {
                  setState(() {
                    selectedSeason = 'autumn';
                  });
                }),
                _buildTypeButton('winter', selectedSeason ?? '', () {
                  setState(() {
                    selectedSeason = 'winter';
                  });
                }),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Select Colour',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8.0,
              children: [
                _buildTypeButton('red', selectedColour ?? '', () {
                  setState(() {
                    selectedColour = 'red';
                  });
                }),
                _buildTypeButton('blue', selectedColour ?? '', () {
                  setState(() {
                    selectedColour = 'blue';
                  });
                }),
                _buildTypeButton('green', selectedColour ?? '', () {
                  setState(() {
                    selectedColour = 'green';
                  });
                }),
                _buildTypeButton('yellow', selectedColour ?? '', () {
                  setState(() {
                    selectedColour = 'yellow';
                  });
                }),
                _buildTypeButton('brown', selectedColour ?? '', () {
                  setState(() {
                    selectedColour = 'brown';
                  });
                }),
                _buildTypeButton('grey', selectedColour ?? '', () {
                  setState(() {
                    selectedColour = 'grey';
                  });
                }),
                _buildTypeButton('rainbow', selectedColour ?? '', () {
                  setState(() {
                    selectedColour = 'rainbow';
                  });
                }),
                _buildTypeButton('black', selectedColour ?? '', () {
                  setState(() {
                    selectedColour = 'black';
                    selectedColourVariation = null;
                  });
                }),
                _buildTypeButton('white', selectedColour ?? '', () {
                  setState(() {
                    selectedColour = 'white';
                    selectedColourVariation = null;
                  });
                }),
              ],
            ),
            if (selectedColour != 'black' && selectedColour != 'white' && selectedColour != null) ...[
              const SizedBox(height: 12),
              const Text(
                'Select Colour Variation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildTypeButton('light', selectedColourVariation ?? '', () {
                    setState(() {
                      selectedColourVariation = 'light';
                    });
                  }),
                  _buildTypeButton('medium', selectedColourVariation ?? '', () {
                    setState(() {
                      selectedColourVariation = 'medium';
                    });
                  }),
                  _buildTypeButton('dark', selectedColourVariation ?? '', () {
                    setState(() {
                      selectedColourVariation = 'dark';
                    });
                  }),
                ],
              ),
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isFormValid
                  ? () async {
                await _saveData();
              }
                  : null,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
