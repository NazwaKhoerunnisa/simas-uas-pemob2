import 'package:flutter/material.dart';
import '../data/models/donasi_model.dart';
import '../data/services/donasi_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';

class DonasiEditPage extends StatefulWidget {
  final Donasi donasi;

  const DonasiEditPage({super.key, required this.donasi});

  @override
  State<DonasiEditPage> createState() => _DonasiEditPageState();
}

class _DonasiEditPageState extends State<DonasiEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaJamaahController;
  late TextEditingController _nominalController;
  late TextEditingController _keteranganController;

  late String _tipe;
  late String _tujuan;

  final List<String> _tujuanOptions = ['Pembangunan', 'Sosial', 'Kesehatan', 'Pendidikan', 'Lainnya', 'Pembangunan Masjid', 'Pemberdayaan Anak Yatim', 'Sosial Kemasyarakatan', 'Kesehatan Jamaah', 'Pembangunan Perpustakaan'];
  late String _metodeTransfer;

  @override
  void initState() {
    super.initState();
    _namaJamaahController = TextEditingController(text: widget.donasi.namaJamaah);
    _nominalController = TextEditingController(text: widget.donasi.nominal.toString());
    _keteranganController = TextEditingController(text: widget.donasi.keterangan ?? '');
    _tipe = widget.donasi.tipe;
    _tujuan = widget.donasi.tujuan;
    _metodeTransfer = widget.donasi.metodeTransfer;
  }

  @override
  void dispose() {
    _namaJamaahController.dispose();
    _nominalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _updateDonasi() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final updatedDonasi = widget.donasi.copyWith(
        namaJamaah: _namaJamaahController.text.trim(),
        tipe: _tipe,
        nominal: int.parse(_nominalController.text),
        tujuan: _tujuan,
        metodeTransfer: _metodeTransfer,
        keterangan: _keteranganController.text.isEmpty ? null : _keteranganController.text,
      );

      await DonasiService().update(updatedDonasi);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donasi berhasil diperbarui'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Donasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Donatur',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _namaJamaahController,
                decoration: const InputDecoration(
                  labelText: 'Nama Jamaah',
                  hintText: 'Masukkan nama jamaah',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Data Donasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                value: _tipe,
                decoration: const InputDecoration(
                  labelText: 'Jenis Donasi',
                  prefixIcon: Icon(Icons.category),
                ),
                items: ['Infaq', 'Sedekah', 'Zakat', 'Hibah']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _tipe = value ?? 'Infaq');
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _nominalController,
                decoration: const InputDecoration(
                  labelText: 'Nominal',
                  hintText: '100000',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Nominal harus angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                value: _tujuanOptions.contains(_tujuan) ? _tujuan : null,
                decoration: const InputDecoration(
                  labelText: 'Tujuan Donasi',
                  prefixIcon: Icon(Icons.flag),
                ),
                items: _tujuanOptions
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _tujuan = value ?? 'Pembangunan');
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tujuan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                value: _metodeTransfer,
                decoration: const InputDecoration(
                  labelText: 'Metode Transfer',
                  prefixIcon: Icon(Icons.payment),
                ),
                items: ['Tunai', 'Transfer', 'Cek']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _metodeTransfer = value ?? 'Tunai');
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(
                  labelText: 'Keterangan (Opsional)',
                  hintText: 'Catatan tambahan',
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateDonasi,
                  child: const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
