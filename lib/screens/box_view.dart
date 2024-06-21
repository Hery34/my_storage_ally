import 'package:flutter/material.dart';
import 'package:french_date_formatter/french_date_formatter.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/database/app_database.dart';
import 'package:my_storage_ally/database/box_database.dart';
import 'package:my_storage_ally/models/box_model.dart';
import 'package:my_storage_ally/screens/box_create_view.dart';
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

  goToCreateBoxView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BoxCreateView(boxId: id)),
    );
    refreshNotes();
  }

  goToBoxDetailView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BoxDetailView(boxId: id)),
    );
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 50,
              ),
              FloatingActionButton.extended(
                onPressed: () => goToCreateBoxView(),
                icon: const Icon(Icons.add),
                label: const Text("Ajouter un Carton"),
                backgroundColor: orangeSa,
              ),
              const SizedBox(
                width: 50,
              ),
            ],
          ),
        ),
        boxes.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Vous n'avez aucun carton sauvegardé",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: boxes.length,
                itemBuilder: (context, index) {
                  final box = boxes[index];
                  return GestureDetector(
                    onTap: () => goToBoxDetailView(id: box.idBox),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Carton ajouté le : ${FrenchDateFormatter.formatDateFR(box.createdTime.toString())}',
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
      ],
    );
  }
}
