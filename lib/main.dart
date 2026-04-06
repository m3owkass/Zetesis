import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:zetesis/views/index.dart';
import 'package:zetesis/views/cadastro_screen.dart';
import 'firebase_options.dart';
import 'package:zetesis/views/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zetesis',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff251d30),

        colorScheme: ColorScheme.light(
          primary: Color(0xff5f54a0),
          onPrimary: Color(0xff38344f),
          surface: Color(0xfff8efeb)
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xffb7aac6)),
          ),

          hintStyle: TextStyle(color: Color(0xffb7aac6)),
        ),
      ),
      home: const CadastroScreen(),
      routes: {'/login': (context) => const LoginScreen(),'/cadastro':(context)=> const CadastroScreen(), '/index': (context) => const Index()},
    );
  }
}
