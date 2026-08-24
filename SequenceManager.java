    package com.example.safezone;

    import android.util.Log;
    import java.util.LinkedList;
    import java.util.List;
    import java.util.Arrays;


    public class SequenceManager{

            static private List<Eventos> teste = Arrays.asList(Eventos.SCREEN_OFF, Eventos.SCREEN_ON,Eventos.SCREEN_OFF);
            static private List<Eventos> testeb = Arrays.asList(Eventos.SCREEN_ON, Eventos.SCREEN_OFF,Eventos.SCREEN_ON);

            private LinkedList<Eventos> sequencia = new LinkedList<>();

            public boolean add(Eventos eventos){
                sequencia.add(eventos);

                if(sequencia.size()>teste.size()){sequencia.removeFirst();}

                Log.d("SEQUENCE","adicionado " + sequencia.toString());
                if ((sequencia.equals(teste)) || (sequencia.equals(testeb))){
                    Log.d("SEQUENCE","Opa, eu");
                    sequencia.clear();
                    return true;
                }

                return false;

            }



        public enum Eventos{
            SCREEN_ON,
            SCREEN_OFF,
            VOLUME_UP,
            VOLUME_DOWN
        }
    }

