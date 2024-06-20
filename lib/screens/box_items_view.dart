import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: const Text('Items in Box'),
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
                  title: Text(item.itemName),
                  subtitle: Text('Nombre : ${item.itemNumber}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
