import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/box_model.dart';
import 'package:my_storage_ally/screens/box_items_view.dart';
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

  final itemDatabase = ItemDatabase(AppDatabase.instance);

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

  goToBoxContentView(int? boxId) async {
    if (boxId == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoxItemsView(
          boxId: boxId,
          itemDatabase: itemDatabase,
        ),
      ),
    );
    refreshBoxes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: graySA,
      appBar: AppBar(
        foregroundColor: blueSa,
        backgroundColor: graySA,
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
            color: orangeSa,
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
                      color: purpleSa,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Référence',
                      labelStyle: TextStyle(
                        color: blueSa,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () => goToBoxContentView(widget.boxId),
                      child: const Text("Voir le contenu du carton"))
                ]),
        ),
      ),
    );
  }
}
