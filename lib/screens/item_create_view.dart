import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
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
  File? _imageFile;

  @override
  void initState() {
    refreshItems();
    fetchBoxes();
    super.initState();
  }

  refreshItems() {
    if (widget.itemId == null) {
      setState(() {
        isNewItem = true;
      });
      return;
    }
    database.readItem(widget.itemId!).then((value) {
      setState(() {
        if (value != null) {
          item = value;
          itemNameController.text = item.itemName;
          itemNumberController.text = item.itemNumber.toString();
          selectedBoxId = item.boxId;
          isFavorite = item.isFavorite;
          if (item.imagePath != null) {
            _imageFile = File(item.imagePath!);
          }
        }
      });
    });
  }

  Future<void> fetchBoxes() async {
    boxes = await boxDatabase.readAllBoxes();
    setState(() {});
  }

  Future<void> pickImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final name = basename(pickedFile.path);
      final imagePath = join(directory.path, name);
      final imageFile = File(pickedFile.path);
      final newImage = await imageFile.copy(imagePath);

      setState(() {
        _imageFile = newImage;
      });
    }
  }

  createItem(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    final model = ItemModel(
      itemName: itemNameController.text,
      itemNumber: int.parse(itemNumberController.text),
      boxId: selectedBoxId,
      isFavorite: isFavorite,
      createdTime: DateTime.now(),
      imagePath: _imageFile?.path,
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

  deleteItem(BuildContext context) {
    if (!isNewItem && item.id != null) {
      database.deleteItem(item.id!);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.blue[800],
        backgroundColor: Colors.white,
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
              onPressed: () {
                deleteItem(context);
              },
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            color: orangeSa,
            onPressed: () {
              createItem(context);
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
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
                    const SizedBox(height: 20),
                    _imageFile == null
                        ? const Text(
                            'Aucune image sélectionnée.',
                            style: TextStyle(color: blueSa),
                          )
                        : ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.4,
                            ),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.contain,
                            ),
                          ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blueSa,
                          ),
                          onPressed: pickImageFromCamera,
                          child: const Text(
                            'Prendre une photo',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
