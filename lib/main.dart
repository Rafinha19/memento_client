import 'dart:convert' show json, base64, ascii;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:memento_flutter_client/Model/usuario_provider.dart';
import 'package:memento_flutter_client/components/loading_overlay.dart';
import 'package:memento_flutter_client/loginView.dart';
import 'package:memento_flutter_client/TabPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('es', ''),
      ],
      title: 'Memento',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
        accentColor: Colors.grey[700],
        scaffoldBackgroundColor:  Colors.black,
      ),
      home: LoadingOverlay(
        child: FutureBuilder(
            future: jwtOrEmpty,
            builder: (context, snapshot) {
              if(!snapshot.hasData) return CircularProgressIndicator();
              if(snapshot.data != "") {
                var str = snapshot.data.toString();
                var jwt = str.split(".");


                if(jwt.length !=3) {
                  return LoginView();
                } else {
                  var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                  if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                    return TabPage();
                  } else {
                    return LoginView();
                  }
                }
              } else {
                return LoginView();
              }
            }
        ),
      ),
    );
  }
}