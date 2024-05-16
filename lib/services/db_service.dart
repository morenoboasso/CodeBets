import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/bet.dart';

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
      List<Bet> betsList = betsSnapshot.docs.map((doc) {
        return Bet.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      return betsList;
    } catch (e) {
      debugPrint("Errore nel recupero di scommesse");
      return [];
    }
  }

  //prende i dati degli utenti
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

  //resetta tutti i dati di un utente
  Future<void> resetUserData(String userName) async {
    try {
      // Ottieni il riferimento al documento dell'utente nel database
      DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(userName);
      debugPrint("Cancellate statistiche");

      await userRef.update({
        'score': 0,
        'scommesse_create': 0,
        'scommesse_vinte': 0,
        'scommesse_perse': 0,
      });
    } catch (e) {
      debugPrint("Errore durante il reset dei dati utente: $e");
    }
  }

  // Aggiorna la risposta dell'utente per una scommessa
  Future<void> updateAnswer(String betId, String userName, String answer) async {
    try {
      // Ottieni il riferimento al documento della risposta nel database
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('risposte')
          .where('scommessa_id', isEqualTo: betId)
          .where('utente', isEqualTo: userName)
          .get();

      // Verifica se esiste una risposta per l'utente e la scommessa corrispondenti
      if (querySnapshot.docs.isNotEmpty) {
        // Aggiorna il campo 'risposta_scelta' nel documento esistente
        DocumentSnapshot doc = querySnapshot.docs.first;
        await doc.reference.update({'risposta_scelta': answer});
      } else {
        // Se non esiste, crea un nuovo documento per l'utente e la scommessa corrispondenti
        await FirebaseFirestore.instance.collection('risposte').add({
          'scommessa_id': betId,
          'utente': userName,
          'risposta_scelta': answer,
        });
      }
    } catch (e) {
      debugPrint("Errore durante l'aggiornamento della risposta: $e");
    }
  }

  // Recupera la risposta dell'utente per una scommessa
  Future<String?> getUserAnswerForBet(String betId, String userName) async {
    try {
      // Ottieni il riferimento al documento della risposta nel database
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('risposte')
          .where('scommessa_id', isEqualTo: betId)
          .where('utente', isEqualTo: userName)
          .get();

      // Se esiste una risposta per l'utente e la scommessa corrispondenti, restituisci la risposta
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.get('risposta_scelta');
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Errore durante il recupero della risposta dell'utente: $e");
      return null;
    }
  }

  // Stream delle scommesse per ricevere aggiornamenti in tempo reale
  Stream<List<Bet>> get betsStream {
    return FirebaseFirestore.instance.collection('scommesse').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Bet.fromMap(doc.id, doc.data());
      }).toList();
    });
  }
}
