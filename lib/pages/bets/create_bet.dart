import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codebets/style/text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../services/db_service.dart';
import '../../style/color_style.dart';
import '../../widgets/debug_only/clear_bets.dart';
import '../../widgets/input_forms_dropdown/bet_descr_input.dart';
import '../../widgets/input_forms_dropdown/bet_risposte_input.dart';
import '../../widgets/input_forms_dropdown/bet_target_dropdown.dart';
import '../../widgets/input_forms_dropdown/bet_title_input.dart';

class CreateBetPage extends StatefulWidget {
  const CreateBetPage({super.key});
  @override
  _CreateBetPageState createState() => _CreateBetPageState();
}
class _CreateBetPageState extends State<CreateBetPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _title;
  String _description = '';
  String _answer1 = '';String _answer2 = '';
  String _answer3 = '';String _answer4 = '';
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
    setState(() {_usersList = usersList;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _submit();
                            }
                          },
                          child:  Row(
                            children: [
                              Text(
                                'Crea',
                                style: TextStyleBets.betTextTitle
                              ),
                              const SizedBox(width: 5),
                               const Icon(Icons.arrow_forward,color: ColorsBets.blueHD,),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    BetTitleFormField(
                      formKey: _formKey,
                      onSaved: (newValue) {
                        _title = newValue!;
                      },
                    ),
                    BetTargetDropdownFormField(
                      usersList: _usersList,
                      selectedUser: _selectedUser,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedUser = newValue;
                        });
                      },
                    ),
                    BetDescriptionFormField(
                      onChanged: (value) {
                        _description = value;
                      },
                    ),
                    BetAnswerFormField(
                      labelText: 'Risposta 1*',
                      hintText: "Es. Sì",
                      onSaved: (newValue) {
                        _answer1 = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Inserisci la prima risposta';
                        }
                        return null;
                      },
                    ),
                    BetAnswerFormField(
                      labelText: 'Risposta 2*',
                      hintText: "Es. No",
                      onSaved: (newValue) {
                        _answer2 = newValue!;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Inserisci la seconda risposta';
                        }
                        return null;
                      },
                    ),
                    BetAnswerFormField(
                      labelText: 'Risposta 3',
                      hintText: "Es. Yes",
                      onSaved: (newValue) {
                        _answer3 = newValue ?? '';
                      },
                      validator: (value) {
                        return null; // Nessuna validazione necessaria
                      },
                    ),
                    BetAnswerFormField(
                      labelText: 'Risposta 4',
                      hintText: "Es. No",
                      onSaved: (newValue) {
                        _answer4 = newValue ?? '';
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: kDebugMode ? const ClearButton() : null,
    );
  }


  Future<void> _submit() async {
    String currentDate = DateFormat('HH:mm - d MMMM yyyy').format(DateTime.now());
    String? userName = GetStorage().read<String>('userName');
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
          Text('Scommessa creata con successo!', style: TextStyle(color: ColorsBets.whiteHD)),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    _resetForm();
  }
  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _title = '';
      _selectedUser = null;
      _description = '';
      _answer1 = '';
      _answer2 = '';
      _answer3 = '';
      _answer4 = '';
    });
    FocusScope.of(context).unfocus();
  }
}