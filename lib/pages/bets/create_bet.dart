import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../services/db_service.dart';

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
  String? _selectedUser;
  List<String> _usersList = [];

  DbService dbService = DbService();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    DbService dbService = DbService();
    List<String> usersList = await dbService.getUsersList();
    setState(() {
      _usersList = usersList;
    });
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
                DropdownButtonFormField<String>(
                  value: _selectedUser,
                  items: _usersList.map((String user) {
                    return DropdownMenuItem<String>(
                      value: user,
                      child: Text(user),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUser = newValue;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Target (se presente)',
                    hintText: "Per ping pong lasciare vuoto",
                  ),
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
      floatingActionButton: kDebugMode
          ? FloatingActionButton(
              onPressed: () async {
                await Firebase.initializeApp();
                FirebaseFirestore firestore = FirebaseFirestore.instance;
                debugPrint("Cancellata collezione scommesse dal DB");
                // Cancella la collezione "scommesse"
                await firestore
                    .collection('scommesse')
                    .get()
                    .then((querySnapshot) {
                  for (var doc in querySnapshot.docs) {
                    doc.reference.delete();
                  }
                });
              },
        tooltip: "Cancella tutte le scommesse",
              child: const Icon(Icons.delete_sweep),
            )
          : null,
    );
  }

  Future<void> _submit() async {
    String currentDate = DateFormat('HH:mm - d MMMM yyyy').format(DateTime.now());
    String? userName = GetStorage().read<String>('userName');
    debugPrint('Titolo: $_title');
    debugPrint('Target: $_selectedUser');
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
    // Ottieni il riferimento al documento dell'utente nel database
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userName);

    // Incrementa il conteggio delle scommesse create per l'utente
    await userRef.update({'scommesse_create': FieldValue.increment(1)});

    // Visualizza il  loading
    showDialog(
      context: context,
      barrierDismissible: false, // Impedisce la chiusura del dialog
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.orangeAccent,
            color: Colors.orange,
          ),
        );
      },
    );

//simulo ritardo
    await Future.delayed(const Duration(milliseconds: 350));


    // Crea un nuovo documento nella collezione "scommesse"
    DocumentReference betRef = await FirebaseFirestore.instance.collection('scommesse').add({
      'titolo': _title.trim(),
      'target': _selectedUser,
      'descrizione': _description.trim(),
      'risposta1': _answer1.trim(),
      'risposta2': _answer2.trim(),
      'risposta3': _answer3.trim(),
      'risposta4': _answer4.trim(),
      'data_creazione': currentDate,
      'creatore': userName,
    });

    String betId = betRef.id;

    // Crea le risposte associate alla scommessa nel database
    List<String> usersList = await dbService.getUsersList();
    for (String user in usersList) {
      await FirebaseFirestore.instance.collection('risposte').add({
        'scommessa_id': betId,
        'utente': user,
        'risposta_scelta': '',
      });
    }

//chiudo il loading e mostro la snackbar successo
    Navigator.pop(context);
    const snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      content: Row(
        children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 10),
          Text('Scommessa creata con successo!',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    debugPrint('Dati inviati al database Firebase con successo!');
  }
}
