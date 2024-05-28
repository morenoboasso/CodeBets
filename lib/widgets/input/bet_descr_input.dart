import 'package:flutter/material.dart';
import 'package:codebets/style/text_style.dart';
import '../../style/color_style.dart';

class BetDescriptionFormField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const BetDescriptionFormField({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descrizione',
          style: TextStyleBets.inputTextTitle,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 70,
            maxHeight: 150,
          ),
          child: TextSelectionTheme(
            data: TextSelectionThemeData(
              selectionColor: ColorsBets.blueHD.withOpacity(0.3),
              cursorColor: ColorsBets.blueHD.withOpacity(0.9),
            ),
            child: TextFormField(
              cursorOpacityAnimates: true,
              cursorRadius: const Radius.circular(20),
              cursorWidth: 2.5,
              style: TextStyleBets.hintTextTitle,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                hintText: "Es. La scommessa finisce venerdì",
                hintStyle: TextStyleBets.hintTextAnswer,
                fillColor: ColorsBets.whiteHD,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: ColorsBets.blueHD.withOpacity(0.8),
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: ColorsBets.blueHD.withOpacity(0.8),
                    width: 2.0,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: null,
              maxLength: 150,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
