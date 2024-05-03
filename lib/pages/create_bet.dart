import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class CreateBetPage extends StatefulWidget {
  const CreateBetPage({super.key});

  @override
  _CreateBetPageState createState() => _CreateBetPageState();
}

class _CreateBetPageState extends State<CreateBetPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _title;
  String _description = '';
  String _answer1 = '';
  String _answer2 = '';
  String _answer3 = '';
  String _answer4 = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea Scommessa'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Titolo*',
                    hintText: "Es. Rob bestemmierà oggi?",
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il titolo della scommessa';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _title = newValue!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Descrizione',
                    hintText:
                        "Es. Chi dimenticherà qualcosa nella sala ping pong?",
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                  onChanged: (value) {
                    _description = value;
                  },
                  maxLines: null, // Per consentire più righe di testo
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Risposta 1*',
                    hintText: "Es. Sì",
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci la prima risposta';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _answer1 = newValue!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Risposta 2*',
                    hintText: "Es. No",
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci la seconda risposta';
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _answer2 = newValue!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Risposta 3',
                    hintText: "Es. Robert Cadrà per terra",
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                  onSaved: (newValue) {
                    _answer3 = newValue ?? '';
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Risposta 4',
                    hintText: "Es. Lia rimarrà chiusa fuori dall'ufficio",
                    hintStyle: TextStyle(fontSize: 12),
                  ),
                  onSaved: (newValue) {
                    _answer4 = newValue ?? '';
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _previewDialog();
                      }
                    },
                    child: const Text('Preview Scommessa'),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _submit();
                      }
                    },
                    child: const Text('Crea Scommessa'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //ti mostra una preview di come verrà la card
  void _previewDialog() {
    String? userName = GetStorage().read<String>('userName');
    String currentDate = DateFormat('d MMMM - HH:mm').format(DateTime.now());
    List<Widget> previewContent = [
      Text('Titolo: $_title'),
    ];

    if (_description.isNotEmpty) {
      previewContent.add(Text('Descrizione: $_description'));
    }

    if (_answer1.isNotEmpty) {
      previewContent.add(Text('Risposta 1: $_answer1'));
    }

    if (_answer2.isNotEmpty) {
      previewContent.add(Text('Risposta 2: $_answer2'));
    }

    if (_answer3.isNotEmpty) {
      previewContent.add(Text('Risposta 3: $_answer3'));
    }

    if (_answer4.isNotEmpty) {
      previewContent.add(Text('Risposta 4: $_answer4'));
    }

    previewContent.addAll([
      Text('Data di creazione: $currentDate'),
      Text('Creatore: $userName'),
    ]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Anteprima'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: previewContent,
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Chiudi la dialog
                  _submit();
                },
                child: const Text('Crea Scommessa'),
              ),
            ),
          ],
        );
      },
    );
  }

  //todo inviare al db i dati
  void _submit() {
    String currentDate = DateFormat('d MMMM - HH:mm').format(DateTime.now());
    String? userName = GetStorage().read<String>('userName');
    debugPrint('Titolo: $_title');
    if (_description.isNotEmpty) {
      debugPrint('Descrizione: $_description');
    }
    debugPrint('Data di creazione: $currentDate');
    debugPrint('Creatore: $userName');

    if (_answer1.isNotEmpty) {
      debugPrint('Risposta 1: $_answer1');
    }
    if (_answer2.isNotEmpty) {
      debugPrint('Risposta 2: $_answer2');
    }
    if (_answer3.isNotEmpty) {
      debugPrint('Risposta 3: $_answer3');
    }
    if (_answer4.isNotEmpty) {
      debugPrint('Risposta 4: $_answer4');
    }
  }
}
