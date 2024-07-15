import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/box_model.dart';
import 'package:my_storage_ally/screens/qr__code_adding_view.dart';

class BoxCreateView extends StatefulWidget {
  const BoxCreateView({super.key, this.boxId});
  final int? boxId;

  @override
  State<BoxCreateView> createState() => _BoxCreateViewState();
}

class _BoxCreateViewState extends State<BoxCreateView> {
  final database = BoxDatabase(AppDatabase.instance);
  TextEditingController boxNumberController = TextEditingController();
  TextEditingController boxDescriptionController = TextEditingController();
  String scannedQRCode = '';

  late BoxModel box;
  bool isLoading = false;
  bool isNewBox = false;
  bool isFavorite = false;

  final itemDatabase = ItemDatabase(AppDatabase.instance);
  final _createBoxKey = GlobalKey<FormState>();

  @override
  void initState() {
    refreshBoxes();
    super.initState();
  }

  refreshBoxes() {
    if (widget.boxId == null) {
      setState(() {
        isNewBox = true;
      });
      return;
    }
    database.readBox(widget.boxId!).then((value) {
      setState(() {
        box = value;
        boxNumberController.text = box.boxNumber.toString();
        boxDescriptionController.text = box.boxDescription.toString();
        isFavorite = box.isFavorite;
      });
    });
  }

  Future<void> scanQRCode() async {
    try {
      final qrCode = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const QRCodeAddingView(),
        ),
      );
      if (qrCode != null) {
        setState(() {
          scannedQRCode = qrCode;
        });
      }
    } catch (e) {
      print('Error scanning QR code: $e');
    }
  }

  createBox() {
    if (_createBoxKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final model = BoxModel(
        boxNumber: (boxNumberController.text),
        boxDescription: boxDescriptionController.text,
        isFavorite: isFavorite,
        createdTime: DateTime.now(),
        qrCode: scannedQRCode,
      );
      if (isNewBox) {
        database.createBox(model);
      } else {
        model.idBox = box.idBox;
        database.updateBox(model);
      }
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: coffeeStally,
          content: Text(
            'Carton rajouté !',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  deleteItem() {
    database.deleteBox(box.idBox!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brownStally,
      appBar: AppBar(
        foregroundColor: blackStally,
        backgroundColor: brownStally,
        actions: [
          IconButton(
            color: blueSa,
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(!isFavorite ? Icons.favorite_border : Icons.favorite),
          ),
          Visibility(
            visible: !isNewBox,
            child: IconButton(
              color: Colors.red,
              onPressed: deleteItem,
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            color: blackStally,
            onPressed: createBox,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Form(
                    key: _createBoxKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: boxNumberController,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: blackStally,
                            fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Référence',
                            labelStyle: TextStyle(
                              color: coffeeStally,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La référence ne peut pas être vide';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: boxDescriptionController,
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: blackStally,
                            fontSize: 20,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(
                              color: coffeeStally,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La description ne peut pas être vide';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: scanQRCode,
                          child: const Text(
                            'Associer un QR Code',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        if (scannedQRCode.isNotEmpty)
                          Text('QR Code scanné : $scannedQRCode'),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
