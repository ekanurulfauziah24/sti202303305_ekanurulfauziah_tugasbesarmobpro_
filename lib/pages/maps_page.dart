import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_wisata_lokal/database/db_helper.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController? _controller;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    loadMarkers();
  }

  Future<void> loadMarkers() async {
    final data = await DBHelper.instance.getAllWisata();

    Set<Marker> temp = {};

    for (var item in data) {
      temp.add(
        Marker(
          markerId: MarkerId(item['id'].toString()),
          position: LatLng(item['lat'], item['lng']),
          infoWindow: InfoWindow(
            title: item['nama'],
            snippet: item['deskripsi'],
          ),
        ),
      );
    }

    setState(() {
      markers = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Peta Wisata")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-6.200000, 106.816666),
          zoom: 10,
        ),
        markers: markers,
        onMapCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}
