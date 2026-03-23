import 'package:flutter/material.dart';
import 'package:zetesis/views/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zetesis',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfff8efeb),

        colorScheme: ColorScheme.light(primary: Color(0xffb7aac6), onPrimary: Color(0xff38344f)),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xffb7aac6)),
          ),

          hintStyle: TextStyle(color: Color(0xffb7aac6)),
        ),
      ),
      home: const LoginScreen(),
      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
