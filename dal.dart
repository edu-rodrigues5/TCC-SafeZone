
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safezone/cliente.dart';
import 'package:safezone/erro.dart';
import 'package:safezone/funcao.dart';
import 'contato.dart';

class DAL {

  void cadastrar(Cliente cl) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: cl.getEmail.toString(),
        password: cl.getSenha.toString(),
      );


    } on FirebaseAuthException catch (e) {
      Erro.setErro("Deu Erro no cadastro DAL  ${e.code}");
    }
  }

  void cadastraContato(Contato cont) async{

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Usuário não logado");
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        "nome": cont.getNome,
        "numero": cont.getNumero,
      }, SetOptions(merge: true));

      print("Contato gravado com sucesso!");
    } on FirebaseAuthException catch (e) {
      Erro.setErro("Deu erro na gravacao");
    }
  }

  Future<Contato> resgataContato() async{
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Usuário não logado");
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    Contato a = Contato(doc.get("nome"),doc.get("numero"));

    return a;
  }

  void gravaFunc(Funcao gatilho) async{
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Usuário não logado");
    }

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('gatilhos')
            .add({
          'palavras': gatilho.getPalavras(),
          'mensagem': gatilho.getMens(),
        });

        print("Funcao gravada com sucesso!");
      } on FirebaseAuthException catch (e) {
        Erro.setErro("Deu erro na gravacao");
      }

  }

  Future<void> alterarBotao(bool ativo,String funcao) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Usuário não logado");
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set({
      "botaoAtivo": ativo,
      "funcao": funcao,
    }, SetOptions(merge: true));
  }

  Future<String> buscarFunc() async{

    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Usuário não logado");
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.get("funcao");
  }

  Future<bool> buscarLigado() async{
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("Usuário não logado");
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.get("botaoAtivo");
  }


  Future<List<Map<String, dynamic>>> pegarConfig() async {
    User? user = FirebaseAuth.instance.currentUser;

    if(user ==null){
      throw Exception("Erro no login");
    }

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("gatilhos")
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future <bool> login(Cliente cl) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: cl.getEmail.toString(), password: cl.getSenha.toString(),
      );

      return false;
    } on FirebaseAuthException catch (e) {
      Erro.setErro("Erro no DAL login");

      return true;
    }
  }


}