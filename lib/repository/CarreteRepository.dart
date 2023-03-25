import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/carrete.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:memento_flutter_client/Config/Properties.dart';


class CarreteRepository {

  final storage = FlutterSecureStorage();


  Future<Carrete> getMyLastCarrete () async {
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    try {
      var res = await http.get(
        Uri.parse("$SERVER_IP/api/carretes/mylastcarrete"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token', //'bearer token'
        },
      );
      if (res.statusCode == 200) {
        return Carrete.fromJson(jsonDecode(res.body));
      } else {
        throw Exception('Error al obtener el carrete');
      }
    } catch (e) {
      //return "Connection Error";
      throw Exception('Error al obtener el carrete');
    }
  }
}