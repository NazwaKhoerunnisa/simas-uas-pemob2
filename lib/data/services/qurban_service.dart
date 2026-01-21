import '../models/qurban_model.dart';

class QurbanService {
  // Mock data
  static final List<Qurban> _mockQurban = [
    Qurban(
      id: '1',
      namaJamaah: 'Ahmad Rizki',
      jenisHewan: 'Sapi',
      jumlah: 1,
      nomorInduk: 'Q-001-2024',
      kondisi: 'Sehat',
      tanggalPendaftaran: DateTime(2024, 1, 10),
      status: 'Menunggu',
    ),
    Qurban(
      id: '2',
      namaJamaah: 'Budi Santoso',
      jenisHewan: 'Kambing',
      jumlah: 2,
      nomorInduk: 'Q-002-2024',
      kondisi: 'Sehat',
      tanggalPendaftaran: DateTime(2024, 1, 15),
      status: 'Disembelih',
      tanggalPenyembelihan: DateTime(2024, 6, 17),
    ),
    Qurban(
      id: '3',
      namaJamaah: 'Siti Nurhaliza',
      jenisHewan: 'Domba',
      jumlah: 1,
      nomorInduk: 'Q-003-2024',
      kondisi: 'Sehat',
      tanggalPendaftaran: DateTime(2024, 1, 20),
      status: 'Selesai',
      tanggalPenyembelihan: DateTime(2024, 6, 17),
    ),
  ];

  Future<List<Qurban>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockQurban;
  }

  Future<Qurban?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockQurban.firstWhere((qurban) => qurban.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Qurban> add(Qurban qurban) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockQurban.add(qurban);
    return qurban;
  }

  Future<Qurban> update(Qurban qurban) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockQurban.indexWhere((q) => q.id == qurban.id);
    if (index != -1) {
      _mockQurban[index] = qurban;
    }
    return qurban;
  }

  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockQurban.removeWhere((qurban) => qurban.id == id);
    return true;
  }

  Future<int> getTotalQurban() async {
    return _mockQurban.length;
  }

  Future<int> getByStatus(String status) async {
    return _mockQurban.where((q) => q.status == status).length;
  }
}
