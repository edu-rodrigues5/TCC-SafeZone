package com.example.safezone;

import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.media.AudioManager;
import android.os.IBinder;
import android.util.Log;
import com.example.safezone.*;

/**
 * Service que detecta:
 * - Aumento/diminuição de volume (via broadcast do sistema)
 * - Tela ligando (SCREEN_ON) e desligando (SCREEN_OFF)
 *
 * OBS IMPORTANTE:
 * Um Service comum não recebe eventos de tecla (KeyEvent) diretamente,
 * pois não possui janela/foco. Por isso a detecção de volume aqui é feita
 * escutando o broadcast "android.media.VOLUME_CHANGED_ACTION", que o sistema
 * dispara sempre que o volume de algum stream muda (inclusive pelos botões
 * físicos). Se você precisar interceptar o KeyEvent bruto (antes de alterar
 * o volume), a alternativa é usar um AccessibilityService.
 */
public class VolumeScreenService extends Service {

    private static final String TAG = "VolumeScreenService";


    private SequenceManager sequenceManager;
    private boolean reconheceu = false;
    private AudioManager audioManager;
    private int ultimoVolume = -1;

    private final BroadcastReceiver receiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action == null) return;

            switch (action) {
                case "android.media.VOLUME_CHANGED_ACTION":
                    tratarMudancaDeVolume();
                    verificaReconhceu();
                    break;
                case Intent.ACTION_SCREEN_ON:
                    reconheceu = sequenceManager.add(SequenceManager.Eventos.SCREEN_ON);
                    verificaReconhceu();
                    break;
                case Intent.ACTION_SCREEN_OFF:
                    reconheceu = sequenceManager.add(SequenceManager.Eventos.SCREEN_OFF);
                    verificaReconhceu();
                    break;
            }
        }
    };

    @Override
    public void onCreate() {
        super.onCreate();

        sequenceManager = new SequenceManager();
        audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
        ultimoVolume = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);

        // Criar canal de notificação
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            android.app.NotificationChannel channel = new android.app.NotificationChannel( "volume_service", "Monitoramento do SafeZone", android.app.NotificationManager.IMPORTANCE_LOW );
            android.app.NotificationManager manager = getSystemService(android.app.NotificationManager.class);
            manager.createNotificationChannel(channel); }

        // Criar notificação
        android.app.Notification notification = new android.app.Notification.Builder(this, "volume_service")
                .setContentTitle("SafeZone")
                .setContentText("Monitoramento de emergência ativo")
                .setSmallIcon(com.example.safezone.R.mipmap.ic_launcher)
                .build();

        // Transformar o serviço em Foreground Service
        startForeground(1, notification);

        IntentFilter filter = new IntentFilter();
        filter.addAction("android.media.VOLUME_CHANGED_ACTION");
        filter.addAction(Intent.ACTION_SCREEN_ON);
        filter.addAction(Intent.ACTION_SCREEN_OFF);
        registerReceiver(receiver, filter);

        Log.d(TAG, "VolumeScreenService iniciado");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        // START_STICKY faz o sistema tentar recriar o service se ele for morto
        return START_STICKY;
    }

    private void tratarMudancaDeVolume() {
        int volumeAtual = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC);
        if (volumeAtual > ultimoVolume) {
            reconheceu = sequenceManager.add(SequenceManager.Eventos.VOLUME_UP);
        } else if (volumeAtual < ultimoVolume) {
            reconheceu = sequenceManager.add(SequenceManager.Eventos.VOLUME_DOWN);
        }
        ultimoVolume = volumeAtual;
    }

    private void onVolumeAumentou() {

    }

    private void onVolumeDiminuiu() {



    }

    private void onTelaLigada() {
    }

    private void onTelaDesligada() {
    }

    private void verificaReconhceu(){
        if (reconheceu== true){
            Log.d("VolumeScreen", "Reconheceu");

            Intent intent = new Intent("SEQUENCE_TRIGGERED");
            intent.setPackage(getPackageName());
            sendBroadcast(intent);

            reconheceu = false;
        }
    }
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        unregisterReceiver(receiver);
        stopForeground(STOP_FOREGROUND_REMOVE);
        super.onDestroy();

        Log.d(TAG, "VolumeScreenService destruído");
    }
}
