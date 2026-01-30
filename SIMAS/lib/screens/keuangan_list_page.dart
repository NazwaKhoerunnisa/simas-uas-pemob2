import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../core/utils/animated_navigation.dart';
import '../data/models/keuangan_model.dart';
import '../data/services/keuangan_service.dart';
import '../data/services/laporan_service.dart';
import 'keuangan_add_page.dart';
import 'keuangan_edit_page.dart';

class KeuanganListPage extends StatefulWidget {
  const KeuanganListPage({super.key});

  @override
  State<KeuanganListPage> createState() => _KeuanganListPageState();
}

class _KeuanganListPageState extends State<KeuanganListPage> {
  late Future<List<Keuangan>> listKeuangan;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  void refreshData() {
    listKeuangan = KeuanganService().fetchAll();
  }

  int hitungTotal(List<Keuangan> data, String tipe) {
    return data
        .where((e) => e.tipe.toLowerCase() == tipe.toLowerCase())
        .fold(0, (sum, item) => sum + (int.tryParse(item.nominal) ?? 0));
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
        title: const Text('Keuangan Masjid'),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Unduh Laporan CSV',
            onPressed: () async {
              try {
                final keuanganList = await listKeuangan;
                if (keuanganList.isEmpty) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tidak ada data untuk diunduh'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                  return;
                }

                // Tampilkan loading
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Membuat laporan...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }

                final message = await LaporanService.exportKeuanganCSV(
                  keuanganList,
                );

                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Laporan Keuangan'),
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Error'),
                      content: Text('Gagal membuat laporan:\n${e.toString()}'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            SlidePageRoute(builder: (_) => const KeuanganAddPage()),
          );
          if (result == true) {
            setState(() {
              refreshData();
            });
          }
        },
      ),
      body: FutureBuilder<List<Keuangan>>(
        future: listKeuangan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wallet,
                    size: 64,
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'Belum ada data keuangan',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          final totalMasuk = hitungTotal(data, 'pemasukan');
          final totalKeluar = hitungTotal(data, 'pengeluaran');
          final saldo = totalMasuk - totalKeluar;

          return SingleChildScrollView(
            child: Column(
              children: [
                // 📊 STATISTIK HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.lg,
                    AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Saldo Anda',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                formatCurrency(saldo),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 📊 STATISTIK CARDS (RESPONSIVE)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Jika lebar < 600, gunakan 2 kolom atau scroll horizontal
                      bool isSmall = constraints.maxWidth < 600;

                      if (isSmall) {
                        // Untuk mobile: 2 card di atas, 1 card di bawah
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    title: 'Pemasukan',
                                    value: formatCurrency(totalMasuk),
                                    icon: Icons.trending_up,
                                    backgroundColor: AppColors.success
                                        .withOpacity(0.1),
                                    iconColor: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: _buildStatCard(
                                    title: 'Pengeluaran',
                                    value: formatCurrency(totalKeluar),
                                    icon: Icons.trending_down,
                                    backgroundColor: AppColors.error
                                        .withOpacity(0.1),
                                    iconColor: AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            _buildStatCard(
                              title: 'Selisih Rata-rata',
                              value: formatCurrency(
                                (saldo / (data.length > 0 ? data.length : 1))
                                    .toInt(),
                              ),
                              icon: Icons.account_balance_wallet,
                              backgroundColor: AppColors.info.withOpacity(0.1),
                              iconColor: AppColors.info,
                            ),
                          ],
                        );
                      } else {
                        // Untuk tablet/desktop: 3 card dalam satu baris
                        return Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                title: 'Pemasukan',
                                value: formatCurrency(totalMasuk),
                                icon: Icons.trending_up,
                                backgroundColor: AppColors.success.withOpacity(
                                  0.1,
                                ),
                                iconColor: AppColors.success,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _buildStatCard(
                                title: 'Pengeluaran',
                                value: formatCurrency(totalKeluar),
                                icon: Icons.trending_down,
                                backgroundColor: AppColors.error.withOpacity(
                                  0.1,
                                ),
                                iconColor: AppColors.error,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: _buildStatCard(
                                title: 'Selisih',
                                value: formatCurrency(
                                  (saldo / (data.length > 0 ? data.length : 1))
                                      .toInt(),
                                ),
                                icon: Icons.account_balance_wallet,
                                backgroundColor: AppColors.info.withOpacity(
                                  0.1,
                                ),
                                iconColor: AppColors.info,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),

                // 📋 LIST TRANSAKSI
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Riwayat Transaksi (${data.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),

                ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    final isMasuk = item.tipe.toLowerCase() == 'pemasukan';

                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
                        border: Border.all(
                          color: (isMasuk ? AppColors.success : AppColors.error)
                              .withOpacity(0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                (isMasuk ? AppColors.success : AppColors.error)
                                    .withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              SlidePageRoute(
                                builder: (_) =>
                                    KeuanganEditPage(keuangan: item),
                              ),
                            );
                            if (result == true) {
                              print('Hasil update = true, refresh data...');
                              setState(() {
                                listKeuangan = KeuanganService().fetchAll();
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusLg,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color:
                                        (isMasuk
                                                ? AppColors.success
                                                : AppColors.error)
                                            .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(
                                      AppSpacing.radiusMd,
                                    ),
                                  ),
                                  child: Icon(
                                    isMasuk
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: isMasuk
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.kategori,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.tanggal,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.keterangan,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatCurrency(
                                        int.tryParse(item.nominal) ?? 0,
                                      ),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: isMasuk
                                            ? AppColors.success
                                            : AppColors.error,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isMasuk ? 'Masuk' : 'Keluar',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isMasuk
                                            ? AppColors.success
                                            : AppColors.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: iconColor.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
