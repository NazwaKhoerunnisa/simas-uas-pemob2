import 'package:flutter/material.dart';
import '../data/models/qurban_model.dart';
import '../data/services/qurban_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';

class QurbanEditPage extends StatefulWidget {
  final Qurban qurban;

  const QurbanEditPage({super.key, required this.qurban});

  @override
  State<QurbanEditPage> createState() => _QurbanEditPageState();
}

class _QurbanEditPageState extends State<QurbanEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaJamaahController;
  late TextEditingController _nomorIndukController;
  late TextEditingController _jumlahController;
  late String _jenisHewan;
  late String _kondisi;

  @override
  void initState() {
    super.initState();
    _namaJamaahController = TextEditingController(text: widget.qurban.namaJamaah);
    _nomorIndukController = TextEditingController(text: widget.qurban.nomorInduk);
    _jumlahController = TextEditingController(text: widget.qurban.jumlah.toString());
    _jenisHewan = widget.qurban.jenisHewan;
    _kondisi = widget.qurban.kondisi;
  }

  @override
  void dispose() {
    _namaJamaahController.dispose();
    _nomorIndukController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _updateQurban() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final updatedQurban = widget.qurban.copyWith(
        namaJamaah: _namaJamaahController.text.trim(),
        jenisHewan: _jenisHewan,
        jumlah: int.parse(_jumlahController.text),
        nomorInduk: _nomorIndukController.text.trim(),
        kondisi: _kondisi,
      );

      await QurbanService().update(updatedQurban);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Qurban berhasil diperbarui'),
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
        title: const Text('Edit Qurban'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Jamaah',
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
                'Data Hewan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                value: _jenisHewan,
                decoration: const InputDecoration(
                  labelText: 'Jenis Hewan',
                  prefixIcon: Icon(Icons.agriculture),
                ),
                items: ['Sapi', 'Kambing', 'Domba']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _jenisHewan = value ?? 'Sapi');
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _jumlahController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  hintText: '1',
                  prefixIcon: Icon(Icons.numbers),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Jumlah harus angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _nomorIndukController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Induk',
                  hintText: 'Contoh: Q-001-2024',
                  prefixIcon: Icon(Icons.tag),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor induk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                value: _kondisi,
                decoration: const InputDecoration(
                  labelText: 'Kondisi Hewan',
                  prefixIcon: Icon(Icons.health_and_safety),
                ),
                items: ['Sehat', 'Kurang sehat']
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _kondisi = value ?? 'Sehat');
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateQurban,
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
