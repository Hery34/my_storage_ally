import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/item_model.dart';
import 'package:my_storage_ally/widgets/edit_item_dialog.dart';

class ItemDetailView extends StatefulWidget {
  const ItemDetailView({super.key, this.itemId});
  final int? itemId;

  @override
  State<ItemDetailView> createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  final database = ItemDatabase(AppDatabase.instance);
  final databaseBox = BoxDatabase(AppDatabase.instance);
  late ItemModel item;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshItems();
  }

  refreshItems() async {
    if (widget.itemId != null) {
      item = (await database.readItem(widget.itemId ?? 0))!;
      setState(() {
        isLoading = false;
      });
    }
  }

  void showEditDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          EditItemDialog(item: item, onItemUpdated: refreshItems),
    );
  }

  void deleteItem() {
    database.deleteItem(item.id!);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Objet supprimé !',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: graySA,
      appBar: AppBar(
        title: const Text('Détails'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              deleteItem();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              showEditDialog();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.blue.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: const Text('Désignation',
                                    style: TextStyle(color: blueSa)),
                                subtitle: Text(item.itemName,
                                    style: TextStyle(
                                        color: Colors.blue[800], fontSize: 20)),
                              ),
                              ListTile(
                                title: const Text('Nombre',
                                    style: TextStyle(color: blueSa)),
                                subtitle: Text(item.itemNumber.toString(),
                                    style: TextStyle(
                                        color: Colors.blue[800], fontSize: 20)),
                              ),
                              ListTile(
                                title: const Text('Carton n°',
                                    style: TextStyle(color: blueSa)),
                                subtitle: Text(item.boxId.toString(),
                                    style: TextStyle(
                                        color: Colors.blue[800], fontSize: 20)),
                              ),
                              if (item.imagePath != null &&
                                  item.imagePath!.isNotEmpty)
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.blue.shade800),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Image.file(
                                    File(item.imagePath!),
                                    height: 200,
                                    width: 200,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
