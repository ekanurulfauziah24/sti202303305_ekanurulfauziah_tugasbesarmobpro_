import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectMapPage extends StatefulWidget {
  const SelectMapPage({super.key});

  @override
  State<SelectMapPage> createState() => _SelectMapPageState();
}

class _SelectMapPageState extends State<SelectMapPage> {
  LatLng? selectedLocation;
  Marker? marker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Lokasi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: selectedLocation == null
                ? null
                : () => Navigator.pop(context, selectedLocation),
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-6.200000, 106.816666),
          zoom: 10,
        ),
        onTap: (latLng) {
          setState(() {
            selectedLocation = latLng;
            marker = Marker(
              markerId: const MarkerId("lokasi"),
              position: latLng,
            );
          });
        },
        markers: marker != null ? {marker!} : {},
      ),
    );
  }
}
