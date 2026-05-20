import 'package:flutter/material.dart';
import 'package:zetesis/views/desafio_start.dart';

class SelecaoTema extends StatefulWidget {
  const SelecaoTema({super.key});

  @override
  State<SelecaoTema> createState() => _SelecaoTemaState();
}

class _SelecaoTemaState extends State<SelecaoTema> {
  @override
  DesafioStart desafioStart = DesafioStart();

  Widget build(BuildContext context) {
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
    

    return Scaffold(
      backgroundColor: const Color(0xff251d30),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.heightOf(context) * 0.05,
            bottom: MediaQuery.heightOf(context) * 0.05,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.widthOf(context) * 0.7,
                height: MediaQuery.heightOf(context) * 0.05,
                decoration: BoxDecoration(
                  color: Color(0xff6055a2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Escolha seu Tema",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: MediaQuery.of(context).size.height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: temas.length,

                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.heightOf(context) * 0.13),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              width: MediaQuery.widthOf(context),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0,
                                ),
                                child: Container(
                                  width: MediaQuery.widthOf(context) * 0.5,
                                  height: MediaQuery.heightOf(context) * 0.38,
                                  decoration: BoxDecoration(
                                    color: Color(0xfff0915a),
                                    borderRadius: BorderRadius.circular(2000),
                                  ),
                                  child: Image.asset(images[index]),
                                ),
                              ),
                            ),
                          ),
                          FilledButton(
                            onPressed: () {
                              desafioStart.setDesafio(index);
                              Navigator.pop(context);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.widthOf(context) * 0.5,
                              height: MediaQuery.heightOf(context) * 0.05,
                              decoration: BoxDecoration(
                                color: Color(0xff6055a2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                temas[index],
                                style: TextStyle(
                                  fontSize: MediaQuery.heightOf(context) * 0.03,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
