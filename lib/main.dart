import 'package:codebets/controllers/bet_controller.dart';
import 'package:codebets/routes.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'services/db_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init(); // Inizializza GetStorage

  // Controlla se esiste un nome utente memorizzato nelle shared preferences
  String? storedUserName = GetStorage().read<String>('userName');
  if (storedUserName != null) {
    // Se esiste, naviga direttamente alla schermata principale
    runApp(const MyApp(initialRoute: AppRoutes.mainScreen));
  } else {
    // Altrimenti, mostra la schermata di login
    runApp(const MyApp(initialRoute: AppRoutes.login));
  }

  Get.put(BetController());
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute, super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CodeBets',
      initialRoute: initialRoute,
      getPages: AppRoutes.routes,
    );
  }
}

//login
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    String userName = '';
    DbService dbService = DbService();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Image(image: const AssetImage("assets/logo.png"),
                 width:MediaQuery.of(context).size.width * 0.8,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  userName = value;
                },
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Inserisci il tuo nome...',
                  hintStyle: TextStyle(fontSize: 14),
                  icon: Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () async {
                // Controlla se il nome utente esiste nel database
                bool nameExists = await dbService.checkUserNameExists(userName);
                if (nameExists) {
                  // Naviga alla schermata principale
                  Get.offNamed(AppRoutes.mainScreen);
                  // Salva il nome utente nel GetStorage
                  GetStorage().write('userName', userName);
                } else {
                  // Mostra uno Snackbar di errore
                  Get.snackbar(
                    'Accesso Fallito',
                    'Sei così stupido che non sai il tuo nome?',
                    icon: const Icon(
                      Icons.error_sharp,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
