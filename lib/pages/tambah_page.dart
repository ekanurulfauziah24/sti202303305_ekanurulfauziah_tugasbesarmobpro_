import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TambahPage extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? destinasi;

  TambahPage({
    required this.isEdit,
    required this.destinasi,
    super.key,
  });

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController alamatMapsController = TextEditingController();
  final TextEditingController jamBukaController = TextEditingController();

  File? foto;

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.destinasi != null) {
      namaController.text = widget.destinasi!["nama"] ?? "";
      lokasiController.text = widget.destinasi!["lokasi"] ?? "";
      deskripsiController.text = widget.destinasi!["deskripsi"] ?? "";
      alamatMapsController.text = widget.destinasi!["maps"] ?? "";
      jamBukaController.text = widget.destinasi!["jam"] ?? "";
      if (widget.destinasi!["foto"] != null) {
        foto = File(widget.destinasi!["foto"]);
      }
    }
  }

  Future<void> pilihFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        foto = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Edit Destinasi" : "Tambah Destinasi"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: "Nama Destinasi"),
            ),
            TextField(
              controller: lokasiController,
              decoration: const InputDecoration(labelText: "Lokasi"),
            ),
            TextField(
              controller: deskripsiController,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            TextField(
              controller: alamatMapsController,
              decoration:
              const InputDecoration(labelText: "Alamat Maps (link Google Maps)"),
            ),
            TextField(
              controller: jamBukaController,
              decoration: const InputDecoration(labelText: "Jam Buka"),
            ),

            const SizedBox(height: 20),

            // FOTO
            foto == null
                ? const Text("Belum ada foto")
                : Image.file(
              foto!,
              height: 150,
            ),

            ElevatedButton(
              onPressed: pilihFoto,
              child: const Text("Pilih Foto"),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  "nama": namaController.text,
                  "lokasi": lokasiController.text,
                  "deskripsi": deskripsiController.text,
                  "maps": alamatMapsController.text,
                  "jam": jamBukaController.text,
                  "foto": foto?.path,
                });
              },
              child: Text(widget.isEdit ? "Update" : "Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
