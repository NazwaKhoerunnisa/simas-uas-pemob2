class Donasi {
  final String id;
  final String namaJamaah;
  final String tipe; // Infaq, Sedekah, Zakat, Hibah, dll
  final int nominal;
  final String tujuan; // Pembangunan, Sosial, Kesehatan, dll
  final DateTime tanggal;
  final String status; // Masuk, Diproses, Selesai
  final String metodeTransfer; // Tunai, Transfer, Cek
  final String? keterangan;
  final String? bukti; // Foto bukti transfer

  Donasi({
    required this.id,
    required this.namaJamaah,
    required this.tipe,
    required this.nominal,
    required this.tujuan,
    required this.tanggal,
    required this.status,
    required this.metodeTransfer,
    this.keterangan,
    this.bukti,
  });

  factory Donasi.fromJson(Map<String, dynamic> json) {
    return Donasi(
      id: json['id'] as String? ?? '',
      namaJamaah: json['namaJamaah'] as String? ?? '',
      tipe: json['tipe'] as String? ?? 'Infaq',
      nominal: json['nominal'] as int? ?? 0,
      tujuan: json['tujuan'] as String? ?? 'Sosial',
      tanggal: json['tanggal'] != null
          ? DateTime.parse(json['tanggal'])
          : DateTime.now(),
      status: json['status'] as String? ?? 'Masuk',
      metodeTransfer: json['metodeTransfer'] as String? ?? 'Tunai',
      keterangan: json['keterangan'] as String?,
      bukti: json['bukti'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'namaJamaah': namaJamaah,
      'tipe': tipe,
      'nominal': nominal,
      'tujuan': tujuan,
      'tanggal': tanggal.toIso8601String(),
      'status': status,
      'metodeTransfer': metodeTransfer,
      'keterangan': keterangan,
      'bukti': bukti,
    };
  }

  Donasi copyWith({
    String? id,
    String? namaJamaah,
    String? tipe,
    int? nominal,
    String? tujuan,
    DateTime? tanggal,
    String? status,
    String? metodeTransfer,
    String? keterangan,
    String? bukti,
  }) {
    return Donasi(
      id: id ?? this.id,
      namaJamaah: namaJamaah ?? this.namaJamaah,
      tipe: tipe ?? this.tipe,
      nominal: nominal ?? this.nominal,
      tujuan: tujuan ?? this.tujuan,
      tanggal: tanggal ?? this.tanggal,
      status: status ?? this.status,
      metodeTransfer: metodeTransfer ?? this.metodeTransfer,
      keterangan: keterangan ?? this.keterangan,
      bukti: bukti ?? this.bukti,
    );
  }
}
