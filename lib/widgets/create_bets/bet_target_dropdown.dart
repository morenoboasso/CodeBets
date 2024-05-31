import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:codebets/style/text_style.dart';
import 'package:get_storage/get_storage.dart';
import '../../style/color_style.dart';

class BetTargetDropdownFormField extends StatelessWidget {
  final List<Map<String, String>> usersList;
  final String? selectedUser;
  final ValueChanged<String?> onChanged;
  final String? currentUser = GetStorage().read<String>('userName');

   BetTargetDropdownFormField({
    super.key,
    required this.usersList,
    required this.selectedUser,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredUsersList = usersList.where((user) => user['name'] != currentUser).toList();

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
                      backgroundColor: ColorsBets.whiteHD,
                      surfaceTintColor: ColorsBets.whiteHD,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        side: BorderSide(color: ColorsBets.blueHD, width:3.0),
                      ),
                      title:  Text("Cos'è il 'Target' ?", textAlign: TextAlign.center,style: TextStyleBets.dialogTitle,),
                      content: const AutoSizeText(
                        'Il Target è la persona che sarà al centro della scommessa.\nQuesta persona non verrà informata della scommessa, ma alla fine otterrà 2 punti.',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.justify,
                        maxFontSize: 18,
                        minFontSize: 12,
                        maxLines: 5,
                      ),
                      actions: <Widget>[
                        //bottone chiudi dialog
                        Center(
                          child: _buildActionButton(
                            label: 'Chiudi',
                            color: Colors.red.withOpacity(0.8),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
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
              ...filteredUsersList.map((Map<String, String> user) {
                return DropdownMenuItem<String>(
                  value: user['name'],
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user['pfp']!),
                        radius: 12,
                        backgroundColor: ColorsBets.whiteHD,
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
// close button
  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: ColorsBets.whiteHD),
      ),
    );
  }
}
