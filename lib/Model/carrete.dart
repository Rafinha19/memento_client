import 'dart:convert';
import 'package:intl/intl.dart';

class Carrete {
  final int ano;
  final String mes;
  final List<int> ids_fotos;
  final int num_fotos;

  const Carrete({required this.ano,required this.mes, required this.ids_fotos,required this.num_fotos});

  factory Carrete.fromJson(Map<String, dynamic> json) {
    return Carrete(
      ano: json['ano'],
      mes: DateFormat.MMMM().format(DateTime(json['ano'], json['mes'])),
      ids_fotos: List<int>.from(json['lista_id_imagenes']),
      num_fotos: json['num_fotos'],
    );
  }

}