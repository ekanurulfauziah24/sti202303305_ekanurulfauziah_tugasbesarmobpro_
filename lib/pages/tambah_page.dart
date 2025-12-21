import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../database/db_helper.dart';
import 'select_map_page.dart';

class TambahPage extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? destinasi;

  const TambahPage({
    super.key,
    required this.isEdit,
    this.destinasi,
  });

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController jamBukaController = TextEditingController();

  File? foto;
  LatLng? lokasiTerpilih;

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.destinasi != null) {
      namaController.text = widget.destinasi!['nama'] ?? '';
      lokasiController.text = widget.destinasi!['lokasi'] ?? '';
      deskripsiController.text = widget.destinasi!['deskripsi'] ?? '';
      jamBukaController.text = widget.destinasi!['jamBuka'] ?? '';

      if (widget.destinasi!['fotoPath'] != null) {
        foto = File(widget.destinasi!['fotoPath']);
      }

      if (widget.destinasi!['latitude'] != null &&
          widget.destinasi!['longitude'] != null) {
        lokasiTerpilih = LatLng(
          widget.destinasi!['latitude'],
          widget.destinasi!['longitude'],
        );
      }
    }
  }

  Future<void> pilihFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => foto = File(picked.path));
    }
  }

  Future<void> simpanData() async {
    if (namaController.text.isEmpty ||
        lokasiTerpilih == null ||
        jamBukaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Nama, lokasi, dan jam buka wajib diisi"),
        ),
      );
      return;
    }

    final data = {
      'nama': namaController.text,
      'lokasi': lokasiController.text,
      'deskripsi': deskripsiController.text,
      'jamBuka': jamBukaController.text,
      'fotoPath': foto?.path,
      'latitude': lokasiTerpilih!.latitude,
      'longitude': lokasiTerpilih!.longitude,
    };

    if (widget.isEdit && widget.destinasi != null) {
      await DBHelper.instance.updateWisata(widget.destinasi!['id'], data);
    } else {
      await DBHelper.instance.insertWisata(data);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Destinasi" : "Tambah Destinasi"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HEADER =================
            Text(
              widget.isEdit
                  ? "Edit Destinasi Wisata"
                  : "Tambah Destinasi Wisata",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Lengkapi informasi destinasi wisata lokal",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // ================= kontribusi afit =================
            _sectionCard(
              title: "Informasi Destinasi",
              icon: Icons.info,
              child: Column(
                children: [
                  _inputField(
                    controller: namaController,
                    label: "Nama Destinasi",
                    icon: Icons.place,
                  ),
                  _inputField(
                    controller: deskripsiController,
                    label: "Deskripsi",
                    icon: Icons.description,
                  ),
                  _inputField(
                    controller: jamBukaController,
                    label: "Jam Buka",
                    icon: Icons.access_time,
                    readOnly: true,
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (picked != null) {
                        setState(() {
                          jamBukaController.text =
                              "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ================= LOKASI =================
            _sectionCard(
              title: "Lokasi Destinasi",
              icon: Icons.map,
              child: _inputField(
                controller: lokasiController,
                label: "Klik untuk memilih lokasi di Maps",
                icon: Icons.location_on,
                readOnly: true,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SelectMapPage(),
                    ),
                  );

                  if (result != null && result is LatLng) {
                    setState(() {
                      lokasiTerpilih = result;
                      lokasiController.text =
                          "Lat: ${result.latitude}, Lng: ${result.longitude}";
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 16),

            // ================= FOTO =================
            _sectionCard(
              title: "Foto Destinasi",
              icon: Icons.camera_alt,
              child: GestureDetector(
                onTap: pilihFoto,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: foto != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            foto!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 40),
                            SizedBox(height: 6),
                            Text("Tambah Foto"),
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ================= SIMPAN =================
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(
                  widget.isEdit ? "Update Destinasi" : "Simpan Destinasi",
                  style: const TextStyle(fontSize: 16),
                ),
                onPressed: simpanData,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= WIDGET BANTU =================
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
