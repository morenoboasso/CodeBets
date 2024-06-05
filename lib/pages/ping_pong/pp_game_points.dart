import 'package:flutter/material.dart';

class PointsPage extends StatefulWidget {
  final String team1Name;
  final String team2Name;
  final Color team1Color;
  final Color team2Color;
  final int players;
  final int numberOfSets;
  final int pointsPerSet;

  const PointsPage({
    Key? key,
    required this.team1Name,
    required this.team2Name,
    required this.team1Color,
    required this.team2Color,
    required this.players,
    required this.numberOfSets,
    required this.pointsPerSet,
  }) : super(key: key);

  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  int _team1Points = 0;
  int _team2Points = 0;
  int _currentSet = 1;
  int _maxPoints = 11; // Default to 11 points per set

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Points'),
      ),
      body: Row(
        children: [
          _buildTeamColumn(
            teamName: widget.team1Name,
            teamColor: widget.team1Color,
            teamPoints: _team1Points,
            onPressedAdd: () {
              _incrementPoints(1);
            },
            onPressedRemove: () {
              _decrementPoints(1);
            },
          ),
          _buildScoreColumn(),
          _buildTeamColumn(
            teamName: widget.team2Name,
            teamColor: widget.team2Color,
            teamPoints: _team2Points,
            onPressedAdd: () {
              _incrementPoints(2);
            },
            onPressedRemove: () {
              _decrementPoints(2);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTeamColumn({
    required String teamName,
    required Color teamColor,
    required int teamPoints,
    required VoidCallback onPressedAdd,
    required VoidCallback onPressedRemove,
  }) {
    return Expanded(
      child: Container(
        color: teamColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              teamName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Points: $teamPoints',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onPressedAdd,
                  child: Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: onPressedRemove,
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreColumn() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Set $_currentSet',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _incrementPoints(int team) {
    setState(() {
      if (team == 1) {
        if (_team1Points < _maxPoints) {
          _team1Points++;
        }
      } else if (team == 2) {
        if (_team2Points < _maxPoints) {
          _team2Points++;
        }
      }
    });
  }

  void _decrementPoints(int team) {
    setState(() {
      if (team == 1 && _team1Points > 0) {
        _team1Points--;
      } else if (team == 2 && _team2Points > 0) {
        _team2Points--;
      }
    });
  }
}
