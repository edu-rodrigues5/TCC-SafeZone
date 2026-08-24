import 'package:intl/intl.dart';
import 'package:safezone/cliente.dart';
import 'package:safezone/dal.dart';
import 'package:safezone/erro.dart';
import 'package:safezone/funcao.dart';
import 'package:safezone/servico.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contato.dart';

class BLL{
  static DAL firebase = DAL();
  static RegExp rgxEmail = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  static RegExp rgxSenha = RegExp(r"(?=.*[a-z])(?=.*[A-Z])(?=.*[\d])(?=.*[$&*%()@!=+?:;><,.#_']).{8,4000}", multiLine:true);
  static RegExp rgxNome = RegExp(r"^[A-Za-zÀ-ÿ\s]{2,}$");
  static RegExp rgxNumero = RegExp(r"^\d{10,11}$");
  static List<Funcao> listFuncao = [];

  static void validaAlteracao(bool ligado, String funcao){
    //sem lógica, por enquanto
    firebase.alterarBotao(ligado, funcao);
  }

  static void verificaContato(Contato contato){
    var matchNome = rgxNome.firstMatch(contato.getNome);
    var matchNum = rgxNumero.firstMatch(contato.getNumero);

    if(matchNome != null){
      if(matchNum != null){
        firebase.cadastraContato(contato);
      }
    }

  }

  static void validaCadastro(Cliente cl){
   var matchE = rgxEmail.firstMatch(cl.getEmail);
   var matchS = rgxSenha.firstMatch(cl.getSenha);
   var matchN = rgxNome.firstMatch(cl.getNome);

   if(matchE != null) {
       if(matchS != null) {
             if(matchN != null) {
               firebase.cadastrar(cl);
             }
             else{
               Erro.setErro("Nome de usuário deve ser maior que 1 caractere");
             }
       }
       else{
         Erro.setErro("A Senha deve ser formada por 8 caracteres tendo uma letra minúscula e maiúscula, além de um caractere especial e número.");
       }
   }
   else {
     Erro.setErro("O Email deve seguir este formato: usuário@domínio.com ");
   }

  }

  static Future<bool> verificaBtn() async{
    bool ligado = await firebase.buscarLigado();

    if(ligado == true){
        iniciarServicoGesto("botao");
    }

    return ligado;
  }
  static Future<String> verificaFuncBtn() async{
    String func = await firebase.buscarFunc();

    return func;
  }

  static Future<String> buscarMensagem() async{

    String mensagem;

    String funcao = await firebase.buscarFunc();

    switch(funcao) {
      case "Sequestro":
        mensagem = "Eu fui sequestrado(a) " +" (sem localização)   ";
        break;
      case "Violencia":
        mensagem = "Eu fui vítima de violência " +"  (sem localização)  ";
        break;
      default:
        mensagem = "sem funcao programada";
        break;
    }

    return mensagem;
  }

  static Future<bool> validaLogin(Cliente cl) async {
    var matchE = rgxEmail.firstMatch(cl.getEmail);
    var matchS = rgxSenha.firstMatch(cl.getSenha);

    if(matchE != null){
      if(matchS != null) {
        return await firebase.login(cl);

      }{
        Erro.setErro("A Senha deve ser formada por 8 caracteres tendo uma letra minúscula e maiúscula, além de um caractere especial e número.");
        return true;
      }
    }
    else{
      Erro.setErro("O Email deve seguir este formato: usuário@domínio.com ");

      return true;
    }
  }

  static void transformaObj(List<Map<String,dynamic>>? config) async {
      if(config != null){
        for (var doc in config) {
          List<dynamic>? palavrasRaw = doc["palavras"];
          String? mensagem = doc["mensagem"];
          String funcao = " ";

          if (palavrasRaw != null && mensagem != null) {
            List<String> palavras =
            palavrasRaw.map((e) => e.toString()).toList();

            listFuncao.add(Funcao(palavras, funcao, mensagem));
          }
        }
        for(Funcao gatilho in listFuncao){
          print(gatilho.palavras);
        }
      }else{
        listFuncao.clear();
      }
  }
  static Future<Funcao?> perceberGatilho(String texto) async{

    // Verifica palavra-gatilho

    String lower = texto.toLowerCase();

    print("iniciou percepção de gatilho");
    for (Funcao func in listFuncao) {
      print("Função entrou");
      for(String gatilho in func.palavras) {
        print("Gatilho entrou");

        if (lower.contains(gatilho.toLowerCase())) {
          print("ALARME DISPARADO: " + gatilho);
          return func;
        }
      }
    }
    return null;
  }

  static String pegaTempo() {

    DateTime now = DateTime.now();
    String agora = DateFormat("dd/MM/yyyy HH:mm").format(now);

    return agora;
  }

  static void validaGatilho(List<String> palavra, String funcao) async{

        String mensagem;

        switch(funcao) {
          case "Sequestro":
            mensagem = "Eu fui sequestrado(a) " +" (sem localização)   ";
            break;
          case "Violencia":
            mensagem = "Eu fui vítima de violência " +"  (sem localização)  ";
            break;
          default:
            mensagem = "sem funcao programada";
            break;
        }

        Funcao gatilho = Funcao(palavra, funcao, mensagem);
        firebase.gravaFunc(gatilho);

  }

  static Future<void> mandarSMS(String numero, String mensagem) async{
    final url = Uri(
      scheme:"sms",
      path: numero,
      queryParameters: {
        "body": mensagem
      },
    );

    await launchUrl(url);

  }

}