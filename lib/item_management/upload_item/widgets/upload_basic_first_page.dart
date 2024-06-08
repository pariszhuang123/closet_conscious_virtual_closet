import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

class UploadBasicFirstPage extends StatefulWidget {
  final Function(String itemName, String amount, String itemType) onDataChanged;

  const UploadBasicFirstPage({required this.onDataChanged, super.key});

  @override
  UploadBasicFirstPageState createState() => UploadBasicFirstPageState();
}

class UploadBasicFirstPageState extends State<UploadBasicFirstPage> {
  String? itemName;
  String? amount;
  String? itemType;
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: itemNameController,
              decoration: InputDecoration(
                labelText: S.of(context).ItemNameLabel,
                hintText: S.of(context).ItemNameHint,
              ),
              onChanged: (value) {
                setState(() {
                  itemName = value;
                });
                widget.onDataChanged(itemName!, amount ?? '', itemType ?? '');
              },
            ),
            TextFormField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: S.of(context).AmountLabel,
                hintText: S.of(context).AmountHint,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  amount = value;
                });
                widget.onDataChanged(itemName ?? '', amount!, itemType ?? '');
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIconButton(Icons.category, 'clothing'),
                _buildIconButton(Icons.shopping_bag, 'accessory'),
                _buildIconButton(Icons.emoji_objects, 'shoes'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, String type) {
    return IconButton(
      icon: Icon(
        icon,
        size: 40,
        color: itemType == type ? Colors.white : Colors.black,
      ),
      color: itemType == type ? const Color(0xFF366d59) : Colors.transparent,
      onPressed: () {
        setState(() {
          itemType = type;
        });
        widget.onDataChanged(itemName ?? '', amount ?? '', itemType!);
      },
    );
  }
}
