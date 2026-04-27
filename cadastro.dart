import 'package:flutter/material.dart';
import 'package:safezone/cliente.dart';
import 'package:safezone/dal.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final nomeText = TextEditingController();
  final emailText = TextEditingController();
  final senhaText = TextEditingController();
  DAL firebase = DAL();
  Cliente cliente = Cliente();

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Cadastro"),
      backgroundColor: Colors.redAccent,
    ),
    body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nomeText,
                decoration: const InputDecoration(labelText: "Nome"),
                keyboardType: TextInputType.text,
            ),
              TextField(
                controller: emailText,
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
            ),
              TextField(
                controller: senhaText,
                decoration: const InputDecoration(labelText: "Senha"),
                keyboardType: TextInputType.text,
                obscureText: true,
            ),
            Container(
              height: 20,
            ),
            Row(

              children: [
                ElevatedButton(onPressed: (){
                  try {
                    cliente.nome = nomeText.text;
                    cliente.email = emailText.text;
                    cliente.senha = int.parse(senhaText.text);

                    print(cliente.getNome);
                    print(cliente.getSenha);
                    print(cliente.getEmail);

                    firebase.create(cliente);
                  }catch(e)
                  {
                    print("Erro aqui ó $e");
                  }
                },
                    child: Text("Cadastrar")),

                TextButton(onPressed: (){
                    Navigator.pushNamed(context, "/auth");
                },
                    child: Text("Já tem conta? Clique aqui!")),
              ],
            )
            ],
      ),
    ),
  );
  }
}
