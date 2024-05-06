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
              const Text('Punta su di una risposta:'),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 10,width: 10,),

                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text(widget.bet.answer1)),
                    ),
                  ),
                  const SizedBox(height: 10,width: 10,),

                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text(widget.bet.answer2)),
                    ),
                  ),
                  const SizedBox(height: 10,width: 10,),

                ],
              ),
              const SizedBox(height: 10,width: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 10,width: 10,),

                  Expanded(
                    flex: 1,
                    child: widget.bet.answer3.isEmpty
                        ? Container()
                        : Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text(widget.bet.answer3)),
                    ),
                  ),
                  const SizedBox(height: 10,width: 10,),
                  Expanded(
                    flex: 1,
                    child: widget.bet.answer4.isEmpty
                        ? Container()
                        : Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(child: Text(widget.bet.answer4)),
                    ),
                  ),
                  const SizedBox(height: 10,width: 10,),

                ],
              ),
            ],
          ),
          Text(widget.bet.creationDate),
        ],
      ),
    );
  }
}
