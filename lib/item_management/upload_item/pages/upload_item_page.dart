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
  const UploadItemPage({super.key});

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
        selectedColourVariation != null &&
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
        _amountSpentError = null;  // Clear the error if the field is empty
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

  Widget _buildShoeTypeButton(String shoeType) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedSpecificType = shoeType;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedSpecificType == shoeType ? Colors.blue : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(shoeType),
    );
  }

  Widget _buildAccessoryTypeButton(String accessoryType) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedSpecificType = accessoryType;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedSpecificType == accessoryType ? Colors.blue : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(accessoryType),
    );
  }

  Widget _buildClothingTypeButton(String clothingType) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedSpecificType = clothingType;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedSpecificType == clothingType ? Colors.blue : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(clothingType),
    );
  }

  Widget _buildClothingLayerButton(String clothingLayer) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedClothingLayer = clothingLayer;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedClothingLayer == clothingLayer ? Colors.blue : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(clothingLayer),
    );
  }

  Widget _buildOccasionButton(String occasion) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedOccasion = occasion;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedOccasion == occasion ? Colors.blue : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(occasion),
    );
  }

  Widget _buildSeasonButton(String season) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedSeason = season;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedSeason == season ? Colors.blue : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(season),
    );
  }

  Widget _buildColourButton(String colour) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedColour = colour;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedColour == colour ? Colors.blue : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(colour),
    );
  }

  Widget _buildColourVariationButton(String colourVariation) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedColourVariation = colourVariation;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedColourVariation == colourVariation ? Colors.blue : Colors.grey,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(colourVariation),
    );
  }

  @override
  Widget build(BuildContext context) {
    _validateAmountSpent();

    return Scaffold(
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
            decoration: const InputDecoration(
              label: Text('Item Name'),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _amountSpentController,
            decoration: InputDecoration(
              label: const Text('Amount Spent'),
              hintText: 'Enter amount spent',
              errorText: _amountSpentError,
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
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedItemType = 'clothing';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedItemType == 'clothing' ? Colors.blue : Colors.grey,
                ),
                child: const Text('Clothing'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedItemType = 'shoes';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedItemType == 'shoes' ? Colors.blue : Colors.grey,
                ),
                child: const Text('Shoes'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedItemType = 'accessory';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedItemType == 'accessory' ? Colors.blue : Colors.grey,
                ),
                child: const Text('Accessories'),
              ),
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
                _buildShoeTypeButton('boots'),
                _buildShoeTypeButton('casual shoes'),
                _buildShoeTypeButton('running shoes'),
                _buildShoeTypeButton('dress shoes'),
                _buildShoeTypeButton('speciality shoes'),
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
                _buildAccessoryTypeButton('bag'),
                _buildAccessoryTypeButton('belt'),
                _buildAccessoryTypeButton('eyewear'),
                _buildAccessoryTypeButton('gloves'),
                _buildAccessoryTypeButton('hat'),
                _buildAccessoryTypeButton('jewellery'),
                _buildAccessoryTypeButton('scarf and wrap'),
                _buildAccessoryTypeButton('tie & bowtie'),
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
                _buildClothingTypeButton('top'),
                _buildClothingTypeButton('bottom'),
                _buildClothingTypeButton('full-length'),
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
                _buildClothingLayerButton('base_layer'),
                _buildClothingLayerButton('insulating_layer'),
                _buildClothingLayerButton('outer_layer'),
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
              _buildOccasionButton('active'),
              _buildOccasionButton('casual'),
              _buildOccasionButton('workplace'),
              _buildOccasionButton('social'),
              _buildOccasionButton('event'),
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
              _buildSeasonButton('spring'),
              _buildSeasonButton('summer'),
              _buildSeasonButton('autumn'),
              _buildSeasonButton('winter'),
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
              _buildColourButton('red'),
              _buildColourButton('blue'),
              _buildColourButton('green'),
              _buildColourButton('yellow'),
              _buildColourButton('brown'),
              _buildColourButton('grey'),
              _buildColourButton('rainbow'),
              _buildColourButton('black'),
              _buildColourButton('white'),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Select Colour Variation',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Wrap(
            spacing: 8.0,
            children: [
              _buildColourVariationButton('light'),
              _buildColourVariationButton('medium'),
              _buildColourVariationButton('dark'),
            ],
          ),
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
    );
  }
}
