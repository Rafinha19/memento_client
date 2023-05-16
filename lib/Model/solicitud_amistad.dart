import '../Config/Properties.dart';

class Solicitud_amistad {
  final int id_solicitud_amistad;
  final int id_actor;
  final String username_actor;
  final String url_foto_perfil_actor;

  Solicitud_amistad({required this.id_solicitud_amistad, required this.id_actor, required this.username_actor,required this.url_foto_perfil_actor});

  factory Solicitud_amistad.fromJson(Map<String, dynamic> json){
    return Solicitud_amistad(
      id_solicitud_amistad: json['id_solicitudAmistad'],
      id_actor: json['id_actor'],
      username_actor: json['username_actor'] ,
      url_foto_perfil_actor: "$SERVER_IP/api/users/" + json['username_actor'] + "/image"
    );
  }
}
