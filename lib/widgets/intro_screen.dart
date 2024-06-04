import 'package:codebets/style/color_style.dart';
import 'package:codebets/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:codebets/routes.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        image: Image.asset('assets/logo.png'),
        title: "Benvenuto su CodeBets!",
        body: "Entra nel divertimento delle scommesse con i tuoi colleghi! Guarda le scommesse attive e fai la tua mossa per vincere punti!",
        decoration: PageDecoration(
          titleTextStyle: TextStyleBets.onboardTitle,
          bodyTextStyle: TextStyleBets.onboardBody,
          imagePadding: const EdgeInsets.only(top: 100.0),
        ),
      ),
      PageViewModel(
        image: Image.asset('assets/intro_2.jpg'),
        title: "Crea e Partecipa alle Scommesse",
        body: "Metti alla prova la tua astuzia!\nCrea la tua scommessa e sfida i tuoi colleghi.",
        decoration: PageDecoration(
          titleTextStyle: TextStyleBets.onboardTitle,
          bodyTextStyle: TextStyleBets.onboardBody,
          imagePadding: const EdgeInsets.only(top: 100.0),
        ),
      ),
      PageViewModel(
        image: Image.asset('assets/intro_3.jpg'),
        title: "Il Punteggio",
        body: "Scommetti e guadagna punti!\n5 punti se indovini, 2 se sei il target.\nChi arriverà in cima alla classifica?",
        decoration: PageDecoration(
          titleTextStyle: TextStyleBets.onboardTitle,
          bodyTextStyle: TextStyleBets.onboardBody,
          imagePadding: const EdgeInsets.only(top: 100.0),
        ),
      ),
      PageViewModel(
        image: Image.asset('assets/intro_4.jpg'),
        title: "La Classifica",
        body: "Scala la classifica e diventa il re delle scommesse!\nVinci più punti, fai più scommesse e diventa il piu... ludopatico?",
        decoration: PageDecoration(
          titleTextStyle: TextStyleBets.onboardTitle,
          bodyTextStyle: TextStyleBets.onboardBody,
          imagePadding: const EdgeInsets.only(top: 100.0),
        ),
      ),
      PageViewModel(
        image: Image.asset('assets/intro_5.jpg'),
        title: "Sei Pronto?",
        body: "Sfida i tuoi amici, guadagna punti, e goditi l'emozione del rischio! Entra ora e inizia a vincere!",
        decoration: PageDecoration(
          titleTextStyle: TextStyleBets.onboardTitle,
          bodyTextStyle: TextStyleBets.onboardBody,
          imagePadding: const EdgeInsets.only(top: 100.0),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          done: Text("Inizia", style: TextStyleBets.dialogTitle.copyWith(fontSize: 14)),
          onDone: () {
            String? storedUserName = GetStorage().read<String>('userName');
            if (storedUserName != null) {
              Get.offAllNamed(AppRoutes.mainScreen);
            } else {
              Get.offAllNamed(AppRoutes.login);
            }
          },
          dotsDecorator: DotsDecorator(
          activeColor: ColorsBets.blueHD,
            color: ColorsBets.blueHD.withOpacity(0.3),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
          ),
          pages: getPages(),
          globalBackgroundColor: ColorsBets.whiteHD,
          showNextButton: true,
          next: const Icon(Icons.arrow_forward,color: ColorsBets.blueHD,),
          showBackButton: true,
          back: const Icon(Icons.arrow_back,color: ColorsBets.blueHD,),
        ),
      ),
    );
  }
}
