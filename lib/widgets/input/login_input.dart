import 'package:flutter/material.dart';
import 'package:codebets/style/text_style.dart';
import '../../style/color_style.dart';

class CustomTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const CustomTextField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        selectionColor: ColorsBets.blueHD.withOpacity(0.5),
        cursorColor: ColorsBets.blueHD.withOpacity(0.9),
      ),
      child: TextField(
        // cursor
        cursorOpacityAnimates: true,
        cursorRadius: const Radius.circular(20),
        cursorWidth: 2.5,
        // text
        enableSuggestions: true,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.left,
        textCapitalization: TextCapitalization.words,
        style: TextStyleBets.inputTextLogin,
        // forma + hint
        decoration: InputDecoration(
          hintText: 'Inserisci il tuo nome...',
          hintStyle: TextStyleBets.hintTextLogin,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          fillColor: ColorsBets.whiteHD,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: ColorsBets.blueHD,
              width: 2.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: ColorsBets.blueHD,
              width: 2.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: ColorsBets.blueHD,
              width: 2.5,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
