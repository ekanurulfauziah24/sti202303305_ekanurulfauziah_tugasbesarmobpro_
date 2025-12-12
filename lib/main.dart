import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/tambah_page.dart';
import 'pages/maps_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wisata Lokal",
      debugShowCheckedModeBanner: false,

      // Home tidak pakai const biar aman
      home: HomePage(),

      routes: {
        // Halaman Tambah
        "/tambah": (context) => TambahPage(
          isEdit: false,   // default
          destinasi: null, // default
        ),

        // Halaman Maps
        "/maps": (context) => MapsPage(),
      },
    );
  }
}
