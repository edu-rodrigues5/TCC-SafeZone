import 'package:flutter/material.dart';
import 'package:safezone/Telas/cadastro.dart';
import 'package:safezone/cliente.dart';
import 'package:safezone/dal.dart';
import 'package:safezone/Telas/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _LoginState();
}

class _LoginState extends State<AuthScreen> {
  final _emailCampo = TextEditingController();
  final _senhaCampo = TextEditingController();
  bool _oculto = true;
  Cliente cliente = Cliente();
  DAL db = DAL();

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
              controller: _emailCampo,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            Row(
                children: [
                  Expanded(child: TextField(
                    controller: _senhaCampo,
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
            ElevatedButton( //BLL para validar email
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: () {

                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cadastro()));
                print("oi");

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
  void validar() {

  }
}

/*class _CadastroState extends State<AuthScreen> {
  bool _isLoginMode = true;

  final _nomeCampo = TextEditingController();
  final _emailCampo = TextEditingController();
  final _senhaCampo = TextEditingController();
  bool _oculto = true;
  Cliente cliente = Cliente();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nomeCampo,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _emailCampo,
              decoration: const InputDecoration(labelText: 'E-mail'),
              keyboardType: TextInputType.emailAddress,
            ),
            Row(
                children: [
                  Expanded(child: TextField(
                    controller: _senhaCampo,
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
            ElevatedButton( //DAL para inserir
              onPressed: () {
                cliente.nome = _nomeCampo.text;
                cliente.email = _emailCampo.text;
                cliente.senha = int.parse(_senhaCampo.text);

              },
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: (){
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
                Navigator.pushNamed(context, '/');
                print("oi");
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
*/

/*
* bool _isLoginMode = true;

  final _email = TextEditingController();
  final _senhaController = TextEditingController();
  final _nomeController = TextEditingController();
  bool _oculto = true;
  Cliente cliente = Cliente();
  DAL db = DAL();

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
                if(!_isLoginMode){  //cadastro
                  cliente.nome = _nomeController.text;
                  cliente.email = _email.text;
                  cliente.nome = _nomeController.text;

                  print("a");
                  db.Create(cliente);
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
    );*/