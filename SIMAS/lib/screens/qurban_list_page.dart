import 'package:flutter/material.dart';
import '../core/utils/animated_navigation.dart';
import '../data/services/qurban_service.dart';
import '../data/services/qurban_laporan_service.dart';
import '../data/models/qurban_model.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import 'qurban_add_page.dart';
import 'qurban_detail_page.dart';

class QurbanListPage extends StatefulWidget {
  const QurbanListPage({super.key});

  @override
  State<QurbanListPage> createState() => _QurbanListPageState();
}

class _QurbanListPageState extends State<QurbanListPage> {
  late Future<List<Qurban>> qurbanFuture;

  @override
  void initState() {
    super.initState();
    _loadQurban();
  }

  void _loadQurban() {
    qurbanFuture = QurbanService().fetchAll();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return AppColors.warning;
      case 'Disembelih':
        return AppColors.info;
      case 'Selesai':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Program Qurban'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final qurbanList = await qurbanFuture;
              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuat laporan...')),
              );

              final result = await QurbanLaporanService.exportQurbanCSV(qurbanList);

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
                      title: const Text('Laporan Qurban'),
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
      body: FutureBuilder<List<Qurban>>(
        future: qurbanFuture,
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
                      setState(() => _loadQurban());
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final qurbanList = snapshot.data ?? [];

          if (qurbanList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.agriculture, size: 64, color: AppColors.primary.withOpacity(0.5)),
                  const SizedBox(height: AppSpacing.lg),
                  const Text('Belum ada data qurban'),
                  const SizedBox(height: AppSpacing.lg),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        SlidePageRoute(builder: (context) => const QurbanAddPage()),
                      );
                      setState(() => _loadQurban());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Qurban'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: qurbanList.length,
            itemBuilder: (context, index) {
              final qurban = qurbanList[index];
              return GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    SlidePageRoute(
                      builder: (context) => QurbanDetailPage(qurban: qurban),
                    ),
                  );
                  setState(() => _loadQurban());
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
                                    qurban.namaJamaah,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.sm),
                                  Text(
                                    '${qurban.jenisHewan} (${qurban.jumlah} ekor)',
                                    style: const TextStyle(
                                      fontSize: 14,
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
                                color: _getStatusColor(qurban.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              ),
                              child: Text(
                                qurban.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(qurban.status),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.tag, size: 18, color: AppColors.textSecondary),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    qurban.nomorInduk,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    qurban.kondisi == 'Sehat' ? Icons.health_and_safety : Icons.warning,
                                    size: 18,
                                    color: qurban.kondisi == 'Sehat' ? AppColors.success : AppColors.warning,
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    qurban.kondisi,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: qurban.kondisi == 'Sehat' ? AppColors.success : AppColors.warning,
                                    ),
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
                                    builder: (context) => QurbanDetailPage(qurban: qurban),
                                  ),
                                );
                                setState(() => _loadQurban());
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
            SlidePageRoute(builder: (context) => const QurbanAddPage()),
          );
          setState(() => _loadQurban());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
