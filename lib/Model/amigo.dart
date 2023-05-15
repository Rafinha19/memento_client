import '../Config/Properties.dart';

class Amigo {
  final int id_usuario;
  final String nombre_usuario;
  final String url_foto_perfil;

  Amigo({required this.id_usuario, required this.nombre_usuario, required this.url_foto_perfil});

  factory Amigo.fromJson(Map<String, dynamic> json){
    return Amigo(
        id_usuario: json['id'],
        nombre_usuario: json['login'],
        url_foto_perfil:  "$SERVER_IP/api/users/" + json['login'] + "/image",
    );
  }
}
