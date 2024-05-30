import 'package:flutter/material.dart';
import 'package:codebets/style/color_style.dart';

class TerminateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;

  const TerminateButton({
    super.key,
    required this.onPressed,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? ColorsBets.whiteHD : ColorsBets.blackHD,
        surfaceTintColor: ColorsBets.whiteHD,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.cancel_outlined,
            color: isEnabled ? Colors.red : ColorsBets.blackHD,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            'Termina',
            style: TextStyle(
              fontSize: 17,
              color: isEnabled ? Colors.red : ColorsBets.blackHD,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
