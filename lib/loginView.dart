import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/TabPage.dart';
import 'package:memento_flutter_client/signUpView.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const SERVER_IP = 'http://localhost:8080';
final storage = FlutterSecureStorage();


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //Funcion auxiliar para hacer un display de un dialogo
  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(32.0))),
                title: Text(title),
                content: Text(text)
            ),
      );

  Future<String?> attemptLogIn(String username, String password) async {
    Map loginDTO = {
      'login': username,
      'password': password
    };

    try{
      var res = await http.post(
          Uri.parse("$SERVER_IP/api/authenticate") ,
          headers: {"Content-Type": "application/json"},
          body: json.encode(loginDTO)
      );
      if(res.statusCode == 200) {
        return res.body;
      }else {
        return null;
      }
    }catch(e){
      return "Connection Error";
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding (
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Memento',
                  textAlign: TextAlign.center,
                  textScaleFactor: 4.0,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter valid mail as abc@gmail.com'
                  ),

                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter your secure password'
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.orange, borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () async {
                      var username = usernameController.text;
                      var password = passwordController.text;
                      var jwt = await attemptLogIn(username, password);
                      if(jwt != null) {
                        storage.write(key: "jwt", value: jwt);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TabPage.fromBase64(jwt)
                            )
                        );
                      } else {
                        //OJO AQUI VA A QUEDAR ARREGLAR EL CASO DE QUE NO HAYA CONEXION A INTERNET
                        displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Dont have an account?',
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => signUpView()
                          )
                      );
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),

        )
      ),
    );
  }



}
