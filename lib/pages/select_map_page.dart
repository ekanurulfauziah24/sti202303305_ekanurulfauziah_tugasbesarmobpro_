import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class SelectMapPage extends StatefulWidget {
  const SelectMapPage({super.key});

  @override
  State<SelectMapPage> createState() => _SelectMapPageState();
}

class _SelectMapPageState extends State<SelectMapPage> {
  LatLng? selectedLocation;
  Marker? marker;
  final TextEditingController searchController = TextEditingController();
  GoogleMapController? _mapController;

  Future<void> cariLokasi(String query) async {
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng latLng = LatLng(location.latitude, location.longitude);

        setState(() {
          selectedLocation = latLng;
          marker = Marker(
            markerId: const MarkerId("lokasi"),
            position: latLng,
          );
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 15),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lokasi tidak ditemukan")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error mencari lokasi")),
      );
    }
  }

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Cari lokasi (alamat, tempat)...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: cariLokasi,
            ),
          ),
          Expanded(
            child: GoogleMap(
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
              onMapCreated: (controller) => _mapController = controller,
            ),
          ),
        ],
      ),
    );
  }
}
