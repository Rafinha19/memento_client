import 'package:memento_flutter_client/Config/Properties.dart';

class CurrentUsuarioData{
  final int id_usuario;
  final String nombre_usuario;
  final String url_foto_perfil;
  final int num_carretes;
  final String rol;

  CurrentUsuarioData({
    required this.id_usuario,
    required this.nombre_usuario,
    required this.url_foto_perfil,
    required this.num_carretes,
    required this.rol,
  });

  factory CurrentUsuarioData.fromJson(Map<String, dynamic> json){
    return CurrentUsuarioData(
      id_usuario: json['id_usuario'],
      nombre_usuario: json['nombre_usuario'],
      url_foto_perfil:  "$SERVER_IP/api/users/" + json['nombre_usuario'] + "/image",
      num_carretes: json['num_carretes'],
      rol: json['rol']
    );
  }



}