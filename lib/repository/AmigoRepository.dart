import 'package:memento_flutter_client/Model/amigo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../Config/Properties.dart';

class AmigoRepository{

  final storage = FlutterSecureStorage();

  Future<List<Amigo>> getMyAmigos() async {
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    try {
      var res = await http.get(
        Uri.parse("$SERVER_IP/api/friends/myfriends"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token', //'bearer token'
        },
      );
      if (res.statusCode == 200) {
        List<dynamic> amigosJson = jsonDecode(res.body);
        List<Amigo> amigos = amigosJson.map((c) => Amigo.fromJson(c)).toList();
        return amigos;
      } else {
        throw Exception('Error al obtener los amigos');
      }
    } catch (e) {
      //return "Connection Error";
      throw Exception('Error al obtener los amigos');
    }
  }

  Future<int> crearSolicitudAmistad(int id_usuario) async {
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    try {
      var res = await http.post(
        Uri.parse("$SERVER_IP/api/friendrequest/create/"+ id_usuario.toString()),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token', //'bearer token'
        },
      );
      if (res.statusCode == 200) {
        return 0;
      } else {
        String jsonString = res.body;
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        String message = jsonMap['message'];
        if(message.compareTo("The friend request was already created and is in pending state") == 0){
          return 1;
        }else if(message.compareTo("You already have a pending friend request from that user") == 0){
          return 2;
        }else{
          throw Exception('Error al crear la solicitud');
        }
      }
    } catch (e) {
      //return "Connection Error";
      throw Exception('Error al obtener los amigos');
    }
  }
}