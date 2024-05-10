import 'package:flutter/material.dart';

class PingPongPage extends StatefulWidget {
  const PingPongPage({super.key});

  @override
  _PingPongPageState createState() => _PingPongPageState();
}

class _PingPongPageState extends State<PingPongPage> {
  int redScore = 0;
  int blueScore = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              setState(() {
                redScore++;
              });
            },
            child: Container(
              color: Colors.red,
              child: Center(
                child: Text(
                  'Squadra 1: $redScore',
                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              setState(() {
                blueScore++;
              });
            },
            child: Container(
              color: Colors.blue,
              child: Center(
                child:
                   Text(
                  'Squadra 2: $blueScore',
                  style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),

              ),
            ),
          ),
        ),
      ],
    );
  }
}
