
class Erro {
  static String _mens = " ";
  static bool _erro = false;

  //metodo

  static void setErro(String mens){_mens=mens;_erro=true;}
  static void setErrobool(){_erro =!_erro;}
  static void resetaErro(){_erro = false; _mens="";}

  static bool getErro(){return _erro;}
  static String getMens(){return _mens;}


}