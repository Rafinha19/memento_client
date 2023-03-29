import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/TabPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final storage = FlutterSecureStorage();


class signUpView extends StatefulWidget {
  const signUpView({Key? key}) : super(key: key);

  @override
  _signUpViewState createState() => _signUpViewState();
}

class _signUpViewState extends State<signUpView> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeat_passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

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
  }

  //HABRA QUE CAMBIAR ESTA FUNCION SEGURO
  //  me falta meterle el correo/telefono
  Future<int> attemptSignUp(String username, String password) async {

    Map userDTO = {
      'login': username,
      'password': password
    };
    var res = await http.post(
        Uri.parse('$SERVER_IP/api/register') ,
        headers: {"Content-Type": "application/json"},
        body: json.encode(userDTO)
    );
    return res.statusCode;

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
                  AppLocalizations.of(context)!.memento,
                  textAlign: TextAlign.center,
                  textScaleFactor: 4.0,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  AppLocalizations.of(context)!.create_an_account,
                  textAlign: TextAlign.center,
                  textScaleFactor: 1.4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.username,
                      hintText: AppLocalizations.of(context)!.username_hint
                  ),

                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  controller: emailController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.email,
                      hintText: AppLocalizations.of(context)!.email_hint
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
                      labelText: AppLocalizations.of(context)!.password,
                      hintText: AppLocalizations.of(context)!.password_hint
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  controller: repeat_passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.repeat_password,
                      hintText: AppLocalizations.of(context)!.repeat_password_hint
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
                      //Primero hacemos las comprobaciones necesarias
                      var username = usernameController.text;
                      var password = passwordController.text;
                      var repeatPassword = repeat_passwordController.text;
                      if(password.length < 4)
                        displayDialog(context, "Invalid Password", "The password should be at least 4 characters long");
                      else if(password!= repeatPassword){
                        displayDialog(context,"Passwords dont match","Please rewrite the passwords");
                      }else{
                        //Acontinuación creamos la cuenta y en caso de no haber problemas logeamos al usuario
                        var res = await attemptSignUp(username, password);
                        //Seria más correcto cambiar el servidor para que devuelva un 201, pero en este caso devuelve un 200
                        if(res == 200){
                          displayDialog(context, "Success", "The user was created.");
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
                            displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                          }
                        }
                        else if(res == 409){
                          displayDialog(context, "That username is already registered", "Please try to sign up using another username or log in if you already have an account.");
                        }
                        else {
                          displayDialog(context, "Error", "An unknown error ocured");
                        }

                      }
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 25),
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
