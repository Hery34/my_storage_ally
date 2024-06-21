import 'package:flutter/material.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/item_model.dart';
import 'package:my_storage_ally/screens/item_detail_view.dart';

class SearchItemDialog extends StatefulWidget {
  final ItemDatabase database;
  const SearchItemDialog({super.key, required this.database});

  @override
  SearchItemDialogState createState() => SearchItemDialogState();
}

class SearchItemDialogState extends State<SearchItemDialog> {
  TextEditingController searchController = TextEditingController();
  List<ItemModel> searchResults = [];
  bool isLoading = false;

  void searchItems(String query) async {
    setState(() {
      isLoading = true;
    });
    final results = await widget.database.searchItems(query);
    setState(() {
      searchResults = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher des objets',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  searchItems(searchController.text);
                },
              ),
            ),
            onSubmitted: (query) {
              searchItems(query);
            },
          ),
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final item = searchResults[index];
                    return ListTile(
                      title: Text(item.itemName),
                      subtitle: Text(
                          'Nombre: ${item.itemNumber}, Carton: ${item.boxId}'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ItemDetailView(itemId: item.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
      ],
    );
  }
}
