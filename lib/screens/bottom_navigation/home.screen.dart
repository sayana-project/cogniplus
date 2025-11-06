import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Les 10 phrases inspirantes
  final List<String> _inspirationalQuotes = [
    "L'intelligence est la capacité de s'adapter au changement.",
    "Chaque jour est une nouvelle opportunité d'apprendre.",
    "Ton cerveau est un muscle, plus tu l'entraînes, plus il devient fort.",
    "La curiosité est le moteur de l'apprentissage.",
    "Les erreurs sont des étapes indispensables vers la maîtrise.",
    "Apprendre aujourd'hui pour être meilleur demain.",
    "La connaissance est un trésor qui suit partout son possesseur.",
    "Chaque problème résolu rend ton esprit plus agile.",
    "La persévérance est la clé de la réussite cognitive.",
    "Ton potentiel est illimité, continue d'explorer."
  ];

  late String _randomQuote;

  @override
  void initState() {
    super.initState();
    _generateRandomQuote();
  }

  void _generateRandomQuote() {
    final random = DateTime.now().millisecond;
    setState(() {
      _randomQuote = _inspirationalQuotes[random % _inspirationalQuotes.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cogniplus')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. PHRASE INSPIRANTE
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.blue, size: 40),
                    const SizedBox(height: 16),
                    Text(
                      "Citation du jour",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _randomQuote,
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _generateRandomQuote,
                      child: const Text("Nouvelle citation"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 2. BOUTON JEU RAPIDE
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Le jeu de calcul arrive bientôt !')),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Jeu Rapide - Calcul Mental',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 24),

            // 3. MINI TABLEAU DE BORD PERSONNEL
            const Text(
              'Mon Progrès',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.local_fire_department, color: Colors.orange, size: 30),
                          const SizedBox(height: 8),
                          const Text('Streak', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text('7 jours', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.psychology, color: Colors.blue, size: 30),
                          const SizedBox(height: 8),
                          const Text('Points', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 4),
                          Text('1,250', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
