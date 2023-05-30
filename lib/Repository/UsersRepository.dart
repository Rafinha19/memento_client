
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Config/Properties.dart';
import '../Model/usuario.dart';

class UsersRepository {

  final storage = FlutterSecureStorage();

  Future<List<Usuario>> getUsuariosNoAmigos() async {
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    try {
      var res = await http.get(
        Uri.parse("$SERVER_IP/api/friends/notfriends"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token', //'bearer token'
        },
      );
      if (res.statusCode == 200) {
        List<dynamic> amigosJson = jsonDecode(res.body);
        List<Usuario> amigos = amigosJson.map((c) => Usuario.fromJson(c)).toList();
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