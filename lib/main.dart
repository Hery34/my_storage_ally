import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_storage_ally/providers/navigation_provider.dart';
import 'package:my_storage_ally/screens/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  Intl.defaultLocale = 'fr_FR';
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigationProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
