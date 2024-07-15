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
        'color': blackStally,
        'index': 1,
      },
      {
        'icon': Icons.inventory_2,
        'label': 'Mes cartons',
        'color': coffeeStally,
        'index': 2,
      },
      {
        'icon': Icons.qr_code_scanner,
        'label': 'Scanner un Qr code',
        'color': whiteStally,
        'index': 3,
      },
      {
        'icon': Icons.qr_code_2,
        'label': 'Générer des Qr code',
        'color': brownStally,
        'index': 4,
      },
    ];

    return MyScaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: yellowGradientStally,
        ),
        child: Center(
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
                return InkWell(
                  onTap: () {
                    navigationProvider.setIndex(button['index'] as int);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          button['color'] as Color,
                          const Color.fromARGB(221, 93, 83, 2)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 10.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          button['icon'] as IconData,
                          size: 48.0,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          button['label'] as String,
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
