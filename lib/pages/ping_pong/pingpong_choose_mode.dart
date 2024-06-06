import 'package:codebets/pages/ping_pong/pp_team_creation.dart';
import 'package:codebets/style/color_style.dart';
import 'package:flutter/material.dart';

class ModeSelectionPage extends StatelessWidget {
  const ModeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildModeButton(
                  context: context,
                  label: ' 1 vs 1 ',
                  icon: Icons.person,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeamCreationPage(players: 2),
                      ),
                    );
                  },
                  borderColor: ColorsBets.blueHD,
                ),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: ColorsBets.blackHD,
                        thickness: 1.5,
                        indent: 25,
                        endIndent: 5,
                      ),
                    ),
                    Text(
                      'Scegli Modalità',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColorsBets.blackHD,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: ColorsBets.blackHD,
                        thickness: 1.5,
                        indent: 5,
                        endIndent: 25,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _buildModeButton(
                  context: context,
                  label: ' 2 vs 2 ',
                  icon: Icons.people,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeamCreationPage(players: 4),
                      ),
                    );
                  },
                  borderColor: ColorsBets.orangeHD,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color borderColor,
  }) {
    return Material(
      elevation: 3.0,
      shadowColor: Colors.black.withOpacity(0.7),
      borderRadius: BorderRadius.circular(15),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: ColorsBets.whiteHD,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          textStyle: const TextStyle(fontSize: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: BorderSide(
            color: borderColor,
            width: 2.5,
          ),
          foregroundColor: borderColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 30, color: borderColor),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: borderColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Icon(icon, size: 30, color: borderColor),
          ],
        ),
      ),
    );
  }
}
