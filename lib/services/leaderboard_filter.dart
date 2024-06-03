import 'package:flutter/material.dart';
import '../pages/leaderboard.dart';

class LeaderboardFilter extends StatelessWidget {
  final OrderBy orderBy;
  final ValueChanged<OrderBy> onSelected;
  final ValueChanged<String> onUpdateTitle;

  const LeaderboardFilter({
    super.key,
    required this.orderBy,
    required this.onSelected,
    required this.onUpdateTitle,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<OrderBy>(
      onSelected: (OrderBy result) {
        onSelected(result);
        onUpdateTitle(_getAppBarTitle(result));
      },
      icon: const Icon(Icons.filter_list),
      tooltip: "Filtra",
      itemBuilder: (BuildContext context) => <PopupMenuEntry<OrderBy>>[
        const PopupMenuItem<OrderBy>(
          value: OrderBy.highestScore,
          child: Text('👑 - Punteggio più alto'),
        ),
        const PopupMenuItem<OrderBy>(
          value: OrderBy.lowestScore,
          child: Text('💩 - Punteggio più basso'),
        ),
        const PopupMenuItem<OrderBy>(
          value: OrderBy.mostCreatedBets,
          child: Text('💰 - Scommesse create'),
        ),
        const PopupMenuItem<OrderBy>(
          value: OrderBy.mostWonBets,
          child: Text('🏆 - Scommesse vinte'),
        ),
        const PopupMenuItem<OrderBy>(
          value: OrderBy.mostLostBets,
          child: Text('😢 - Scommesse perse'),
        ),
      ],
    );
  }

  String _getAppBarTitle(OrderBy orderBy) {
    switch (orderBy) {
      case OrderBy.highestScore:
        return 'Classifica';
      case OrderBy.lowestScore:
        return 'Classifica dei peggiori';
      case OrderBy.mostCreatedBets:
        return 'Classifica del ludopatico';
      case OrderBy.mostWonBets:
        return 'Classifica del Vincente';
      case OrderBy.mostLostBets:
        return 'Classifica del Perdente';
    }
  }
}
