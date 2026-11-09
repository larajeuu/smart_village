import 'package:flutter/material.dart';

import '../widgets/sv_theme.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'peta_screen.dart';
import 'profile_screen.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _i, children: [
        HomeScreen(onOpenMap: () => setState(() => _i = 1)),
        // panah "←" di tab Peta kembali ke Beranda (sesuai desain)
        PetaScreen(onBack: () => setState(() => _i = 0)),
        const FavoritesScreen(),
        const ProfileScreen(),
      ]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: svLine)),
        ),
        child: BottomNavigationBar(
          currentIndex: _i,
          onTap: (v) => setState(() => _i = v),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: svBlue,
          unselectedItemColor: svSub,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Beranda'),
            BottomNavigationBarItem(
                icon: Icon(Icons.place_outlined),
                activeIcon: Icon(Icons.place),
                label: 'Peta'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                activeIcon: Icon(Icons.favorite),
                label: 'Favorit'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profil'),
          ],
        ),
      ),
    );
  }
}