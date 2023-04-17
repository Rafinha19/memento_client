import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/components/zoomableImage.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../Config/Properties.dart';
import '../Model/usuario_provider.dart';
import '../repository/CarreteRepository.dart';

class editcarreteDescriptionView extends StatefulWidget {
  final Carrete carrete;
  editcarreteDescriptionView({Key? key, required this.carrete})
      : super(key: key);

  @override
  State<editcarreteDescriptionView> createState() =>
      _editcarreteDescriptionViewState();
}

class _editcarreteDescriptionViewState
    extends State<editcarreteDescriptionView> {
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    descriptionController.text = widget.carrete.descripcion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Memento',
            style: TextStyle(fontSize: 26),
          ),
          backgroundColor: Colors.black),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
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
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                    CarreteRepository().toUpperCaseFirstLetter(DateFormat('MMMM',Localizations.localeOf(context).languageCode).format(DateTime(widget.carrete.ano,widget.carrete.mes))) + " " + widget.carrete.ano.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: TextField(
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    controller: descriptionController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Descripcion",
                        hintText: "Descripcion"),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
