import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memento_flutter_client/Controller/friendsCarretes_provider.dart';
import 'package:memento_flutter_client/components/myFriendsCarretes.dart';
import 'package:memento_flutter_client/components/myLastCarrete.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Controller/myCarretes_provider.dart';

class InicioView extends StatefulWidget {
  @override
  _InicioViewState createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyCarretes_provider mycarrete_provider =
        Provider.of<MyCarretes_provider>(context, listen: true);
    FriendsCarretes_provider friendsCarretes_provider = Provider.of<FriendsCarretes_provider>(context, listen: true);

    Future refresh() async {
      friendsCarretes_provider.getMyFriendsCarretes();
      setState(() {

      });
    }

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 12.0, right: 12.0),
      child: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              mycarrete_provider.isLoading?
                  Container()
              :
              Padding(
                padding: EdgeInsets.only(left: 10.0,bottom: 5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    CarreteRepository().toUpperCaseFirstLetter(
                        DateFormat(
                            'MMMM',
                            Localizations.localeOf(
                                context)
                                .languageCode)
                            .format(DateTime(
                            mycarrete_provider.getLastCarrete().ano,
                            mycarrete_provider.getLastCarrete().mes)) +
                            " " +
                            mycarrete_provider.getLastCarrete().ano.toString()),
                    textScaleFactor: 2.0,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              myLastCarrete(),
              Padding(
                padding:  EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(AppLocalizations.of(context)!.friends,
                    textScaleFactor: 1.5,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              myFriendsCarretes()
            ],
          ),
        ),
      ),
    ));
  }
}
