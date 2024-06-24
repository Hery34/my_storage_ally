import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/box_model.dart';
import 'package:my_storage_ally/models/item_model.dart';

class ItemCreateView extends StatefulWidget {
  const ItemCreateView({super.key, this.itemId});
  final int? itemId;

  @override
  State<ItemCreateView> createState() => _ItemCreateViewState();
}

class _ItemCreateViewState extends State<ItemCreateView> {
  final database = ItemDatabase(AppDatabase.instance);
  final boxDatabase = BoxDatabase(AppDatabase.instance);

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemNumberController = TextEditingController();

  late ItemModel item;
  bool isLoading = false;
  bool isNewItem = false;
  bool isFavorite = false;

  int? selectedBoxId;
  List<BoxModel> boxes = [];

  @override
  void initState() {
    refreshItems();
    fetchBoxes();
    super.initState();
  }

  ///Gets the note from the database and updates the state if the noteId is not null else it sets the isNewNote to true
  refreshItems() {
    if (widget.itemId == null) {
      setState(() {
        isNewItem = true;
      });
      return;
    }
    database.readItem(widget.itemId!).then((value) {
      setState(() {
        item = value!;
        itemNameController.text = item.itemName;
        itemNumberController.text = item.itemNumber.toString();
        selectedBoxId = item.boxId;
        isFavorite = item.isFavorite;
      });
    });
  }

  Future<void> fetchBoxes() async {
    boxes = await boxDatabase.readAllBoxes();
    setState(() {});
  }

  ///Creates a new note if the isNewNote is true else it updates the existing note
  createItem() {
    setState(() {
      isLoading = true;
    });
    final model = ItemModel(
      itemName: itemNameController.text,
      itemNumber: int.parse(itemNumberController.text),
      boxId: selectedBoxId,
      isFavorite: isFavorite,
      createdTime: DateTime.now(),
    );
    if (isNewItem) {
      database.createItem(model);
    } else {
      model.id = item.id;
      database.updateItem(model);
    }
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: orangeSa,
        content: Text(
          'Objet rajouté !',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  deleteItem() {
    database.deleteItem(item.id!);
    Navigator.pop(context);
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
            visible: !isNewItem,
            child: IconButton(
              color: Colors.red,
              onPressed: deleteItem,
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            color: orangeSa,
            onPressed: createItem,
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
                    controller: itemNameController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: purpleSa,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Désignation',
                      labelStyle: TextStyle(
                        color: blueSa,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: itemNumberController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: purpleSa,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(
                        color: blueSa,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<int>(
                    value: selectedBoxId,
                    hint: const Text(
                      'Sélectionnez un carton',
                      style: TextStyle(color: blueSa),
                    ),
                    items: boxes.map((box) {
                      return DropdownMenuItem<int>(
                        value: box.idBox,
                        child: Text(
                          box.boxNumber,
                          style: const TextStyle(color: purpleSa),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBoxId = value;
                      });
                    },
                  ),
                ]),
        ),
      ),
    );
  }
}
