import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../Config/Properties.dart';
import '../Model/carrete.dart';

class mementoView extends StatelessWidget {
  String? mesAno;
  Carrete? carrete;
  String? token;
  mementoView(this.mesAno, this.carrete,this.token,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memento'),
      ),
      body: PdfPreview(
        pdfFileName: 'memento_'+ mesAno!.replaceAll(' ', ''),
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        build: (context) => makePdf(this.carrete!),
      ),
    );
  }

  Future<Uint8List> makePdf(Carrete carrete) async {
    final carreteImage0 = await networkImage(
        "$SERVER_IP/api/fotos/" +
            carrete.ids_fotos[0]
                .toString(),
        headers: {
          'Authorization': 'Bearer $token',
        });
    final carreteImage1 = await networkImage(
        "$SERVER_IP/api/fotos/" +
            carrete.ids_fotos[1]
                .toString(),
        headers: {
          'Authorization': 'Bearer $token',
        });
    final carreteImage2 = await networkImage(
        "$SERVER_IP/api/fotos/" +
            carrete.ids_fotos[2]
                .toString(),
        headers: {
          'Authorization': 'Bearer $token',
        });
    final carreteImage3 = await networkImage(
        "$SERVER_IP/api/fotos/" +
            carrete.ids_fotos[3]
                .toString(),
        headers: {
          'Authorization': 'Bearer $token',
        });
    final carreteImage4 = await networkImage(
        "$SERVER_IP/api/fotos/" +
            carrete.ids_fotos[4]
                .toString(),
        headers: {
          'Authorization': 'Bearer $token',
        });
    final carreteImage5 = await networkImage(
        "$SERVER_IP/api/fotos/" +
            carrete.ids_fotos[5]
                .toString(),
        headers: {
          'Authorization': 'Bearer $token',
        });
    final carreteImage6 = await networkImage(
        "$SERVER_IP/api/fotos/" +
            carrete.ids_fotos[6]
                .toString(),
        headers: {
          'Authorization': 'Bearer $token',
        });
    final carreteImage7 = await networkImage(
        "$SERVER_IP/api/fotos/" +
            carrete.ids_fotos[7]
                .toString(),
        headers: {
          'Authorization': 'Bearer $token',
        });
    final carreteImage8 = await networkImage(
        "$SERVER_IP/api/fotos/" +
            carrete.ids_fotos[8]
                .toString(),
        headers: {
          'Authorization': 'Bearer $token',
        });

    final netImage = await networkImage('https://www.nfet.net/nfet.jpg');
    final servImage =
    await networkImage('http://192.168.0.8:8080/api/users/rafa/image');
    final pdf = pw.Document();
    final ByteData byteslogo = await rootBundle.load('assets/velaMemento.png');
    final Uint8List byteListLogo = byteslogo.buffer.asUint8List();
    pdf.addPage(pw.Page(
        margin: const pw.EdgeInsets.all(10),
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              vertical: 20, horizontal: 30),
                          child: pw.Text('Junio 2023',
                              style:  pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold)))
                    ]),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          vertical: 30, horizontal: 25),
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Image(carreteImage0,
                                fit: pw.BoxFit.fitHeight,
                                height: 150,
                                width: 150),
                            pw.Image(carreteImage1,
                                fit: pw.BoxFit.fitHeight,
                                height: 150,
                                width: 150),
                            pw.Image(carreteImage2,
                                fit: pw.BoxFit.fitHeight,
                                height: 150,
                                width: 150)
                          ]),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          vertical: 30, horizontal: 25),
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Image(carreteImage3,
                                fit: pw.BoxFit.fitHeight,
                                height: 150,
                                width: 150),
                            pw.Image(carreteImage4,
                                fit: pw.BoxFit.fitHeight,
                                height: 150,
                                width: 150),
                            pw.Image(carreteImage5,
                                fit: pw.BoxFit.fitHeight,
                                height: 150,
                                width: 150)
                          ]),
                    ),
                    pw.Padding(
                      padding:  const pw.EdgeInsets.symmetric(
                          vertical: 30, horizontal: 25),
                      child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Image(carreteImage6,
                                fit: pw.BoxFit.fitHeight,
                                height: 150,
                                width: 150),
                            pw.Image(carreteImage7,
                                fit: pw.BoxFit.fitHeight,
                                height: 150,
                                width: 150),
                            pw.Image(carreteImage8,
                                fit: pw.BoxFit.fitHeight,
                                height: 150,
                                width: 150)
                          ]),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.symmetric(
                          vertical: 30, horizontal: 30),
                      child: pw.Row(
                        //mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Spacer(),
                            pw.Image(pw.MemoryImage(byteListLogo),
                                fit: pw.BoxFit.fitHeight,
                                height: 40,
                                width: 40),
                            pw.Text('Memento', style: const pw.TextStyle(fontSize: 20))
                          ]),
                    )


                  ],
                ),
              ]);
        }));
    return pdf.save();
  }
}
