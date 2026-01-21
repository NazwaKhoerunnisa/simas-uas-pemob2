class Agenda {
  final String id;
  final String judul;
  final String tanggal;
  final String deskripsi;
  final String? gambar; // Gambar agenda (base64 atau URL)
  final String? dokumentasi; // Foto dokumentasi agenda
  final String status; // terlaksana, tidak_terlaksana, akan_datang

  Agenda({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.deskripsi,
    this.gambar,
    this.dokumentasi,
    this.status = 'akan_datang',
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json['id'],
      judul: json['judul'],
      tanggal: json['tanggal'],
      deskripsi: json['deskripsi'],
      gambar: json['gambar'],
      dokumentasi: json['dokumentasi'],
      status: json['status'] ?? 'akan_datang',
    );
  }

  Agenda copyWith({
    String? id,
    String? judul,
    String? tanggal,
    String? deskripsi,
    String? gambar,
    String? dokumentasi,
    String? status,
  }) {
    return Agenda(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      tanggal: tanggal ?? this.tanggal,
      deskripsi: deskripsi ?? this.deskripsi,
      gambar: gambar ?? this.gambar,
      dokumentasi: dokumentasi ?? this.dokumentasi,
      status: status ?? this.status,
    );
  }
}
