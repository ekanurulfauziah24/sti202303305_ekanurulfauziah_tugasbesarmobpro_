import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/destinasi.dart';

class DetailPage extends StatelessWidget {
  final Destinasi destinasi;
  final bool isEdit;

  const DetailPage({super.key, required this.destinasi, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destinasi.nama),
        actions: isEdit
            ? [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // jika mau implement edit -> navigasi ke halaman edit
            },
          )
        ]
            : null,
      ),
      body: ListView(
        children: [
          if (destinasi.fotoPath != null)
            Image.file(
              File(destinasi.fotoPath!),
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(destinasi.nama, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(destinasi.lokasi),
                const SizedBox(height: 12),
                if (destinasi.deskripsi != null) Text(destinasi.deskripsi!),
                const SizedBox(height: 12),
                if (destinasi.latitude != null && destinasi.longitude != null)
                  SizedBox(
                    height: 300,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(destinasi.latitude!, destinasi.longitude!),
                        zoom: 15,
                      ),
                      markers: {
                        Marker(markerId: const MarkerId('lok'), position: LatLng(destinasi.latitude!, destinasi.longitude!))
                      },
                      zoomControlsEnabled: false,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
