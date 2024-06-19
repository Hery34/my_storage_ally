import 'package:flutter/material.dart';
import 'package:french_date_formatter/french_date_formatter.dart';
import 'package:my_storage_ally/database/app_database.dart.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/database/box_fields.dart';
import 'package:my_storage_ally/models/box_model.dart';
import 'package:my_storage_ally/screens/box_detail_view.dart';

class BoxView extends StatefulWidget {
  const BoxView({super.key});

  @override
  State<BoxView> createState() => _BoxViewState();
}

class _BoxViewState extends State<BoxView> {
  final database = BoxDatabase(AppDatabase.instance);
  List<BoxModel> boxes = [];

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
    database.readAllBoxes().then((value) {
      setState(() {
        boxes = value;
      });
    });
  }

  goToBoxDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BoxDetailView(boxId: id)),
    );
    refreshNotes();
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
        child: boxes.isEmpty
            ? const Text(
                "Vous n'avez aucun carton sauvegardé",
                style: TextStyle(color: Colors.white),
              )
            : ListView.builder(
                itemCount: boxes.length,
                itemBuilder: (context, index) {
                  final box = boxes[index];
                  return GestureDetector(
                    onTap: () => goToBoxDetailsView(id: box.idBox),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Objet ajouté le : ${FrenchDateFormatter.formatDateFR(box.createdTime.toString())}',
                              ),
                              Text(
                                box.boxNumber.toString(),
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
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
        onPressed: goToBoxDetailsView,
        tooltip: 'Créer un nouvel article',
        child: const Icon(Icons.add),
      ),
    );
  }
}
