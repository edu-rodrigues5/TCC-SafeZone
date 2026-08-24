class Funcao{

  List<String> palavras;
  String funcao;
  String mensagem = "Sem função atribuída";


  Funcao( this.palavras, this.funcao, this.mensagem);

  List<String> getPalavras() => palavras;
  String getMens() => mensagem;
  String getFuncao() => funcao;

}