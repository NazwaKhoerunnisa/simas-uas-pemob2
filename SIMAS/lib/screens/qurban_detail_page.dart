import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/qurban_model.dart';
import '../data/services/qurban_service.dart';
import '../data/services/qurban_laporan_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import 'qurban_edit_page.dart';

class QurbanDetailPage extends StatefulWidget {
  final Qurban qurban;

  const QurbanDetailPage({super.key, required this.qurban});

  @override
  State<QurbanDetailPage> createState() => _QurbanDetailPageState();
}

class _QurbanDetailPageState extends State<QurbanDetailPage> {
  late Qurban _qurban;

  @override
  void initState() {
    super.initState();
    _qurban = widget.qurban;
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

  Future<void> _updateStatus(String newStatus) async {
    final updated = _qurban.copyWith(
      status: newStatus,
      tanggalPenyembelihan: newStatus == 'Disembelih' ? DateTime.now() : _qurban.tanggalPenyembelihan,
    );

    await QurbanService().update(updated);
    setState(() => _qurban = updated);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Status berhasil diperbarui'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _deleteQurban() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Qurban?'),
        content: const Text('Data qurban akan dihapus permanen'),
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
      await QurbanService().delete(_qurban.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Qurban berhasil dihapus')),
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
        title: const Text('Detail Qurban'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Membuat laporan...')),
              );

              final result = await QurbanLaporanService.exportQurbanCSV([_qurban]);

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
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Edit'),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QurbanEditPage(qurban: _qurban),
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
                onTap: _deleteQurban,
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
                color: _getStatusColor(_qurban.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: _getStatusColor(_qurban.status),
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
                          color: _getStatusColor(_qurban.status),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                        ),
                        child: Text(
                          _qurban.status,
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
                    children: ['Menunggu', 'Disembelih', 'Selesai']
                        .where((s) => s != _qurban.status)
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

            // Jamaah Section
            const Text(
              'Data Jamaah',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(
              icon: Icons.person,
              label: 'Nama',
              value: _qurban.namaJamaah,
            ),
            const SizedBox(height: AppSpacing.md),

            // Hewan Section
            const Text(
              'Data Hewan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(
              icon: Icons.agriculture,
              label: 'Jenis Hewan',
              value: _qurban.jenisHewan,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(
              icon: Icons.numbers,
              label: 'Jumlah',
              value: '${_qurban.jumlah} ekor',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(
              icon: Icons.tag,
              label: 'Nomor Induk',
              value: _qurban.nomorInduk,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(
              icon: _qurban.kondisi == 'Sehat' ? Icons.health_and_safety : Icons.warning,
              label: 'Kondisi',
              value: _qurban.kondisi,
              iconColor: _qurban.kondisi == 'Sehat' ? AppColors.success : AppColors.warning,
            ),
            const SizedBox(height: AppSpacing.md),

            // Tanggal Section
            const Text(
              'Tanggal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailCard(
              icon: Icons.calendar_today,
              label: 'Pendaftaran',
              value: dateFormat.format(_qurban.tanggalPendaftaran),
            ),
            if (_qurban.tanggalPenyembelihan != null) ...[
              const SizedBox(height: AppSpacing.md),
              _buildDetailCard(
                icon: Icons.check_circle,
                label: 'Penyembelihan',
                value: dateFormat.format(_qurban.tanggalPenyembelihan!),
                iconColor: AppColors.success,
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
    Color? iconColor,
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
            color: iconColor ?? AppColors.primary,
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
