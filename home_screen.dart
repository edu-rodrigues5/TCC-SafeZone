
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _itson = true;

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

            Text('Status: ${_itson ? "Ligado" : "Desligado"}'),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: (){
                setState(() {
                  _itson = !_itson;
                });
              },
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