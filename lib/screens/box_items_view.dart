import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/item_model.dart';
import 'package:my_storage_ally/screens/item_detail_view.dart';

class BoxItemsView extends StatelessWidget {
  final int boxId;
  final ItemDatabase itemDatabase;

  const BoxItemsView(
      {super.key, required this.boxId, required this.itemDatabase});

  @override
  Widget build(BuildContext context) {
    goToItemDetailView({int? id}) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ItemDetailView(itemId: id)),
      );
    }

    return Scaffold(
      backgroundColor: brownStally,
      appBar: AppBar(
        foregroundColor: blackStally,
        backgroundColor: brownStally,
        title: const Text(
          'Contenu du carton',
          style: TextStyle(color: Color.fromARGB(255, 54, 2, 2)),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: yellowGradientStally),
        child: FutureBuilder<List<ItemModel>>(
          future: itemDatabase.readItemsByBoxId(boxId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Icon(Icons.report_gmailerrorred,
                        size: 100, color: Colors.white),
                    Center(
                      child: Text(
                        "Ce carton est vide",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final items = snapshot.data!;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => goToItemDetailView(id: item.id),
                      child: Card(
                        child: ListTile(
                          style: ListTileStyle.list,
                          leading: item.imagePath != null &&
                                  item.imagePath!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    File(item.imagePath!),
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Icon(
                                  Icons.image,
                                  color: Colors.yellow.shade200,
                                  size: 50,
                                ),
                          title: Text(
                            item.itemName,
                            style: const TextStyle(
                                fontSize: 20, color: blackStally),
                          ),
                          subtitle: Text(
                            'Nombre : ${item.itemNumber}',
                            style: const TextStyle(
                                fontSize: 14, color: brownStally),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  goToItemDetailView({int? id}) {}
}
