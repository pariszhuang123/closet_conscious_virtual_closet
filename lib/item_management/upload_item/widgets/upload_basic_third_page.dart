import 'package:flutter/material.dart';

class UploadReviewThirdPage extends StatefulWidget {
  final Function(String colorVariation) onColorVariationChanged;
  final Function(String clothingType) onClothingTypeChanged;
  final Function(String clothingLayer) onClothingLayerChanged;

  const UploadReviewThirdPage({
    required this.onColorVariationChanged,
    required this.onClothingTypeChanged,
    required this.onClothingLayerChanged,
    super.key,
  });

  @override
  UploadReviewThirdPageState createState() => UploadReviewThirdPageState();
}

class UploadReviewThirdPageState extends State<UploadReviewThirdPage> {
  String? selectedColorVariation;
  String? selectedClothingType;
  String? selectedClothingLayer;

  void _setSelectedColorVariation(String colorVariation) {
    setState(() {
      selectedColorVariation = colorVariation;
    });
    widget.onColorVariationChanged(colorVariation);
  }

  void _setSelectedClothingType(String clothingType) {
    setState(() {
      selectedClothingType = clothingType;
    });
    widget.onClothingTypeChanged(clothingType);
  }

  void _setSelectedClothingLayer(String clothingLayer) {
    setState(() {
      selectedClothingLayer = clothingLayer;
    });
    widget.onClothingLayerChanged(clothingLayer);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Colour Variations', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorVariationButton(Colors.black, 'dark'),
                _buildColorVariationButton(Colors.grey, 'medium'),
                _buildColorVariationButton(Colors.white, 'light'),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Clothing Type', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildClothingTypeButton(Icons.category, 'top'),
                _buildClothingTypeButton(Icons.shopping_bag, 'bottom'),
                _buildClothingTypeButton(Icons.emoji_objects, 'full-length'),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Clothing Layer', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildClothingLayerButton(Icons.category, 'base_layer'),
                _buildClothingLayerButton(Icons.shopping_bag, 'insulating_layer'),
                _buildClothingLayerButton(Icons.emoji_objects, 'outer_layer'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorVariationButton(Color color, String colorName) {
    return GestureDetector(
      onTap: () => _setSelectedColorVariation(colorName),
      child: Container(
        color: selectedColorVariation == colorName ? const Color(0xFF366d59) : color,
        width: 40,
        height: 40,
        child: selectedColorVariation == colorName ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }

  Widget _buildClothingTypeButton(IconData icon, String type) {
    return IconButton(
      icon: Icon(
        icon,
        size: 40,
        color: selectedClothingType == type ? Colors.white : Colors.black,
      ),
      color: selectedClothingType == type ? const Color(0xFF366d59) : Colors.transparent,
      onPressed: () => _setSelectedClothingType(type),
    );
  }

  Widget _buildClothingLayerButton(IconData icon, String layer) {
    return IconButton(
      icon: Icon(
        icon,
        size: 40,
        color: selectedClothingLayer == layer ? Colors.white : Colors.black,
      ),
      color: selectedClothingLayer == layer ? const Color(0xFF366d59) : Colors.transparent,
      onPressed: () => _setSelectedClothingLayer(layer),
    );
  }
}
