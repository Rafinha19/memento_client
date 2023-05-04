import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:provider/provider.dart';

import 'Controller/carrete_provider.dart';
import 'components/carreteDetail.dart';
import 'components/displayDialog.dart';
import 'components/loading_overlay.dart';
import 'components/select_photo_options_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class UploadImageView extends StatefulWidget {
  const UploadImageView({super.key});

  static const id = 'set_photo_screen';

  @override
  State<UploadImageView> createState() => _UploadImageViewState();
}

class _UploadImageViewState extends State<UploadImageView> {
  File? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
    );
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

  void _showLastCarreteIsFullDialog(BuildContext context) {
    displayDialog(context, AppLocalizations.of(context)!
        .error,
        AppLocalizations.of(context)!
            .currentReelIsFull);
  }

  @override
  Widget build(BuildContext context) {
    Carrete_provider carrete_provider =
        Provider.of<Carrete_provider>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 12, right: 12, bottom: 30, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  carrete_provider.isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(
                              CarreteRepository().toUpperCaseFirstLetter(
                                      DateFormat(
                                              'MMMM',
                                              Localizations.localeOf(context)
                                                  .languageCode)
                                          .format(DateTime(
                                              carrete_provider
                                                  .getLastCarrete()
                                                  .ano,
                                              carrete_provider
                                                  .getLastCarrete()
                                                  .mes))) +
                                  " " +
                                  carrete_provider
                                      .getLastCarrete()
                                      .ano
                                      .toString(),
                              textAlign: TextAlign.center,
                              textScaleFactor: 2.5,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, top: 12.0, right: 12.0),
                              child: Center(
                                child: Text(
                                  carrete_provider
                                          .getLastCarrete()
                                          .num_fotos
                                          .toString() +
                                      AppLocalizations.of(context)!.of9photos,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      //Solo permitimos escoger si el ultimo carrete NO esta lleno
                      if (!carrete_provider.LastCarreteIsFull()) {
                        _showSelectPhotoOptions(context);
                      } else {
                        _showLastCarreteIsFullDialog(context);
                      }
                    },
                    child: Center(
                      child: Container(
                          height: 350.0,
                          width: 350,
                          decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade800)),
                          child: Center(
                              child:
                              carrete_provider.isLoading?
                              const CircularProgressIndicator()
                                  :
                              carrete_provider.LastCarreteIsFull()
                                  ? Text(
                                      AppLocalizations.of(context)!
                                          .currentReelIsFull,
                                      style: TextStyle(fontSize: 20),
                                    )
                                  : _image == null
                                      ? Text(
                                          AppLocalizations.of(context)!
                                              .noImageSelectedYet,
                                          style: TextStyle(fontSize: 20),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image(
                                            image: FileImage(_image!),
                                            fit: BoxFit.cover,
                                          ),
                                        ))),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        if (!carrete_provider.LastCarreteIsFull()) {
                          _showSelectPhotoOptions(context);
                        } else {
                          _showLastCarreteIsFullDialog(context);
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.selectAnImage,
                        style: TextStyle(
                            color:
                            carrete_provider.isLoading?
                            Colors.white
                                :
                            carrete_provider.LastCarreteIsFull()
                                ? Colors.white38
                                : Colors.white,
                            fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color:
                        carrete_provider.isLoading?
                        Colors.white
                            :
                        _image != null
                            ? Colors.orange
                            : Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () async {
                        if (carrete_provider.LastCarreteIsFull()) {
                          return;
                        }
                        LoadingOverlay.of(context).show();

                        if (_image != null) {
                          var res =
                              await CarreteRepository().uploadPhoto(_image!);

                          if (res == 0) {
                            // ha funcionado bien - reseteamos la foto y lo llevamos al carrete en cuestión a parte de decir que se traiga de nuevo los datos
                            //ESTO SERÍA MEJOR QUE SOLO ACTUALIZASE EL ÚLTIMO CARRETE
                            await carrete_provider.getMyCarretes();
                            setState(() {
                              _image = null;
                            });

                            LoadingOverlay.of(context).hide();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => carreteDetail(
                                        carrete: carrete_provider
                                            .getLastCarrete())));
                          } else if (res == 1) {
                            LoadingOverlay.of(context).hide();
                            displayDialog(
                                context,
                                AppLocalizations.of(context)!.error,
                                AppLocalizations.of(context)!.currentReelIsFull);
                          } else if (res == 2) {
                            LoadingOverlay.of(context).hide();
                            displayDialog(
                                context,
                                AppLocalizations.of(context)!.connection_error,
                                AppLocalizations.of(context)!
                                    .connection_error_description);
                          } else {
                            LoadingOverlay.of(context).hide();
                            displayDialog(
                                context,
                                AppLocalizations.of(context)!.error,
                                AppLocalizations.of(context)!.unexpected_error);
                          }
                        } else {
                          LoadingOverlay.of(context).hide();
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.uploadPhotoReel,
                        style: TextStyle(
                            color:
                                _image != null ? Colors.white : Colors.white38,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
