import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../style/color_style.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const ColorPickerDialog({required this.initialColor, super.key});

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: ColorsBets.whiteHD,
      backgroundColor: ColorsBets.whiteHD,
      title: const Text('Colore Squadra'),
        content: BlockPicker(
          pickerColor: _currentColor,
          onColorChanged: (color) {
            setState(() {
              _currentColor = color;
            });
          },
          availableColors: const [
            TeamColors.green,
            TeamColors.blue,
            TeamColors.purple,
            TeamColors.silver,
            TeamColors.yellow,
            TeamColors.orange,
            TeamColors.red,
            TeamColors.brown
          ],
        ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annulla'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_currentColor);
          },
          child: const Text('Seleziona'),
        ),
      ],
    );
  }
}
