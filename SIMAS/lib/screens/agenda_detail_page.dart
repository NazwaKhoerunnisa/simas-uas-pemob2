import 'package:flutter/material.dart';
import 'dart:convert';
import '../data/models/agenda_model.dart';
import '../data/services/agenda_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import 'agenda_edit_page.dart';

class AgendaDetailPage extends StatefulWidget {
  final Agenda agenda;

  const AgendaDetailPage({super.key, required this.agenda});

  @override
  State<AgendaDetailPage> createState() => _AgendaDetailPageState();
}

class _AgendaDetailPageState extends State<AgendaDetailPage> {
  late Agenda currentAgenda;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentAgenda = widget.agenda;
  }

  Future<void> _refreshAgenda() async {
    setState(() => isLoading = true);
    try {
      final agendas = await AgendaService().fetchAgenda();
      final updated = agendas.firstWhere(
        (a) => a.id == currentAgenda.id,
        orElse: () => currentAgenda,
      );
      setState(() => currentAgenda = updated);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'terlaksana':
        return AppColors.success;
      case 'tidak_terlaksana':
        return AppColors.error;
      case 'akan_datang':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'terlaksana':
        return 'Terlaksana';
      case 'tidak_terlaksana':
        return 'Tidak Terlaksana';
      case 'akan_datang':
        return 'Akan Datang';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Agenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AgendaEditPage(agenda: currentAgenda),
                ),
              );

              if (result == true) {
                await _refreshAgenda();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Hapus Agenda'),
                  content: const Text('Yakin ingin menghapus agenda ini?'),
                  actions: [
                    TextButton(
                      child: const Text('Batal'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      child: const Text('Hapus'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await AgendaService().deleteAgenda(currentAgenda.id);
                Navigator.pop(context, true);
              }
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(currentAgenda.status),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Text(
                _getStatusLabel(currentAgenda.status),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Judul
            Text(
              currentAgenda.judul,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Tanggal
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpacing.md),
                Text(
                  currentAgenda.tanggal,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Deskripsi
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              ),
              child: Text(
                currentAgenda.deskripsi,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Dokumentasi (jika ada)
            if (currentAgenda.dokumentasi != null && currentAgenda.dokumentasi!.isNotEmpty) ...[
              const Text(
                'Dokumentasi Agenda',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  child: _buildDocumentationImage(currentAgenda.dokumentasi!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentationImage(String dokumentasi) {
    // Cek apakah dokumentasi adalah base64
    if (_isBase64(dokumentasi)) {
      try {
        final bytes = base64Decode(dokumentasi);
        return Image.memory(
          bytes,
          height: 250,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return _buildPlaceholder('Error loading image');
      }
    }
    // Cek apakah dokumentasi adalah URL
    else if (dokumentasi.startsWith('http://') || dokumentasi.startsWith('https://')) {
      return Image.network(
        dokumentasi,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder('Image not available');
        },
      );
    }
    // Jika plain text, tampilkan sebagai teks
    else {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Text(
          dokumentasi,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      );
    }
  }

  Widget _buildPlaceholder(String message) {
    return Container(
      height: 250,
      color: Colors.grey[100],
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  bool _isBase64(String str) {
    try {
      // Base64 hanya mengandung karakter tertentu
      if (str.isEmpty) return false;
      base64Decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }
}
