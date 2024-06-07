import 'package:flutter/material.dart';
import 'package:codebets/style/color_style.dart';
import 'package:codebets/pages/profile.dart';
import 'bets/active_bets.dart';
import 'bets/create_bet.dart';
import 'leaderboard.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  BottomNavigationBarWidgetState createState() =>
      BottomNavigationBarWidgetState();
}

class BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const ActiveBetsPage(),
    const CreateBetPage(),
    const LeaderboardPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10.0,left: 45,right: 45,top: 5),
        child: Container(
          decoration: BoxDecoration(
            color: ColorsBets.whiteHD,
            borderRadius: BorderRadius.circular(7.0),
            border: Border.all(color: ColorsBets.blueHD, width: 1.8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7.0),
            child: BottomNavigationBar(
              elevation: 0,
              iconSize: 24,
              selectedIconTheme: const IconThemeData(size: 28),
              unselectedIconTheme: const IconThemeData(size: 24),
              items: <BottomNavigationBarItem>[
                _buildNavigationBarItem(Icons.question_answer, 'Attive', 0),
                _buildNavigationBarItem(Icons.add_box, 'Crea', 1),
                _buildNavigationBarItem(Icons.emoji_events, 'Classifica', 2),
                _buildNavigationBarItem(Icons.person, 'Profilo', 4),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: ColorsBets.blueHD,
              unselectedItemColor: ColorsBets.blackHD.withOpacity(0.4),
              showSelectedLabels: true, // Hide selected labels
              showUnselectedLabels: false, // Hide unselected labels
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
