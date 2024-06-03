import 'package:codebets/style/color_style.dart';
import 'package:flutter/material.dart';

import '../../style/text_style.dart';

class UserModal extends StatelessWidget {
  final String userName;
  final int score;
  final int scommesseCreate;
  final int scommesseVinte;
  final int scommessePerse;
  final String? userPfp;

  const UserModal({
    super.key,
    required this.userName,
    required this.score,
    required this.scommesseCreate,
    required this.scommesseVinte,
    required this.scommessePerse,
    this.userPfp,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: ColorsBets.whiteHD,
      backgroundColor: ColorsBets.whiteHD,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: ColorsBets.blueHD, width: 3.5),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(width: 35),
          Center(
              child: Text(
            userName,
            style: TextStyleBets.profileUserName,
          )),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (userPfp != null)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(userPfp ?? "https://thebowlcut.com/cdn/shop/t/41/assets/loading.gif?v=157493769327766696621701744369"),
                ),
              ),
            ),
          const SizedBox(height: 20),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Punteggio: ',
                style: TextStyleBets.profileVariable,
              ),
              Text(
                '$score',
                style: TextStyleBets.profileVariable
                  .copyWith(color: ColorsBets.blueHD),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Scommesse create: ', style: TextStyleBets.profileVariable,
              ),
              Text('$scommesseCreate', style: TextStyleBets.profileVariable.copyWith(color: ColorsBets.blueHD)),
            ]),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Vinte: ', style: TextStyleBets.profileVariable,
                  ),
                  Text('$scommesseVinte', style: TextStyleBets.profileVariable.copyWith(color: ColorsBets.blueHD)),
                ]),
              ),
              const SizedBox(width: 20),
              Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'Perse: ', style: TextStyleBets.profileVariable,
                  ),
                  Text('$scommessePerse', style: TextStyleBets.profileVariable.copyWith(color: ColorsBets.blueHD)),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
