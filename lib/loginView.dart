import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/TabPage.dart';
import 'package:memento_flutter_client/signUpView.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



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
                  AppLocalizations.of(context)!.memento,
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
                      hintText: 'Enter your username'
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
                      var jwt = await AccountRepository().attemptLogIn(username, password);
                      if(jwt == "400"){
                        displayDialog(context, "Error", "Password and username must be at least 4 characters long");
                      } else if (jwt=="401"){
                        displayDialog(context, "Error", "We haven't found any account with that password or username");
                      } else if(jwt=="CONN_ERR"){
                        displayDialog(context, "Connection error", "There was a problem with the internet connection. Try again later");
                      }else if(jwt =="SERV_ERR"){
                        displayDialog(context, AppLocalizations.of(context)!.server_error, "There was a problem with the server. Try again later");
                      } else if(jwt != null) {
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
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[700], borderRadius: BorderRadius.circular(10)),
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
