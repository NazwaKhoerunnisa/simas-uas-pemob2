import 'package:flutter/material.dart';
import '../data/models/qurban_model.dart';
import '../data/services/qurban_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';

class QurbanAddPage extends StatefulWidget {
  const QurbanAddPage({super.key});

  @override
  State<QurbanAddPage> createState() => _QurbanAddPageState();
}

class _QurbanAddPageState extends State<QurbanAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaJamaahController = TextEditingController();
  final _nomorIndukController = TextEditingController();
  final _jumlahController = TextEditingController(text: '1');
  String _jenisHewan = 'Sapi';
  String _kondisi = 'Sehat';

  @override
  void dispose() {
    _namaJamaahController.dispose();
    _nomorIndukController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  Future<void> _addQurban() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final newQurban = Qurban(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        namaJamaah: _namaJamaahController.text.trim(),
        jenisHewan: _jenisHewan,
        jumlah: int.parse(_jumlahController.text),
        nomorInduk: _nomorIndukController.text.trim(),
        kondisi: _kondisi,
        tanggalPendaftaran: DateTime.now(),
        status: 'Menunggu',
      );

      await QurbanService().add(newQurban);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Qurban berhasil ditambahkan'),
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
        title: const Text('Tambah Qurban'),
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
                  onPressed: _addQurban,
                  child: const Text('Tambah Qurban'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
