import 'package:flutter/material.dart';
import '../../style/color_style.dart';

class BetTarget extends StatelessWidget {
  final String targetName;
  final String targetAvatar;

  const BetTarget({super.key, required this.targetName, required this.targetAvatar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Target: ',
            style: TextStyle(fontSize: 14,color: ColorsBets.blackHD, fontWeight: FontWeight.bold),
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(targetAvatar ),
            radius: 15,
            backgroundColor: ColorsBets.whiteHD,
          ),
          const SizedBox(width: 3),
          Text(
            targetName,
            style: const TextStyle(fontSize: 15,color: ColorsBets.blackHD, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
