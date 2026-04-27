
class Cliente {
  String? nome;
  String? email;
  int? senha;

  Cliente({this.nome, this.email, this.senha});

//métodos

    String? get getNome => nome;
    String? get getEmail => email;
    int? get getSenha => senha;

}