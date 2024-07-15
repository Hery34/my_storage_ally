import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/database/item_database.dart';
import 'package:my_storage_ally/models/box_model.dart';
import 'package:my_storage_ally/screens/box_items_view.dart';
import 'package:my_storage_ally/widgets/edit_box_dialog.dart';

class BoxDetailView extends StatefulWidget {
  const BoxDetailView({super.key, this.boxId});
  final int? boxId;

  @override
  State<BoxDetailView> createState() => _BoxDetailViewState();
}

class _BoxDetailViewState extends State<BoxDetailView> {
  final database = BoxDatabase(AppDatabase.instance);
  final itemDatabase = ItemDatabase(AppDatabase.instance);
  late BoxModel box;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshBoxes();
  }

  refreshBoxes() async {
    if (widget.boxId != null) {
      box = (await database.readBox(widget.boxId!));
      setState(() {
        isLoading = false;
      });
    }
  }

  void showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => EditBoxDialog(box: box, onBoxUpdated: refreshBoxes),
    );
  }

  goToBoxContentView(int? boxId) async {
    if (boxId == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BoxItemsView(
          boxId: boxId,
          itemDatabase: itemDatabase,
        ),
      ),
    );
    refreshBoxes();
  }

  void deleteBox() {
    database.deleteBox(box.idBox!);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: orangeSa,
        content: Text(
          'Carton supprimé !',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer le carton'),
        content: const Text(
            "Cette action est irréversible. Si vous souhaitez continuer, assurez-vous d'avoir transféré vos objets, sinon ils se retrouveront sans carton"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteBox();
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: brownStally,
      appBar: AppBar(
        title: const Text('Détails'),
        foregroundColor: blackStally,
        backgroundColor: brownStally,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              confirmDelete();
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
        decoration: const BoxDecoration(
          gradient: yellowGradientStally,
        ),
        child: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text('Référence',
                                  style: TextStyle(color: blackStally)),
                              subtitle: Text(box.boxNumber,
                                  style: const TextStyle(
                                      color: coffeeStally, fontSize: 20)),
                            ),
                            ListTile(
                              title: const Text('Description',
                                  style: TextStyle(color: blackStally)),
                              subtitle: Text(box.boxDescription,
                                  style: const TextStyle(
                                      color: coffeeStally, fontSize: 20)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () => goToBoxContentView(widget.boxId),
                          child: const Text("Voir le contenu du carton"))
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
