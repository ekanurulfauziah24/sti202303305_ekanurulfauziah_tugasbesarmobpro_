import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wisata Lokal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Menu Tambah
            ListTile(
              leading: Icon(Icons.add, size: 32),
              title: Text("Tambah Wisata Baru"),
              onTap: () => Navigator.pushNamed(context, "/tambah"),
            ),

            // Menu Maps
            ListTile(
              leading: Icon(Icons.map, size: 32),
              title: Text("Lihat Maps"),
              onTap: () => Navigator.pushNamed(context, "/maps"),
            ),

            // Menu Daftar / Awal
            ListTile(
              leading: Icon(Icons.list, size: 32),
              title: Text("Daftar Wisata"),
              onTap: () {
                // kamu nanti bisa isi list
              },
            ),
          ],
        ),
      ),
    );
  }
}
