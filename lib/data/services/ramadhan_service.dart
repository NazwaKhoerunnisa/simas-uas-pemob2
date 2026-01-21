import '../models/ramadhan_model.dart';
import '../models/jadwal_shalat_model.dart';

class RamadhanService {
  // Mock data Zakat Fitrah
  static final List<ZakatFitrah> _mockZakatFitrah = [
    ZakatFitrah(
      id: '1',
      namaJamaah: 'Keluarga Ahmadi',
      tanggal: DateTime(2025, 2, 20),
      jumlahJiwa: 4,
      jenisZakat: 'Beras',
      nominal: 0,
      gram: 2000,
      status: 'Sudah',
    ),
    ZakatFitrah(
      id: '2',
      namaJamaah: 'Bapak Suryanto',
      tanggal: DateTime(2025, 2, 22),
      jumlahJiwa: 2,
      jenisZakat: 'Uang',
      nominal: 150000,
      gram: 0,
      status: 'Belum',
    ),
  ];

  // Mock data Zakat Mal
  static final List<ZakatMal> _mockZakatMal = [
    ZakatMal(
      id: '1',
      namaJamaah: 'Ahmad Rizki',
      tanggal: DateTime(2025, 2, 20),
      nominalDana: 500000,
      gramEmas: 0,
      status: 'Sudah',
    ),
    ZakatMal(
      id: '2',
      namaJamaah: 'Siti Nurhaliza',
      tanggal: DateTime(2025, 2, 22),
      nominalDana: 1000000,
      gramEmas: 5,
      status: 'Belum',
    ),
  ];

  // Mock data Jadwal Ta'jil
  static final List<TajilSchedule> _mockTajilSchedule = [
    TajilSchedule(
      id: '1',
      hari: 1,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 19),
      jamaah: ['Bu Ade Sofyan 01'],
    ),
    TajilSchedule(
      id: '2',
      hari: 2,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 20),
      jamaah: ['Bu Tanti', 'Umi Amay 03'],
    ),
    TajilSchedule(
      id: '3',
      hari: 3,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 21),
      jamaah: ['Bu Saef 08', 'Bu Cecep 01'],
    ),
    TajilSchedule(
      id: '4',
      hari: 4,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 22),
      jamaah: ['Bu Lukman 01', 'Grup JUMBER'],
    ),
    TajilSchedule(
      id: '5',
      hari: 5,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 23),
      jamaah: ['Bu Rani', 'DW 162 02'],
    ),
    TajilSchedule(
      id: '6',
      hari: 6,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 24),
      jamaah: ['Bu Jajang 01', 'Bu Uus 01'],
    ),
    TajilSchedule(
      id: '7',
      hari: 7,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 25),
      jamaah: ['Bu Beni 01'],
    ),
    TajilSchedule(
      id: '8',
      hari: 8,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 26),
      jamaah: ['Bu Imas', 'Th Erna', 'Mh Ambar 01'],
    ),
    TajilSchedule(
      id: '9',
      hari: 9,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 27),
      jamaah: ['Bu Citra', 'Bu Anita', 'Bu Marianus 01'],
    ),
    TajilSchedule(
      id: '10',
      hari: 10,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 28),
      jamaah: ['B Dani', 'B Dadan 01', 'Mah Dea', 'Pa Tatang 01'],
    ),
    TajilSchedule(
      id: '11',
      hari: 11,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 1),
      jamaah: ['Bu Kukuh', 'Bu Waluyo 01'],
    ),
    TajilSchedule(
      id: '12',
      hari: 12,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 2),
      jamaah: ['Bu Dedih', 'Teh Iva 03'],
    ),
    TajilSchedule(
      id: '13',
      hari: 13,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 3),
      jamaah: ['B Yadi 01'],
    ),
    TajilSchedule(
      id: '14',
      hari: 14,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 4),
      jamaah: ['Bu Ai Lalan', 'Bu Yana', 'Bu Sarif 03'],
    ),
    TajilSchedule(
      id: '15',
      hari: 15,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 5),
      jamaah: ['B Dewi', 'B Wawan 01'],
    ),
    TajilSchedule(
      id: '16',
      hari: 16,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 6),
      jamaah: ['B Siti', 'B Ule 01'],
    ),
    TajilSchedule(
      id: '17',
      hari: 17,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 7),
      jamaah: ['B Levi', 'B Endro 01'],
    ),
    TajilSchedule(
      id: '18',
      hari: 18,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 8),
      jamaah: ['B Tatang', 'Mah Vio 02'],
    ),
    TajilSchedule(
      id: '19',
      hari: 19,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 9),
      jamaah: ['Mbun', 'Ma Gina 03'],
    ),
    TajilSchedule(
      id: '20',
      hari: 20,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 10),
      jamaah: ['Bu Nila', 'Bu Isye 03'],
    ),
    TajilSchedule(
      id: '21',
      hari: 21,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 11),
      jamaah: ['B Dida RT 03'],
    ),
    TajilSchedule(
      id: '22',
      hari: 22,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 12),
      jamaah: ['B H Dadang 01'],
    ),
    TajilSchedule(
      id: '23',
      hari: 23,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 13),
      jamaah: ['B Handoyo 01'],
    ),
    TajilSchedule(
      id: '24',
      hari: 24,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 14),
      jamaah: ['Mah Ipal', 'Mah Eni 01'],
    ),
    TajilSchedule(
      id: '25',
      hari: 25,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 15),
      jamaah: ['Teh Gita', 'Ambu 03'],
    ),
    TajilSchedule(
      id: '26',
      hari: 26,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 16),
      jamaah: ['DW 154 01'],
    ),
    TajilSchedule(
      id: '27',
      hari: 27,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 17),
      jamaah: ['B Wandi 01'],
    ),
    TajilSchedule(
      id: '28',
      hari: 28,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 18),
      jamaah: ['Teh Sri 01', 'Bu Hilal 03', 'Mah Eza 01'],
    ),
    TajilSchedule(
      id: '29',
      hari: 29,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 19),
      jamaah: ['Mah Hilmi', 'Teh Tika 03'],
    ),
    TajilSchedule(
      id: '30',
      hari: 30,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 20),
      jamaah: ['B Rendi', 'B Nova 01'],
    ),
  ];

  // Mock data Jadwal Shalat
  static final List<JadwalShalat> _mockJadwalShalat = [
    JadwalShalat(
      id: '1',
      tanggal: DateTime(2025, 2, 19),
      namaHari: 'Rabu',
      tanggalHijri: '1 Ramadhan',
      subuh: '04:30',
      dzuhur: '12:20',
      ashar: '15:30',
      maghrib: '18:32',
      isya: '19:45',
    ),
    JadwalShalat(
      id: '2',
      tanggal: DateTime(2025, 2, 20),
      namaHari: 'Kamis',
      tanggalHijri: '2 Ramadhan',
      subuh: '04:29',
      dzuhur: '12:21',
      ashar: '15:31',
      maghrib: '18:33',
      isya: '19:46',
    ),
    JadwalShalat(
      id: '3',
      tanggal: DateTime(2025, 2, 21),
      namaHari: 'Jumat',
      tanggalHijri: '3 Ramadhan',
      subuh: '04:28',
      dzuhur: '12:21',
      ashar: '15:32',
      maghrib: '18:34',
      isya: '19:47',
    ),
    JadwalShalat(
      id: '4',
      tanggal: DateTime(2025, 2, 22),
      namaHari: 'Sabtu',
      tanggalHijri: '4 Ramadhan',
      subuh: '04:27',
      dzuhur: '12:22',
      ashar: '15:33',
      maghrib: '18:35',
      isya: '19:48',
    ),
    JadwalShalat(
      id: '5',
      tanggal: DateTime(2025, 2, 23),
      namaHari: 'Minggu',
      tanggalHijri: '5 Ramadhan',
      subuh: '04:26',
      dzuhur: '12:22',
      ashar: '15:34',
      maghrib: '18:36',
      isya: '19:49',
    ),
  ];

  // Zakat Fitrah Methods
  Future<List<ZakatFitrah>> fetchZakatFitrah() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockZakatFitrah;
  }

  Future<ZakatFitrah?> getZakatFitrahById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockZakatFitrah.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createZakatFitrah(ZakatFitrah zakatFitrah) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockZakatFitrah.add(zakatFitrah);
  }

  Future<void> updateZakatFitrah(ZakatFitrah zakatFitrah) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockZakatFitrah.indexWhere((item) => item.id == zakatFitrah.id);
    if (index != -1) {
      _mockZakatFitrah[index] = zakatFitrah;
    }
  }

  Future<void> deleteZakatFitrah(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockZakatFitrah.removeWhere((item) => item.id == id);
  }

  // Zakat Mal Methods
  Future<List<ZakatMal>> fetchZakatMal() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockZakatMal;
  }

  Future<ZakatMal?> getZakatMalById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockZakatMal.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createZakatMal(ZakatMal zakatMal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockZakatMal.add(zakatMal);
  }

  Future<void> updateZakatMal(ZakatMal zakatMal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockZakatMal.indexWhere((item) => item.id == zakatMal.id);
    if (index != -1) {
      _mockZakatMal[index] = zakatMal;
    }
  }

  Future<void> deleteZakatMal(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockZakatMal.removeWhere((item) => item.id == id);
  }

  // Jadwal Ta'jil Methods
  Future<List<TajilSchedule>> fetchTajilSchedule() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockTajilSchedule;
  }

  Future<TajilSchedule?> getTajilScheduleById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockTajilSchedule.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createTajilSchedule(TajilSchedule tajilSchedule) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockTajilSchedule.add(tajilSchedule);
  }

  Future<void> updateTajilSchedule(TajilSchedule tajilSchedule) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockTajilSchedule.indexWhere((item) => item.id == tajilSchedule.id);
    if (index != -1) {
      _mockTajilSchedule[index] = tajilSchedule;
    }
  }

  Future<void> deleteTajilSchedule(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockTajilSchedule.removeWhere((item) => item.id == id);
  }

  // Mock data Jadwal Imsak & Buka Puasa
  static final List<JadwalImsakBuka> _mockJadwalImsakBuka = [
    JadwalImsakBuka(
      id: '1',
      hari: 1,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 19),
      waktuImsak: '04:30',
      waktuBuka: '18:31',
    ),
    JadwalImsakBuka(
      id: '2',
      hari: 2,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 20),
      waktuImsak: '04:29',
      waktuBuka: '18:32',
    ),
    JadwalImsakBuka(
      id: '3',
      hari: 3,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 21),
      waktuImsak: '04:28',
      waktuBuka: '18:33',
    ),
    JadwalImsakBuka(
      id: '4',
      hari: 4,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 22),
      waktuImsak: '04:27',
      waktuBuka: '18:34',
    ),
    JadwalImsakBuka(
      id: '5',
      hari: 5,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 23),
      waktuImsak: '04:26',
      waktuBuka: '18:35',
    ),
    JadwalImsakBuka(
      id: '6',
      hari: 6,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 24),
      waktuImsak: '04:25',
      waktuBuka: '18:36',
    ),
    JadwalImsakBuka(
      id: '7',
      hari: 7,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 25),
      waktuImsak: '04:24',
      waktuBuka: '18:37',
    ),
    JadwalImsakBuka(
      id: '8',
      hari: 8,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 26),
      waktuImsak: '04:23',
      waktuBuka: '18:38',
    ),
    JadwalImsakBuka(
      id: '9',
      hari: 9,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 27),
      waktuImsak: '04:22',
      waktuBuka: '18:39',
    ),
    JadwalImsakBuka(
      id: '10',
      hari: 10,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 2, 28),
      waktuImsak: '04:21',
      waktuBuka: '18:40',
    ),
    JadwalImsakBuka(
      id: '11',
      hari: 11,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 1),
      waktuImsak: '04:20',
      waktuBuka: '18:41',
    ),
    JadwalImsakBuka(
      id: '12',
      hari: 12,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 2),
      waktuImsak: '04:19',
      waktuBuka: '18:42',
    ),
    JadwalImsakBuka(
      id: '13',
      hari: 13,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 3),
      waktuImsak: '04:18',
      waktuBuka: '18:43',
    ),
    JadwalImsakBuka(
      id: '14',
      hari: 14,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 4),
      waktuImsak: '04:17',
      waktuBuka: '18:44',
    ),
    JadwalImsakBuka(
      id: '15',
      hari: 15,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 5),
      waktuImsak: '04:16',
      waktuBuka: '18:45',
    ),
    JadwalImsakBuka(
      id: '16',
      hari: 16,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 6),
      waktuImsak: '04:15',
      waktuBuka: '18:46',
    ),
    JadwalImsakBuka(
      id: '17',
      hari: 17,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 7),
      waktuImsak: '04:14',
      waktuBuka: '18:47',
    ),
    JadwalImsakBuka(
      id: '18',
      hari: 18,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 8),
      waktuImsak: '04:13',
      waktuBuka: '18:48',
    ),
    JadwalImsakBuka(
      id: '19',
      hari: 19,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 9),
      waktuImsak: '04:12',
      waktuBuka: '18:49',
    ),
    JadwalImsakBuka(
      id: '20',
      hari: 20,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 10),
      waktuImsak: '04:11',
      waktuBuka: '18:50',
    ),
    JadwalImsakBuka(
      id: '21',
      hari: 21,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 11),
      waktuImsak: '04:10',
      waktuBuka: '18:51',
    ),
    JadwalImsakBuka(
      id: '22',
      hari: 22,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 12),
      waktuImsak: '04:09',
      waktuBuka: '18:52',
    ),
    JadwalImsakBuka(
      id: '23',
      hari: 23,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 13),
      waktuImsak: '04:08',
      waktuBuka: '18:53',
    ),
    JadwalImsakBuka(
      id: '24',
      hari: 24,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 14),
      waktuImsak: '04:07',
      waktuBuka: '18:54',
    ),
    JadwalImsakBuka(
      id: '25',
      hari: 25,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 15),
      waktuImsak: '04:06',
      waktuBuka: '18:55',
    ),
    JadwalImsakBuka(
      id: '26',
      hari: 26,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 16),
      waktuImsak: '04:05',
      waktuBuka: '18:56',
    ),
    JadwalImsakBuka(
      id: '27',
      hari: 27,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 17),
      waktuImsak: '04:04',
      waktuBuka: '18:57',
    ),
    JadwalImsakBuka(
      id: '28',
      hari: 28,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 18),
      waktuImsak: '04:03',
      waktuBuka: '18:58',
    ),
    JadwalImsakBuka(
      id: '29',
      hari: 29,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 19),
      waktuImsak: '04:02',
      waktuBuka: '18:59',
    ),
    JadwalImsakBuka(
      id: '30',
      hari: 30,
      bulanHijri: 9,
      tanggalMasehi: DateTime(2025, 3, 20),
      waktuImsak: '04:01',
      waktuBuka: '19:00',
    ),
  ];

  // Jadwal Imsak & Buka Methods
  Future<List<JadwalImsakBuka>> fetchJadwalImsakBuka() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockJadwalImsakBuka;
  }

  Future<JadwalImsakBuka?> getJadwalImsakBukaById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockJadwalImsakBuka.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createJadwalImsakBuka(JadwalImsakBuka jadwal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockJadwalImsakBuka.add(jadwal);
  }

  Future<void> updateJadwalImsakBuka(JadwalImsakBuka jadwal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockJadwalImsakBuka.indexWhere((item) => item.id == jadwal.id);
    if (index != -1) {
      _mockJadwalImsakBuka[index] = jadwal;
    }
  }

  Future<void> deleteJadwalImsakBuka(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockJadwalImsakBuka.removeWhere((item) => item.id == id);
  }

  // Jadwal Shalat Methods
  Future<List<JadwalShalat>> fetchJadwalShalat() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Generate full month schedule (current month) based on first known times
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    // Use base times from mock if available, otherwise fallback
    final base = _mockJadwalShalat.isNotEmpty ? _mockJadwalShalat.first : null;
    final baseSubuh = base?.subuh ?? '04:30';
    final baseDzuhur = base?.dzuhur ?? '12:20';
    final baseAshar = base?.ashar ?? '15:30';
    final baseMaghrib = base?.maghrib ?? '18:30';
    final baseIsya = base?.isya ?? '19:45';

    return List.generate(daysInMonth, (i) {
      final date = start.add(Duration(days: i));
      return JadwalShalat(
        id: 'js-${date.toIso8601String()}',
        tanggal: date,
        namaHari: null,
        tanggalHijri: null,
        subuh: baseSubuh,
        dzuhur: baseDzuhur,
        ashar: baseAshar,
        maghrib: baseMaghrib,
        isya: baseIsya,
      );
    });
  }

  Future<JadwalShalat?> getJadwalShalatById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _mockJadwalShalat.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> createJadwalShalat(JadwalShalat jadwal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockJadwalShalat.add(jadwal);
  }

  Future<void> updateJadwalShalat(JadwalShalat jadwal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockJadwalShalat.indexWhere((item) => item.id == jadwal.id);
    if (index != -1) {
      _mockJadwalShalat[index] = jadwal;
    }
  }

  Future<void> deleteJadwalShalat(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockJadwalShalat.removeWhere((item) => item.id == id);
  }
}
