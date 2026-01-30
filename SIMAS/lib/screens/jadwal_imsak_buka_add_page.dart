import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/ramadhan_model.dart';
import '../data/services/ramadhan_service.dart';
import '../core/constants/app_spacing.dart';

class JadwalImsakBukaAddPage extends StatefulWidget {
  final JadwalImsakBuka? jadwalImsakBuka;

  const JadwalImsakBukaAddPage({super.key, this.jadwalImsakBuka});

  @override
  State<JadwalImsakBukaAddPage> createState() => _JadwalImsakBukaAddPageState();
}

class _JadwalImsakBukaAddPageState extends State<JadwalImsakBukaAddPage> {
  late TextEditingController _hariController;
  late TextEditingController _waktuImsakController;
  late TextEditingController _waktuBukaController;
  late TextEditingController _keteranganController;

  DateTime _tanggal = DateTime.now();
  final _service = RamadhanService();

  @override
  void initState() {
    super.initState();
    _hariController = TextEditingController(
      text: widget.jadwalImsakBuka?.hari.toString() ?? '',
    );
    _waktuImsakController = TextEditingController(
      text: widget.jadwalImsakBuka?.waktuImsak ?? '',
    );
    _waktuBukaController = TextEditingController(
      text: widget.jadwalImsakBuka?.waktuBuka ?? '',
    );
    _keteranganController = TextEditingController(
      text: widget.jadwalImsakBuka?.keterangan ?? '',
    );

    if (widget.jadwalImsakBuka != null) {
      _tanggal = widget.jadwalImsakBuka!.tanggalMasehi;
    }
  }

  @override
  void dispose() {
    _hariController.dispose();
    _waktuImsakController.dispose();
    _waktuBukaController.dispose();
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

  Future<void> _selectTime(TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _submit() async {
    if (_hariController.text.isEmpty ||
        _waktuImsakController.text.isEmpty ||
        _waktuBukaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua field yang diperlukan')),
      );
      return;
    }

    final hari = int.tryParse(_hariController.text);
    if (hari == null || hari < 1 || hari > 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hari harus antara 1-30')),
      );
      return;
    }

    try {
      final jadwal = JadwalImsakBuka(
        id: widget.jadwalImsakBuka?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        hari: hari,
        bulanHijri: 9,
        tanggalMasehi: _tanggal,
        waktuImsak: _waktuImsakController.text,
        waktuBuka: _waktuBukaController.text,
        keterangan:
            _keteranganController.text.isEmpty ? null : _keteranganController.text,
      );

      if (widget.jadwalImsakBuka == null) {
        await _service.createJadwalImsakBuka(jadwal);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal Imsak & Buka berhasil ditambahkan')),
        );
      } else {
        await _service.updateJadwalImsakBuka(jadwal);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal Imsak & Buka berhasil diperbarui')),
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
        title: Text(widget.jadwalImsakBuka == null
            ? 'Tambah Jadwal Imsak & Buka'
            : 'Edit Jadwal Imsak & Buka'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            TextFormField(
              controller: _hariController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Hari (1-30)',
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
            InkWell(
              onTap: () => _selectTime(_waktuImsakController),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Waktu Imsak',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_waktuImsakController.text.isEmpty
                        ? 'Pilih waktu'
                        : _waktuImsakController.text),
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            InkWell(
              onTap: () => _selectTime(_waktuBukaController),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Waktu Buka Puasa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_waktuBukaController.text.isEmpty
                        ? 'Pilih waktu'
                        : _waktuBukaController.text),
                    const Icon(Icons.access_time),
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
                child: Text(widget.jadwalImsakBuka == null ? 'Tambah' : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
