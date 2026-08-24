import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safezone/Telas/gravacao.dart';
import 'package:safezone/Telas/home_screen.dart';
import 'package:safezone/Telas/login.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Pedir permissões
  await Permission.microphone.request();
  await Permission.location.request();
  await Permission.sms.request();

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
      initialRoute: "/roteador",  // Rota inicial
      routes: {            // Registro das rotas
        '/': (context) => const HomeScreen(),
        '/auth': (context) => const AuthScreen(),
        '/roteador': (context) => const Roteador(),
        '/gravador': (context) => const Gravacao(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
      ),
    );
  }
}

class Roteador extends StatelessWidget {
  const Roteador({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
      if(snapshot.hasData)
      {
        return HomeScreen();
      }else
      {
        return AuthScreen();
      }
    },);
  }
}

//fazer a classe que verifica se o usuário está logado