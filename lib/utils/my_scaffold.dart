import 'package:flutter/material.dart';
import 'package:my_storage_ally/providers/navigation_provider.dart';
import 'package:my_storage_ally/screens/box_view.dart';
import 'package:my_storage_ally/screens/item_view.dart';
import 'package:my_storage_ally/screens/qr_code_generator_page.dart';
import 'package:my_storage_ally/screens/qr_scanner_view.dart';
import 'package:provider/provider.dart';
import 'package:my_storage_ally/constants/colors.dart';

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
      extendBodyBehindAppBar: true,
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
              style: const TextStyle(
                  fontSize: 30, color: Color.fromARGB(255, 54, 2, 2)),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: yellowGradientStally,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: yellowGradientStally,
        ),
        child: _getViewForCurrentIndex(navigationProvider.currentIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: yellowGradientStally,
        ),
        child: BottomNavigationBar(
          currentIndex: navigationProvider.currentIndex,
          onTap: (index) {
            navigationProvider.setIndex(index);
          },
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.home, color: Colors.white),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.storage,
                color: Colors.white,
              ),
              label: 'Objets',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.inventory_2,
                color: Colors.white,
              ),
              label: 'Cartons',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner, color: Colors.white),
              label: 'Scanner',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code_2,
                color: Colors.white,
              ),
              label: 'QR Code',
            ),
          ],
          selectedItemColor: Colors.yellowAccent,
          unselectedItemColor: Colors.white,
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
        ),
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
      case 3:
        // Ajouter la page de scanner ici
        return const QRScannerView(); // Remplacer par la page de scanner
      case 4:
        return QrCodeGeneratorPage();
      default:
        return widget.body;
    }
  }
}
