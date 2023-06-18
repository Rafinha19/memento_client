import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/Views/carreteDetailView.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../Config/Properties.dart';
import '../Controller/myCarretes_provider.dart';

class carreteCard extends StatefulWidget {
  final Carrete carrete;
  final bool ismyLastcarrete;
  final bool isInicioCarrete;
  final bool isMycarrete;

  carreteCard(
      {Key? key,
      required this.carrete,
      required this.ismyLastcarrete,
      required this.isInicioCarrete,
      required this.isMycarrete})
      : super(key: key);

  @override
  State<carreteCard> createState() => _carreteCardState();
}

class _carreteCardState extends State<carreteCard> {
  late Future<String> futureToken;

  @override
  void initState() {
    super.initState();
    futureToken = AccountRepository().getJwtToken();
  }

  @override
  Widget build(BuildContext context) {
    MyCarretes_provider carrete_provider = Provider.of<MyCarretes_provider>(context);

    return Scaffold(
      body: Center(
        child: FutureBuilder<String>(
          future: futureToken,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String token = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider.value(
                                  value: carrete_provider,
                                  child:  carreteDetail(carrete: widget.carrete, isMyCarrete: widget.isMycarrete,)) ));
                },
                onDoubleTap: () {
                  print("liked");
                },
                child: Card(
                  color: Colors.grey[850],
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.isInicioCarrete
                          ? Padding(
                              padding:EdgeInsets.only(top: 10.0, left: 10,right: 10),
                              child:
                              widget.ismyLastcarrete?

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text("Carrete actual"),
                                    ],
                                  ),
                                  Text(widget.carrete.num_fotos.toString() + "/9")
                                ],
                              )
                                  :
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 15, // Image radius
                                        backgroundImage: NetworkImage(
                                            "$SERVER_IP/api/users/" +
                                                widget.carrete.propietario +
                                                "/image"),
                                      ),
                                      Container(
                                          margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                          child: Text(widget.carrete.propietario,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                              textAlign: TextAlign.center)),
                                    ],
                                  ),
                                  Text(widget.carrete.num_fotos.toString() + "/9")
                                ],
                              ),
                            )
                          :
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.ismyLastcarrete
                                  ? AppLocalizations.of(context)!.currentReel +
                                      widget.carrete.num_fotos.toString() +
                                      "/9"
                                  : CarreteRepository().toUpperCaseFirstLetter(
                                          DateFormat(
                                                  'MMMM',
                                                  Localizations.localeOf(
                                                          context)
                                                      .languageCode)
                                              .format(DateTime(
                                                  widget.carrete.ano,
                                                  widget.carrete.mes))) +
                                      " " +
                                      widget.carrete.ano.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Text(
                              widget.ismyLastcarrete
                                  ? CarreteRepository().toUpperCaseFirstLetter(
                                          DateFormat(
                                                  'MMMM',
                                                  Localizations.localeOf(
                                                          context)
                                                      .languageCode)
                                              .format(DateTime(
                                                  widget.carrete.ano,
                                                  widget.carrete.mes))) +
                                      " " +
                                      widget.carrete.ano.toString()
                                  : widget.carrete.num_fotos.toString() + "/9",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 150.0,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.carrete.ids_fotos.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "$SERVER_IP/api/fotos/" +
                                            widget.carrete.ids_fotos[index]
                                                .toString(),
                                        headers: {
                                          'Authorization': 'Bearer $token',
                                        }),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
