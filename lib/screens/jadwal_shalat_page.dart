import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/jadwal_shalat_model.dart';
import '../data/services/ramadhan_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';

class JadwalShalatPage extends StatefulWidget {
  const JadwalShalatPage({super.key});

  @override
  State<JadwalShalatPage> createState() => _JadwalShalatPageState();
}

class _JadwalShalatPageState extends State<JadwalShalatPage> {
  final _service = RamadhanService();

  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  String getDayName(DateTime date) {
    const days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    return days[date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Shalat'),
      ),
      body: FutureBuilder<List<JadwalShalat>>(
        future: _service.fetchJadwalShalat(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snapshot.data ?? [];

          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 64, color: AppColors.primary.withOpacity(0.5)),
                  const SizedBox(height: AppSpacing.lg),
                  const Text('Belum ada jadwal shalat'),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // (Header removed) - only the table is displayed

                // Table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: AppSpacing.lg,
                    columns: const [
                      DataColumn(label: Text('Hari / Tanggal')),
                      DataColumn(label: Text('Subuh')),
                      DataColumn(label: Text('Dzuhur')),
                      DataColumn(label: Text('Ashar')),
                      DataColumn(label: Text('Maghrib')),
                      DataColumn(label: Text('Isya')),
                    ],
                    rows: list.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.namaHari ?? getDayName(item.tanggal),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  formatDate(item.tanggal),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(
                              item.subuh,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.dzuhur,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.ashar,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.maghrib,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.success,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(
                              item.isya,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // (Legend removed) - only table remains
              ],
            ),
          );
        },
      ),
    );
  }

  // Legend helper removed since legend is not displayed
}
