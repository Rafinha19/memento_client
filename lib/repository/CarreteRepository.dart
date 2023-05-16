import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:memento_flutter_client/Model/usuario.dart';
import '../Model/carrete.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:memento_flutter_client/Config/Properties.dart';

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



  Future<Carrete> edtiCarreteDescription (int id_carrete, String description) async{
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    final Map<String, dynamic> editCarreteDescription = {
      'id_carrete': id_carrete,
      'descripcion': description,
    };

    try {
      var res = await http.put(
        Uri.parse("$SERVER_IP/api/carretes/description/$id_carrete"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token', //'bearer token'
        },
        body: jsonEncode(editCarreteDescription)
      );
      if (res.statusCode == 200) {
        dynamic carretesJson = jsonDecode(res.body);
        Carrete carrete =Carrete.fromJson(carretesJson);
        return carrete;
      } else {
        throw Exception('Error al obtener los carretes');
      }
    } catch (e) {
      //return "Connection Error";
      throw Exception('Error al obtener los carretes');
    }
  }


  Future<int> uploadPhoto(File image) async {
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    try {

      var url = Uri.parse("$SERVER_IP/api/carretes/lastcarrete/images");
      var request = http.MultipartRequest('POST', url);

      var archivo = await http.MultipartFile.fromPath('file', image.path);
      request.files.add(archivo);

      request.headers.addAll({
        'Authorization': 'Bearer $token'
      });

      var res = await request.send();

      if(res.statusCode == 200){
        return 0;
      }else{
        return 1;
      }
    } catch (e) {
      //return "Connection Error";
      return 2;
    }
  }

  Future<List<Carrete>> getMyFriendsCarretes() async {
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    try {
      var res = await http.get(
        Uri.parse("$SERVER_IP/api/carretes/myfriends"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token', //'bearer token'
        },
      );
      if (res.statusCode == 200) {
        List<dynamic> carretesJson = jsonDecode(res.body);
        List<Carrete> carretes = carretesJson.map((c) => Carrete.fromJson(c)).toList();
        return carretes;
      } else {
        throw Exception('Error al obtener los amigos');
      }
    } catch (e) {
      //return "Connection Error";
      throw Exception('Error al obtener los amigos');
    }
  }

}