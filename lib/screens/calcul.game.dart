import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class CalculGame extends StatefulWidget {
  const CalculGame({super.key});

  @override
  State<CalculGame> createState() => _CalculGameState();
}

class _CalculGameState extends State<CalculGame> with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;

  int score = 0;
  int timeLeft = 60; // 60 secondes
  int correctAnswer = 0;
  String question = '';
  List<int> answers = <int>[];
  bool isGameActive = false;
  bool isProcessingAnswer = false;  // Anti double-clic
  late Timer _gameTimer;

  @override
  void initState() {
    super.initState();
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _startNewGame();
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _gameTimer.cancel();
    super.dispose();
  }

  void _startNewGame() {
    setState(() {
      score = 0;
      timeLeft = 60;
      isGameActive = true;
    });

    _generateQuestion();
    _startTimer();
  }

  void _generateQuestion() {
    Random random = Random();
    int a = random.nextInt(20) + 1;
    int b = random.nextInt(20) + 1;
    int operation = random.nextInt(4);

    switch (operation) {
      case 0: // Addition
        correctAnswer = a + b;
        question = '$a + $b';
        break;
      case 1: // Soustraction
        correctAnswer = a - b;
        question = '$a - $b';
        break;
      case 2: // Multiplication
        correctAnswer = a * b;
        question = '$a × $b';
        break;
      case 3: // Division
        b = random.nextInt(10) + 1;
        a = b * (random.nextInt(10) + 1);
        correctAnswer = a ~/ b;
        question = '$a ÷ $b';
        break;
    }

    _generateAnswers();
  }

  void _generateAnswers() {
    Random random = Random();
    answers = [correctAnswer];

    while (answers.length < 8) {
      int wrongAnswer = correctAnswer + random.nextInt(20) - 10;
      if (wrongAnswer > 0 && !answers.contains(wrongAnswer)) {
        answers.add(wrongAnswer);
      }
    }

    answers.shuffle();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          _endGame();
        }
      });
    });
  }

  void _checkAnswer(int selectedAnswer) {
    if (!isGameActive || isProcessingAnswer) return;

    setState(() {
      isProcessingAnswer = true;  // Bloque les clics
    });

    if (selectedAnswer == correctAnswer) {
      setState(() {
        score += 10;
      });

      _scoreAnimationController.forward().then((_) {
        _scoreAnimationController.reverse();
      });

      // Pause avant de générer la prochaine question
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _generateQuestion();
          setState(() {
            isProcessingAnswer = false;  // Réactive les clics
          });
        }
      });
    } else {
      setState(() {
        score = max(0, score - 5); // Decrease score
        isProcessingAnswer = false;  // Réactive immédiatement pour les mauvaises réponses
      });
    }
  }

  void _endGame() {
    setState(() {
      isGameActive = false;
    });
    _gameTimer.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Partie terminée !'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Score final: $score'),
              const SizedBox(height: 16),
              Text(
                score >= 100
                  ? 'Excellent performance !'
                  : score >= 50
                    ? 'Bon travail !'
                    : 'Continue de t\'entraîner !',
                style: TextStyle(
                  color: score >= 100
                    ? Colors.green
                    : score >= 50
                      ? Colors.blue
                      : Colors.orange,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startNewGame();
              },
              child: const Text('Rejouer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Retour'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcul Mental'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewGame,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header avec score et timer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),
                        const SizedBox(width: 8),
                        AnimatedBuilder(
                          animation: _scoreAnimationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 1.0 + (_scoreAnimationController.value * 0.2),
                              child: Text(
                                'Score: $score',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  color: timeLeft <= 10 ? Colors.red.shade100 : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer,
                          color: timeLeft <= 10 ? Colors.red : Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Temps: ${timeLeft}s',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: timeLeft <= 10 ? Colors.red : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Question
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                question,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Grille de réponses 8 cases (4x2)
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(answers[index]),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue.shade700,
                        side: BorderSide(color: Colors.blue.shade300),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        answers[index].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bouton pour abandonner
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _gameTimer.cancel();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red.shade700,
                ),
                child: const Text('Abandonner'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
