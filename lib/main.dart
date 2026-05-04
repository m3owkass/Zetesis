import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zetesis/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox<Map>('userBox');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zetesis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff251d30),
        colorScheme: const ColorScheme.light(
          primary: Color(0xff5f54a0),
          onPrimary: Color(0xff38344f),
          surface: Color(0xfff8efeb),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xffb7aac6)),
          ),
          hintStyle: const TextStyle(color: Color(0xffb7aac6)),
          prefixIconColor: Color.fromARGB(255, 110, 99, 156),
        ),
      ),
      home: const AuthGate(),
    );
  }
}