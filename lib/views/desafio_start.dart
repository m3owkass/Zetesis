import 'package:flutter/material.dart';

class DesafioStart extends StatefulWidget {
  const DesafioStart({super.key});

  @override
  State<DesafioStart> createState() => _DesafioStartState();
}

class _DesafioStartState extends State<DesafioStart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.heightOf(context) * 0.05),
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
          SizedBox(height: MediaQuery.heightOf(context)*0.1,),
          TextButton(onPressed: null, child: Center(
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
          ),),
          
        ],
      ),
    );
  }
}
