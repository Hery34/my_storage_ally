import 'package:flutter/material.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/item_model.dart';
import 'package:my_storage_ally/screens/item_view.dart';

class ItemDetailView extends StatefulWidget {
  const ItemDetailView({super.key, this.itemId});
  final int? itemId;

  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  ItemDatabase database = ItemDatabase.instance;

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
    database.read(widget.itemId!).then((value) {
      setState(() {
        item = value;
        itemNameController.text = item.itemName;
        itemNumberController.text = item.itemNumber.toString();
        boxController.text = item.boxNumber.toString();
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
      boxNumber: int.parse(boxController.text),
      isFavorite: isFavorite,
      createdTime: DateTime.now(),
    );
    if (isNewItem) {
      database.create(model);
    } else {
      model.id = item.id;
      database.update(model);
    }
    setState(() {
      isLoading = false;
    });
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => const ItemView()));
  }

  ///Deletes the note from the database and navigates back to the previous screen
  deleteItem() {
    database.delete(item.id!);
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
            visible: !isNewItem,
            child: IconButton(
              color: Colors.red,
              onPressed: deleteItem,
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            color: Colors.white,
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
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Désignation',
                      labelStyle: TextStyle(
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: itemNumberController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: boxController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Carton n°',
                      labelStyle: TextStyle(
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                ]),
        ),
      ),
    );
  }
}
