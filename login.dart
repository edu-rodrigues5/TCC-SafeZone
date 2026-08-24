import 'package:flutter/material.dart';
import 'package:safezone/Telas/cadastro.dart';
import 'package:safezone/bll.dart';
import 'package:safezone/cliente.dart';
import 'package:safezone/erro.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _LoginState();
}

class _LoginState extends State<AuthScreen> {
  final _emailText = TextEditingController();
  final _senhaText = TextEditingController();
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faça o Login"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailText,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            Row(
                children: [
                  Expanded(child: TextField(
                    controller: _senhaText,
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
              onPressed: () async {

                    Cliente cliente = Cliente("", _emailText.text, _senhaText.text);

                    bool erro = await BLL.validaLogin(cliente);

                    if(erro == false) {
                      Navigator.pushNamed((context), "/");
                    }
                    else {

                      ScaffoldMessenger.of((context)).showSnackBar(
                        SnackBar(
                          content: Text("Login falhou ${Erro.getMens()}"),),
                      );

                      Erro.resetaErro();
                    }

                  }
              ,
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cadastro()));
                Erro.resetaErro();
              },
              child: Text(
                'Não tem conta? Cadastre-se',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
