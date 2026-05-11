import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/controller/auth_controller.dart';
import 'package:zetesis/views/desafio_selecao.dart';

class DesafioStart extends ConsumerStatefulWidget {
  const DesafioStart({super.key});

  @override
  ConsumerState<DesafioStart> createState() => _DesafioStartState();
}

class _DesafioStartState extends ConsumerState<DesafioStart> {
  void _logout() async {
    await ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.heightOf(context) * 0.05),
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<int>(
                  builder: (context) => DesafioSelecao(),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xfff0915a),
                  borderRadius: BorderRadius.circular(180),
                ),
                height: MediaQuery.heightOf(context) * 0.35,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset('assets/desafio_placeholder.png'),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.widthOf(context) * 0.6,
              height: MediaQuery.heightOf(context) * 0.063,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff6055a2),
              ),
              child: Center(
                child: Text(
                  'Existência',
                  style: TextStyle(
                    fontSize: MediaQuery.heightOf(context) * 0.03,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.widthOf(context) * 0.4,
              height: MediaQuery.heightOf(context) * 0.063,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff8175c8),
              ),
              child: Center(
                child: Text(
                  'Existência',
                  style: TextStyle(
                    fontSize: MediaQuery.heightOf(context) * 0.02,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.heightOf(context) * 0.1),
          TextButton(
            onPressed: _logout,
            child: Center(
              child: Container(
                width: MediaQuery.widthOf(context) * 0.7,
                height: MediaQuery.heightOf(context) * 0.063,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xfff0915a),
                ),
                child: Center(
                  child: Text(
                    'Iniciar Desafio',
                    style: TextStyle(
                      fontSize: MediaQuery.heightOf(context) * 0.03,
                      color: Color(0xff23255d),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
