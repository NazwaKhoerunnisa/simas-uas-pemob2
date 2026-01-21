import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/ramadhan_model.dart';
import '../data/services/ramadhan_service.dart';
import '../core/constants/app_spacing.dart';

class ZakatMalAddPage extends StatefulWidget {
  final ZakatMal? zakatMal;

  const ZakatMalAddPage({super.key, this.zakatMal});

  @override
  State<ZakatMalAddPage> createState() => _ZakatMalAddPageState();
}

class _ZakatMalAddPageState extends State<ZakatMalAddPage> {
  late TextEditingController _namaController;
  late TextEditingController _nominalDanaController;
  late TextEditingController _gramEmasController;
  late TextEditingController _keteranganController;
  
  DateTime _tanggal = DateTime.now();
  final _service = RamadhanService();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.zakatMal?.namaJamaah ?? '');
    _nominalDanaController = TextEditingController(text: widget.zakatMal?.nominalDana.toString() ?? '');
    _gramEmasController = TextEditingController(text: widget.zakatMal?.gramEmas.toString() ?? '');
    _keteranganController = TextEditingController(text: widget.zakatMal?.keterangan ?? '');
    
    if (widget.zakatMal != null) {
      _tanggal = widget.zakatMal!.tanggal;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nominalDanaController.dispose();
    _gramEmasController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() => _tanggal = picked);
    }
  }

  Future<void> _submit() async {
    if (_namaController.text.isEmpty || _nominalDanaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field yang diperlukan')),
      );
      return;
    }

    try {
      final zakatMal = ZakatMal(
        id: widget.zakatMal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        namaJamaah: _namaController.text,
        tanggal: _tanggal,
        nominalDana: int.parse(_nominalDanaController.text),
        gramEmas: int.tryParse(_gramEmasController.text) ?? 0,
        status: 'Belum',
        keterangan: _keteranganController.text.isEmpty ? null : _keteranganController.text,
      );

      if (widget.zakatMal == null) {
        await _service.createZakatMal(zakatMal);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zakat Mal berhasil ditambahkan')),
        );
      } else {
        await _service.updateZakatMal(zakatMal);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zakat Mal berhasil diperbarui')),
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.zakatMal == null ? 'Tambah Zakat Mal' : 'Edit Zakat Mal'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            TextFormField(
              controller: _namaController,
              decoration: InputDecoration(
                labelText: 'Nama Jamaah',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _nominalDanaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nominal Dana',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _gramEmasController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Gram Emas (opsional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Tanggal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('dd MMMM yyyy', 'id_ID').format(_tanggal)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _keteranganController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Keterangan (opsional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: Text(widget.zakatMal == null ? 'Tambah' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
