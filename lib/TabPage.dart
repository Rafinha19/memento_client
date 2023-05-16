import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Controller/amigo_provider.dart';
import 'package:memento_flutter_client/Controller/solicitudAmistad_provider.dart';
import 'package:memento_flutter_client/Controller/usuarioList_provider.dart';
import 'package:memento_flutter_client/InicioView.dart';
import 'package:memento_flutter_client/Controller/carrete_provider.dart';
import 'package:memento_flutter_client/ProfileView.dart';
import 'package:memento_flutter_client/components/loading_overlay.dart';
import 'package:memento_flutter_client/uploadImageView.dart';
import 'package:provider/provider.dart';
import 'Config/Properties.dart';
import 'package:memento_flutter_client/Controller/currentUsuario_provider.dart';

import 'Model/currentUsuarioData.dart';

class TabPage extends StatefulWidget {
  TabPage();




  @override
  _TabPageState createState() => _TabPageState();
}


class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;



  @override
  void initState() {
    super.initState();
  }




  static List<Widget> _pages = <Widget>[
    Center(
      child: InicioView(),
    ),
    Center(
      child: LoadingOverlay(child: UploadImageView()),
    ),
    Center(
      child: ProfileView(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_) => Carrete_provider()),
        ChangeNotifierProvider( create: (_) => CurrentUsuario_provider()),
        ChangeNotifierProvider( create: (_) => Amigo_provider()),
        ChangeNotifierProvider( create: (_) => SolicitudAmistad_provider()),
        ChangeNotifierProvider( create: (_) => UsuarioList_provider())
      ],
      builder : (context,child){
        CurrentUsuario_provider usuario_provider = Provider.of<CurrentUsuario_provider>(context, listen: true);

        return WillPopScope(
          //El willpopScope no permite al usuario salir a la pantalla de login dandole al boton de atras de su dispositivo
          onWillPop: () async => false,
          child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  'Memento',
                  style: TextStyle(fontSize: 26),
                ),
                backgroundColor: AppbackgroundColor,
                automaticallyImplyLeading: false
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade800,width: 0.5)),
              ),
              child: BottomNavigationBar(
                iconSize: 25,
                selectedItemColor: Colors.orange,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: AppbackgroundColor,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.camera_alt_rounded),
                    label: "camera",
                  ),
                  BottomNavigationBarItem(
                    icon: 
                    usuario_provider.isLoading?
                     CircularProgressIndicator()
                        :
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(usuario_provider.usuario.url_foto_perfil),
                    ),
                    label: "profile",
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ),
          ),
        );
      }

    );
  }
}
