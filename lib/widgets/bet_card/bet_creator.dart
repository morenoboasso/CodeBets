import 'package:flutter/material.dart';
import 'package:codebets/style/color_style.dart';

class BetCreator extends StatelessWidget {
  final String creatorName;
  final String? creatorAvatar;

  const BetCreator({
    super.key,
    required this.creatorName,
    this.creatorAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Creata da: ',
            style: TextStyle(fontSize: 14, color: ColorsBets.blueHD, fontWeight: FontWeight.bold),
          ),
          CircleAvatar(
            backgroundImage: creatorAvatar != null
                ? NetworkImage(creatorAvatar!)
                : Image.asset('assets/logo.png').image,
            radius: 15,
            backgroundColor: ColorsBets.whiteHD,
          ),
          const SizedBox(width: 2),
          Text(
            creatorName,
            style: const TextStyle(fontSize: 15, color: ColorsBets.blueHD, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
