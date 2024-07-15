import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/box_model.dart';
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
  final boxDatabase = BoxDatabase(AppDatabase.instance);

  late TextEditingController itemNameController;
  late TextEditingController itemNumberController;
  int? selectedBoxId;
  bool isLoading = false;
  List<BoxModel> boxes = [];
  File? _image;

  @override
  void initState() {
    super.initState();
    itemNameController = TextEditingController(text: widget.item.itemName);
    itemNumberController =
        TextEditingController(text: widget.item.itemNumber.toString());
    selectedBoxId = widget.item.boxId;
    _image =
        widget.item.imagePath != null ? File(widget.item.imagePath!) : null;
    fetchBoxes();
  }

  Future<void> fetchBoxes() async {
    boxes = await boxDatabase.readAllBoxes();
    setState(() {});
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choisissez la source de l\'image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Appareil photo'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: const Text('Galerie'),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  updateItem() async {
    setState(() {
      isLoading = true;
    });
    final updatedItem = ItemModel(
      id: widget.item.id,
      itemName: itemNameController.text,
      itemNumber: int.parse(itemNumberController.text),
      boxId: selectedBoxId,
      isFavorite: widget.item.isFavorite,
      createdTime: widget.item.createdTime,
      imagePath: _image?.path,
    );
    await database.updateItem(updatedItem);
    setState(() {
      isLoading = false;
    });
    widget.onItemUpdated();
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
                    controller: itemNameController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: brownStally,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Désignation',
                      labelStyle: TextStyle(
                        color: blackStally,
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
                      color: brownStally,
                      fontSize: 20,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(
                        color: blackStally,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<int>(
                    value: selectedBoxId,
                    hint: const Text(
                      'Sélectionnez un carton',
                      style: TextStyle(color: blackStally),
                    ),
                    items: boxes.map((box) {
                      return DropdownMenuItem<int>(
                        value: box.idBox,
                        child: Text(
                          box.boxNumber.toString(),
                          style: const TextStyle(color: brownStally),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBoxId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _image != null
                      ? Image.file(
                          _image!,
                          height: 200,
                        )
                      : const Text(
                          'Aucune image sélectionnée.',
                          style: TextStyle(color: blackStally),
                        ),
                  TextButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(Icons.image, color: brownStally),
                    label: const Text('Ajouter/Modifier la photo',
                        style: TextStyle(color: blackStally)),
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
          child:
              const Text('Sauvegarder', style: TextStyle(color: blackStally)),
        ),
      ],
    );
  }
}
