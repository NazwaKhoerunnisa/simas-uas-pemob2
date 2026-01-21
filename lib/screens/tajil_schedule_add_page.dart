import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/models/ramadhan_model.dart';
import '../data/services/ramadhan_service.dart';
import '../core/constants/app_spacing.dart';

class TajilScheduleAddPage extends StatefulWidget {
  final TajilSchedule? tajilSchedule;

  const TajilScheduleAddPage({super.key, this.tajilSchedule});

  @override
  State<TajilScheduleAddPage> createState() => _TajilScheduleAddPageState();
}

class _TajilScheduleAddPageState extends State<TajilScheduleAddPage> {
  late TextEditingController _hariController;
  late TextEditingController _jamaahController;
  late TextEditingController _keteranganController;
  
  DateTime _tanggalMasehi = DateTime.now();
  final _service = RamadhanService();
  List<String> _jamaahList = [];

  @override
  void initState() {
    super.initState();
    _hariController = TextEditingController(text: widget.tajilSchedule?.hari.toString() ?? '');
    _jamaahController = TextEditingController();
    _keteranganController = TextEditingController(text: widget.tajilSchedule?.keterangan ?? '');
    
    if (widget.tajilSchedule != null) {
      _tanggalMasehi = widget.tajilSchedule!.tanggalMasehi;
      _jamaahList = List.from(widget.tajilSchedule!.jamaah);
    }
  }

  @override
  void dispose() {
    _hariController.dispose();
    _jamaahController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalMasehi,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() => _tanggalMasehi = picked);
    }
  }

  void _addJamaah() {
    if (_jamaahController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama jamaah tidak boleh kosong')),
      );
      return;
    }
    
    setState(() {
      _jamaahList.add(_jamaahController.text);
      _jamaahController.clear();
    });
  }

  void _removeJamaah(int index) {
    setState(() {
      _jamaahList.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (_hariController.text.isEmpty || _jamaahList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hari dan minimal 1 jamaah harus diisi')),
      );
      return;
    }

    try {
      final hari = int.parse(_hariController.text);
      if (hari < 1 || hari > 30) {
        throw 'Hari harus antara 1-30';
      }

      final tajilSchedule = TajilSchedule(
        id: widget.tajilSchedule?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        hari: hari,
        bulanHijri: 9,
        tanggalMasehi: _tanggalMasehi,
        jamaah: _jamaahList,
        keterangan: _keteranganController.text.isEmpty ? null : _keteranganController.text,
      );

      if (widget.tajilSchedule == null) {
        await _service.createTajilSchedule(tajilSchedule);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Jadwal Ta'jil berhasil ditambahkan")),
        );
      } else {
        await _service.updateTajilSchedule(tajilSchedule);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Jadwal Ta'jil berhasil diperbarui")),
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
        title: Text(widget.tajilSchedule == null ? "Tambah Jadwal Ta'jil" : "Edit Jadwal Ta'jil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            TextFormField(
              controller: _hariController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Hari Ramadhan (1-30)',
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
                    Text(DateFormat('dd MMMM yyyy', 'id_ID').format(_tanggalMasehi)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Daftar Jamaah',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _jamaahController,
                    decoration: InputDecoration(
                      hintText: 'Nama jamaah',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                ElevatedButton.icon(
                  onPressed: _addJamaah,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (_jamaahList.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Text('Belum ada jamaah'),
              )
            else
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _jamaahList.length,
                  separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(_jamaahList[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeJamaah(index),
                      ),
                    );
                  },
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
                child: Text(widget.tajilSchedule == null ? "Tambah Jadwal Ta'jil" : 'Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
