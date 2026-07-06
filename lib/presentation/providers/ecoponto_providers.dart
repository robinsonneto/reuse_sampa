import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ecoponto.dart';
import 'repository_providers.dart';

final allEcopontosProvider = StreamProvider<List<EcoPonto>>((ref) {
  return ref.watch(ecopontoRepositoryProvider).watchAllEcopontos();
});

final ecopontoByIdProvider = FutureProvider.family<EcoPonto?, String>((ref, id) {
  return ref.watch(ecopontoRepositoryProvider).getEcopontoById(id);
});

/// Ecoponto do Projeto Piloto (única unidade). Usar este provider em vez de
/// [allEcopontosProvider] em qualquer tela voltada ao cidadão — ele nunca
/// deve ver uma lista/seleção de unidades. A tela administrativa pode
/// continuar usando os providers acima, já prontos para múltiplas unidades.
final currentEcopontoProvider = StreamProvider<EcoPonto?>((ref) {
  return ref.watch(ecopontoRepositoryProvider).watchAllEcopontos().map((list) {
    for (final eco in list) {
      if (eco.id == kBresserEcopontoId) return eco;
    }
    return list.isNotEmpty ? list.first : null;
  });
});
