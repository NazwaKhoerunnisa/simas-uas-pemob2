import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/utils/animated_navigation.dart';
import '../data/services/donasi_service.dart';
import '../data/services/donasi_laporan_service.dart';
import '../data/models/donasi_model.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import 'donasi_add_page.dart';
import 'donasi_detail_page.dart';

class DonasiListPage extends StatefulWidget {
  const DonasiListPage({super.key});

  @override
  State<DonasiListPage> createState() => _DonasiListPageState();
}

class _DonasiListPageState extends State<DonasiListPage> {
  late Future<List<Donasi>> donasiFuture;

  @override
  void initState() {
    super.initState();
    _loadDonasi();
  }

  void _loadDonasi() {
    donasiFuture = DonasiService().fetchAll();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Masuk':
        return AppColors.success;
      case 'Diproses':
        return AppColors.warning;
      case 'Selesai':
        return AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  String formatCurrency(int value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Donasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final donasiList = await donasiFuture;
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuat laporan...')),
              );

              final result = await DonasiLaporanService.exportDonasiCSV(donasiList);

              if (!mounted) return;

              if (result.contains('Error')) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error'),
                      content: Text(result),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Laporan Donasi'),
                      content: Text(result),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Donasi>>(
        future: donasiFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _loadDonasi());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final donasiList = snapshot.data ?? [];

          if (donasiList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite, size: 64, color: AppColors.primary.withOpacity(0.5)),
                  const SizedBox(height: AppSpacing.lg),
                  const Text('Belum ada data donasi'),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        SlidePageRoute(builder: (context) => const DonasiAddPage()),
                      );
                      setState(() => _loadDonasi());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Donasi'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: donasiList.length,
            itemBuilder: (context, index) {
              final donasi = donasiList[index];
              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    SlidePageRoute(
                      builder: (context) => DonasiDetailPage(donasi: donasi),
                    ),
                  );
                  setState(() => _loadDonasi());
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    donasi.namaJamaah,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    donasi.tipe,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(donasi.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              child: Text(
                                donasi.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(donasi.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nominal',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    formatCurrency(donasi.nominal),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Tujuan',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    donasi.tujuan,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.end,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.info_outline, size: 18),
                              label: const Text('Detail'),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  SlidePageRoute(
                                    builder: (context) => DonasiDetailPage(donasi: donasi),
                                  ),
                                );
                                setState(() => _loadDonasi());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            SlidePageRoute(builder: (context) => const DonasiAddPage()),
          );
          setState(() => _loadDonasi());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
