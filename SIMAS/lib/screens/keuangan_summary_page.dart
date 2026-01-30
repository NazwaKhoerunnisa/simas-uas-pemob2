import 'package:flutter/material.dart';
import '../data/models/keuangan_model.dart';
import '../data/services/keuangan_service.dart';

class KeuanganSummaryPage extends StatefulWidget {
  const KeuanganSummaryPage({super.key});

  @override
  State<KeuanganSummaryPage> createState() => _KeuanganSummaryPageState();
}

class _KeuanganSummaryPageState extends State<KeuanganSummaryPage> {
  late Future<List<Keuangan>> listKeuangan;

  @override
  void initState() {
    super.initState();
    listKeuangan = KeuanganService().fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan Keuangan')),
      body: FutureBuilder<List<Keuangan>>(
        future: listKeuangan,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Keuangan> data = snapshot.data!;
          double totalPemasukan = 0;
          double totalPengeluaran = 0;

          for (var item in data) {
            double value = double.tryParse(item.nominal) ?? 0;
            if (item.tipe == 'pemasukan') {
              totalPemasukan += value;
            } else {
              totalPengeluaran += value;
            }
          }

          double saldo = totalPemasukan - totalPengeluaran;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Total Pemasukan'),
                    trailing: Text('Rp ${totalPemasukan.toStringAsFixed(0)}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Total Pengeluaran'),
                    trailing: Text('Rp ${totalPengeluaran.toStringAsFixed(0)}'),
                  ),
                ),
                const Divider(),
                Card(
                  color: Colors.green[100],
                  child: ListTile(
                    title: const Text('Saldo Akhir'),
                    trailing: Text('Rp ${saldo.toStringAsFixed(0)}'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
