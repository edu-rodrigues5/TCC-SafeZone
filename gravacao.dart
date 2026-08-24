import'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safezone/bll.dart';
import 'package:safezone/funcao.dart';
import 'package:safezone/servico.dart';

const EventChannel _eventChannel = EventChannel('com.example.safezone/voice_events');
EventChannel _canal = new EventChannel("com.example.safezone/sequence_events");


class Gravacao extends StatefulWidget {
  const Gravacao({super.key});

  @override
  State<Gravacao> createState() => _GravacaoState();
}

class _GravacaoState extends State<Gravacao> {

  String opcaoTipo = "Gesto";
  String valor = "Escolha uma situação";
  Set<String> _selected = {'Audio'};


  void mudarTipo(String? value){
    if(value != null){
      setState(() {
        opcaoTipo = value;
      });
    }
  }

  void mudarSelec(Set<String>? value){
    if(value != null){
      setState(() {
        _selected = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configuração de Gatilho"),
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.deepPurple, Colors.indigoAccent])),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20,),
        child: Center(
              child: Container(
                width: 1200,
                decoration: BoxDecoration(border:Border.all(color: Colors.black26)),
                child: Column(
                  //mainAxisAlignment: , isso permite a distância horizontal dos conteúdos da coluna, mainCross varia a vertical
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [

                    ///*
                    SegmentedButton(
                        segments: <ButtonSegment<String>>[
                        ButtonSegment(value: "Gesto", label: Text("Comando por Gesto")),
                        ButtonSegment(value: "Audio", label: Text("Comando de Voz")),
                        ],
                        selected: _selected,
                        onSelectionChanged: mudarSelec,
                    ),

                    SizedBox(height: 30),
                    //*/
                    ElevatedButton(
                        onPressed: (){
                          if(_selected.contains("Gesto")) {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Manual()));
                          }else if(_selected.contains("Audio")){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Voz()));
                          }
                    },
                        child: Text("Fazer Gravação", style: TextStyle(color: Colors.black),)),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}

class Voz extends StatefulWidget {
  //final String mudarFuncao;

  //const Voz({super.key, required this.mudarFuncao});
  const Voz({super.key});
  @override
  State<Voz> createState() => _VozState();
}

class _VozState extends State<Voz> {
  //declaração de variáveis
  final TextEditingController _palavraGatilho = TextEditingController();
  bool micon = false;
  bool continuaLoop = false;
  String funcao = "";
  //métodos

  void mudarFunc(String? value){
    if(value != null){
      setState(() {
        funcao = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    //funcao = widget.mudarFuncao;
    print("=======tela de voz==========");
    _eventChannel.receiveBroadcastStream().listen((data) async {
      /*if (data == 'ALARME') {
        showDialog(
            context: context,
            builder: (context) => Aviso(aviso: _textoDeEmergencia.text),  //aqui envia mensagem
        );
            //builder: Aviso(aviso: _textoDeEmergencia.text).build);
        print('Palavra de emergência detectada!');
      }*/


      Funcao? func = await BLL.perceberGatilho(data);

      if(func != null){
        showDialog(
          context: context,
          builder: (context) => Aviso(aviso: func.mensagem),  //aqui envia mensagem
        );

        await BLL.mandarSMS("+5513996622177", func.mensagem);

        func.mensagem += BLL.pegaTempo();
        await enviarSMS("+5513996622177", func.mensagem);
        print("foi enviado");

      }

    });
    print("dado Recebido");
  }


  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text("Teste Inicial"),
            backgroundColor: Colors.indigoAccent,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
            child: Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [

                   TextField(
                     controller: _palavraGatilho,
                     decoration: InputDecoration(label: Text("Adicionar palavra ou frase gatilho")),
                   ),
                   SizedBox(height: 20,),
                   SizedBox(height: 40,),

                   DropdownMenu<String>(
                     enableFilter: true,
                     dropdownMenuEntries: [
                       DropdownMenuEntry(value: "Sequestro", label: "Sequestro"),
                       DropdownMenuEntry(value: "Violencia", label: "Violência"),
                     ],
                     label: Text("Selecione uma Função"),
                     onSelected: mudarFunc,
                   ),

                   SizedBox(height: 30),
                    ElevatedButton(onPressed: () async {
                      await mandarGatilho(_palavraGatilho.text, funcao);
                    }, child: Text("Mandar Frase e Gatilho")),

                 ],
               ),
            ),
          ),
    );
  }
}

class Manual extends StatefulWidget {
  const Manual({super.key});

  @override
  State<Manual> createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  
  bool mexerlig = false;
  bool botaolig = false;
  bool gatilho = false;
  String funcao = "";

  //metodos
  void trocar(bool ligado, String flag, String funcao) async {
    if (ligado) {
      BLL.validaAlteracao(true, funcao);
      await iniciarServicoGesto(flag);
      print("opa");
    } else {
      BLL.validaAlteracao(false, funcao);
      await pararServicoGesto(flag);
    }

    setState(() {
      if (flag == "botao") {
        botaolig = ligado;
      } else {
        mexerlig = ligado;
      }
    });

  }

  void mudarFunc(String? value){
    if(value != null){
      setState(() {
        funcao = value;
      });
    }
  }

  void gamb()async{
    bool valor = await BLL.verificaBtn();
    String a = await BLL.verificaFuncBtn();

    if (!mounted) return;

    setState(() {
      botaolig = valor;
      funcao = a;
    });

  }

  @override
  void initState() {
    super.initState();

    //verificar se botão está ligado e então já ligar o servico
    gamb();//gambiarra
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teste Inicial"),
        backgroundColor: Colors.indigoAccent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              SizedBox(height: 50,),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Title(color: Colors.black, child: Text("Opção de Botões: ${botaolig ?"Ligado": "Desligado"}")),

          Row(
            children: [
              Switch(
              value: botaolig,
              onChanged: (valor) => trocar(valor, "botao", funcao),),

              DropdownMenu<String>(
                enableFilter: true,
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: "Sequestro", label: "Sequestro"),
                  DropdownMenuEntry(value: "Violencia", label: "Violência"),
                ],
                label: Text("Selecione uma Função"),
                onSelected: mudarFunc,
              ),
                ],),
              ]),

              SizedBox(height: 35,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Title(color: Colors.black, child: Text("Opção de Movimento ${mexerlig ?"Ligado": "Desligado"}")),
              Row(
                children: [
                  Switch(
                    value: mexerlig,
                    onChanged: (valor) => trocar(valor, "mexer", funcao),),

              DropdownMenu<String>(
                enableFilter: true,
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: "Sequestro", label: "Sequestro"),
                  DropdownMenuEntry(value: "Violencia", label: "Violência"),
                ],
                label: Text("Selecione uma Função"),
                onSelected: mudarFunc,
              ),
              ],),
                ],),
            ],
          ),
        ),
      ),
    );
  }
}

class Aviso extends StatelessWidget {
  final String aviso;

  const Aviso({super.key, required this.aviso});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("ALERTA"),
      content: Text("mensagem: "+ aviso),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
            child: Text("Cancelar")),
        TextButton(onPressed: () => Navigator.pop(context),
            child: Text("Ok"))
      ],
    );
  }
}
