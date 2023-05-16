import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(WordGuessingGame());
}

class WordGuessingGame extends StatefulWidget {
  @override
  _WordGuessingGameState createState() => _WordGuessingGameState();
}

class _WordGuessingGameState extends State<WordGuessingGame> {
  Random random = Random();
  List<String> stages = ["Yasuo", "Yone", "Syndra", "Malzahar", "Garen", "Mordekaiser", "Lux", "Morgana", "Samira"];
  int currentStage = 0;
  String selectedWord = "";
  String guessedWord = "";
  bool wordGuessed = false;
  bool gameFinished = false;
  List<String> availableLetters = [
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
    'z', 'x', 'c', 'v', 'b', 'n', 'm'
  ];
  List<bool> buttonStates = List<bool>.generate(26, (index) => true);

  @override
  void initState() {
    super.initState();
    selectWord();
  }

  void selectWord() {
    selectedWord = stages[currentStage];
    guessedWord = List.filled(selectedWord.length, '-').join();
  }

  void makeGuess(int index) {
    setState(() {
      String letter = availableLetters[index];
      buttonStates[index] = false;

      if (selectedWord.toLowerCase().contains(letter)) {
        List<String> updatedWord = List<String>.generate(
          selectedWord.length,
              (index) {
            if (selectedWord[index].toLowerCase() == letter.toLowerCase()) {
              return selectedWord[index];
            } else {
              return guessedWord[index];
            }
          },
        );
        guessedWord = updatedWord.join();
      }

      if (!guessedWord.contains('-')) {
        wordGuessed = true;
      }

      if (wordGuessed && currentStage == stages.length - 1) {
        gameFinished = true;
      }
    });

    if (wordGuessed) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          if (currentStage < stages.length - 1) {
            currentStage++;
            selectWord();
            resetButtons();
          } else {
            gameFinished = true;
          }
          wordGuessed = false;
        });
      });
    }
  }

  void resetButtons() {
    buttonStates = List<bool>.generate(26, (index) => true);
  }

  void goToNextStage() {
    setState(() {
      if (currentStage < stages.length - 1) {
        currentStage++;
        selectWord();
        resetButtons();
        gameFinished = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Lol Şampiyon Tahmin Oyunu',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
          title: const Text('Lol Şampiyon Tahmin Oyunu'),
    ),
          body: Column(
          children: [
            Expanded(
            child: Center(
             child: Text(guessedWord,
    style: const TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
    ),
    ),
    ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < 10; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: buttonStates[i] ? () => makeGuess(i) : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return Colors.blue;
                      },
                    ),
                  ),
                  child: Text(
                    availableLetters[i],
                    style: const TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
            ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 10; i < 19; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  onPressed: buttonStates[i] ? () => makeGuess(i) : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Colors.grey;
                        }
                        return Colors.blue;
                      },
                    ),
                  ),
                  child: Text(
                    availableLetters[i],
                    style: const TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
            ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 19; i < 26; i++)
            if (i < availableLetters.length)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: buttonStates[i] ? () => makeGuess(i) : null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey;
                          }
                          return Colors.blue;
                        },
                      ),
                    ),
                    child: Text(
                      availableLetters[i],
                      style: const TextStyle(fontSize: 24.0),
                    ),
                  ),
                ),
              ),
        ],
      ),
      if (gameFinished && currentStage < stages.length - 1)
        ElevatedButton(
          onPressed: goToNextStage,
          child: const Text('Sonraki Seviye'),
        ),
      if (gameFinished && currentStage == stages.length - 1)
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Tebrikler! Oyunu Tamamladınız!',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
    ],
    ),
        ),
    );
  }
}
