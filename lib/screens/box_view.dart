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
    return Container(
      decoration: const BoxDecoration(gradient: yellowGradientStally),
      child: ListView(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: () => goToCreateBoxView(),
                  icon: const Icon(Icons.add),
                  label: const Text("Ajouter un Carton"),
                  backgroundColor: brownStally,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          boxes.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Icon(Icons.report_gmailerrorred,
                          size: 100, color: Colors.white),
                      Center(
                        child: Text(
                          "Vous n'avez aucun carton sauvegardé",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
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
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  Colors.yellow.shade200,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Carton ajouté le : ${FrenchDateFormatter.formatDateFR(box.createdTime.toString())}',
                                          style: const TextStyle(
                                            color: blackStally,
                                          ),
                                        ),
                                        Text(
                                          box.boxNumber.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: brownStally,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
