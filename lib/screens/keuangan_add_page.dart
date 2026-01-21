import 'package:flutter/material.dart';
import '../data/models/keuangan_model.dart';
import '../data/services/keuangan_service.dart';

class KeuanganAddPage extends StatefulWidget {
  const KeuanganAddPage({super.key});

  @override
  State<KeuanganAddPage> createState() => _KeuanganAddPageState();
}

class _KeuanganAddPageState extends State<KeuanganAddPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController tanggalC = TextEditingController();
  final TextEditingController kategoriC = TextEditingController();
  final TextEditingController nominalC = TextEditingController();
  final TextEditingController keteranganC = TextEditingController();

  String tipe = 'pemasukan';

  void simpan() async {
    if (_formKey.currentState!.validate()) {
      Keuangan data = Keuangan(
        id: '',
        tanggal: tanggalC.text,
        tipe: tipe,
        kategori: kategoriC.text,
        nominal: nominalC.text,
        keterangan: keteranganC.text,
      );

      await KeuanganService().create(data);

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Keuangan')),
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
                onPressed: simpan,
                child: const Text('SIMPAN'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
