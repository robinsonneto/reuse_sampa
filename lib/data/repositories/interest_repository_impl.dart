import 'dart:async';
import '../../domain/entities/interest.dart';
import '../../domain/repositories/interest_repository.dart';

/// Implementação MOCK. Migrar para uma coleção `interesses` no Firestore,
/// com um índice composto em (`itemId`, `createdAt`) para a consulta
/// administrativa por item.
class MockInterestRepository implements InterestRepository {
  final List<Interest> _interests = [];
  final _controller = StreamController<List<Interest>>.broadcast();

  MockInterestRepository() {
    _controller.add(_interests);
  }

  @override
  Future<Interest> registerInterest({
    required String itemId,
    required String itemName,
    required String userId,
    required String userName,
    required String ecopontoId,
  }) async {
    final interest = Interest(
      id: 'interesse_${DateTime.now().microsecondsSinceEpoch}',
      itemId: itemId,
      itemName: itemName,
      userId: userId,
      userName: userName,
      ecopontoId: ecopontoId,
      createdAt: DateTime.now(),
    );
    _interests.insert(0, interest);
    _controller.add(List.of(_interests));
    return interest;
  }

  @override
  Stream<List<Interest>> watchUserInterests(String userId) {
    return _controller.stream.map((list) => list.where((i) => i.userId == userId).toList());
  }

  @override
  Stream<List<Interest>> watchAllInterests() => _controller.stream;

  @override
  Stream<List<Interest>> watchInterestsForItem(String itemId) {
    return _controller.stream.map((list) => list.where((i) => i.itemId == itemId).toList());
  }

  void dispose() => _controller.close();
}
