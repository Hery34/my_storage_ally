import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:my_storage_ally/screens/box_detail_view.dart';
import 'package:my_storage_ally/models/box_model.dart';
import 'package:my_storage_ally/database/box_database.dart'; // Importez votre classe de base de données

class QRScannerView extends StatefulWidget {
  const QRScannerView({super.key});

  @override
  QRScannerViewState createState() => QRScannerViewState();
}

class QRScannerViewState extends State<QRScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = true;
  final databaseBox = BoxDatabase(AppDatabase.instance);

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: Future.delayed(const Duration(milliseconds: 500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: brownStally,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isScanning) {
        setState(() {
          isScanning = false;
        });
        final String code = scanData.code!;
        await _processQRCode(code);
      }
    });
  }

  Future<void> _processQRCode(String code) async {
    try {
      controller?.pauseCamera();

      final int? boxId = await _getBoxIdFromQRCode(code);

      if (boxId != null) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => BoxDetailView(boxId: boxId),
            ),
          );
        }
      } else {
        _showErrorDialog('QR Code invalide ou non trouvé.');
        setState(() {
          isScanning = true;
          controller?.resumeCamera();
        });
      }
    } catch (e) {
      _showErrorDialog('Erreur lors du traitement du QR Code.');
      setState(() {
        isScanning = true;
        controller?.resumeCamera();
      });
    }
  }

  Future<int?> _getBoxIdFromQRCode(String qrCode) async {
    final BoxModel? box = await databaseBox.getBoxByQRCode(qrCode);
    return box?.idBox;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
