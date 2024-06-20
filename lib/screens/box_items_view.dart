import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/item_model.dart';

class BoxItemsView extends StatelessWidget {
  final int boxId;
  final ItemDatabase itemDatabase;

  const BoxItemsView(
      {super.key, required this.boxId, required this.itemDatabase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: graySA,
      appBar: AppBar(
        foregroundColor: blueSa,
        title: const Text(
          'Contenu de votre carton',
          style: TextStyle(color: blueSa),
        ),
      ),
      body: FutureBuilder<List<ItemModel>>(
        future: itemDatabase.readItemsByBoxId(boxId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Ce carton est vide');
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  style: ListTileStyle.list,
                  title: Text(
                    item.itemName,
                    style: const TextStyle(fontSize: 20, color: blueSa),
                  ),
                  subtitle: Text(
                    'Nombre : ${item.itemNumber}',
                    style: const TextStyle(fontSize: 14, color: orangeSa),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
