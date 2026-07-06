import '../../core/constants/item_category.dart';
import '../entities/reuse_item.dart';

/// Contrato de acesso a dados de itens (coleção `produtos` no Firestore).
/// Durante o desenvolvimento/design, usamos uma implementação mock com
/// dados de exemplo (ver data/repositories/item_repository_impl.dart).
abstract class ItemRepository {
  Stream<List<ReuseItem>> watchAllItems();

  Stream<List<ReuseItem>> watchItemsByCategory(ItemCategory category);

  Stream<List<ReuseItem>> watchRecentItems({int limit = 10});

  Stream<List<ReuseItem>> watchMostWanted({int limit = 10});

  Future<ReuseItem?> getItemById(String id);

  Future<List<ReuseItem>> searchItems(String query);

  /// Registra o "Tenho interesse" do usuário no item (piloto sem reserva
  /// automática — apenas soma o ID à lista `interessados`). O registro
  /// detalhado com data/hora fica no [InterestRepository] à parte.
  Future<void> addInterest({required String itemId, required String userId});

  // --- Operações do painel administrativo ---
  Future<void> createItem(ReuseItem item);

  Future<void> updateItem(ReuseItem item);

  Future<void> deleteItem(String itemId);

  /// Alterna a disponibilidade do item (ex.: "Marcar como retirado" /
  /// "Marcar como disponível novamente") pelo painel administrativo.
  Future<void> setAvailability({required String itemId, required bool available});
}
