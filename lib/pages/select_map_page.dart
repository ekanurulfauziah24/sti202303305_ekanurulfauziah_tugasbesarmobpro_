import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectMapPage extends StatefulWidget {
  const SelectMapPage({super.key});

  @override
  State<SelectMapPage> createState() => _SelectMapPageState();
}

class _SelectMapPageState extends State<SelectMapPage> {
  LatLng? selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Lokasi')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-6.200000, 106.816666),
          zoom: 12,
        ),
        onTap: (pos) {
          setState(() => selected = pos);
        },
        markers: selected == null
            ? {}
            : {
          Marker(markerId: const MarkerId('sel'), position: selected!),
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: selected == null
            ? null
            : () {
          Navigator.of(context).pop({'lat': selected!.latitude, 'lng': selected!.longitude});
        },
        icon: const Icon(Icons.check),
        label: const Text('Pilih Lokasi'),
      ),
    );
  }
}
