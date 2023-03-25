import 'dart:convert';
class Carrete {
  final String ano_mes;
  final List<int> ids_fotos;
  final int num_fotos;

  const Carrete({required this.ano_mes, required this.ids_fotos,required this.num_fotos});

  factory Carrete.fromJson(Map<String, dynamic> json) {
    return Carrete(
      ano_mes: json['ano_mes'],
      ids_fotos: List<int>.from(json['lista_id_imagenes']),
      num_fotos: json['num_fotos'],
    );
  }
}