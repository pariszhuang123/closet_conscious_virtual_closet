import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

class UploadSecondPage extends StatefulWidget {
  final Function(String occasion) onOccasionChanged;
  final Function(String season) onSeasonChanged;
  final Function(String color) onColorChanged;

  const UploadSecondPage({
    required this.onOccasionChanged,
    required this.onSeasonChanged,
    required this.onColorChanged,
    super.key,
  });

  @override
  UploadSecondPageState createState() => UploadSecondPageState();
}

class UploadSecondPageState extends State<UploadSecondPage> {
  String? selectedOccasion;
  String? selectedSeason;
  String? selectedColor;

  void _setSelectedOccasion(String occasion) {
    setState(() {
      selectedOccasion = occasion;
    });
    widget.onOccasionChanged(occasion);
  }

  void _setSelectedSeason(String season) {
    setState(() {
      selectedSeason = season;
    });
    widget.onSeasonChanged(season);
  }

  void _setSelectedColor(String color) {
    setState(() {
      selectedColor = color;
    });
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(S.of(context).ItemOccasionLabel, style: const TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOccasionIconButton(Icons.directions_walk, 'hiking'),
                _buildOccasionIconButton(Icons.family_restroom, 'casual'),
                _buildOccasionIconButton(Icons.work, 'workplace'),
                _buildOccasionIconButton(Icons.party_mode, 'social'),
                _buildOccasionIconButton(Icons.sports, 'event'),
              ],
            ),
            const SizedBox(height: 10),
            Text(S.of(context).ItemSeasonLabel, style: const TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSeasonIconButton(Icons.local_florist, 'spring'),
                _buildSeasonIconButton(Icons.wb_sunny, 'summer'),
                _buildSeasonIconButton(Icons.ac_unit, 'autumn'),
                _buildSeasonIconButton(Icons.waves, 'winter'),
              ],
            ),
            const SizedBox(height: 10),
            Text(S.of(context).ItemColourLabel, style: const TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildColorButton(Colors.red, 'red'),
                _buildColorButton(Colors.green, 'green'),
                _buildColorButton(Colors.blue, 'blue'),
                _buildColorButton(Colors.yellow, 'yellow'),
                _buildColorButton(Colors.black, 'black'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOccasionIconButton(IconData icon, String occasion) {
    return IconButton(
      icon: Icon(
        icon,
        size: 40,
        color: selectedOccasion == occasion ? Colors.white : Colors.black,
      ),
      color: selectedOccasion == occasion ? const Color(0xFF366d59) : Colors.transparent,
      onPressed: () => _setSelectedOccasion(occasion),
    );
  }

  Widget _buildSeasonIconButton(IconData icon, String season) {
    return IconButton(
      icon: Icon(
        icon,
        size: 40,
        color: selectedSeason == season ? Colors.white : Colors.black,
      ),
      color: selectedSeason == season ? const Color(0xFF366d59) : Colors.transparent,
      onPressed: () => _setSelectedSeason(season),
    );
  }

  Widget _buildColorButton(Color color, String colorName) {
    return GestureDetector(
      onTap: () => _setSelectedColor(colorName),
      child: Container(
        color: selectedColor == colorName ? const Color(0xFF366d59) : color,
        width: 40,
        height: 40,
        child: selectedColor == colorName ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    );
  }
}
