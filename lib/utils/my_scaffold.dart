import 'package:flutter/material.dart';
import 'package:my_storage_ally/constants/colors.dart';
import 'package:my_storage_ally/providers/navigation_provider.dart';
import 'package:my_storage_ally/screens/box_view.dart';
import 'package:my_storage_ally/screens/item_view.dart';
import 'package:my_storage_ally/screens/qr_code_generator_page.dart';
import 'package:provider/provider.dart';

class MyScaffold extends StatefulWidget {
  final Widget body;

  const MyScaffold({super.key, required this.body});

  @override
  // ignore: library_private_types_in_public_api
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  final List<String> _titles = [
    'Accueil',
    'Mes objets',
    'Mes cartons',
    'Scanner',
    'QR Code',
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    return Scaffold(
      backgroundColor: graySA,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.webp',
              height: 50,
            ),
            const SizedBox(width: 8),
            Text(
              _titles[navigationProvider.currentIndex],
              style: const TextStyle(fontSize: 30, color: graySA),
            ),
          ],
        ),
        backgroundColor: Colors.grey[700],
      ),
      body: _getViewForCurrentIndex(navigationProvider.currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.currentIndex,
        onTap: (index) {
          navigationProvider.setIndex(index);
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.grey[700],
            icon: const Icon(Icons.home, color: graySA),
            label: 'Accueil',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.storage,
              color: graySA,
            ),
            label: 'Objets',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.inventory_2,
              color: graySA,
            ),
            label: 'Cartons',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner, color: graySA),
            label: 'Scanner',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.qr_code_2,
              color: graySA,
            ),
            label: 'QR Code',
          ),
        ],
        selectedItemColor: graySA,
      ),
    );
  }

  Widget _getViewForCurrentIndex(int index) {
    switch (index) {
      case 0:
        return widget.body;
      case 1:
        return const ItemView();
      case 2:
        return const BoxView();
      case 4:
        return QrCodeGeneratorPage();
      default:
        return widget.body;
    }
  }
}
