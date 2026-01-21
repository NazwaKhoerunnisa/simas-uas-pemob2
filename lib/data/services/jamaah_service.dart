import '../models/jamaah_model.dart';

class JamaahService {
  // Mock data
  static final List<Jamaah> _mockJamaah = [
    Jamaah(
      id: '1',
      nama: 'Ahmad Rizki',
      noHp: '081234567890',
      alamat: 'Jl. Masjid No. 1, Jakarta',
      status: 'aktif',
      terdaftar: DateTime(2023, 1, 15),
    ),
    Jamaah(
      id: '2',
      nama: 'Budi Santoso',
      noHp: '081234567891',
      alamat: 'Jl. Masjid No. 2, Jakarta',
      status: 'aktif',
      terdaftar: DateTime(2023, 3, 20),
    ),
    Jamaah(
      id: '3',
      nama: 'Siti Nurhaliza',
      noHp: '081234567892',
      alamat: 'Jl. Masjid No. 3, Jakarta',
      status: 'aktif',
      terdaftar: DateTime(2024, 1, 10),
    ),
    Jamaah(
      id: '4',
      nama: 'Hendra Wijaya',
      noHp: '081234567893',
      alamat: 'Jl. Masjid No. 4, Jakarta',
      status: 'nonaktif',
      terdaftar: DateTime(2022, 6, 5),
    ),
    Jamaah(
      id: '5',
      nama: 'Dewi Lestari',
      noHp: '081234567894',
      alamat: 'Jl. Masjid No. 5, Jakarta',
      status: 'aktif',
      terdaftar: DateTime(2024, 11, 01),
    ),
  ];

  // Simulate API call
  Future<List<Jamaah>> fetchAll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockJamaah;
  }

  Future<Jamaah?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockJamaah.firstWhere((jamaah) => jamaah.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<Jamaah> add(Jamaah jamaah) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockJamaah.add(jamaah);
    return jamaah;
  }

  Future<Jamaah> update(Jamaah jamaah) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockJamaah.indexWhere((j) => j.id == jamaah.id);
    if (index != -1) {
      _mockJamaah[index] = jamaah;
    }
    return jamaah;
  }

  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockJamaah.removeWhere((jamaah) => jamaah.id == id);
    return true;
  }

  // Statistics
  Future<int> getTotalJamaah() async {
    return _mockJamaah.length;
  }

  Future<int> getActiveJamaah() async {
    return _mockJamaah.where((j) => j.status == 'aktif').length;
  }

  Future<int> getNewJamaahThisMonth() async {
    final now = DateTime.now();
    return _mockJamaah
        .where((j) =>
            j.terdaftar.year == now.year && j.terdaftar.month == now.month)
        .length;
  }
}
