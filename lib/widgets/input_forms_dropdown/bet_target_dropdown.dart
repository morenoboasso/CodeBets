import 'package:flutter/material.dart';
import 'package:codebets/style/text_style.dart';
import '../../style/color_style.dart';

class BetTargetDropdownFormField extends StatelessWidget {
  final List<Map<String, String>> usersList;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Target',
              style: TextStyleBets.inputTextTitle,
            ),
            IconButton(
              icon: const Icon(Icons.info_outline, size: 24,),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Cos'è il target?", textAlign: TextAlign.center,),
                      content: const Text(
                        'Il target è la persona che sarà al centro della scommessa.\nQuesta persona non verrà informata della scommessa, ma alla fine otterrà 2 punti.',
                        textAlign: TextAlign.center,),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Chiudi'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
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
              ...usersList.map((Map<String, String> user) {
                return DropdownMenuItem<String>(
                  value: user['name'],
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user['pfp']!),
                        radius: 12,
                      ),
                      const SizedBox(width: 8),
                      Text(user['name']!),
                    ],
                  ),
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
