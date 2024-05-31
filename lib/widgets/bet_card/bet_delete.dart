import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:codebets/style/color_style.dart';

import '../../style/text_style.dart';

class DeleteConfirmationModal extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onCancel;

  const DeleteConfirmationModal({
    super.key,
    required this.onDelete,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  AutoSizeText(
        'Eliminare la scommessa?',
        style: TextStyleBets.dialogTitle,
      textAlign: TextAlign.center,),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: const <TextSpan>[
                  TextSpan(
                    text: '⚠️ ATTENZIONE ⚠️\n',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextSpan(
                    text: 'Questa azione è irreversibile.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorsBets.blueHD, width: 2.5),
              ),
              child: TextButton(
                onPressed: onCancel,
                child: Text(
                  'Annulla',
                  style: TextStyle(
                    color: ColorsBets.blueHD.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red, width: 2.5),
              ),
              child: TextButton(
                onPressed: onDelete,
                child: const Text(
                  'Elimina',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: ColorsBets.blueHD, width: 3),
      ),
    );
  }
}


