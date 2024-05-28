import 'package:flutter/material.dart';
import 'package:codebets/style/text_style.dart';
import '../../style/color_style.dart';

class BetTargetDropdownFormField extends StatelessWidget {
  final List<String> usersList;
  final String? selectedUser;
  final ValueChanged<String?> onChanged;

  const BetTargetDropdownFormField({
    super.key,
    required this.usersList,
    required this.selectedUser,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target',
          style: TextStyleBets.inputTextTitle,
        ),
        Text(
          "Il Target non sarà consapevole della scommessa, ma al termine guadagnerà comunque 2 punti.",          style: TextStyleBets.targetTextDescription,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 4,),
        ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 70,
            maxHeight: 70,
          ),
          child: DropdownButtonFormField<String>(
            value: selectedUser,
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Nessun target'),
              ),
              ...usersList
                  .where((user) => user != 'admin')
                  .map((String user) {
                return DropdownMenuItem<String>(
                  value: user,
                  child: Text(user),
                );
              }),
            ],
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
              hintStyle: TextStyleBets.hintTextTitle,
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
            dropdownColor: ColorsBets.whiteHD,
            style: TextStyleBets.hintTextTitle,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
