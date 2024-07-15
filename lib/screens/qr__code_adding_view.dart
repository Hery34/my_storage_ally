import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeAddingView extends StatefulWidget {
  const QRCodeAddingView({super.key});

  @override
  State<StatefulWidget> createState() => _QRCodeAddingViewState();
}

class _QRCodeAddingViewState extends State<QRCodeAddingView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewAdded,
        overlay: QrScannerOverlayShape(
          borderColor: brownStally,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }

  void _onQRViewAdded(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.dispose();
      Navigator.of(context).pop(scanData.code);
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
