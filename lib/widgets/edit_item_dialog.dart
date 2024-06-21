import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/item_model.dart';

class EditItemDialog extends StatefulWidget {
  final ItemModel item;
  final Function onItemUpdated;

  const EditItemDialog(
      {super.key, required this.item, required this.onItemUpdated});

  @override
  EditItemDialogState createState() => EditItemDialogState();
}

class EditItemDialogState extends State<EditItemDialog> {
  final database = ItemDatabase(AppDatabase.instance);
  late TextEditingController itemNameController;
  late TextEditingController itemNumberController;
  late TextEditingController boxController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController(text: widget.item.itemName);
    itemNumberController =
        TextEditingController(text: widget.item.itemNumber.toString());
    boxController = TextEditingController(text: widget.item.boxId.toString());
  }

  updateItem() async {
    setState(() {
      isLoading = true;
    });
    final updatedItem = ItemModel(
      id: widget.item.id,
      itemName: itemNameController.text,
      itemNumber: int.parse(itemNumberController.text),
      boxId: int.parse(boxController.text),
      isFavorite: widget.item.isFavorite,
      createdTime: widget.item.createdTime,
    );
    await database.updateItem(updatedItem);
    setState(() {
      isLoading = false;
    });
    widget.onItemUpdated();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Objet mis à jour !',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier l\'objet'),
      content: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                    maxLength: 8,
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
                    maxLength: 8,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: purpleSa,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Référence carton',
                      labelStyle: TextStyle(
                        color: blueSa,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          child: const Text('Annuler', style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          onPressed: updateItem,
          child: const Text('Sauvegarder', style: TextStyle(color: blueSa)),
        ),
      ],
    );
  }
}
