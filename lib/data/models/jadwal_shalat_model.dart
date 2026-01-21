class JadwalShalat {
  final String id;
  final DateTime tanggal;
  final String? namaHari;
  final String? tanggalHijri;
  final String subuh;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;
  final String? keterangan;

  JadwalShalat({
    required this.id,
    required this.tanggal,
    this.namaHari,
    this.tanggalHijri,
    required this.subuh,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
    this.keterangan,
  });

  factory JadwalShalat.fromJson(Map<String, dynamic> json) {
    return JadwalShalat(
      id: json['id'] as String? ?? '',
      tanggal: json['tanggal'] != null
          ? DateTime.parse(json['tanggal'] as String)
          : DateTime.now(),
      namaHari: json['namaHari'] as String?,
      tanggalHijri: json['tanggalHijri'] as String?,
      subuh: json['subuh'] as String? ?? '04:30',
      dzuhur: json['dzuhur'] as String? ?? '12:30',
      ashar: json['ashar'] as String? ?? '15:30',
      maghrib: json['maghrib'] as String? ?? '18:30',
      isya: json['isya'] as String? ?? '20:00',
      keterangan: json['keterangan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tanggal': tanggal.toIso8601String(),
        'namaHari': namaHari,
        'tanggalHijri': tanggalHijri,
        'subuh': subuh,
        'dzuhur': dzuhur,
        'ashar': ashar,
        'maghrib': maghrib,
        'isya': isya,
        'keterangan': keterangan,
      };

  JadwalShalat copyWith({
    String? id,
    DateTime? tanggal,
    String? namaHari,
    String? tanggalHijri,
    String? subuh,
    String? dzuhur,
    String? ashar,
    String? maghrib,
    String? isya,
    String? keterangan,
  }) {
    return JadwalShalat(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      namaHari: namaHari ?? this.namaHari,
      tanggalHijri: tanggalHijri ?? this.tanggalHijri,
      subuh: subuh ?? this.subuh,
      dzuhur: dzuhur ?? this.dzuhur,
      ashar: ashar ?? this.ashar,
      maghrib: maghrib ?? this.maghrib,
      isya: isya ?? this.isya,
      keterangan: keterangan ?? this.keterangan,
    );
  }
}
