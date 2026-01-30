class ZakatFitrah {
  final String id;
  final String namaJamaah;
  final DateTime tanggal;
  final int jumlahJiwa;
  final String jenisZakat; // Beras, Uang, Daging
  final int nominal; // Untuk jenis Uang
  final int gram; // Untuk jenis Beras atau Daging
  final String status; // Belum, Sudah
  final String? keterangan;

  ZakatFitrah({
    required this.id,
    required this.namaJamaah,
    required this.tanggal,
    required this.jumlahJiwa,
    required this.jenisZakat,
    required this.nominal,
    required this.gram,
    required this.status,
    this.keterangan,
  });

  factory ZakatFitrah.fromJson(Map<String, dynamic> json) {
    return ZakatFitrah(
      id: json['id'] as String? ?? '',
      namaJamaah: json['namaJamaah'] as String? ?? '',
      tanggal: json['tanggal'] != null
          ? DateTime.parse(json['tanggal'] as String)
          : DateTime.now(),
      jumlahJiwa: json['jumlahJiwa'] as int? ?? 0,
      jenisZakat: json['jenisZakat'] as String? ?? 'Beras',
      nominal: json['nominal'] as int? ?? 0,
      gram: json['gram'] as int? ?? 0,
      status: json['status'] as String? ?? 'Belum',
      keterangan: json['keterangan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'namaJamaah': namaJamaah,
        'tanggal': tanggal.toIso8601String(),
        'jumlahJiwa': jumlahJiwa,
        'jenisZakat': jenisZakat,
        'nominal': nominal,
        'gram': gram,
        'status': status,
        'keterangan': keterangan,
      };

  ZakatFitrah copyWith({
    String? id,
    String? namaJamaah,
    DateTime? tanggal,
    int? jumlahJiwa,
    String? jenisZakat,
    int? nominal,
    int? gram,
    String? status,
    String? keterangan,
  }) {
    return ZakatFitrah(
      id: id ?? this.id,
      namaJamaah: namaJamaah ?? this.namaJamaah,
      tanggal: tanggal ?? this.tanggal,
      jumlahJiwa: jumlahJiwa ?? this.jumlahJiwa,
      jenisZakat: jenisZakat ?? this.jenisZakat,
      nominal: nominal ?? this.nominal,
      gram: gram ?? this.gram,
      status: status ?? this.status,
      keterangan: keterangan ?? this.keterangan,
    );
  }
}

class ZakatMal {
  final String id;
  final String namaJamaah;
  final DateTime tanggal;
  final int nominalDana;
  final int gramEmas;
  final String status; // Belum, Sudah
  final String? keterangan;

  ZakatMal({
    required this.id,
    required this.namaJamaah,
    required this.tanggal,
    required this.nominalDana,
    required this.gramEmas,
    required this.status,
    this.keterangan,
  });

  factory ZakatMal.fromJson(Map<String, dynamic> json) {
    return ZakatMal(
      id: json['id'] as String? ?? '',
      namaJamaah: json['namaJamaah'] as String? ?? '',
      tanggal: json['tanggal'] != null
          ? DateTime.parse(json['tanggal'] as String)
          : DateTime.now(),
      nominalDana: json['nominalDana'] as int? ?? 0,
      gramEmas: json['gramEmas'] as int? ?? json['nominalEmas'] as int? ?? 0,
      status: json['status'] as String? ?? 'Belum',
      keterangan: json['keterangan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'namaJamaah': namaJamaah,
        'tanggal': tanggal.toIso8601String(),
        'nominalDana': nominalDana,
        'gramEmas': gramEmas,
        'status': status,
        'keterangan': keterangan,
      };

  ZakatMal copyWith({
    String? id,
    String? namaJamaah,
    DateTime? tanggal,
    int? nominalDana,
    int? gramEmas,
    String? status,
    String? keterangan,
  }) {
    return ZakatMal(
      id: id ?? this.id,
      namaJamaah: namaJamaah ?? this.namaJamaah,
      tanggal: tanggal ?? this.tanggal,
      nominalDana: nominalDana ?? this.nominalDana,
      gramEmas: gramEmas ?? this.gramEmas,
      status: status ?? this.status,
      keterangan: keterangan ?? this.keterangan,
    );
  }
}

class TajilSchedule {
  final String id;
  final int hari; // 1-30
  final int bulanHijri; // Ramadhan (9)
  final DateTime tanggalMasehi;
  final List<String> jamaah; // Nama-nama jamaah
  final String? keterangan;

  TajilSchedule({
    required this.id,
    required this.hari,
    required this.bulanHijri,
    required this.tanggalMasehi,
    required this.jamaah,
    this.keterangan,
  });

  factory TajilSchedule.fromJson(Map<String, dynamic> json) {
    return TajilSchedule(
      id: json['id'] as String? ?? '',
      hari: json['hari'] as int? ?? 0,
      bulanHijri: json['bulanHijri'] as int? ?? 9,
      tanggalMasehi: json['tanggalMasehi'] != null
          ? DateTime.parse(json['tanggalMasehi'] as String)
          : DateTime.now(),
      jamaah: List<String>.from(json['jamaah'] as List<dynamic>? ?? []),
      keterangan: json['keterangan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'hari': hari,
        'bulanHijri': bulanHijri,
        'tanggalMasehi': tanggalMasehi.toIso8601String(),
        'jamaah': jamaah,
        'keterangan': keterangan,
      };

  TajilSchedule copyWith({
    String? id,
    int? hari,
    int? bulanHijri,
    DateTime? tanggalMasehi,
    List<String>? jamaah,
    String? keterangan,
  }) {
    return TajilSchedule(
      id: id ?? this.id,
      hari: hari ?? this.hari,
      bulanHijri: bulanHijri ?? this.bulanHijri,
      tanggalMasehi: tanggalMasehi ?? this.tanggalMasehi,
      jamaah: jamaah ?? this.jamaah,
      keterangan: keterangan ?? this.keterangan,
    );
  }
}

class JadwalImsakBuka {
  final String id;
  final int hari; // 1-30
  final int bulanHijri; // Ramadhan (9)
  final DateTime tanggalMasehi;
  final String waktuImsak; // Format HH:mm
  final String waktuBuka; // Format HH:mm
  final String? keterangan;

  JadwalImsakBuka({
    required this.id,
    required this.hari,
    required this.bulanHijri,
    required this.tanggalMasehi,
    required this.waktuImsak,
    required this.waktuBuka,
    this.keterangan,
  });

  factory JadwalImsakBuka.fromJson(Map<String, dynamic> json) {
    return JadwalImsakBuka(
      id: json['id'] as String? ?? '',
      hari: json['hari'] as int? ?? 0,
      bulanHijri: json['bulanHijri'] as int? ?? 9,
      tanggalMasehi: json['tanggalMasehi'] != null
          ? DateTime.parse(json['tanggalMasehi'] as String)
          : DateTime.now(),
      waktuImsak: json['waktuImsak'] as String? ?? '04:30',
      waktuBuka: json['waktuBuka'] as String? ?? '18:30',
      keterangan: json['keterangan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'hari': hari,
        'bulanHijri': bulanHijri,
        'tanggalMasehi': tanggalMasehi.toIso8601String(),
        'waktuImsak': waktuImsak,
        'waktuBuka': waktuBuka,
        'keterangan': keterangan,
      };

  JadwalImsakBuka copyWith({
    String? id,
    int? hari,
    int? bulanHijri,
    DateTime? tanggalMasehi,
    String? waktuImsak,
    String? waktuBuka,
    String? keterangan,
  }) {
    return JadwalImsakBuka(
      id: id ?? this.id,
      hari: hari ?? this.hari,
      bulanHijri: bulanHijri ?? this.bulanHijri,
      tanggalMasehi: tanggalMasehi ?? this.tanggalMasehi,
      waktuImsak: waktuImsak ?? this.waktuImsak,
      waktuBuka: waktuBuka ?? this.waktuBuka,
      keterangan: keterangan ?? this.keterangan,
    );
  }
}
