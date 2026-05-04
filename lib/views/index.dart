import 'package:flutter/material.dart';
import 'package:zetesis/views/desafio_start.dart';
import 'package:zetesis/views/login_screen.dart';
import 'package:zetesis/widgets/components/appbar.dart';
import 'package:zetesis/widgets/components/bottom_navigation.dart';

class Index extends StatelessWidget {
  Index({super.key});
  final List<Widget> _pages = [DesafioStart(), LoginScreen()];

  CustomBottomNav bottomNav = CustomBottomNav();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomStatefulAppBar(title: 'Olá USERNAME'),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xffcbafa2), width: 2.0)),
        ),
        child: CustomBottomNav(),
      ),
    body: _pages[0]);
  }
}

