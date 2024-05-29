import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class ClearButton extends StatelessWidget {
  const ClearButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await Firebase.initializeApp();
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        debugPrint("Cancellata collezione scommesse e risposte dal DB");
        // Cancella la collezione "scommesse"
        await firestore.collection('scommesse').get().then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });
        // Cancella la collezione "risposte"
        await firestore.collection('risposte').get().then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.delete();
          }
        });
      },
      icon: const Icon(Icons.delete_sweep),
      label: const Text('Cancella Bets Attive'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      ),
    );
  }
}
