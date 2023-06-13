import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:memento_flutter_client/Views/editProfileImageView.dart';
import 'package:memento_flutter_client/Views/editProfileImageView.dart';
import 'package:memento_flutter_client/Views/editUserCredentialsView.dart';
import 'package:memento_flutter_client/Views/editUserDataView.dart';
import 'package:memento_flutter_client/components/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Controller/currentUsuario_provider.dart';

class editProfileView extends StatefulWidget {
  @override
  _editProfileViewState createState() => _editProfileViewState();
}

class _editProfileViewState extends State<editProfileView> {
  @override
  void initState() {
    super.initState();
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
                  padding: EdgeInsets.only(top:20,bottom: 30.0),
                  child: Text(
                      AppLocalizations.of(context)!.editProfile,
                      textAlign: TextAlign.left,
                      textScaleFactor: 2.0,
                      overflow: TextOverflow.ellipsis,),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0) ,
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return LoadingOverlay(child: editProfileImageView(username: currentUsuario_provider.usuario.nombre_usuario,));
                          }),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.editProfilePicture,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0) ,
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return ChangeNotifierProvider.value(
                                value: currentUsuario_provider,
                                child: LoadingOverlay(child: editUserDataView(email: currentUsuario_provider.usuario.email,)));
                          }),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.editUserData,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0) ,
                  child: Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return ChangeNotifierProvider.value(
                                value: currentUsuario_provider,
                                child: LoadingOverlay(child: editUserCredentialsView(username: currentUsuario_provider.usuario.nombre_usuario,)));
                          }),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.editCredentials,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
