import 'package:flutter/material.dart';
import 'package:codebets/style/color_style.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isEnabled;

  const ConfirmButton({
    super.key,
    required this.onPressed,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsBets.whiteHD,
        surfaceTintColor: ColorsBets.whiteHD,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: ColorsBets.greenHD, width: 1.5),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outlined, color: ColorsBets.greenHD, size: 20,),
          SizedBox(width: 4),
          Text(
            'Conferma',
            style: TextStyle(fontSize:17, color: ColorsBets.greenHD, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
