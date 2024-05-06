class Bet {
  String creator;
  String creationDate;
  String description;
  String answer1;
  String answer2;
  String answer3;
  String answer4;
  String target;
  String title;

  Bet({
    required this.creator,
    required this.creationDate,
    required this.description,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4,
    required this.target,
    required this.title,
  });

  factory Bet.fromMap(Map<String, dynamic> map) {
    return Bet(
      creator: map['creatore'] ?? '',
      creationDate: map['data_creazione'] ?? '',
      description: map['descrizione'] ?? '',
      answer1: map['risposta1'] ?? '',
      answer2: map['risposta2'] ?? '',
      answer3: map['risposta3'] ?? '',
      answer4: map['risposta4'] ?? '',
      target: map['target'] ?? '',
      title: map['titolo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'creatore': creator,
      'data_creazione': creationDate,
      'descrizione': description,
      'risposta1': answer1,
      'risposta2': answer2,
      'risposta3': answer3,
      'risposta4': answer4,
      'target': target,
      'titolo': title,
    };
  }
}
