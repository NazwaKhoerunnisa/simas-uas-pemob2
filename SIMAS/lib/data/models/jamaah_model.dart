class Jamaah {
  final String id;
  final String nama;
  final String noHp;
  final String alamat;
  final String status; // aktif, nonaktif
  final DateTime terdaftar;
  final String? fotoProfil;

  Jamaah({
    required this.id,
    required this.nama,
    required this.noHp,
    required this.alamat,
    required this.status,
    required this.terdaftar,
    this.fotoProfil,
  });

  factory Jamaah.fromJson(Map<String, dynamic> json) {
    return Jamaah(
      id: json['id'] as String? ?? '',
      nama: json['nama'] as String? ?? '',
      noHp: json['noHp'] as String? ?? '',
      alamat: json['alamat'] as String? ?? '',
      status: json['status'] as String? ?? 'aktif',
      terdaftar: json['terdaftar'] != null
          ? DateTime.parse(json['terdaftar'])
          : DateTime.now(),
      fotoProfil: json['fotoProfil'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'noHp': noHp,
      'alamat': alamat,
      'status': status,
      'terdaftar': terdaftar.toIso8601String(),
      'fotoProfil': fotoProfil,
    };
  }

  Jamaah copyWith({
    String? id,
    String? nama,
    String? noHp,
    String? alamat,
    String? status,
    DateTime? terdaftar,
    String? fotoProfil,
  }) {
    return Jamaah(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      noHp: noHp ?? this.noHp,
      alamat: alamat ?? this.alamat,
      status: status ?? this.status,
      terdaftar: terdaftar ?? this.terdaftar,
      fotoProfil: fotoProfil ?? this.fotoProfil,
    );
  }
}
