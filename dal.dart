import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safezone/cliente.dart';

class DAL {
    //var snapshot = await db.get();


    void create(Cliente cl) async {

      try{
        FirebaseFirestore.instance.collection('clientes').add({
            'nome': cl.getNome,
            'email': cl.getEmail,
            'senha' : cl.getSenha,
        });

        print("Cadastro realizado!!");
      }catch(e){
          print("Erro: O cadastro não foi realizado $e");
      }

    }


    //tá tudo errado, ele nem tá conectado direito com o firebase e não tá encontrando as funções de DAL no Mycode
/*
    void Consultar(String nome) async {
      await db.get(db.id);
    }

    void Delete(String id) async {
      await usuarios.doc(id).delete();
    }

    void Update(String id, String nome, int idade) async {
      await usuarios.doc(id).update({
          'nome':nome,
          'idade': idade,
      });
    }*/
}