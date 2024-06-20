import 'package:flutter/material.dart';
import 'package:my_storage_ally/providers/navigation_provider.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/utils/my_scaffold.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);
    final buttons = [
      {
        'icon': Icons.storage,
        'label': 'Mes objets',
        'color': purpleSa,
        'index': 1,
      },
      {
        'icon': Icons.inventory_2,
        'label': 'Mes cartons',
        'color': orangeSa,
        'index': 2,
      },
      {
        'icon': Icons.search,
        'label': 'Rechercher',
        'color': Colors.orangeAccent,
        'index': 3,
      },
      {
        'icon': Icons.qr_code,
        'label': 'Générer un code QR',
        'color': Colors.redAccent,
        'index': 4,
      },
    ];

    return MyScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.6,
          ),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: buttons.map((button) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16.0),
                  backgroundColor: button['color'] as Color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onPressed: () {
                  navigationProvider.setIndex(button['index'] as int);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      button['icon'] as IconData,
                      size: 48.0,
                      color: Colors.white,
                    ),
                    Text(
                      button['label'] as String,
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
