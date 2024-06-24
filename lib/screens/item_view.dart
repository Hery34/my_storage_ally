import 'package:flutter/material.dart';
import 'package:french_date_formatter/french_date_formatter.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/models/item_model.dart';
import 'package:my_storage_ally/screens/item_detail_view.dart';
import 'package:my_storage_ally/screens/item_create_view.dart';
import 'package:my_storage_ally/widgets/search_item_dialog.dart';

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

  void showSearchDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SearchItemDialog(database: database),
    );
  }

  goToCreateItemView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ItemCreateView(itemId: id)),
    );
    refreshNotes();
  }

  goToItemDetailView({int? id}) async {
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
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton.extended(
                onPressed: () => goToCreateItemView(),
                icon: const Icon(Icons.add),
                label: const Text("Ajouter            "),
                backgroundColor: orangeSa,
              ),
              FloatingActionButton.extended(
                onPressed: () => showSearchDialog(),
                icon: const Icon(Icons.search),
                label: const Text("Rechercher"),
                backgroundColor: orangeSa,
              ),
            ],
          ),
        ),
        items.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Vous n'avez aucun objet sauvegardé",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () => goToItemDetailView(id: item.id),
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
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      item.itemName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                  ),
                                  FutureBuilder<String?>(
                                    future: getBoxName(item.boxId ?? 0),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return const Text('Erreur');
                                      } else {
                                        return Text(
                                          snapshot.data ?? 'Aucun carton',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
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
                },
              ),
      ],
    );
  }
}
