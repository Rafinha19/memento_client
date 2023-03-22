import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memento_flutter_client/ProfileView.dart';
import 'carreteCard.dart';

class TabPage extends StatefulWidget {
  TabPage(this.jwt, this.payload);

  factory TabPage.fromBase64(String jwt) => TabPage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: MementoCard(),
          ),
        ],
      ),
    ),
    Center(
      child: Icon(
        Icons.camera,
        size: 150,
      ),
    ),
    Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: ProfileView(),
      ),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Memento'),
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
        items: const <BottomNavigationBarItem>[
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
    );
  }
}
