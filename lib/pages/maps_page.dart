import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../database/db_helper.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? _controller;
  Set<Marker> markers = {};
  final TextEditingController searchController = TextEditingController();

  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(-6.200000, 106.816666),
    zoom: 10,
  );

  @override
  void initState() {
    super.initState();
    loadMarkers();
  }

  Future<void> loadMarkers() async {
    final data = await DBHelper.instance.getAllWisata();

    final temp = data.map((item) {
      return Marker(
        markerId: MarkerId(item['id'].toString()),
        position: LatLng(item['latitude'], item['longitude']),
        infoWindow: InfoWindow(
          title: item['nama'],
          snippet: item['lokasi'],
        ),
      );
    }).toSet();

    setState(() => markers = temp);
  }

  void cariLokasi(String keyword) async {
    final data = await DBHelper.instance.getAllWisata();

    try {
      final hasil = data.firstWhere(
            (e) => e['nama']
            .toString()
            .toLowerCase()
            .contains(keyword.toLowerCase()),
      );

      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(hasil['latitude'], hasil['longitude']),
          15,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Destinasi tidak ditemukan")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Peta Wisata")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Cari destinasi wisata...",
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
              initialCameraPosition: _initialPosition,
              markers: markers,
              onMapCreated: (c) => _controller = c,
            ),
          ),
        ],
      ),
    );
  }
}
