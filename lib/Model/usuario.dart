class Usuario{
  final String id_usuario;
  final String nombre_usuario;
  final String url_foto_perfil;
  final int num_carretes;
  final String rol;

  Usuario({
    required this.id_usuario,
    required this.nombre_usuario,
    required this.url_foto_perfil,
    required this.num_carretes,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json){
    return Usuario(
      id_usuario: json['id_usuario'],
      nombre_usuario: json['nombre_usuario'],
      url_foto_perfil: json['path_foto_perfil'],
      num_carretes: json['num_carretes'],
      rol: json['rol']
    );
  }


}