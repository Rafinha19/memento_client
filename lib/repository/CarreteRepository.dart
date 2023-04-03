import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../Model/carrete.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:memento_flutter_client/Config/Properties.dart';
import 'dart:developer' as developer;

class CarreteRepository {

  final storage = FlutterSecureStorage();

  //esta funcion devuelve todos tus carretes
  Future<List<Carrete>> getMyCarretes() async {
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    try {
      var res = await http.get(
        Uri.parse("$SERVER_IP/api/carretes/mycarretes"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token', //'bearer token'
        },
      );
      if (res.statusCode == 200) {
        List<dynamic> carretesJson = jsonDecode(res.body);
        List<Carrete> carretes = carretesJson.map((c) => Carrete.fromJson(c)).toList();
        //developer.log(carretes[0].ano_mes);
        return carretes;
      } else {
        throw Exception('Error al obtener los carretes');
      }
    } catch (e) {
      //return "Connection Error";
      throw Exception('Error al obtener los carretes');
    }
  }

  //Esto lo hago porque por defecto el mes en castellano viene con la priemra letra en minuscula
  String toUpperCaseFirstLetter(String text) {
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }
}