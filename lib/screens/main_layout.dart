import 'package:flutter/material.dart';
// Ganti import ini dengan nama file aslimu:
import 'home_screen.dart'; // Halaman Screener (yang ada harga crypto berkedip)
import 'education_screen.dart';
import 'risk_calculator_screen.dart'; // Halaman Kalkulator Risiko-mu
import 'profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Masukkan class halaman aslimu di sini secara berurutan
  final List<Widget> _pages = [
    const HomeScreen(),           // Index 0: Screener
    const EducationScreen(),      // Index 1: Edukasi
    const RiskCalculatorScreen(), // Index 2: Kalkulator
    const ProfileScreen(),        // Index 3: Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Screener',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Edukasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Kalkulator', // Cocok untuk manajemen risiko
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}