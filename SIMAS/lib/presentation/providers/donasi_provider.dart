import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/donasi_model.dart';
import '../../data/services/donasi_service.dart';

final donasiServiceProvider = Provider((ref) => DonasiService());

final donasiListProvider = FutureProvider<List<Donasi>>((ref) async {
  final service = ref.watch(donasiServiceProvider);
  return service.fetchAll();
});

final donasiSearchProvider = StateProvider<String>((ref) => '');
final donasiTypeFilterProvider = StateProvider<String?>((ref) => null);

final filteredDonasiProvider = FutureProvider<List<Donasi>>((ref) async {
  final donasiList = await ref.watch(donasiListProvider.future);
  final searchQuery = ref.watch(donasiSearchProvider);
  final typeFilter = ref.watch(donasiTypeFilterProvider);
  
  var result = donasiList;
  
  if (searchQuery.isNotEmpty) {
    result = result
        .where((d) => d.namaJamaah.toLowerCase().contains(searchQuery.toLowerCase()) ||
            d.tujuan.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
  
  if (typeFilter != null) {
    result = result.where((d) => d.tipe == typeFilter).toList();
  }
  
  return result;
});

final donasiCountProvider = FutureProvider<int>((ref) async {
  final list = await ref.watch(donasiListProvider.future);
  return list.length;
});

final donasiTotalProvider = FutureProvider<int>((ref) async {
  try {
    final list = await ref.watch(donasiListProvider.future);
    int total = 0;
    for (final d in list) {
      total += d.nominal;
    }
    return total;
  } catch (e) {
    return 0;
  }
});
