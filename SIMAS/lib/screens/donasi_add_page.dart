import 'package:flutter/material.dart';
import '../data/models/donasi_model.dart';
import '../data/services/donasi_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';

class DonasiAddPage extends StatefulWidget {
  const DonasiAddPage({super.key});

  @override
  State<DonasiAddPage> createState() => _DonasiAddPageState();
}

class _DonasiAddPageState extends State<DonasiAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaJamaahController = TextEditingController();
  final _nominalController = TextEditingController();
  final _keteranganController = TextEditingController();

  String _tipe = 'Infaq';
  String _tujuan = 'Pembangunan';
  String _metodeTransfer = 'Tunai';

  @override
  void dispose() {
    _namaJamaahController.dispose();
    _nominalController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _addDonasi() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final newDonasi = Donasi(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        namaJamaah: _namaJamaahController.text.trim(),
        tipe: _tipe,
        nominal: int.parse(_nominalController.text),
        tujuan: _tujuan,
        tanggal: DateTime.now(),
        status: 'Masuk',
        metodeTransfer: _metodeTransfer,
        keterangan: _keteranganController.text.isEmpty ? null : _keteranganController.text,
      );

      await DonasiService().add(newDonasi);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donasi berhasil ditambahkan'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
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
        title: const Text('Tambah Donasi'),
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
                value: _tujuan,
                decoration: const InputDecoration(
                  labelText: 'Tujuan Donasi',
                  prefixIcon: Icon(Icons.flag),
                ),
                items: ['Pembangunan', 'Sosial', 'Kesehatan', 'Pendidikan', 'Lainnya']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _tujuan = value ?? 'Pembangunan');
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
                  onPressed: _addDonasi,
                  child: const Text('Tambah Donasi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
