import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/donasi_model.dart';
import '../data/services/donasi_service.dart';
import '../data/services/donasi_laporan_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import 'donasi_edit_page.dart';

class DonasiDetailPage extends StatefulWidget {
  final Donasi donasi;

  const DonasiDetailPage({super.key, required this.donasi});

  @override
  State<DonasiDetailPage> createState() => _DonasiDetailPageState();
}

class _DonasiDetailPageState extends State<DonasiDetailPage> {
  late Donasi _donasi;

  @override
  void initState() {
    super.initState();
    _donasi = widget.donasi;
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

  Future<void> _updateStatus(String newStatus) async {
    final updated = _donasi.copyWith(status: newStatus);
    await DonasiService().update(updated);
    setState(() => _donasi = updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Status berhasil diperbarui'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _deleteDonasi() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Donasi?'),
        content: const Text('Data donasi akan dihapus permanen'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await DonasiService().delete(_donasi.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donasi berhasil dihapus')),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Donasi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuat laporan...')),
              );

              final result = await DonasiLaporanService.exportDonasiCSV([_donasi]);

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
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Edit'),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DonasiEditPage(donasi: _donasi),
                    ),
                  );

                  if (result == true) {
                    if (!mounted) return;
                    Navigator.pop(context, true);
                  }
                },
              ),
              PopupMenuItem(
                child: const Text('Hapus'),
                onTap: _deleteDonasi,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: _getStatusColor(_donasi.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: _getStatusColor(_donasi.status),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(_donasi.status),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Text(
                          _donasi.status,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: ['Masuk', 'Diproses', 'Selesai']
                        .where((s) => s != _donasi.status)
                        .map((status) => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.background,
                                foregroundColor: AppColors.textSecondary,
                              ),
                              onPressed: () => _updateStatus(status),
                              child: Text(status),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Nominal
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nominal Donasi',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    formatCurrency(_donasi.nominal),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Donatur Section
            const Text(
              'Data Donatur',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(
              icon: Icons.person,
              label: 'Nama',
              value: _donasi.namaJamaah,
            ),
            const SizedBox(height: AppSpacing.md),

            // Donasi Section
            const Text(
              'Data Donasi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(
              icon: Icons.category,
              label: 'Jenis Donasi',
              value: _donasi.tipe,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(
              icon: Icons.flag,
              label: 'Tujuan',
              value: _donasi.tujuan,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(
              icon: Icons.payment,
              label: 'Metode Transfer',
              value: _donasi.metodeTransfer,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(
              icon: Icons.calendar_today,
              label: 'Tanggal',
              value: dateFormat.format(_donasi.tanggal),
            ),
            if (_donasi.keterangan != null && _donasi.keterangan!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              _buildDetailCard(
                icon: Icons.notes,
                label: 'Keterangan',
                value: _donasi.keterangan!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
