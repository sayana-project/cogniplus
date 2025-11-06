import 'package:flutter/material.dart';
import 'package:cogniplus/screens/calcul.game.dart';
import 'package:cogniplus/screens/color.game.dart';

class TrainningScreen extends StatelessWidget {
  const TrainningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Training')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Carte Calcul Mental
            Card(
              child: ListTile(
                title: const Text(
                  'CALCUL MENTAL',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Jouer'),
                trailing: const Icon(Icons.play_arrow),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CalculGame()),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Carte Mémoire
            Card(
              color: Colors.grey[100],
              child: ListTile(
                title: const Text(
                  'MÉMOIRE',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Bientôt disponible'),
                trailing: const Icon(Icons.play_for_work),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ce jeu arrive bientôt !')),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Carte Couleurs
            Card(
              child: ListTile(
                title: const Text(
                  'COULEURS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Jouer'),
                trailing: const Icon(Icons.play_arrow),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ColorGame()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
