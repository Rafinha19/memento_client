import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:memento_flutter_client/Config/Properties.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountRepository {
  final storage = FlutterSecureStorage();

  logOut() {
    storage.write(key: "jwt", value: null);
  }

  Future<String?> attemptLogIn(String username, String password) async {
    Map loginDTO = {'username': username, 'password': password};

    try{
      var res = await http.post(Uri.parse("$SERVER_IP/api/authenticate"),
          headers: {"Content-Type": "application/json"},
          body: json.encode(loginDTO));
      if (res.statusCode == 200) {
        return res.body;
      }else if(res.statusCode == 400) {
        return "400"; //Bad request
      }else if(res.statusCode == 401) {
        return "401"; //Unauthorized - bad credentials
      } else {
        return null;
      }
    }catch(e){
      if(e is SocketException) {
        //treat SocketException
        return "SERV_ERR";
      }else {
        return "CONN_ERR";
      }
    }

  }

  Future<String> getJwtToken() async {
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    return jsonData['token'];
  }
}
