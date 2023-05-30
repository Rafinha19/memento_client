import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:memento_flutter_client/Config/Properties.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../Model/datosUsuarioActual.dart';

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


  Future<int> attemptSignUp(String username, String password, String email) async {

    Map userDTO = {
      'nombre_usuario': username,
      'password': password,
      'email': email
    };
    try {
      var res = await http.post(
          Uri.parse('$SERVER_IP/api/register') ,
          headers: {"Content-Type": "application/json"},
          body: json.encode(userDTO)
      );
      if(res.statusCode != 200) {
        //Esto es un workaround para poder anotar que ya existe un usuario con ese correo
        String jsonString = res.body;
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        String message = jsonMap['message'];
        if(message.compareTo("There is already a user with the email " + email) == 0){
          return 3;
        }
      }
      return res.statusCode;
    }catch(e){
      if(e is SocketException) {
        //SERVER ERROR
        return 1;
      }else {
        //CONECTION ERROR
        return 2;
      }
    }
  }


  Future<String> getJwtToken() async {
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    return jsonData['token'];
  }



  Future <CurrentUsuarioData> getAccount() async{
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    var res = await http.get(
      Uri.parse("$SERVER_IP/api/account"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token', //'bearer token'
      },
    );
    if (res.statusCode == 200) {
      return CurrentUsuarioData.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Error al subir la foto');
    }
  }

  String getProfileImageUrl(String username){
    return  "$SERVER_IP/api/users/" + username + "/image";
  }

  Future<int> edtiUserData (String email) async{
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    final Map<String, dynamic> userData = {
      'email': email,
    };

    try {
      var res = await http.put(
          Uri.parse("$SERVER_IP/api/users/myData"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token', //'bearer token'
          },
          body: jsonEncode(userData)
      );
      if (res.statusCode == 200) {
        return 0;
      } else {
        return 1;
      }
    } catch (e) {
      //return "Connection Error";
      return 2;
    }
  }

  Future<int> edtiUserCredentials (String username, String currentPassword, String newPassword) async{
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];
    final Map<String, dynamic> userData = {
      'username': username,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };

    try {
      var res = await http.put(
          Uri.parse("$SERVER_IP/api/users/myCredentials"),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token', //'bearer token'
          },
          body: jsonEncode(userData)
      );
      if (res.statusCode == 200) {
        return 0;
      } else {
        String jsonString = res.body;
        Map<String, dynamic> jsonMap = json.decode(jsonString);
        String message = jsonMap['message'];
        if(message.compareTo("The username " + username + " already exists") == 0){
          return 3;
        }else if(message.compareTo("You have written your password wrong")== 0){
          return 4;
        }else{
          return 1;
        }

      }
    } catch (e) {
      //return "Connection Error";
      return 2;
    }
  }

  Future<int> updateProfileImage (File image) async{
    var jsonString = await storage.read(key: "jwt");
    Map<String, dynamic> jsonData = jsonDecode(jsonString!);
    String token = jsonData['token'];

    try {
      var url = Uri.parse("$SERVER_IP/api/users/myprofilepicture");
      var request = http.MultipartRequest('PUT', url);

      var file = await http.MultipartFile.fromPath('file', image.path);
      request.files.add(file);

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


}
