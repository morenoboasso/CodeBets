import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../services/db_service.dart';
import '../style/color_style.dart';

class SubmitBetService {
  final BuildContext context;
  final String title;
  final String? selectedUser;
  final String description;
  final String answer1;
  final String answer2;
  final String answer3;
  final String answer4;
  final GlobalKey<FormState> formKey;
  final Function resetForm;

  SubmitBetService({
    required this.context,
    required this.title,
    required this.selectedUser,
    required this.description,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4,
    required this.formKey,
    required this.resetForm,
  });

  Future<void> submit() async {
    String currentDate = DateFormat('HH:mm - d MMMM yyyy').format(DateTime.now());
    String? userName = GetStorage().read<String>('userName');

    // Ottieni il riferimento al documento dell'utente nel database
    DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userName);

    // Incrementa il conteggio delle scommesse create per l'utente
    await userRef.update({'scommesse_create': FieldValue.increment(1)});

    // Visualizza il loading
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

    // Simulo ritardo
    await Future.delayed(const Duration(milliseconds: 350));

    // Crea un nuovo documento nella collezione "scommesse"
    DocumentReference betRef = await FirebaseFirestore.instance.collection('scommesse').add({
      'titolo': title.trim(),
      'target': selectedUser,
      'descrizione': description.trim(),
      'risposta1': answer1.trim(),
      'risposta2': answer2.trim(),
      'risposta3': answer3.trim(),
      'risposta4': answer4.trim(),
      'data_creazione': currentDate,
      'creatore': userName,
    });

    String betId = betRef.id;

    // Crea le risposte associate alla scommessa nel database
    DbService dbService = DbService();
    List<String> usersList = await dbService.getUsersList();
    for (String user in usersList) {
      await FirebaseFirestore.instance.collection('risposte').add({
        'scommessa_id': betId,
        'utente': user,
        'risposta_scelta': '',
      });
    }

    // Chiudo il loading e mostro la snackbar successo
    Navigator.pop(context);
    const snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      content: Row(
        children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 10),
          Text('Scommessa creata con successo!', style: TextStyle(color: ColorsBets.whiteHD)),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    resetForm();
  }
}
