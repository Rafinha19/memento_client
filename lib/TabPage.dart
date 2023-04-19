import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/InicioView.dart';
import 'package:memento_flutter_client/Model/carrete_provider.dart';
import 'package:memento_flutter_client/ProfileView.dart';
import 'package:memento_flutter_client/components/carreteCard.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/UsersRepository.dart';
import 'package:provider/provider.dart';
import 'Config/Properties.dart';
import 'package:memento_flutter_client/Model/usuario_provider.dart';

import 'Model/usuario.dart';

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
      child: Icon(
        Icons.camera,
        size: 150,
      ),
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
        ChangeNotifierProvider( create: (_) => Usuario_provider()),
        ChangeNotifierProvider(create:(_) => Carrete_provider())
      ],
      builder : (context,child){
        Usuario_provider usuario_provider = Provider.of<Usuario_provider>(context, listen: true);

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
                backgroundColor: Colors.black,
                automaticallyImplyLeading: false
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade900,width: 0.5)),
              ),
              child: BottomNavigationBar(
                iconSize: 25,
                selectedItemColor: Colors.orange,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Colors.black,
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
