import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mantém o conjunto de IDs de itens favoritados pelo usuário atual.
///
/// Em produção: persistir em `users/{uid}/favorites/{itemId}` no Firestore
/// (permite sincronizar entre dispositivos) e usar isso para disparar as
/// notificações de "categoria favorita recebeu novos itens".
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggle(String itemId) {
    if (state.contains(itemId)) {
      state = {...state}..remove(itemId);
    } else {
      state = {...state, itemId};
    }
  }

  bool isFavorite(String itemId) => state.contains(itemId);
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});
