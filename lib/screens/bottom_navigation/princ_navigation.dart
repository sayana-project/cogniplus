import 'package:flutter/material.dart';
import 'dashboard.screen.dart';
import 'profil.screen.dart';
import 'trainning.screen.dart';
import 'home.screen.dart';

class PrincNavigationBar extends StatefulWidget {
  const PrincNavigationBar({super.key});

  @override
  State<PrincNavigationBar> createState() => _PrincNavigationBarState();
}

class _PrincNavigationBarState extends State<PrincNavigationBar> {
  int _selectedIndex =0;
  //ecran home,game,dashboard
  final List<Widget> _screen=const[
    HomeScreen(),
    TrainningScreen(),
    DashboardScreen(),
    ProfilScreen(),
  ];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,       // Couleur pour l'item sélectionné
        unselectedItemColor: Colors.grey,     // Couleur pour les items non sélectionnés
        backgroundColor: Colors.white,         // Fond blanc
        type: BottomNavigationBarType.fixed,  // Pour que tous les items soient visibles
        items: const[
          BottomNavigationBarItem(
            icon: Text('1', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Text('2', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            label: 'Trainning',
          ),
          BottomNavigationBarItem(
            icon: Text('3', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            label: 'Dashbaord',
          ),
          BottomNavigationBarItem(
            icon: Text('4', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
