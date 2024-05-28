import 'package:flutter/material.dart';
import 'package:codebets/style/text_style.dart';
import '../../style/color_style.dart';

class BetTitleFormField extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<String?> onSaved;

  const BetTitleFormField({
    super.key,
    required this.formKey,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Titolo della scommessa*',
          style: TextStyleBets.inputTextTitle,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 70,
            maxHeight: 70,
          ),
          child: TextSelectionTheme(
            data: TextSelectionThemeData(
              selectionColor: ColorsBets.blueHD.withOpacity(0.3),
              cursorColor: ColorsBets.blueHD.withOpacity(0.9),
            ),
            child: TextFormField(
              //cursor
              cursorOpacityAnimates: true,
              cursorRadius: const Radius.circular(20),
              cursorWidth: 2.5,
              //text
              enableSuggestions: false,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              style: TextStyleBets.hintTextTitle,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
                hintText: "Es. Domani pioverà?",
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
              maxLength: 70,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Inserisci il titolo della scommessa';
                }
                return null;
              },
              onSaved: onSaved,
            ),
          ),
        ),
      ],
    );
  }
}
