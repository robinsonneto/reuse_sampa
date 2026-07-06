import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/ecoponto_repository_impl.dart';
import '../../data/repositories/interest_repository_impl.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/ecoponto_repository.dart';
import '../../domain/repositories/interest_repository.dart';
import '../../domain/repositories/item_repository.dart';

/// Ponto único de troca entre mock <-> Firebase.
///
/// Quando o projeto Firebase estiver configurado, basta trocar a
/// implementação retornada aqui (ex.: `FirestoreItemRepository()`) — nenhuma
/// tela ou provider consumidor precisa mudar, pois todos dependem apenas das
/// interfaces em domain/repositories.
final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  final repo = MockItemRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

final ecopontoRepositoryProvider = Provider<EcopontoRepository>((ref) {
  final repo = MockEcopontoRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

final interestRepositoryProvider = Provider<InterestRepository>((ref) {
  final repo = MockInterestRepository();
  ref.onDispose(repo.dispose);
  return repo;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository();
});
