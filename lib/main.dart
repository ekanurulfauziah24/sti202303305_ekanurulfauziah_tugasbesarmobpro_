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
      title: "Wisata Kota Purbalingga",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,  // Hijau untuk alam
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green,
          secondary: Colors.blue,  // Biru untuk langit/balon
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue,
        ),
      ),

      // Home tidak pakai const biar aman
      home: const HomePage(),

      routes: {
        // Halaman Tambah
        "/tambah": (context) => const TambahPage(
          isEdit: false,   // default
          destinasi: null, // default
        ),

        // Halaman Maps
        "/maps": (context) => const MapsPage(),
      },
    );
  }
}
