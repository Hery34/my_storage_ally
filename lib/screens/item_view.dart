import 'package:flutter/material.dart';
import 'package:french_date_formatter/french_date_formatter.dart';
import 'package:my_storage_ally/database/app_database.dart.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/models/item_model.dart';
import 'package:my_storage_ally/screens/item_detail_view.dart';

class ItemView extends StatefulWidget {
  const ItemView({super.key});

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  final database = ItemDatabase(AppDatabase.instance);
  final databaseBox = BoxDatabase(AppDatabase.instance);
  List<ItemModel> items = [];

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  ///Gets all the notes from the database and updates the state
  refreshNotes() {
    database.readAllItems().then((value) {
      setState(() {
        items = value;
      });
    });
  }

  goToNoteDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemDetailView(itemId: id)),
    );
    refreshNotes();
  }

   Future<String?> getBoxName(int id) async {
    return await databaseBox.getBoxNameById(id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.pinkAccent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: items.isEmpty
            ? const Text(
                "Vous n'avez aucun objet sauvegardé",
                style: TextStyle(color: Colors.white),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () => goToNoteDetailsView(id: item.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Objet ajouté le : ${FrenchDateFormatter.formatDateFR(item.createdTime.toString())}',
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.itemName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  FutureBuilder<String?>(
                                future: getBoxName(item.boxId ?? 0),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text('Erreur');
                                  } else {
                                    return Text(
                                      snapshot.data ?? 'Aucun carton',
                                      style: Theme.of(context).textTheme.subtitle1,
                                    );
                                  }
                                },
                              ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToNoteDetailsView,
        tooltip: 'Créer un nouvel article',
        child: const Icon(Icons.add),
      ),
    );
  }
}
