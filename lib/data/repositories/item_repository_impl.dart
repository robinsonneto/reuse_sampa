import 'dart:async';
import '../../core/constants/item_category.dart';
import '../../domain/entities/reuse_item.dart';
import '../../domain/repositories/item_repository.dart';
import '../datasources/mock_items.dart';

/// Implementação MOCK de [ItemRepository], usada enquanto o projeto Firebase
/// não está conectado. Mantém uma lista em memória e expõe via [Stream] para
/// que a troca pela implementação real com `cloud_firestore` seja transparente
/// para as camadas acima (providers/telas não mudam).
///
/// --- Como migrar para Firestore ---
/// 1. Criar `FirestoreItemRepository implements ItemRepository`.
/// 2. Coleção sugerida: `produtos/{itemId}` com os campos espelhando
///    [ReuseItem] (id, nome, descrição, categoria, estado, imagens,
///    dataCadastro, disponível, ecopontoId, interessados).
/// 3. `watchAllItems()` -> `firestore.collection('produtos').snapshots()`.
/// 4. `watchItemsByCategory()` -> adicionar `.where('category', isEqualTo: ...)`.
/// 5. `addInterest()` -> `arrayUnion([userId])` no campo `interessados` via
///    `update()`, dentro de uma transação se quiser evitar duplicidade.
class MockItemRepository implements ItemRepository {
  final List<ReuseItem> _items = List.of(mockItems);
  final _controller = StreamController<List<ReuseItem>>.broadcast();

  MockItemRepository() {
    _emit();
  }

  void _emit() => _controller.add(List.unmodifiable(_items));

  @override
  Stream<List<ReuseItem>> watchAllItems() => _controller.stream;

  @override
  Stream<List<ReuseItem>> watchItemsByCategory(ItemCategory category) {
    return _controller.stream.map(
      (items) => items.where((i) => i.category == category).toList(),
    );
  }

  @override
  Stream<List<ReuseItem>> watchRecentItems({int limit = 10}) {
    return _controller.stream.map((items) {
      final sorted = [...items]..sort((a, b) => b.entryDate.compareTo(a.entryDate));
      return sorted.take(limit).toList();
    });
  }

  @override
  Stream<List<ReuseItem>> watchMostWanted({int limit = 10}) {
    return _controller.stream.map((items) {
      final sorted = [...items]..sort((a, b) => b.favoriteCount.compareTo(a.favoriteCount));
      return sorted.take(limit).toList();
    });
  }

  @override
  Future<ReuseItem?> getItemById(String id) async {
    try {
      return _items.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ReuseItem>> searchItems(String query) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _items.where((i) {
      return i.name.toLowerCase().contains(q) ||
          i.description.toLowerCase().contains(q) ||
          i.category.label.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Future<void> addInterest({required String itemId, required String userId}) async {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index == -1) return;
    final item = _items[index];
    if (item.hasInterestFrom(userId)) return; // evita duplicidade
    _items[index] = item.copyWith(
      interestedUserIds: [...item.interestedUserIds, userId],
    );
    _emit();
  }

  @override
  Future<void> createItem(ReuseItem item) async {
    _items.insert(0, item);
    _emit();
  }

  @override
  Future<void> updateItem(ReuseItem item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index == -1) {
      _items.insert(0, item);
    } else {
      _items[index] = item;
    }
    _emit();
  }

  @override
  Future<void> deleteItem(String itemId) async {
    _items.removeWhere((i) => i.id == itemId);
    _emit();
  }

  @override
  Future<void> setAvailability({required String itemId, required bool available}) async {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(
      status: available ? ItemStatus.disponivel : ItemStatus.retirado,
    );
    _emit();
  }

  void dispose() => _controller.close();
}
