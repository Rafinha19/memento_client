import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memento_flutter_client/repository/CarreteRepository.dart';
import 'package:provider/provider.dart';

import 'Controller/carrete_provider.dart';
import 'Model/carrete.dart';
import 'components/select_photo_options_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    Carrete_provider carrete_provider = Provider.of<Carrete_provider>(context);

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
                      :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Text(
                                  CarreteRepository().toUpperCaseFirstLetter(
                                          DateFormat(
                                                  'MMMM',
                                                  Localizations.localeOf(
                                                          context)
                                                      .languageCode)
                                              .format(DateTime(carrete_provider.getLastCarrete().ano,
                                                  carrete_provider.getLastCarrete().mes))) +
                                      " " +
                                      carrete_provider.getLastCarrete().ano.toString(),
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
                           carrete_provider.getLastCarrete().num_fotos.toString() + " de 9 fotos",
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
                      _showSelectPhotoOptions(context);
                    },
                    child: Center(
                      child: Container(
                          height: 350.0,
                          width: 350,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade700)
                          ),
                          child: Center(
                              child: _image == null
                                  ? const Text(
                                      'Selecciona una imagen',
                                      style: TextStyle(fontSize: 20),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
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
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () {
                        _showSelectPhotoOptions(context);
                      },
                      child: Text(
                        "Seleccionar foto",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
                      onPressed: () async {
                        var res = await CarreteRepository().uploadPhoto(_image!);


                      },
                      child: Text(
                        "Subir foto al carrete",
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
