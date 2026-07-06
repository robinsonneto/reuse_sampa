import '../entities/interest.dart';

/// Contrato de acesso à coleção de manifestações de interesse
/// (`interesses`, separada de `produtos.interessados` — ver nota em
/// domain/entities/reuse_item.dart). Mantida à parte para permitir consultas
/// administrativas por data, por item ou por usuário sem precisar varrer
/// todos os produtos.
abstract class InterestRepository {
  /// Registra um novo interesse: produto + usuário + data (exatamente os
  /// três campos pedidos no briefing do piloto).
  Future<Interest> registerInterest({
    required String itemId,
    required String itemName,
    required String userId,
    required String userName,
    required String ecopontoId,
  });

  /// Todas as manifestações de interesse de um usuário (para eventualmente
  /// mostrar "itens que você já demonstrou interesse").
  Stream<List<Interest>> watchUserInterests(String userId);

  /// Todas as manifestações de interesse — painel administrativo.
  Stream<List<Interest>> watchAllInterests();

  /// Manifestações de interesse de um item específico — usado na tela
  /// administrativa de detalhe do produto ("Consultar interessados").
  Stream<List<Interest>> watchInterestsForItem(String itemId);
}
