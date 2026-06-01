import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/views/desafio_start.dart';
import 'package:zetesis/views/login_screen.dart';
import 'package:zetesis/views/loja_screen.dart';
import 'package:zetesis/widgets/components/appbar.dart';
import 'package:zetesis/widgets/components/bottom_navigation.dart';

class Index extends ConsumerStatefulWidget {
  const Index({super.key});

  @override
  ConsumerState<Index> createState() => _IndexState();
}

class _IndexState extends ConsumerState<Index> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DesafioStart(),
      const LoginScreen(),
      const LojaScreen(),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomStatefulAppBar(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffcbafa2), width: 2.0)),
        ),
        child: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
        ),
      ),
      body: pages[_currentIndex],
    );
  }
}
