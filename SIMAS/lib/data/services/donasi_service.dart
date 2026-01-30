import '../models/donasi_model.dart';

class DonasiService {
  // Mock data
  static final List<Donasi> _mockDonasi = [
    Donasi(
      id: '1',
      namaJamaah: 'Ahmad Rizki',
      tipe: 'Infaq',
      nominal: 100000,
      tujuan: 'Pembangunan Masjid',
      tanggal: DateTime(2024, 1, 15),
      status: 'Masuk',
      metodeTransfer: 'Transfer',
    ),
    Donasi(
      id: '2',
      namaJamaah: 'Budi Santoso',
      tipe: 'Sedekah',
      nominal: 50000,
      tujuan: 'Pemberdayaan Anak Yatim',
      tanggal: DateTime(2024, 1, 18),
      status: 'Masuk',
      metodeTransfer: 'Tunai',
    ),
    Donasi(
      id: '3',
      namaJamaah: 'Siti Nurhaliza',
      tipe: 'Zakat',
      nominal: 500000,
      tujuan: 'Sosial Kemasyarakatan',
      tanggal: DateTime(2024, 2, 01),
      status: 'Selesai',
      metodeTransfer: 'Transfer',
    ),
    Donasi(
      id: '4',
      namaJamaah: 'Hendra Wijaya',
      tipe: 'Hibah',
      nominal: 1000000,
      tujuan: 'Pembangunan Perpustakaan',
      tanggal: DateTime(2024, 2, 10),
      status: 'Diproses',
      metodeTransfer: 'Transfer',
    ),
    Donasi(
      id: '5',
      namaJamaah: 'Dewi Lestari',
      tipe: 'Infaq',
      nominal: 75000,
      tujuan: 'Kesehatan Jamaah',
      tanggal: DateTime(2024, 2, 15),
      status: 'Masuk',
      metodeTransfer: 'Tunai',
    ),
  ];

  Future<List<Donasi>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockDonasi;
  }

  Future<Donasi?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockDonasi.firstWhere((donasi) => donasi.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Donasi> add(Donasi donasi) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockDonasi.add(donasi);
    return donasi;
  }

  Future<Donasi> update(Donasi donasi) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockDonasi.indexWhere((d) => d.id == donasi.id);
    if (index != -1) {
      _mockDonasi[index] = donasi;
    }
    return donasi;
  }

  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockDonasi.removeWhere((donasi) => donasi.id == id);
    return true;
  }

  // Statistics
  Future<int> getTotalDonasi() async {
    int total = 0;
    for (var donasi in _mockDonasi) {
      total += donasi.nominal;
    }
    return total;
  }

  Future<int> getDonasiByTipe(String tipe) async {
    int total = 0;
    for (var donasi in _mockDonasi.where((d) => d.tipe == tipe)) {
      total += donasi.nominal;
    }
    return total;
  }

  Future<int> getDonasiByStatus(String status) async {
    int total = 0;
    for (var donasi in _mockDonasi.where((d) => d.status == status)) {
      total += donasi.nominal;
    }
    return total;
  }
}
