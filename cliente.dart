
class Cliente {
  String _nome;
  String _email;
  String _senha;

  Cliente(this._nome, this._email, this._senha);

//métodos

    void setNome(String nome){_nome=nome;}
    void setEmail(String email){_email=email;}
    void setSenha(String senha){_senha=senha;}

    String get getNome => _nome;
    String get getEmail => _email;
    String get getSenha => _senha;

}