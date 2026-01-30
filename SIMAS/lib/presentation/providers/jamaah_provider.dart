import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/jamaah_model.dart';
import '../../data/services/jamaah_service.dart';

final jamaahServiceProvider = Provider((ref) => JamaahService());

final jamaahListProvider = FutureProvider<List<Jamaah>>((ref) async {
  final service = ref.watch(jamaahServiceProvider);
  return service.fetchAll();
});

final jamaahStatsProvider = FutureProvider<Map<String, int>>((ref) async {
  final service = ref.watch(jamaahServiceProvider);
  final total = await service.getTotalJamaah();
  final active = await service.getActiveJamaah();
  final newThisMonth = await service.getNewJamaahThisMonth();
  
  return {
    'total': total,
    'active': active,
    'newThisMonth': newThisMonth,
  };
});

final jamaahSearchProvider = StateProvider<String>((ref) => '');

final filteredJamaahProvider = FutureProvider<List<Jamaah>>((ref) async {
  final jamaahList = await ref.watch(jamaahListProvider.future);
  final searchQuery = ref.watch(jamaahSearchProvider);
  
  if (searchQuery.isEmpty) {
    return jamaahList;
  }
  
  return jamaahList
      .where((j) => j.nama.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();
});
