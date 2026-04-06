import 'package:flutter/material.dart';
import 'package:zetesis/widgets/forms/cadastro_form.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07, left:MediaQuery.of(context).size.height * 0.02),
              child: Align(
                alignment: AlignmentGeometry.topLeft,
                child: Text(
                  "Zetesis",
                  textAlign: TextAlign.left,  
                  style: TextStyle(
                    
                    color: Colors.white70,  
                    fontSize: MediaQuery.of(context).size.height * 0.06,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.02),
              child: Align(
                alignment: AlignmentGeometry.topLeft,
                child: Text(
                  "Login",
                  textAlign: TextAlign.left,  
                  style: TextStyle(
                    
                    color: Colors.white70,
                    fontSize: MediaQuery.of(context).size.height * 0.025,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height *0.2,
            ),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CadastroForm(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
