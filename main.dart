import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:safezone/Telas/home_screen.dart';
import 'package:safezone/Telas/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeZone-TCC',
      initialRoute: '/',  // Rota inicial
      routes: {            // Registro das rotas
        '/': (context) => const HomeScreen(),
        '/auth': (context) => const AuthScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
      ),
    );
  }
}

