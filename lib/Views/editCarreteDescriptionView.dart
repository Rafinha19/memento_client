import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memento_flutter_client/Model/carrete.dart';
import 'package:memento_flutter_client/components/displayDialog.dart';
import 'package:memento_flutter_client/repository/AccountRepository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:memento_flutter_client/Config/Properties.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:memento_flutter_client/components/loading_overlay.dart';

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
          backgroundColor: AppbackgroundColor),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context,widget.carrete.descripcion);
          return false;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                          enabledBorder: const OutlineInputBorder(
                            // width: 0.0 produces a thin "hairline" border
                            borderSide: const BorderSide(color: Colors.orange, width: 1.0),
                          ),
                          border: OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.description,
                          hintText: AppLocalizations.of(context)!.description),
                    ),
                  ),
                ),
                Container(
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextButton(
                    onPressed: () async {
                      //LoadingOverlay.of(context).show();
                      try{
                        Carrete updatedCarrete = await CarreteRepository().edtiCarreteDescription(widget.carrete.id_carrete, descriptionController.text);
                        //LoadingOverlay.of(context).hide();
                        Navigator.pop(context,updatedCarrete.descripcion);
                      }catch(e){
                        //LoadingOverlay.of(context).hide();
                        displayDialog(context,AppLocalizations.of(context)!.connection_error, AppLocalizations.of(context)!.connection_error_description);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context)!.saveChanges,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
