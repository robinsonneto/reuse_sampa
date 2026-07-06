import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/interest.dart';
import 'auth_providers.dart';
import 'repository_providers.dart';

final allInterestsProvider = StreamProvider<List<Interest>>((ref) {
  return ref.watch(interestRepositoryProvider).watchAllInterests();
});

final userInterestsProvider = StreamProvider<List<Interest>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return Stream.value(const []);
  return ref.watch(interestRepositoryProvider).watchUserInterests(user.id);
});

final interestsForItemProvider = StreamProvider.family<List<Interest>, String>((ref, itemId) {
  return ref.watch(interestRepositoryProvider).watchInterestsForItem(itemId);
});
