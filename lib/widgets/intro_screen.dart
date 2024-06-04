import 'package:codebets/style/color_style.dart';
import 'package:codebets/style/text_style.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  List<PageViewModel> getPages() {
    return [
      //cos'è
      PageViewModel(
        image: Image.asset('assets/logo.png',scale: 1,),
        title: "Benvenuto su CodeBets!",
        body: "Entra nel divertimento delle scommesse con i tuoi colleghi! Guarda le scommesse attive e fai la tua mossa per vincere punti!",
        decoration: PageDecoration(
          titleTextStyle: TextStyleBets.onboardTitle, // Stile del titolo
          bodyTextStyle: TextStyleBets.onboardBody, // Stile del corpo del testo
          imagePadding: const EdgeInsets.only(top: 100.0), // Spazio dall'alto per l'immagine
        ),
      ),
      PageViewModel(
        image: Image.network('https://img.freepik.com/free-vector/sports-betting-isometric-composition-with-mobile-phone-notebook-with-gambling-application-vector-illustration_1284-78809.jpg'),
        title: "Crea e Partecipa alle Scommesse",
        body: "Metti alla prova la tua astuzia! Crea la tua scommessa e sfida i tuoi colleghi.",
        decoration: PageDecoration(
          titleTextStyle: TextStyleBets.onboardTitle, // Stile del titolo
          bodyTextStyle: TextStyleBets.onboardBody, // Stile del corpo del testo
          imagePadding: const EdgeInsets.only(top: 100.0), // Spazio dall'alto per l'immagine
        ),
      ),
      PageViewModel(
        image: Image.network('https://img.freepik.com/free-vector/competition-scoring-concept-illustration_114360-21193.jpg'),
        title: "Il Punteggio",
        body: "Scommetti e guadagna punti!\n5 punti se indovini, 2 se sei il target. Chi arriverà in cima alla classifica?",
        decoration: PageDecoration(
          titleTextStyle: TextStyleBets.onboardTitle, // Stile del titolo
          bodyTextStyle: TextStyleBets.onboardBody, // Stile del corpo del testo
          imagePadding: const EdgeInsets.only(top: 100.0), // Spazio dall'alto per l'immagine
        ),
      ),
      PageViewModel(
        image: Image.network('https://img.freepik.com/free-vector/business-vision-prediction-forecasting-career-opportunities-monitoring-job-perspectives-searching-strategy-planning-leadership-motivation_335657-148.jpg',),
        title: "La Classifica",
        body: "Scala la classifica e diventa il re delle scommesse! Vinci più punti, fai più scommesse e diventa il piu... ludopatico?",
        decoration: PageDecoration(
          titleTextStyle: TextStyleBets.onboardTitle, // Stile del titolo
          bodyTextStyle: TextStyleBets.onboardBody, // Stile del corpo del testo
          imagePadding: const EdgeInsets.only(top: 100.0), // Spazio dall'alto per l'immagine
        ),
      ),
      PageViewModel(
        image: Image.network('https://img.freepik.com/free-vector/flat-design-starting-line-illustration_23-2149459875.jpg'),
        title: "Sei Pronto?",
        body: "Sfida i tuoi amici, guadagna punti, e goditi l'emozione del rischio! Entra ora e inizia a vincere!",
        decoration: PageDecoration(
          titleTextStyle: TextStyleBets.onboardTitle, // Stile del titolo
          bodyTextStyle: TextStyleBets.onboardBody, // Stile del corpo del testo
          imagePadding: const EdgeInsets.only(top: 100.0), // Spazio dall'alto per l'immagine
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          done: Text("Scommetti", style: TextStyleBets.dialogTitle.copyWith(fontSize: 14)),
          onDone: () { Navigator.of(context).pop(); },
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
