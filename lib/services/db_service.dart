import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DbService {
  //controllo login
  Future<bool> checkUserNameExists(String userName) async {
    try {
      // Controlla se esiste un documento con il nome utente fornito nella collezione "users"
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userName).get();
      return userDoc.exists;
    } catch (e) {
      debugPrint("Errore nel caricamento dei dati");
      return false;
    }
  }
//lista utenti
  Future<List<String>> getUsersList() async {
    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
      List<String> usersList = usersSnapshot.docs.map((doc) => doc.id).toList();
      return usersList;
    } catch (e) {
      debugPrint("Errore nel caricamento dei dati");
      return [];
    }
  }

}
