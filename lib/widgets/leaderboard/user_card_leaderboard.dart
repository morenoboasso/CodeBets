import 'package:codebets/style/color_style.dart';
import 'package:codebets/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class UserCard extends StatelessWidget {
  final int index;
  final String userName;
  final int score;
  final String? userPfp;
  final Function onTap;
  final int totalUsers;

  const UserCard({
    super.key,
    required this.index,
    required this.userName,
    required this.score,
    required this.userPfp,
    required this.onTap,
    required this.totalUsers,
  });

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final currentUserName = box.read('userName');

    bool isCurrentUser = userName == currentUserName;

    Widget leadingIcon;
    if (index == 0) {
      leadingIcon = const Text('🏆', style: TextStyle(fontSize: 20)); // Primo utente
    } else if (index == 1) {
      leadingIcon = const Text('🥈', style: TextStyle(fontSize: 20)); // Secondo utente
    } else if (index == 2) {
      leadingIcon = const Text('🥉', style: TextStyle(fontSize: 20)); // Terzo utente
    } else if (index == totalUsers - 1) {
      leadingIcon = const Text('💩', style: TextStyle(fontSize: 20)); // Ultimo utente
    } else {
      leadingIcon = Text(' ${index + 1}°', style:isCurrentUser ? TextStyleBets.userSelfPositionLeader :  TextStyleBets.userPositionLeader); //altri posti
    }

    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side:  BorderSide(color:isCurrentUser ? ColorsBets.blueHD : ColorsBets.blueHD, width: 2),
        ),
        surfaceTintColor: isCurrentUser ? ColorsBets.blueHD : ColorsBets.whiteHD,
        color: isCurrentUser ? ColorsBets.blueHD : ColorsBets.whiteHD,
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              leadingIcon,
              const SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  userPfp ??
                      "https://thebowlcut.com/cdn/shop/t/41/assets/loading.gif?v=157493769327766696621701744369",
                  scale: 80,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(isCurrentUser? "Tu" : userName, style:isCurrentUser ? TextStyleBets.userSelfLeaderboardText : TextStyleBets.userLeaderboardText)),
              const SizedBox(width: 10),
              Text(
                '$score',
                style:isCurrentUser ? TextStyleBets.userSelfLeaderboardText :  TextStyleBets.userLeaderboardText,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
    );
  }
}
