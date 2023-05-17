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
import '../Controller/myCarretes_provider.dart';
import '../repository/CarreteRepository.dart';
import 'displayDialog.dart';
import 'loading_overlay.dart';

class carreteDetail extends StatefulWidget {
  final Carrete carrete;
  final bool isMyCarrete;
  carreteDetail({Key? key, required this.carrete, required this.isMyCarrete})
      : super(key: key);

  @override
  State<carreteDetail> createState() => _carreteDetailState();
}

class _carreteDetailState extends State<carreteDetail> {
  late Future<String> futureToken;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    futureToken = AccountRepository().getJwtToken();
    if (widget.carrete.num_fotos == 0) {
      _currentIndex = 0;
    } else {
      _currentIndex = widget.carrete.ids_fotos[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    MyCarretes_provider mycarrete_provider = Provider.of<MyCarretes_provider>(context);

    void _updateCurrentIndex(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Memento',
            style: TextStyle(fontSize: 26),
          ),
          backgroundColor: AppbackgroundColor),
      body: FutureBuilder<String>(
        future: futureToken,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String token = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25, // Image radius
                              backgroundImage: NetworkImage(AccountRepository()
                                  .getProfileImageUrl(
                                      widget.carrete.propietario)),
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(widget.carrete.propietario)),
                          ],
                        ),
                        widget.isMyCarrete
                            ? Container(
                                height: 35,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                  onPressed: () {
                                    print("Generar memento");
                                  },
                                  child: Text(
                                    "Generar Memento",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(CarreteRepository().toUpperCaseFirstLetter(
                                DateFormat(
                                        'MMMM',
                                        Localizations.localeOf(context)
                                            .languageCode)
                                    .format(DateTime(widget.carrete.ano,
                                        widget.carrete.mes))) +
                            " " +
                            widget.carrete.ano.toString()),
                        Text(widget.carrete.num_fotos.toString() + "/9")
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: SizedBox(
                      height: 400, // card height
                      child: Swiper(
                        itemBuilder: (BuildContext context, int _index) {
                          return zoomableImage(
                              imageUrl: "$SERVER_IP/api/fotos/" +
                                  widget.carrete.ids_fotos[_index].toString(),
                              token: token);
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
                        onIndexChanged: (int index) {
                          _updateCurrentIndex(widget.carrete.ids_fotos[index]);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
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
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                        widget.isMyCarrete
                            ? Row(children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.create_rounded,
                                    size: 30,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () {
                                    _renewEditedReel(context);
                                  },
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                widget.carrete.num_fotos==0?
                                Container()
                                    :
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    size: 35,
                                    color: Colors.orange,
                                  ),
                                  onPressed: () async {
                                    int res = await CarreteRepository().deleteMyPhoto(_currentIndex);
                                    if (res == 0){
                                      //Carreteprovider actualizar
                                      mycarrete_provider.getMyCarretes();
                                      Navigator.pop(context);
                                      displayDialog(context, AppLocalizations.of(context)!.deletedImage,  AppLocalizations.of(context)!.deletedImage_DESC);
                                    }else if( res == 2){
                                      displayDialog(context, AppLocalizations.of(context)!.connection_error, AppLocalizations.of(context)!.connection_error_description );
                                    }else{
                                      displayDialog(context, AppLocalizations.of(context)!.error, AppLocalizations.of(context)!.unexpected_error);
                                    }
                                  },
                                ),
                              ])
                            : Container(),
                      ],
                    ),
                  )
                ],
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
      MaterialPageRoute(
          builder: (context) => LoadingOverlay(
              child: editcarreteDescriptionView(carrete: widget.carrete))),
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
