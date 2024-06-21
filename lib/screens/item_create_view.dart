import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/item_model.dart';

class ItemCreateView extends StatefulWidget {
  const ItemCreateView({super.key, this.itemId});
  final int? itemId;

  @override
  State<ItemCreateView> createState() => _ItemCreateViewState();
}

class _ItemCreateViewState extends State<ItemCreateView> {
  final database = ItemDatabase(AppDatabase.instance);

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemNumberController = TextEditingController();
  TextEditingController boxController = TextEditingController();

  late ItemModel item;
  bool isLoading = false;
  bool isNewItem = false;
  bool isFavorite = false;

  @override
  void initState() {
    refreshItems();
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
        boxController.text = item.boxId.toString();
        isFavorite = item.isFavorite;
      });
    });
  }

  ///Creates a new note if the isNewNote is true else it updates the existing note
  createItem() {
    setState(() {
      isLoading = true;
    });
    final model = ItemModel(
      itemName: itemNameController.text,
      itemNumber: int.parse(itemNumberController.text),
      boxId: int.parse(boxController.text),
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
                  TextField(
                    controller: boxController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: purpleSa,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Carton n°',
                      labelStyle: TextStyle(
                        color: blueSa,
                      ),
                    ),
                  ),
                ]),
        ),
      ),
    );
  }
}
