import 'dart:convert';

class Carrete {
  final String ano_mes;
  final List<String> imageUrls;
  final int num_fotos;

  const Carrete({required this.ano_mes, required this.imageUrls,required this.num_fotos});

  factory Carrete.fromJson(Map<String, dynamic> json) {
    return Carrete(
      ano_mes: json['ano_mes'],
      imageUrls: List<String>.from(json['imageUrls']),
      num_fotos: json['num_fotos'],
    );
  }
}