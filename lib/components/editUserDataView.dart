import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Controller/currentUsuario_provider.dart';
import 'displayDialog.dart';
class editUserDataView extends StatefulWidget {
  final String email;
  editUserDataView({Key? key, required this.email})
      : super(key: key);

  @override
  State<editUserDataView> createState() =>
      _editUserDataViewState();
}

class _editUserDataViewState extends State<editUserDataView> {

  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  bool isValidEmail(String email) {
    return email.contains('@');
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
        padding: const EdgeInsets.only(left: 12.0, top: 18.0, right: 12.0),
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
                      padding: EdgeInsets.only(bottom: 20.0),
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
                  padding: EdgeInsets.only(top:50,bottom: 30.0),
                  child: Text(
                    AppLocalizations.of(context)!.editUserData,
                    textAlign: TextAlign.left,
                    textScaleFactor: 2.0,
                    overflow: TextOverflow.ellipsis,),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: TextField(
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      controller: emailController,
                      decoration: InputDecoration(
                          enabledBorder: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: const BorderSide(color: Colors.orange, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.email,
                          hintText: AppLocalizations.of(context)!.email),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0) ,
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color:  Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () async{
                        if(this.emailController.text==widget.email){
                          Navigator.pop(context);
                        }
                        else if(!this.isValidEmail(emailController.text)){
                          displayDialog(context, AppLocalizations.of(context)!.not_a_valid_email, AppLocalizations.of(context)!.not_a_valid_email_description);
                        }else{
                          //El correo es válido podemos pasar a cambiarlo
                          int res = await AccountRepository().edtiUserData(emailController.text);
                          if(res == 0){
                            currentUsuario_provider.usuario.setEmail(emailController.text);
                            Navigator.pop(context);
                            displayDialog(context, AppLocalizations.of(context)!.changesSaved, AppLocalizations.of(context)!.emailUpdated);
                          }else if(res == 1){
                            displayDialog(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.unexpected_error);
                          }else{
                            displayDialog(context, AppLocalizations.of(context)!.connection_error, AppLocalizations.of(context)!.connection_error_description);
                          }

                        }
                      },
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
