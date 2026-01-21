class Keuangan {
  final String id;
  final String tanggal;
  final String tipe;
  final String kategori;
  final String nominal;
  final String keterangan;

  Keuangan({
    required this.id,
    required this.tanggal,
    required this.tipe,
    required this.kategori,
    required this.nominal,
    required this.keterangan,
  });

  factory Keuangan.fromJson(Map<String, dynamic> json) {
    return Keuangan(
      id: json['id']?.toString() ?? '',
      tanggal: json['tanggal']?.toString() ?? '-',
      tipe: json['tipe']?.toString() ?? '-',
      kategori: json['kategori']?.toString() ?? '-',
      nominal: json['nominal']?.toString() ?? '0',
      keterangan: json['keterangan']?.toString() ?? '-',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'tipe': tipe,
      'kategori': kategori,
      'nominal': nominal,
      'keterangan': keterangan,
    };
  }
}
