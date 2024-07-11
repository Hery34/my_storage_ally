import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/models/box_model.dart';

class EditBoxDialog extends StatefulWidget {
  final BoxModel box;
  final Function onBoxUpdated;

  const EditBoxDialog(
      {super.key, required this.box, required this.onBoxUpdated});

  @override
  EditBoxDialogState createState() => EditBoxDialogState();
}

class EditBoxDialogState extends State<EditBoxDialog> {
  final database = BoxDatabase(AppDatabase.instance);
  late TextEditingController boxNameController;
  late TextEditingController boxDescriptionController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    boxNameController = TextEditingController(text: widget.box.boxNumber);
    boxDescriptionController =
        TextEditingController(text: widget.box.boxDescription);
  }

  updateBox() async {
    setState(() {
      isLoading = true;
    });
    final updatedItem = BoxModel(
      idBox: widget.box.idBox,
      boxNumber: boxNameController.text,
      boxDescription: boxDescriptionController.text,
      isFavorite: widget.box.isFavorite,
      createdTime: widget.box.createdTime,
    );
    await database.updateBox(updatedItem);
    setState(() {
      isLoading = false;
    });
    widget.onBoxUpdated();
    if (mounted) Navigator.of(context).pop();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: orangeSa,
          content: Text(
            'Objet mis à jour !',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
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
                    controller: boxNameController,
                    maxLength: 8,
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
                  TextField(
                    controller: boxDescriptionController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: purpleSa,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        color: blueSa,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
          onPressed: updateBox,
          child: const Text('Sauvegarder', style: TextStyle(color: blueSa)),
        ),
      ],
    );
  }
}
