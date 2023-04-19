import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/components/zoomableImage.dart';
import 'package:memento_flutter_client/editCarreteDescriptionView.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Config/Properties.dart';
import '../Model/usuario_provider.dart';
import '../repository/CarreteRepository.dart';
import 'loading_overlay.dart';

class carreteDetail extends StatefulWidget {
  final Carrete carrete;
  carreteDetail({Key? key, required this.carrete}) : super(key: key);

  @override
  State<carreteDetail> createState() => _carreteDetailState();
}

class _carreteDetailState extends State<carreteDetail> {
  late Future<String> futureToken;

  @override
  void initState() {
    super.initState();
    futureToken = AccountRepository().getJwtToken();
  }

  @override
  Widget build(BuildContext context) {
    int _index = widget.carrete.num_fotos;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Memento',
            style: TextStyle(fontSize: 26),
          ),
          backgroundColor: Colors.black),
      body: FutureBuilder<String>(
        future: futureToken,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String token = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25, // Image radius
                                backgroundImage: NetworkImage(AccountRepository()
                                    .getProfileImageUrl(widget.carrete.propietario)),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(widget.carrete.propietario)),
                            ],
                          ),
                          Container(
                            height: 35,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton(
                              onPressed: () {
                                print("Hola");
                              },
                              child: Text(
                                "Generar Memento",
                                style:
                                    TextStyle(color: Colors.white, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(CarreteRepository().toUpperCaseFirstLetter(DateFormat('MMMM',Localizations.localeOf(context).languageCode).format(DateTime(widget.carrete.ano,widget.carrete.mes))) + " " + widget.carrete.ano.toString()),
                          Text("Carrete " +
                              widget.carrete.num_fotos.toString() +
                              "/9")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: SizedBox(
                        height: 400, // card height
                        child: Swiper(
                          itemBuilder: (BuildContext context, int _index) {
                            return zoomableImage(imageUrl: "$SERVER_IP/api/fotos/" + widget.carrete.ids_fotos[_index].toString(), token: token);
                          },
                          duration: 100,
                          itemCount: widget.carrete.num_fotos,
                          viewportFraction: 1,
                          scale: 0.9,
                          loop: false,
                          pagination: SwiperPagination(
                              alignment: Alignment.bottomCenter,
                              builder: DotSwiperPaginationBuilder(
                                  color: Colors.grey[700],
                                  activeColor: Colors.orange,
                                  activeSize: 12,
                                  size: 8,
                                  space: 4)),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.carrete.descripcion,
                            textAlign: TextAlign.left,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "12",
                                style: TextStyle(
                                  fontSize:
                                      15.0, // Cambia el tamaño de la fuente aquí
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Icon(
                                Icons.favorite,
                                color: Colors.orange,
                                size: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "3",
                                style: TextStyle(
                                  fontSize:
                                      15.0, // Cambia el tamaño de la fuente aquí
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Icon(
                                Icons.mode_comment_outlined,
                                size: 30,
                              )
                            ],
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.create_rounded,
                              size: 30,
                              color: Colors.orange,
                            ), onPressed: () {
                            _renewEditedReel(context);
                          },
                          ),
                        ],
                      ),
                    )
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
    );
  }


  Future<void> _renewEditedReel(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final descripcion = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  LoadingOverlay(child: editcarreteDescriptionView(carrete: widget.carrete))),
    );

    // When a BuildContext is used from a StatefulWidget, the mounted property
    // must be checked after an asynchronous gap.
    if (!mounted) return;

    // Actualizamos la descripcion.
    setState(() {
      widget.carrete.setDescripcion(descripcion);
    });
  }
}
