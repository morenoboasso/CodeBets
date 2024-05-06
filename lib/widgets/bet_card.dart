import 'package:codebets/models/bet.dart';
import 'package:flutter/material.dart';

class BetCard extends StatefulWidget {
  final Bet bet;

  const BetCard({super.key, required this.bet});

  @override
  _BetCardState createState() => _BetCardState();
}

class _BetCardState extends State<BetCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(widget.bet.title,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          Text(widget.bet.description),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Creatore: ${widget.bet.creator}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Target: ${widget.bet.target}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            children: [
              const Text('Risposte:'),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(widget.bet.answer1),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(widget.bet.answer2),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      (widget.bet.answer3 == '')
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(widget.bet.answer3),
                            ),
                      (widget.bet.answer4 == '')
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(widget.bet.answer4),
                            ),
                    ],
                  )
                ],
              ),
              Text(widget.bet.creationDate),
            ],
          )
        ],
      ),
    );
  }
}
