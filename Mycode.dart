import 'package:flutter/material.dart';

import 'DAL.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCC',
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

// ⭐ MUDE para StatefulWidget
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _itson = true;

  void _toggleButton() {
    setState(() {
      _itson = !_itson;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('SafeZone')),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bem-vindo à Home!'),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/auth');
              },
              child: const Text('Ir para Login/Cadastro'),
            ),

            const SizedBox(height: 20),

            // ⭐ Status do botão
            Text('Status: ${_itson ? "Ligado" : "Desligado"}'),
            const SizedBox(height: 20),

            // ⭐ Botão com GestureDetector (sem parêntese extra)
            GestureDetector(
              onTap: _toggleButton,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _itson ? Colors.green : Colors.red,
                ),
                child: Icon(
                  _itson ? Icons.power_settings_new : Icons.power_off,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoginMode = true;

  final _email = TextEditingController();
  final _senhaController = TextEditingController();
  final _nomeController = TextEditingController();
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Login' : 'Cadastro'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_isLoginMode)
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
              Row(
                children: [
                  Expanded(child: TextField(
                    controller: _senhaController,
                    decoration: const InputDecoration(labelText: 'Senha'),
                    obscureText: _oculto,
                    )
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _oculto = !_oculto;
                      });
                    },
                    child: Text(_oculto ? 'Mostrar' : 'Ocultar'),
                  )
                ]

              )
            ,
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if(_isLoginMode){
                  DAL.Create(_nomeController, _email, _senhaController);
                }

              },
              child: Text(_isLoginMode ? 'Entrar' : 'Cadastrar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoginMode = !_isLoginMode;
                });
              },
              child: Text(
                _isLoginMode
                    ? 'Não tem conta? Cadastre-se'
                    : 'Já tem conta? Faça login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}