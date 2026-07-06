import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/item_category.dart';
import '../../domain/entities/reuse_item.dart';
import 'repository_providers.dart';

final allItemsProvider = StreamProvider<List<ReuseItem>>((ref) {
  return ref.watch(itemRepositoryProvider).watchAllItems();
});

final recentItemsProvider = StreamProvider<List<ReuseItem>>((ref) {
  return ref.watch(itemRepositoryProvider).watchRecentItems();
});

final mostWantedItemsProvider = StreamProvider<List<ReuseItem>>((ref) {
  return ref.watch(itemRepositoryProvider).watchMostWanted();
});

final itemsByCategoryProvider =
    StreamProvider.family<List<ReuseItem>, ItemCategory>((ref, category) {
  return ref.watch(itemRepositoryProvider).watchItemsByCategory(category);
});

final itemByIdProvider = FutureProvider.family<ReuseItem?, String>((ref, id) {
  return ref.watch(itemRepositoryProvider).getItemById(id);
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<ReuseItem>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  return ref.watch(itemRepositoryProvider).searchItems(query);
});
