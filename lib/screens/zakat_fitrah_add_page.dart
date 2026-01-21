import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/ramadhan_model.dart';
import '../data/services/ramadhan_service.dart';
import '../core/constants/app_spacing.dart';

class ZakatFitrahAddPage extends StatefulWidget {
  final ZakatFitrah? zakatFitrah;

  const ZakatFitrahAddPage({super.key, this.zakatFitrah});

  @override
  State<ZakatFitrahAddPage> createState() => _ZakatFitrahAddPageState();
}

class _ZakatFitrahAddPageState extends State<ZakatFitrahAddPage> {
  late TextEditingController _namaController;
  late TextEditingController _jumlahJiwaController;
  late TextEditingController _nominalController;
  late TextEditingController _gramController;
  late TextEditingController _keteranganController;
  
  String _jenisZakat = 'Beras';
  DateTime _tanggal = DateTime.now();
  final _service = RamadhanService();

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.zakatFitrah?.namaJamaah ?? '');
    _jumlahJiwaController = TextEditingController(text: widget.zakatFitrah?.jumlahJiwa.toString() ?? '');
    _nominalController = TextEditingController(text: widget.zakatFitrah?.nominal.toString() ?? '');
    _gramController = TextEditingController(text: widget.zakatFitrah?.gram.toString() ?? '');
    _keteranganController = TextEditingController(text: widget.zakatFitrah?.keterangan ?? '');
    
    if (widget.zakatFitrah != null) {
      _jenisZakat = widget.zakatFitrah!.jenisZakat;
      _tanggal = widget.zakatFitrah!.tanggal;
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahJiwaController.dispose();
    _nominalController.dispose();
    _gramController.dispose();
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
    if (_namaController.text.isEmpty || _jumlahJiwaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field yang diperlukan')),
      );
      return;
    }

    // Validasi nominal atau gram tergantung jenis zakat
    if (_jenisZakat == 'Uang' && _nominalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nominal untuk jenis Uang')),
      );
      return;
    }

    if ((_jenisZakat == 'Beras' || _jenisZakat == 'Daging') && _gramController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan gram untuk jenis Beras/Daging')),
      );
      return;
    }

    try {
      final zakatFitrah = ZakatFitrah(
        id: widget.zakatFitrah?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        namaJamaah: _namaController.text,
        tanggal: _tanggal,
        jumlahJiwa: int.parse(_jumlahJiwaController.text),
        jenisZakat: _jenisZakat,
        nominal: _jenisZakat == 'Uang' ? int.parse(_nominalController.text) : 0,
        gram: (_jenisZakat == 'Beras' || _jenisZakat == 'Daging') ? int.parse(_gramController.text) : 0,
        status: 'Belum',
        keterangan: _keteranganController.text.isEmpty ? null : _keteranganController.text,
      );

      if (widget.zakatFitrah == null) {
        await _service.createZakatFitrah(zakatFitrah);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zakat Fitrah berhasil ditambahkan')),
        );
      } else {
        await _service.updateZakatFitrah(zakatFitrah);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Zakat Fitrah berhasil diperbarui')),
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
        title: Text(widget.zakatFitrah == null ? 'Tambah Zakat Fitrah' : 'Edit Zakat Fitrah'),
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
              controller: _jumlahJiwaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Jumlah Jiwa',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<String>(
              value: _jenisZakat,
              decoration: InputDecoration(
                labelText: 'Jenis Zakat',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
              ),
              items: ['Beras', 'Uang', 'Daging']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) => setState(() => _jenisZakat = value!),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (_jenisZakat == 'Uang')
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nominal (Rp)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
              )
            else
              TextFormField(
                controller: _gramController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Gram',
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
                child: Text(widget.zakatFitrah == null ? 'Tambah' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
