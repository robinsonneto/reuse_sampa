import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/item_category.dart';
import '../../domain/entities/reuse_item.dart';
import 'interest_providers.dart';
import 'item_providers.dart';

/// Fator aproximado de CO2 evitado por quilo de material reutilizado em vez
/// de descartado (estimativa simplificada para dashboard/demo — a
/// metodologia oficial de cálculo deve ser validada com a SVMA antes de
/// publicar números para o público).
const double _kgCo2PerKgReused = 2.5;

class DashboardStats {
  final int totalCadastrados;
  final int totalRetirados;
  final int totalDisponiveis;
  final int totalInteresses;
  final double pesoDesviadoKg;
  final double co2EvitadoKg;
  final int numeroUsuarios; // mock — em produção, contagem real de `users`
  final int visitasApp; // mock — em produção, Firebase Analytics
  final List<ReuseItem> maisProcurados;
  final Map<ItemCategory, int> itensPorCategoria;

  const DashboardStats({
    required this.totalCadastrados,
    required this.totalRetirados,
    required this.totalDisponiveis,
    required this.totalInteresses,
    required this.pesoDesviadoKg,
    required this.co2EvitadoKg,
    required this.numeroUsuarios,
    required this.visitasApp,
    required this.maisProcurados,
    required this.itensPorCategoria,
  });
}

/// Estatísticas compartilhadas pelo dashboard administrativo e pela tela
/// pública "Impacto Ambiental" — uma única fonte de verdade para os
/// números, exibidos com ênfases diferentes em cada público.
final dashboardStatsProvider = Provider<AsyncValue<DashboardStats>>((ref) {
  final itemsAsync = ref.watch(allItemsProvider);
  final totalInteresses = ref.watch(allInterestsProvider).valueOrNull?.length ?? 0;

  return itemsAsync.whenData((items) {
    final pesoTotal = items.fold<double>(0, (sum, i) => sum + (i.weightKg ?? 0));
    final porCategoria = <ItemCategory, int>{};
    for (final item in items) {
      porCategoria[item.category] = (porCategoria[item.category] ?? 0) + 1;
    }
    final maisProcurados = [...items]..sort((a, b) => b.favoriteCount.compareTo(a.favoriteCount));

    return DashboardStats(
      totalCadastrados: items.length,
      totalRetirados: items.where((i) => i.status == ItemStatus.retirado).length,
      totalDisponiveis: items.where((i) => i.status == ItemStatus.disponivel).length,
      totalInteresses: totalInteresses,
      pesoDesviadoKg: pesoTotal,
      co2EvitadoKg: pesoTotal * _kgCo2PerKgReused,
      numeroUsuarios: 1284, // mock
      visitasApp: 9840, // mock
      maisProcurados: maisProcurados.take(5).toList(),
      itensPorCategoria: porCategoria,
    );
  });
});
