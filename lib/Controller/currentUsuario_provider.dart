import 'package:flutter/cupertino.dart';
import 'package:memento_flutter_client/Model/datosUsuarioActual.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/UsersRepository.dart';
import 'package:provider/provider.dart';

class CurrentUsuario_provider extends ChangeNotifier {
  late CurrentUsuarioData usuario;
  bool isLoading = false;

  CurrentUsuario_provider(){
    this.loadUserData();
  }


  Future<void> loadUserData() async {
    this.isLoading =true;
    this.usuario = await AccountRepository().getAccount();
    this.isLoading = false;
    notifyListeners();
  }







}