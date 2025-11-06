import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class ColorGame extends StatefulWidget {
  const ColorGame({super.key});

  @override
  State<ColorGame> createState() => _ColorGameState();
}

class _ColorGameState extends State<ColorGame> with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;

  int score = 0;
  int timeLeft = 60; // 60 secondes
  String questionText = '';
  Color questionColor = Colors.black;
  Color correctAnswer = Colors.black;
  List<String> colorNames = [];
  List<Color> colorValues = [];
  bool isGameActive = false;
  bool isProcessingAnswer = false;
  late Timer _gameTimer;

  @override
  void initState() {
    super.initState();
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _initializeColors();
    _startNewGame();
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _gameTimer.cancel();
    super.dispose();
  }

  void _initializeColors() {
    colorNames = ['ROUGE', 'BLEU', 'VERT', 'JAUNE', 'ORANGE', 'VIOLET', 'ROSE', 'GRIS'];
    colorValues = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.grey,
    ];
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

    // Choisir la couleur d'écriture (qui devient la bonne réponse)
    int colorIndex = random.nextInt(8);
    questionColor = _getColorByIndex(colorIndex);
    questionText = _getColorNameByIndex(colorIndex);
    correctAnswer = questionColor;  // La bonne réponse est la couleur affichée
  }

  // Fonction sûre pour obtenir la couleur par index
  Color _getColorByIndex(int index) {
    switch(index) {
      case 0: return Colors.red;
      case 1: return Colors.blue;
      case 2: return Colors.green;
      case 3: return Colors.yellow;
      case 4: return Colors.orange;
      case 5: return Colors.purple;
      case 6: return Colors.pink;
      case 7: return Colors.grey;
      default: return Colors.black;
    }
  }

  // Fonction sûre pour obtenir le nom de couleur par index
  String _getColorNameByIndex(int index) {
    switch(index) {
      case 0: return 'ROUGE';
      case 1: return 'BLEU';
      case 2: return 'VERT';
      case 3: return 'JAUNE';
      case 4: return 'ORANGE';
      case 5: return 'VIOLET';
      case 6: return 'ROSE';
      case 7: return 'GRIS';
      default: return 'NOIR';
    }
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

  void _checkAnswer(Color selectedColor) {
    if (!isGameActive || isProcessingAnswer) return;

    setState(() {
      isProcessingAnswer = true;
    });

    if (selectedColor == correctAnswer) {
      setState(() {
        score += 10;
      });

      _scoreAnimationController.forward().then((_) {
        _scoreAnimationController.reverse();
      });

      // Pause avant de g�n�rer la prochaine question
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _generateQuestion();
          setState(() {
            isProcessingAnswer = false;
          });
        }
      });
    } else {
      setState(() {
        score = max(0, score - 5);
        isProcessingAnswer = false;
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
          title: const Text('Partie termin�e !'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Score final: $score'),
              const SizedBox(height: 16),
              Text(
                score >= 100
                  ? 'Excellent reflexe cognitif !'
                  : score >= 50
                    ? 'Bon travail !'
                    : 'Continue de t\'entra�ner !',
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
        title: const Text('Jeu de Couleurs'),
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
                questionText,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: questionColor,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Indication
            const Text(
              'Clique sur la COULEUR R�ELLE',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 32),

            // Grille de couleurs 8 cases (4x2)
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
                  Color buttonColor = _getColorByIndex(index);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(buttonColor),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: _getContrastColor(buttonColor),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _getColorNameByIndex(index),
                        style: const TextStyle(
                          fontSize: 12,
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

  Color _getContrastColor(Color backgroundColor) {
    // Calculer la luminance pour d�terminer si on doit utiliser du texte noir ou blanc
    double luminance = (0.299 * backgroundColor.red + 0.587 * backgroundColor.green + 0.114 * backgroundColor.blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}