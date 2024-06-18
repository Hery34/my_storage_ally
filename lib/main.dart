import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_storage_ally/screens/home_page.dart';

void main() {
  Intl.defaultLocale = 'fr_FR';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
