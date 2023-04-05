import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/TabPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';

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
  bool _isLoading = false;

  //Funcion auxiliar para hacer un display de un dialogo
  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
                shape: RoundedRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(32.0))),
                title: Text(title,style: TextStyle(color: Colors.orange),),
                content: Text(text),
                backgroundColor: Colors.grey[800],
            ),
      );

  bool isValidEmail(String email) {
    return email.contains('@');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
      ),
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
                      setState(() => _isLoading = true);
                      //Primero hacemos las comprobaciones necesarias
                      var username = usernameController.text.trim();
                      var password = passwordController.text.trim();
                      var repeatPassword = repeat_passwordController.text.trim();
                      var email= emailController.text.trim();
                      if(username=='' || password==''|| email==''||repeatPassword==''){
                        displayDialog(context, AppLocalizations.of(context)!.fill_all_data,AppLocalizations.of(context)!.fill_add_data_description);
                        setState(() => _isLoading = false);
                      }else if(!isValidEmail(email)){
                        displayDialog(context, AppLocalizations.of(context)!.not_a_valid_email, AppLocalizations.of(context)!.not_a_valid_email_description);
                        setState(() => _isLoading = false);
                      } else if(password.length < 4) {
                        displayDialog(context, AppLocalizations.of(context)!
                            .not_a_valid_password, AppLocalizations.of(context)!
                            .not_a_valid_password_description);
                        setState(() => _isLoading = false);
                      }
                      else if(password!= repeatPassword){
                        displayDialog(context,AppLocalizations.of(context)!.passwords_dont_match,AppLocalizations.of(context)!.passwords_dont_match_description);
                        setState(() => _isLoading = false);
                      }else{
                        //Acontinuación creamos la cuenta y en caso de no haber problemas logeamos al usuario
                        var res = await  AccountRepository().attemptSignUp(username, password, email);
                        setState(() => _isLoading = false);
                        //Seria más correcto cambiar el servidor para que devuelva un 201, pero en este caso devuelve un 200
                        if(res == 200){
                          var jwt = await AccountRepository().attemptLogIn(username, password);
                          if(jwt != null) {
                            storage.write(key: "jwt", value: jwt);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TabPage()
                                )
                            );
                          } else {
                            //Este error realmente no debia pasar nunca salvo que el servidor se quede colgado a medias
                            displayDialog(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.unexpected_error);
                          }
                        } else if(res == 400){
                          displayDialog(context, AppLocalizations.of(context)!.username_already_registered, AppLocalizations.of(context)!.username_already_registered_description);
                        }else if(res==1){
                          //Server error
                          displayDialog(context, AppLocalizations.of(context)!.server_error,  AppLocalizations.of(context)!.server_error_description);
                        }else if(res==2){
                          //Connection error
                          displayDialog(context, AppLocalizations.of(context)!.connection_error, AppLocalizations.of(context)!.connection_error_description);
                        }else if(res==3){
                          //Connection error
                          displayDialog(context, AppLocalizations.of(context)!.email_already_in_use,AppLocalizations.of(context)!.email_already_in_use_description);
                        }
                        else {
                          displayDialog(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.unexpected_error);
                        }

                      }
                    },
                    child:
                        _isLoading ?
                            const CircularProgressIndicator(color: Colors.white)
                            :
                    Text(
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
