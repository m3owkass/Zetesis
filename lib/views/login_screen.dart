import 'package:flutter/material.dart';
import 'package:zetesis/widgets/forms/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
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
            SizedBox(
              height: MediaQuery.of(context).size.height *0.3,
            ),

            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoginForm(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
