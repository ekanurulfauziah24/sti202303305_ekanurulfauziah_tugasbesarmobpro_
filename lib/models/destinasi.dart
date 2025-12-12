class Destinasi {
  int? id;
  String nama;
  String lokasi;
  String? deskripsi;
  String? fotoPath;
  String? jamBuka;
  double? latitude;
  double? longitude;

  Destinasi({
    this.id,
    required this.nama,
    required this.lokasi,
    this.deskripsi,
    this.fotoPath,
    this.jamBuka,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'lokasi': lokasi,
      'deskripsi': deskripsi,
      'fotoPath': fotoPath,
      'jamBuka': jamBuka,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Destinasi.fromMap(Map<String, dynamic> m) {
    return Destinasi(
      id: m['id'] as int?,
      nama: m['nama'] as String,
      lokasi: m['lokasi'] as String,
      deskripsi: m['deskripsi'] as String?,
      fotoPath: m['fotoPath'] as String?,
      jamBuka: m['jamBuka'] as String?,
      latitude: m['latitude'] == null ? null : (m['latitude'] as num).toDouble(),
      longitude: m['longitude'] == null ? null : (m['longitude'] as num).toDouble(),
    );
  }
}
