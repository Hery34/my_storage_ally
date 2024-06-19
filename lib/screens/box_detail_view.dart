import 'package:flutter/material.dart';
import 'package:my_storage_ally/database/app_database.dart.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/models/box_model.dart';
import 'package:my_storage_ally/screens/box_view.dart';

class BoxDetailView extends StatefulWidget {
  const BoxDetailView({super.key, this.boxId});
  final int? boxId;

  @override
  State<BoxDetailView> createState() => _BoxDetailViewState();
}

class _BoxDetailViewState extends State<BoxDetailView> {
  final database = BoxDatabase(AppDatabase.instance);
  TextEditingController boxNumberController = TextEditingController();

  late BoxModel box;
  bool isLoading = false;
  bool isNewBox = false;
  bool isFavorite = false;

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
        isFavorite = box.isFavorite;
      });
    });
  }

  createBox() {
    setState(() {
      isLoading = true;
    });
    final model = BoxModel(
      boxNumber: (boxNumberController.text),
      isFavorite: isFavorite,
      createdTime: DateTime.now(),
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
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => const BoxView()));
  }

  deleteItem() {
    database.deleteBox(box.idBox!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        foregroundColor: Colors.pinkAccent,
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            color: Colors.pinkAccent,
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
            color: Colors.white,
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
              : Column(children: [
                  TextField(
                    controller: boxNumberController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Référence',
                      labelStyle: TextStyle(
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ]),
        ),
      ),
    );
  }
}
