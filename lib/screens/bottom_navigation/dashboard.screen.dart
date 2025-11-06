import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre
              Text(
                'Progression',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 24),

              // Statistiques principales
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.psychology, size: 40, color: Colors.blue),
                            SizedBox(height: 8),
                            Text('Score Total', style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text('2850', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.calendar_today, size: 40, color: Colors.green),
                            SizedBox(height: 8),
                            Text('Jours actifs', style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text('7', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Progression par jeu
              Text(
                'Progression par jeu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProgressRow('Calcul mental', 0.8),
                      SizedBox(height: 8),
                      _buildProgressRow('Mémoire', 0.6),
                      SizedBox(height: 8),
                      _buildProgressRow('Couleurs', 0.4),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Derniers scores
              Text(
                'Derniers scores',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildScoreRow('Calcul mental', '250 pts'),
                      SizedBox(height: 8),
                      _buildScoreRow('Mémoire', '180 pts'),
                      SizedBox(height: 8),
                      _buildScoreRow('Couleurs', '120 pts'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildProgressRow(String game, double progress) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(game)),
        Expanded(
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        SizedBox(width: 8),
        Text('${(progress * 100).toInt()}%'),
      ],
    );
  }

  static Widget _buildScoreRow(String game, String score) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(game),
        Text(score, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
