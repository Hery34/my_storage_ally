import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class QrCodeGeneratorPage extends StatelessWidget {
  final int numberOfQRCodes = 12;
  final Random random = Random();
  final DateTime now = DateTime.now();

  QrCodeGeneratorPage({super.key});

  String generateQRData() {
    return 'stally${random.nextInt(1000000)}-${now.millisecondsSinceEpoch}';
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Wrap(
            spacing: 50,
            runSpacing: 20,
            children: List.generate(numberOfQRCodes, (_) {
              return pw.Container(
                width: 120,
                height: 150,
                child: pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: generateQRData(),
                ),
              );
            }),
          );
        },
      ),
    );

    return pdf.save();
  }

  Future<void> _savePdfAndShare(BuildContext context) async {
    final bytes = await _generatePdf(PdfPageFormat.a4);
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File('$appDocPath/qr_codes.pdf');
    await file.writeAsBytes(bytes);

    final xfile = XFile(file.path); // Conversion du chemin du fichier en XFile
    await Share.shareXFiles([xfile],
        text: 'Voici votre planche de QR codes Stally');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Partager ma planche de QR Codes Stally',
          style: TextStyle(color: Colors.blue[800], fontSize: 15),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _savePdfAndShare(context),
            color: Colors.blue,
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
        pdfFileName: 'QR_Codes_Stally.pdf',
        canDebug: false,
      ),
    );
  }
}
