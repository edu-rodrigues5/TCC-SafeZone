
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safezone/contato.dart';
import 'package:safezone/servico.dart';
import 'package:flutter/services.dart';
import 'package:safezone/bll.dart';
import 'package:safezone/funcao.dart';

const EventChannel _eventChannel = EventChannel('com.example.safezone/voice_events');
EventChannel _canal = new EventChannel("com.example.safezone/sequence_events");

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _itson = false;


  void deslogar() async{
    await FirebaseAuth.instance.signOut();
  }

  void abaContato() async{
    TextEditingController nome = TextEditingController();
    TextEditingController numero = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Contato'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nome,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                ),
                TextFormField(
                  controller: numero,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Número',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // salvar
                Contato contato = Contato(nome.text, numero.text);
                BLL.verificaContato(contato);

                Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _troca() async {
    if(_itson){
      setState(() {
        _itson = false;
      });
      await pararServico();
    }else{
      setState(() {
        _itson = true;
      });
      await iniciarServico();
      print("iniciado servico de voz");
    }
  }

  gamb() async{
    bool a = await BLL.verificaBtn();

  }
  @override

  void initState() {
    super.initState();
    //funcao = widget.mudarFuncao;
    gamb();

    _eventChannel.receiveBroadcastStream().listen((data) async {

      Funcao? func = await BLL.perceberGatilho(data);
      Contato emergencia = await BLL.firebase.resgataContato();

      String mensagem;
      if(func != null){
        mensagem = func.mensagem;
        showDialog(
          context: context,
          builder: (context) => Aviso(aviso: mensagem),  //aqui envia mensagem
        );

      // await BLL.mandarSMS("+5513996622177", func.mensagem);

        mensagem += BLL.pegaTempo();
        await enviarSMS("+${emergencia.getNumero}", mensagem);
      }

    });

    _canal.receiveBroadcastStream().listen((evento) async {
        if (evento == "acionado") {

        String mensagem = await BLL.buscarMensagem();
        mensagem += BLL.pegaTempo();
        Contato emergencia = await BLL.firebase.resgataContato();

        if(!mounted)return;

        showDialog(
        context: context,
        builder: (context) => Aviso(aviso: mensagem),  //aqui envia mensagem
        );

        //await BLL.mandarSMS("+5513996622177", mensagem);

        await enviarSMS("+${emergencia.getNumero}", mensagem);
        print("enviado mensagem");
        }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('SafeZone')),
        backgroundColor: Colors.redAccent,
      ),
      drawer: Drawer(
        child: ListView(children: [
          ListTile(
            title: Text("logout"),
            leading: Icon(Icons.logout),
            onTap: (){ deslogar();},
          ),
          ListTile(
            title: Text("contato +"),
            leading: Icon(Icons.add_circle),
            onTap: (){ abaContato();},
          )
        ],),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bem-vindo à Home!'),

            /*ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/auth');
              },
              child: const Text('Ir para Login/Cadastro'),
            ),*/

            const SizedBox(height: 80),

            Text('Status: ${_itson ? "Ligado" : "Desligado"}'),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: (){
                _troca();
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _itson ? Colors.green : Colors.red,
                ),
                child: Icon(
                  _itson ? Icons.power_settings_new : Icons.power_off,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /*SizedBox(
              width: 600,
              height: 200,
              child: ListView.builder(
                itemCount: registros.length,
                itemBuilder: (context, index){
                  return Card(
                    child: ListTile(
                    title: Text(registros[index].getNome()),
                    trailing: Icon(Icons.more_vert),
                    ),
                  );
                }
              ),
            ),*/

            const SizedBox(height: 20),

            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/gravador");
                },
                child: Text("Adicionar Registros")
            ),

          ],
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