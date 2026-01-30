class MasjidProfile {
  final String nama;
  final String deskripsi;
  final String alamat;
  final String? fotoUrl;
  final String mapsUrl;
  final String? fotoAssetPath;

  MasjidProfile({
    required this.nama,
    required this.deskripsi,
    required this.alamat,
    this.fotoUrl,
    required this.mapsUrl,
    this.fotoAssetPath = 'assets/images/masjid.jpg',
  });

  factory MasjidProfile.fromJson(Map<String, dynamic> json) {
    return MasjidProfile(
      nama: json['nama'] as String? ?? 'Masjid Jami Baitul Anshor',
      deskripsi: json['deskripsi'] as String? ?? 'Sistem Informasi Manajemen Aset Masjid',
      alamat: json['alamat'] as String? ?? 'Jl. Gading Tutuka 2, Jakarta',
      fotoUrl: json['fotoUrl'] as String?,
      mapsUrl: json['mapsUrl'] as String? ?? 'https://maps.app.goo.gl/7gKdnbmiUNkNBdh18',
      fotoAssetPath: json['fotoAssetPath'] as String? ?? 'assets/images/masjid.jpg',
    );
  }

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'deskripsi': deskripsi,
    'alamat': alamat,
    'fotoUrl': fotoUrl,
    'mapsUrl': mapsUrl,
    'fotoAssetPath': fotoAssetPath,
  };

  MasjidProfile copyWith({
    String? nama,
    String? deskripsi,
    String? alamat,
    String? fotoUrl,
    String? mapsUrl,
    String? fotoAssetPath,
  }) {
    return MasjidProfile(
      nama: nama ?? this.nama,
      deskripsi: deskripsi ?? this.deskripsi,
      alamat: alamat ?? this.alamat,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      mapsUrl: mapsUrl ?? this.mapsUrl,
      fotoAssetPath: fotoAssetPath ?? this.fotoAssetPath,
    );
  }
}
