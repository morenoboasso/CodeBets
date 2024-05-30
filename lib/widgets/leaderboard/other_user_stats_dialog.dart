import 'package:flutter/material.dart';

class UserModal extends StatelessWidget {
  final String userName;
  final int score;
  final int scommesseCreate;
  final int scommesseVinte;
  final int scommessePerse;
  final String? userPfp;

  const UserModal({
    Key? key,
    required this.userName,
    required this.score,
    required this.scommesseCreate,
    required this.scommesseVinte,
    required this.scommessePerse,
    this.userPfp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(width: 35,),
          Center(
            child: Text(userName),
          ),
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
                  backgroundImage: NetworkImage(userPfp!),
                ),
              ),
            ),
          const SizedBox(height: 20),
          Center(
            child: Text('Punteggio: $score'),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text('Scommesse create: $scommesseCreate'),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Vinte: $scommesseVinte'),
              const SizedBox(width: 20),
              Text('Perse: $scommessePerse'),
            ],
          ),
        ],
      ),
    );
  }
}
