import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  int _team1SetsWon = 0;
  int _team2SetsWon = 0;
  late int _maxPoints;

  @override
  void initState() {
    super.initState();
    _maxPoints = widget.pointsPerSet;

    // Blocca l'orientamento in orizzontale
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Ripristina l'orientamento predefinito
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Points'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildTeamColumn(
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
          ),
          Expanded(
            flex: 1,
            child: _buildScoreColumn(),
          ),
          Expanded(
            flex: 3,
            child: _buildTeamColumn(
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
    return Container(
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
                onPressed: onPressedRemove,
                child: Icon(Icons.remove),
              ),
              ElevatedButton(
                onPressed: onPressedAdd,
                child: Icon(Icons.add),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Set $_currentSet',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          '${widget.team1Name} Sets: $_team1SetsWon',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '${widget.team2Name} Sets: $_team2SetsWon',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  void _incrementPoints(int team) {
    setState(() {
      if (team == 1) {
        if (_team1Points < _maxPoints) {
          _team1Points++;
          if (_team1Points == _maxPoints) {
            _team1SetsWon++;
            _resetPoints();
          }
        }
      } else if (team == 2) {
        if (_team2Points < _maxPoints) {
          _team2Points++;
          if (_team2Points == _maxPoints) {
            _team2SetsWon++;
            _resetPoints();
          }
        }
      }
      if (_currentSet > widget.numberOfSets) {
        _showWinnerDialog();
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

  void _resetPoints() {
    _team1Points = 0;
    _team2Points = 0;
    _currentSet++;
  }

  void _showWinnerDialog() {
    String winner;
    if (_team1SetsWon > _team2SetsWon) {
      winner = widget.team1Name;
    } else if (_team2SetsWon > _team1SetsWon) {
      winner = widget.team2Name;
    } else {
      winner = 'No one, it\'s a tie';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Match Over'),
          content: Text('$winner wins the match!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
