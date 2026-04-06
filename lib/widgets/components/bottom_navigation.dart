import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<CustomBottomNav> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image(image: AssetImage('assets/home.webp'), height: 70),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image(image: AssetImage('assets/biblioteca.webp'), height: 70),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image(image: AssetImage('assets/loja.webp'), height: 70),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image(
            image: AssetImage('assets/config.webp'),
            fit: BoxFit.scaleDown,
            height: 70,
          ),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
