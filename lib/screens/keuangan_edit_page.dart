import 'package:flutter/material.dart';
import '../data/models/keuangan_model.dart';
import '../data/services/keuangan_service.dart';

class KeuanganEditPage extends StatefulWidget {
  final Keuangan keuangan;
  const KeuanganEditPage({super.key, required this.keuangan});

  @override
  State<KeuanganEditPage> createState() => _KeuanganEditPageState();
}

class _KeuanganEditPageState extends State<KeuanganEditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController tanggalC;
  late TextEditingController kategoriC;
  late TextEditingController nominalC;
  late TextEditingController keteranganC;

  late String tipe;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tanggalC = TextEditingController(text: widget.keuangan.tanggal);
    kategoriC = TextEditingController(text: widget.keuangan.kategori);
    nominalC = TextEditingController(text: widget.keuangan.nominal);
    keteranganC = TextEditingController(text: widget.keuangan.keterangan);
    tipe = widget.keuangan.tipe;
  }

  void update() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        Keuangan data = Keuangan(
          id: widget.keuangan.id,
          tanggal: tanggalC.text,
          tipe: tipe,
          kategori: kategoriC.text,
          nominal: nominalC.text,
          keterangan: keteranganC.text,
        );

        await KeuanganService().update(data);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Keuangan berhasil diperbarui'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void hapus() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Keuangan'),
        content: const Text('Yakin ingin menghapus data keuangan ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isLoading = true);
    try {
      await KeuanganService().delete(widget.keuangan.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Keuangan berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Keuangan'),
        actions: [
          IconButton(
            onPressed: hapus,
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              TextFormField(
                controller: tanggalC,
                decoration: const InputDecoration(labelText: 'Tanggal'),
                validator: (v) => v!.isEmpty ? 'Tidak boleh kosong' : null,
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField(
                value: tipe,
                items: const [
                  DropdownMenuItem(value: 'pemasukan', child: Text('Pemasukan')),
                  DropdownMenuItem(value: 'pengeluaran', child: Text('Pengeluaran')),
                ],
                onChanged: (value) {
                  setState(() {
                    tipe = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Tipe'),
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: kategoriC,
                decoration: const InputDecoration(labelText: 'Kategori'),
                validator: (v) => v!.isEmpty ? 'Tidak boleh kosong' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: nominalC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal'),
                validator: (v) => v!.isEmpty ? 'Tidak boleh kosong' : null,
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: keteranganC,
                decoration: const InputDecoration(labelText: 'Keterangan'),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: isLoading ? null : update,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('UPDATE'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
