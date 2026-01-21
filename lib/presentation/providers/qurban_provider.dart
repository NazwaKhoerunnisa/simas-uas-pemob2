import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/qurban_model.dart';
import '../../data/services/qurban_service.dart';

final qurbanServiceProvider = Provider((ref) => QurbanService());

final qurbanListProvider = FutureProvider<List<Qurban>>((ref) async {
  final service = ref.watch(qurbanServiceProvider);
  return service.fetchAll();
});

final qurbanByStatusProvider = FutureProvider.family<int, String>((ref, status) async {
  final service = ref.watch(qurbanServiceProvider);
  return service.getByStatus(status);
});

final qurbanSearchProvider = StateProvider<String>((ref) => '');
final qurbanStatusFilterProvider = StateProvider<String?>((ref) => null);

final filteredQurbanProvider = FutureProvider<List<Qurban>>((ref) async {
  final qurbanList = await ref.watch(qurbanListProvider.future);
  final searchQuery = ref.watch(qurbanSearchProvider);
  final statusFilter = ref.watch(qurbanStatusFilterProvider);
  
  var result = qurbanList;
  
  if (searchQuery.isNotEmpty) {
    result = result
        .where((q) => q.namaJamaah.toLowerCase().contains(searchQuery.toLowerCase()) ||
            q.nomorInduk.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }
  
  if (statusFilter != null) {
    result = result.where((q) => q.status == statusFilter).toList();
  }
  
  return result;
});

final qurbanCountProvider = FutureProvider<int>((ref) async {
  final list = await ref.watch(qurbanListProvider.future);
  return list.length;
});
