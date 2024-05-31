import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import '../models/bet.dart';

class DbService {
  final GetStorage _storage = GetStorage();

  // Controllo login
  Future<bool> checkUserNameExists(String userName) async {
    try {
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

  // Lista utenti
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

  // Recupera tutte le scommesse
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

  // Recupera i dati degli utenti
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

  // Carica utenti con avatar
  Future<List<Map<String, String>>> getUsersListWithAvatars() async {
    Map<String, dynamic> usersData = await getUsersData();
    List<Map<String, String>> usersList = usersData.entries
        .where((entry) => entry.key != 'Admin')
        .map((entry) {
      final name = entry.key;
      final pfp = entry.value['pfp'] as String? ?? 'https://example.com/default-avatar.png';
      return {
        'name': name,
        'pfp': pfp,
      };
    }).toList();
    return usersList;
  }

  // Resetta tutti i dati di un utente
  Future<void> resetUserData(String userName) async {
    try {
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('risposte')
          .where('scommessa_id', isEqualTo: betId)
          .where('utente', isEqualTo: userName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        await doc.reference.update({'risposta_scelta': answer});
      } else {
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('risposte')
          .where('scommessa_id', isEqualTo: betId)
          .where('utente', isEqualTo: userName)
          .get();

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

  Stream<Map<String, dynamic>> getUserDataStream() {
    final userName = _storage.read('userName');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userName)
        .snapshots()
        .map((snapshot) => snapshot.data() ?? {});
  }

  //update scores
  Future<void> checkAndUpdateScores(String selectedAnswer, String betId, String target) async {
    try {
      // Ottieni e aggiorna i punteggi degli utenti
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('risposte')
          .where('scommessa_id', isEqualTo: betId)
          .get();

      for (var doc in querySnapshot.docs) {
        String user = doc['utente'];
        String answer = doc['risposta_scelta'];

        if (user == target) {
          await FirebaseFirestore.instance.collection('users').doc(user).update(
              {
                'score': FieldValue.increment(2),
              });
        }

        // Verifica se l'utente ha selezionato una risposta
        if (answer.isNotEmpty) {
          // Controlla se la risposta dell'utente è corretta
          if (answer == selectedAnswer) {
            // Se la risposta è corretta, aumenta il punteggio e il numero di scommesse vinte
            await FirebaseFirestore.instance.collection('users')
                .doc(user)
                .update({
              'score': FieldValue.increment(5),
              // Aumenta punteggio per chi vince
              'scommesse_vinte': FieldValue.increment(1),
            });
          } else {
            // Se la risposta è sbagliata, incrementa solo il numero di scommesse perse
            await FirebaseFirestore.instance.collection('users')
                .doc(user)
                .update({
              'scommesse_perse': FieldValue.increment(1),
            });
          }
        }
      }

      // Cancella le risposte associate alla scommessa
      await FirebaseFirestore.instance
          .collection('risposte')
          .where('scommessa_id', isEqualTo: betId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });

      // Cancella la scommessa stessa
      await FirebaseFirestore.instance.collection('scommesse')
          .doc(betId)
          .delete();

      debugPrint('Punteggi aggiornati e risposte cancellate correttamente!');
    } catch (e) {
      debugPrint(
          "Errore durante l'aggiornamento dei punteggi degli utenti o la cancellazione delle risposte: $e");
    }
  }

  // Elimina una scommessa
  Future<void> deleteBet(String betId) async {
    try {
      // Cancella le risposte associate alla scommessa
      await FirebaseFirestore.instance
          .collection('risposte')
          .where('scommessa_id', isEqualTo: betId)
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });

      // Cancella la scommessa stessa
      await FirebaseFirestore.instance.collection('scommesse')
          .doc(betId)
          .delete();

      debugPrint('Scommessa eliminata correttamente!');
    } catch (e) {
      debugPrint("Errore durante l'eliminazione della scommessa: $e");
    }
  }

  //invio risposta scelta dall'utente
  Future<void> confirmSelection(String betId, String selectedAnswer) async {
    try {
      if (selectedAnswer != null) {
        String? userName = GetStorage().read<String>('userName');

        // Invia la risposta al database
        await updateAnswer(betId, userName!, selectedAnswer);

        debugPrint('Risposta inviata al database con successo!');
      } else {
        debugPrint('Seleziona una risposta prima di confermare!');
      }
    } catch (e) {
      debugPrint("Errore durante la conferma della selezione: $e");
    }
  }

  // Carica la risposta dell'utente per una scommessa
  Future<String?> loadUserAnswer(String betId) async {
    try {
      String? userName = GetStorage().read<String>('userName');
      String? userAnswer = await getUserAnswerForBet(betId, userName!);
      return userAnswer;
    } catch (e) {
      debugPrint("Errore durante il caricamento della risposta dell'utente: $e");
      return null;
    }
  }

  // Controlla se l'utente ha già confermato la risposta per una scommessa
  Future<bool> checkAnswerConfirmation(String betId) async {
    try {
      String? userName = GetStorage().read<String>('userName');
      String? userAnswer = await getUserAnswerForBet(betId, userName!);
      return userAnswer != null && userAnswer.isNotEmpty;
    } catch (e) {
      debugPrint("Errore durante il controllo della conferma della risposta: $e");
      return false;
    }
  }
}
