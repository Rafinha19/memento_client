import 'package:flutter/cupertino.dart';
import 'package:memento_flutter_client/Model/usuario.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/UsersRepository.dart';
import 'package:provider/provider.dart';

class Usuario_provider extends ChangeNotifier {
  late Usuario usuario;
  bool isLoading = false;


  Future<void> setUsuario() async {
    this.isLoading =true;
    this.usuario = await AccountRepository().getAccount();
    this.isLoading = false;
    notifyListeners();
  }







}