import 'package:flutter/material.dart';
import 'package:safezone/bll.dart';
import 'package:safezone/cliente.dart';
import 'package:safezone/erro.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final nomeText = TextEditingController();
  final emailText = TextEditingController();
  final senhaText = TextEditingController();


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

                    Cliente cliente = Cliente(nomeText.text, emailText.text, senhaText.text);


                    BLL.validaCadastro(cliente);


                    if(Erro.getErro()==false){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cadastro Realizado"),),
                      );
                    }else{


                      //print(Erro.getErro());
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cadastro não Realizado: ${Erro.getMens()}"),),
                      );
                      Erro.resetaErro();

                    }

                },
                    child: Text("Cadastrar")),

                TextButton(onPressed: (){
                    Navigator.pushNamed(context, "/auth");
                    Erro.resetaErro();
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
