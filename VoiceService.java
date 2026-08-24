package com.example.safezone;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;
import android.speech.RecognitionListener;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.util.Log;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class VoiceService extends Service {

    private static final String TAG = "VoiceService";
    private static final String CHANNEL_ID = "voice_trigger_channel";
    private SpeechRecognizer speechRecognizer;
    private boolean continua = true;



    @Override
    public void onCreate() {
        super.onCreate();
        criarCanalNotificacao();
        startForeground(1, criarNotificacao());
        iniciarReconhecimento();
    }


    private void iniciarReconhecimento() {
        speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this);
        speechRecognizer.setRecognitionListener(new RecognitionListener() {

            @Override
            public void onResults(Bundle results) {
                ArrayList<String> matches = results.getStringArrayList(
                        SpeechRecognizer.RESULTS_RECOGNITION
                );
                if (matches != null) {
                    for (String texto : matches) {
                        Log.d(TAG, "Reconhecido: " + texto);


                        // Envia o texto para o Flutter
                        Intent intent = new Intent("VOICE_RESULT");
                        intent.setPackage(getPackageName());
                        intent.putExtra("texto", texto);
                        Log.d("VOICE_DEBUG", "ENVIANDO: " + texto);
                        sendBroadcast(intent);
                    }
                }
                // Reinicia o loop
                if (continua) escutar();
            }

            @Override
            public void onError(int error) {
                Log.d(TAG, "Erro: " + error);
                if (continua) {
                    // Aguarda 1 segundo e tenta de novo
                    new android.os.Handler().postDelayed(() -> {
                        if (continua) escutar();
                    }, 1000);
                }
            }

            @Override public void onReadyForSpeech(Bundle p) {}
            @Override public void onBeginningOfSpeech() {}
            @Override public void onRmsChanged(float v) {}
            @Override public void onBufferReceived(byte[] b) {}
            @Override public void onEndOfSpeech() {}
            @Override public void onPartialResults(Bundle b) {}
            @Override public void onEvent(int i, Bundle b) {}
        });

        escutar();
    }

    private void escutar() {
        Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, "pt-BR");
        intent.putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3);
        speechRecognizer.startListening(intent);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (intent != null && "parar".equals(intent.getAction())) {
            continua = false;
            Log.d("Voice", "terminado");
            speechRecognizer.destroy();
            stopSelf();
        }

//aqui é só pra add um metodo com o mesmo nome do que manda no Main
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        continua = false;
        if (speechRecognizer != null) speechRecognizer.destroy();
        super.onDestroy();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void criarCanalNotificacao() {
        NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID,
                "Monitoramento de voz",
                NotificationManager.IMPORTANCE_LOW
        );
        NotificationManager manager = getSystemService(NotificationManager.class);
        manager.createNotificationChannel(channel);
    }

    private Notification criarNotificacao() {
        return new Notification.Builder(this, CHANNEL_ID)
                .setContentTitle("Monitorando...")
                .setContentText("Aguardando palavra de emergência")
                .setSmallIcon(android.R.drawable.ic_btn_speak_now)
                .build();
    }
}
