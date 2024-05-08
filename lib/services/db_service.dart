import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codebets/models/bet.dart';
import 'package:flutter/cupertino.dart';

class DbService {
  //controllo login
  Future<bool> checkUserNameExists(String userName) async {
    try {
      // Controlla se esiste un documento con il nome utente fornito nella collezione "users"
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userName)
          .get();
      return userDoc.exists;
    } catch (e) {
      debugPrint("Errore nel caricamento dei dati");
      return false;
    }
  }

//lista utenti
  Future<List<String>> getUsersList() async {
    try {
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<String> usersList = usersSnapshot.docs.map((doc) => doc.id).toList();
      return usersList;
    } catch (e) {
      debugPrint("Errore nel caricamento dei dati");
      return [];
    }
  }


  //ricuperare tutte le scommesse
  Future<List<Bet>> getBetsList() async {
    try {
      QuerySnapshot betsSnapshot =
          await FirebaseFirestore.instance.collection('scommesse').get();
      List<Bet> betsList = betsSnapshot.docs
          .map((doc) => Bet.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      return betsList;
    } catch (e) {
      debugPrint("Errore nel recupero di scommesse");
      return [];
    }
  }


  Future<Map<String, dynamic>> getUsersData() async {
    try {
      QuerySnapshot usersSnapshot =
      await FirebaseFirestore.instance.collection('users').get();
      Map<String, dynamic> usersData = {};

      // Itera su ogni documento utente per recuperare i dati
      for (var doc in usersSnapshot.docs) {
        // Ottieni il nome utente
        String userName = doc.id;
        // Ottieni i dati dell'utente
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        // Aggiungi i dati dell'utente alla mappa
        usersData[userName] = userData;
      }

      return usersData;
    } catch (e) {
      debugPrint("Errore nel recupero dei dati degli utenti: $e");
      return {};
    }
  }

}
