import 'package:flutter/material.dart';

class DesafioSelecao extends StatefulWidget {
  const DesafioSelecao({super.key});

  @override
  State<DesafioSelecao> createState() => _DesafioSelecaoState();
}

class _DesafioSelecaoState extends State<DesafioSelecao> {
  @override
  Widget build(BuildContext context) {
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
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,

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
                                  child: Image.asset(
                                    'assets/desafio_placeholder.png',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: MediaQuery.widthOf(context)*0.5,
                            height: MediaQuery.heightOf(context)*0.05,
                            decoration: BoxDecoration(
                              color: Color(0xff6055a2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text("existência", style: TextStyle(fontSize: MediaQuery.heightOf(context)*0.03),),
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
