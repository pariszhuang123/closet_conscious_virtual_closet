import 'package:flutter/material.dart';
import 'avatar.dart';
import '../../../core/config/supabase_config.dart';

class UploadItemPage extends StatefulWidget {
  const UploadItemPage({super.key});

  @override
  State<UploadItemPage> createState() => _UploadItemPageState();
}

class _UploadItemPageState extends State<UploadItemPage> {
  final _itemNameController = TextEditingController();
  final _amountSpentController = TextEditingController();
  String? _imageUrl;
  String? selectedItemType;
  String? selectedSpecificType;
  String? selectedClothingLayer;

  String? selectedOccasion;
  String? selectedSeason;
  String? selectedColour;
  String? selectedColourVariation;

  String? _amountSpentError;

  @override
  void initState() {
    super.initState();
    _getInitialProfile();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _amountSpentController.dispose();
    super.dispose();
  }

  Future<void> _getInitialProfile() async {
    final userId = SupabaseConfig.client.auth.currentUser!.id;
    final data =
    await SupabaseConfig.client.from('item_pics').select().eq('id', userId).single();
    setState(() {
      _imageUrl = data['avatar_url'];
    });
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
    bool isValid = _validateAmountSpent();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Item'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Avatar(
              imageUrl: _imageUrl,
              onUpload: (imageUrl) async {
                setState(() {
                  _imageUrl = imageUrl;
                });
                final userId = SupabaseConfig.client.auth.currentUser!.id;
                await SupabaseConfig.client
                    .from('item_pics')
                    .update({'avatar_url': imageUrl}).eq('id', userId);
              },
               itemName: _itemNameController.text.trim(),
               amountSpent: double.tryParse(_amountSpentController.text) ?? 0.0,
               itemType: selectedItemType ?? '',
               shoesType: selectedSpecificType,
               accessoryType: selectedSpecificType,
               clothingType: selectedSpecificType,
               clothingLayer: selectedClothingLayer,

               occasion: selectedOccasion,
               season: selectedSeason,
               colour: selectedColour,
               colourVariations: selectedColourVariation,
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
            onPressed: isValid ? () async {
              final userId = SupabaseConfig.client.auth.currentUser!.id;

              await SupabaseConfig.client.from('item_pics').update({
              }).eq('id', userId);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Your data has been saved')));
    }
                : null,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

