import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:memento_flutter_client/Model/usuario.dart';

import '../repository/UsersRepository.dart';

class UsuarioList_provider extends ChangeNotifier {
  late List<Usuario> usuariosNoamigos;
  //Por defecto lo dejamos como si estuviera cargando
  bool isLoading = true;
  bool hasErrors = false;

  UsuarioList_provider(){
    //Estaria bien no traerme todos los usuarios al iniciar la app
    this.getUsuariosNoAmigos();
  }

  Future<void> getUsuariosNoAmigos() async {
    try{
      this.isLoading =true;
      this.usuariosNoamigos = await UsersRepository().getUsuariosNoAmigos();
      this.isLoading = false;
      notifyListeners();
    }catch(e){
      this.hasErrors=true;
      notifyListeners();
    }
  }


}