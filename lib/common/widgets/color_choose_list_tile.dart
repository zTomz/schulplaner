import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:schulplaner/config/theme/numbers.dart';

class ColorChooseListTile extends StatelessWidget {
  final Color color;
  final void Function(Color newColor) onColorChanged;

  const ColorChooseListTile({
    super.key,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Color"),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radii.small),
      ),
      onTap: () async {
        final newColor = await _chooseColor(
          context,
          color,
        );

        onColorChanged(newColor);
      },
      trailing: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: const SizedBox.square(dimension: 30),
      ),
    );
  }

  Future<Color> _chooseColor(BuildContext context, Color color) async {
    // Create a seperate variable, so the input variable is not changed
    Color pickerColor = color;

    final choosenColor = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wähle eine Farbe'),
        content: SingleChildScrollView(
          child: HueRingPicker(
            pickerColor: pickerColor,
            onColorChanged: (changeColor) {
              pickerColor = changeColor;
            },
            portraitOnly: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Schließen"),
          ),
          const SizedBox(width: Spacing.small),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(
                pickerColor,
              );
            },
            child: const Text("Bestätigen"),
          ),
        ],
      ),
    );

    return choosenColor ?? color;
  }
}
