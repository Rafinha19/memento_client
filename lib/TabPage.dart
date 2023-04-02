import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/InicioView.dart';
import 'package:memento_flutter_client/ProfileView.dart';
import 'package:memento_flutter_client/carreteCard.dart';
import 'package:memento_flutter_client/myCarretes.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'Config/Properties.dart';
import 'package:memento_flutter_client/Model/usuario.dart';

class TabPage extends StatefulWidget {
  TabPage();





  @override
  _TabPageState createState() => _TabPageState();
}


class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;
  late final Future<Usuario> usuario;

  @override
  void initState() {
    super.initState();
    usuario=  AccountRepository().getAccount();
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
    //El willpopScope no permite al usuario salir a la pantalla de login dandole al boton de atras de su dispositivo
    return new WillPopScope(
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
          bottomNavigationBar: BottomNavigationBar(
            iconSize: 30,
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
                icon: Icon(Icons.person),
                label: "my profile",
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
    );
  }
}
