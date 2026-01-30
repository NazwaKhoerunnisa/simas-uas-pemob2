import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/keuangan_model.dart';
import '../../data/services/keuangan_service.dart';

final keuanganServiceProvider = Provider((ref) => KeuanganService());

final keuanganListProvider = FutureProvider<List<Keuangan>>((ref) async {
  final service = ref.watch(keuanganServiceProvider);
  return service.fetchAll();
});

final keuanganTotalProvider = FutureProvider<double>((ref) async {
  try {
    final list = await ref.watch(keuanganListProvider.future);
    double total = 0;
    for (final k in list) {
      total += double.tryParse(k.nominal) ?? 0;
    }
    return total;
  } catch (e) {
    return 0;
  }
});

final keuanganCountProvider = FutureProvider<int>((ref) async {
  final list = await ref.watch(keuanganListProvider.future);
  return list.length;
});
