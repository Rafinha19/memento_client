import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memento_flutter_client/components/loading_overlay.dart';
import '../Controller/currentUsuario_provider.dart';
import '../loginView.dart';
import 'displayDialog.dart';

class editUserCredentialsView extends StatefulWidget {
  final String username;
  editUserCredentialsView({Key? key, required this.username})
      : super(key: key);

  @override
  State<editUserCredentialsView> createState() =>
      _editUserCredentialsViewState();
}

class _editUserCredentialsViewState extends State<editUserCredentialsView> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatNewPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    usernameController.text == widget.username;
  }


  @override
  Widget build(BuildContext context) {
    CurrentUsuario_provider currentUsuario_provider =
    Provider.of<CurrentUsuario_provider>(context);


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Memento',
          style: TextStyle(fontSize: 26),
        ),
        backgroundColor: AppbackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Center(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                currentUsuario_provider.isLoading
                    ?
                //true
                const CircularProgressIndicator()
                    : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        currentUsuario_provider
                            .usuario.nombre_usuario,
                        textAlign: TextAlign.left,
                        textScaleFactor: 3.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: CircleAvatar(
                        radius: 100, // Image radius
                        backgroundImage: NetworkImage(
                            currentUsuario_provider
                                .usuario.url_foto_perfil),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top:15,bottom: 20.0),
                  child: Text(
                    "Editar credenciales",
                    textAlign: TextAlign.left,
                    textScaleFactor: 2.0,
                    overflow: TextOverflow.ellipsis,),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: TextField(
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      controller: usernameController,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: const BorderSide(color: Colors.orange, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          labelText: "nombre usuario",
                          hintText: "nombre usuario"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: TextField(
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      controller: currentPasswordController,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: const BorderSide(color: Colors.orange, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          labelText: "Contraseña actual",
                          hintText: "Contraseña actual"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: TextField(
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      controller: newPasswordController,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: const BorderSide(color: Colors.orange, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          labelText: "Nueva contraseña",
                          hintText: "Nueva contraseña"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: TextField(
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      controller: repeatNewPasswordController,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: const BorderSide(color: Colors.orange, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          labelText: "Repetir nueva contraseña",
                          hintText: "Repetir nueva contraseña"),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0) ,
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color:  Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () async{
                        LoadingOverlay.of(context).show();
                        var username = usernameController.text.trim();
                        var currentPassword = currentPasswordController.text.trim();
                        var newPassword = newPasswordController.text.trim();
                        var repeatNewPassword = repeatNewPasswordController.text.trim();
                        //Primero comprobamos que concuerden las contraseñas nuevas y si no avisamos al usuario
                        if (newPassword!=repeatNewPassword){
                          LoadingOverlay.of(context).hide();
                          displayDialog(context, AppLocalizations.of(context)!.passwords_dont_match, "Las contraseñas nuevas no coinciden");
                        }else{
                          //Una vez vemos que coinciden llamamos a la funcion
                          var res = await AccountRepository().edtiUserCredentials(username, currentPassword, newPassword);
                          LoadingOverlay.of(context).hide();
                            if(res == 0 ){

                              AccountRepository().logOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LoadingOverlay(child: LoginView())));
                              displayDialog(context, AppLocalizations.of(context)!.changesSaved, "Se han actualizado las credenciales");
                            }else if( res == 1){
                              displayDialog(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.unexpected_error);
                            }else if( res == 2){
                              displayDialog(context, AppLocalizations.of(context)!.connection_error, AppLocalizations.of(context)!.connection_error_description);
                            }else if( res == 3){
                              displayDialog(context, "el nombre de usuario ya existe", "ya existe el username");
                            }else if( res == 4){
                              displayDialog(context, "Has puesto mal la contraseña", "la contraseña esta mal");
                            }
                          }
                        }
                        ,
                      child: Text(
                        AppLocalizations.of(context)!.saveChangesOneLine,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
