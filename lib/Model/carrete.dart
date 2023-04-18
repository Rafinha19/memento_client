import 'dart:convert';
import 'package:intl/intl.dart';

class Carrete {
  final int id_carrete;
  final int ano;
  final int mes;
  final List<int> ids_fotos;
  final int num_fotos;
  String descripcion;
  final String propietario;
  //final int num_megusta;

  Carrete ({required this.id_carrete,required this.ano,required this.mes, required this.ids_fotos,required this.num_fotos,required this.descripcion, required this.propietario});

  factory Carrete.fromJson(Map<String, dynamic> json) {
    return Carrete(
      id_carrete: json['id_carrete'],
      ano: json['ano'],
      mes:json['mes'],
      ids_fotos: List<int>.from(json['lista_id_imagenes']),
      num_fotos: json['num_fotos'],
      descripcion: json['descripcion'],
      propietario: json['propietario']
    );
  }

  void setDescripcion(String descripcion){
    this.descripcion = descripcion;
  }

}