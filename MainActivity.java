package com.example.safezone;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.telephony.SmsManager;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import android.util.Log;

public class MainActivity extends FlutterActivity {

    private static final String METHOD_CHANNEL = "com.example.safezone/voice";
    private static final String EVENT_CHANNEL = "com.example.safezone/voice_events";
    private EventChannel.EventSink eventSink;
    private BroadcastReceiver receiver;

    //sequence trigger

    private static final String SEQUENCE_CHANNEL =
            "com.example.safezone/sequence_events";

    private EventChannel.EventSink sequenceEventSink;
    private BroadcastReceiver sequenceReceiver;
    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // MethodChannel — recebe comandos do Flutter
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("iniciar")) {
                        Intent intent = new Intent(this, VoiceService.class);
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                            startForegroundService(intent);
                        } else {
                            startService(intent);
                        }
                        result.success(null);
                    } else if (call.method.equals("parar")) {
                        Intent intent = new Intent(this, VoiceService.class);
                        intent.setAction("parar");
                        startService(intent);
                        result.success(null);
                    }else if(call.method.equals("enviar-sms")) {
                        String numero = call.argument("numero");
                        String mensagem = call.argument("mensagem");

                        enviarSMS(numero, mensagem);

                        result.success("ok");
                    } else if(call.method.equals("iniciar-bt")){
                        Log.d("TAG", "até aqui chegou");
                        Intent intent = new Intent(this, VolumeScreenService.class);
                        //intent.putExtra("funcao", call.argument("funcao"));
                        startForegroundService(intent);
                        Log.d("MainActivity", "inicializou botão");
                        result.success(null);
                    }else if(call.method.equals("parar-bt")){
                        Intent intent = new Intent(this, VolumeScreenService.class);
                        stopService(intent);
                        result.success(null);
                    }/*else if(call.method.equals("iniciar-mx")){
                        Intent intent = new Intent(this, VolumeScreenService.class);

                    }else if(call.method.equals("parar-mx")){
                        Intent intent = new Intent(this, VolumeScreenService.class);
                        intent.setAction("parar-mx");
                        startService(intent);
                        result.success(null);
                    }*/
                });

        // EventChannel — manda dados do Java para o Flutter
        new EventChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), EVENT_CHANNEL)
                .setStreamHandler(new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object arguments, EventChannel.EventSink events) {
                        eventSink = events;

                        // Recebe broadcasts do VoiceService
                        receiver = new BroadcastReceiver() {
                            @Override
                            public void onReceive(Context context, Intent intent) {
                                String texto = intent.getStringExtra("texto");
                                Log.d("Main","recebi o texto");
                                if (eventSink != null) {
                                    eventSink.success(texto);
                                }
                            }
                        };

                        IntentFilter filter = new IntentFilter("VOICE_RESULT");
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            registerReceiver(receiver, filter, Context.RECEIVER_NOT_EXPORTED);
                        } else {
                            registerReceiver(receiver, filter);
                            Log.d("Main","Recebido no Main");
                        }
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        unregisterReceiver(receiver);
                        eventSink = null;
                    }
                });

        new EventChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                SEQUENCE_CHANNEL
        ).setStreamHandler(new EventChannel.StreamHandler() {

            @Override
            public void onListen(Object arguments, EventChannel.EventSink events) {
                sequenceEventSink = events;

                Log.d("Main", "OnListen chamado");
                //sequenceEventSink.success("acionado");//teste

                Log.d("Main", "Registrado");
                sequenceReceiver = new BroadcastReceiver() {

                    @Override
                    public void onReceive(Context context, Intent intent) {
                        Log.d("Main", "Recebi: " + intent.getAction());

                        if ("SEQUENCE_TRIGGERED".equals(intent.getAction())) {
                            Log.d("Main", "achou");
                            if (sequenceEventSink != null) {
                                Log.d("Main", "Foi mandado");
                                sequenceEventSink.success("acionado");
                            }
                        }
                    }
                };

                IntentFilter filter =
                        new IntentFilter("SEQUENCE_TRIGGERED");

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    registerReceiver(
                            sequenceReceiver,
                            filter,
                            Context.RECEIVER_NOT_EXPORTED
                    );
                } else {
                    registerReceiver(sequenceReceiver, filter);
                }
            }

            @Override
            public void onCancel(Object arguments) {
                if (sequenceReceiver != null) {
                    unregisterReceiver(sequenceReceiver);
                    sequenceReceiver = null;
                }

                sequenceEventSink = null;
            }
        });
    }

    private void enviarSMS(String numero, String mensagem) {
        /*Intent intent = new Intent(Intent.ACTION_SENDTO);
        intent.setData(Uri.parse("smsto:" + numero));
        intent.putExtra("sms_body", mensagem);
        startActivity(intent);*/

        SmsManager smsManager = SmsManager.getDefault();
        smsManager.sendTextMessage(numero, null, mensagem, null, null);
        System.out.println("Deu Certo?");
    }
}