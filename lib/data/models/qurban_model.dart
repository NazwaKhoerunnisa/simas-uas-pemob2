class Qurban {
  final String id;
  final String namaJamaah;
  final String jenisHewan; // Sapi, Kambing, Domba
  final int jumlah;
  final String nomorInduk;
  final String kondisi; // Sehat, Kurang sehat
  final DateTime tanggalPendaftaran;
  final DateTime? tanggalPenyembelihan;
  final String status; // Menunggu, Disembelih, Selesai
  final String? keterangan;
  final String? foto;

  Qurban({
    required this.id,
    required this.namaJamaah,
    required this.jenisHewan,
    required this.jumlah,
    required this.nomorInduk,
    required this.kondisi,
    required this.tanggalPendaftaran,
    this.tanggalPenyembelihan,
    required this.status,
    this.keterangan,
    this.foto,
  });

  factory Qurban.fromJson(Map<String, dynamic> json) {
    return Qurban(
      id: json['id'] as String? ?? '',
      namaJamaah: json['namaJamaah'] as String? ?? '',
      jenisHewan: json['jenisHewan'] as String? ?? '',
      jumlah: json['jumlah'] as int? ?? 1,
      nomorInduk: json['nomorInduk'] as String? ?? '',
      kondisi: json['kondisi'] as String? ?? 'Sehat',
      tanggalPendaftaran: json['tanggalPendaftaran'] != null
          ? DateTime.parse(json['tanggalPendaftaran'])
          : DateTime.now(),
      tanggalPenyembelihan: json['tanggalPenyembelihan'] != null
          ? DateTime.parse(json['tanggalPenyembelihan'])
          : null,
      status: json['status'] as String? ?? 'Menunggu',
      keterangan: json['keterangan'] as String?,
      foto: json['foto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaJamaah': namaJamaah,
      'jenisHewan': jenisHewan,
      'jumlah': jumlah,
      'nomorInduk': nomorInduk,
      'kondisi': kondisi,
      'tanggalPendaftaran': tanggalPendaftaran.toIso8601String(),
      'tanggalPenyembelihan': tanggalPenyembelihan?.toIso8601String(),
      'status': status,
      'keterangan': keterangan,
      'foto': foto,
    };
  }

  Qurban copyWith({
    String? id,
    String? namaJamaah,
    String? jenisHewan,
    int? jumlah,
    String? nomorInduk,
    String? kondisi,
    DateTime? tanggalPendaftaran,
    DateTime? tanggalPenyembelihan,
    String? status,
    String? keterangan,
    String? foto,
  }) {
    return Qurban(
      id: id ?? this.id,
      namaJamaah: namaJamaah ?? this.namaJamaah,
      jenisHewan: jenisHewan ?? this.jenisHewan,
      jumlah: jumlah ?? this.jumlah,
      nomorInduk: nomorInduk ?? this.nomorInduk,
      kondisi: kondisi ?? this.kondisi,
      tanggalPendaftaran: tanggalPendaftaran ?? this.tanggalPendaftaran,
      tanggalPenyembelihan:
          tanggalPenyembelihan ?? this.tanggalPenyembelihan,
      status: status ?? this.status,
      keterangan: keterangan ?? this.keterangan,
      foto: foto ?? this.foto,
    );
  }
}
