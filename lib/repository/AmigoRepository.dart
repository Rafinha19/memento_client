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
}