import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/controller/auth_controller.dart';
import 'package:zetesis/views/selecao_tema.dart';

class DesafioStart extends ConsumerStatefulWidget {
  int desafioSelecionado;

   DesafioStart({super.key,this.desafioSelecionado =0});

  @override
  ConsumerState<DesafioStart> createState() => _DesafioStartState();
   
  void setDesafio(int index){
   desafioSelecionado = index;
  }

  int getDesafio(){
    return desafioSelecionado;
  }
}

class _DesafioStartState extends ConsumerState<DesafioStart> {
  
  DesafioStart  desafioStart = DesafioStart();
  int desafioSelecionado=0;

  setDesafio(){
    setState(() {
      desafioSelecionado = desafioStart.getDesafio();
    });
  }

  final List<String> images = [
    'assets/desafio_placeholder.png',
    'assets/icon_google.png',
    'assets/biblioteca.webp',
    'assets/loja.webp',
  ];
  final List<String> temas = [
    'existencia',
    'subjetividade',
    'verdade',
    'dinheiro',
  ];

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
                MaterialPageRoute<int>(builder: (context) => SelecaoTema()),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xfff0915a),
                  borderRadius: BorderRadius.circular(180),
                ),
                height: MediaQuery.heightOf(context) * 0.35,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(images[desafioSelecionado]),
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
                  temas[desafioSelecionado],
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
                  temas[desafioSelecionado],
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
