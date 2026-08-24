import 'package:flutter/services.dart';
import 'package:safezone/bll.dart';
import 'package:safezone/dal.dart';

const MethodChannel _channel = MethodChannel('com.example.safezone/voice');
DAL firebase = DAL();
Future<void> iniciarServico() async {
  await _channel.invokeMethod('iniciar');
  print("método invocado");
  BLL.transformaObj(await firebase.pegarConfig());
}


Future<void> pararServico() async {
  await _channel.invokeMethod('parar');
  BLL.transformaObj(null);
}

//gesto
Future<void> iniciarServicoGesto(String flag) async {
  if(flag == "botao"){
    await _channel.invokeMethod('iniciar-bt');
  }if(flag == "mexer"){

    await _channel.invokeMethod('iniciar-mx');
  }
}

Future<void> pararServicoGesto(String flag) async {
  if(flag == "botao"){
    print("servico fechado");
    await _channel.invokeMethod('parar-bt');
  }if(flag == "mexer"){
    await _channel.invokeMethod('parar-mx');
  }
}

Future<void> mandarGatilho(String palavra, String funcao) async{
  List<String> palavras = <String>[palavra];

  BLL.validaGatilho(palavras, funcao);
}

Future<void> enviarSMS(String numero, String mensagem) async {
  await _channel.invokeMethod("enviar-sms", {
    "numero": numero,
    "mensagem": mensagem,
  });
}

//aqui a ideia é inicializar o gatilho puxando lá do dal e então dali inicializa os gatilhos do java.