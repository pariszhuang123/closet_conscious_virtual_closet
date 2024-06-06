import 'package:flutter/material.dart';

class UploadOccasionSecondPage extends StatelessWidget {
  const UploadOccasionSecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Occasion', style: TextStyle(fontSize: 18)),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.directions_walk, size: 40),
                Icon(Icons.family_restroom, size: 40),
                Icon(Icons.work, size: 40),
                Icon(Icons.party_mode, size: 40),
                Icon(Icons.sports, size: 40),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Season', style: TextStyle(fontSize: 18)),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.local_florist, size: 40),
                Icon(Icons.wb_sunny, size: 40),
                Icon(Icons.ac_unit, size: 40),
                Icon(Icons.waves, size: 40),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Colour', style: TextStyle(fontSize: 18)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(color: Colors.red, width: 40, height: 40),
                Container(color: Colors.green, width: 40, height: 40),
                Container(color: Colors.blue, width: 40, height: 40),
                Container(color: Colors.yellow, width: 40, height: 40),
                Container(color: Colors.black, width: 40, height: 40),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
