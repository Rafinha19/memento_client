import '../Config/Properties.dart';

class Usuario {
  final int id_usuario;
  final String nombre_usuario;
  final String url_foto_perfil;

  Usuario({required this.id_usuario, required this.nombre_usuario, required this.url_foto_perfil});

  factory Usuario.fromJson(Map<String, dynamic> json){
    return Usuario(
        id_usuario: json['id'],
        nombre_usuario: json['login'],
        url_foto_perfil:  "$SERVER_IP/api/users/" + json['login'] + "/image",
    );
  }
}
