import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/item_category.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../providers/stats_providers.dart';
import '../../widgets/stat_card.dart';
import 'widgets/admin_drawer.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(title: Text('Estatísticas', style: AppTextStyles.headlineLarge)),
      drawer: const AdminDrawer(currentRoute: '/admin'),
      body: statsAsync.when(
        data: (stats) => ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Text('Impacto do Reuse Sampa', style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.35,
              children: [
                StatCard(
                  label: 'Materiais cadastrados',
                  value: '${stats.totalCadastrados}',
                  icon: Icons.inventory_2_rounded,
                  color: AppColors.darkGreen,
                ),
                StatCard(
                  label: 'Materiais retirados',
                  value: '${stats.totalRetirados}',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.mediumGreen,
                ),
                StatCard(
                  label: 'Peso desviado do aterro',
                  value: '${stats.pesoDesviadoKg.toStringAsFixed(0)} kg',
                  icon: Icons.scale_rounded,
                  color: AppColors.orange,
                ),
                StatCard(
                  label: 'CO₂ evitado (estimado)',
                  value: '${stats.co2EvitadoKg.toStringAsFixed(0)} kg',
                  icon: Icons.eco_rounded,
                  color: AppColors.lightGreen,
                ),
                StatCard(
                  label: 'Usuários cadastrados',
                  value: '${stats.numeroUsuarios}',
                  icon: Icons.people_alt_rounded,
                  color: AppColors.info,
                ),
                StatCard(
                  label: 'Interesses registrados',
                  value: '${stats.totalInteresses}',
                  icon: Icons.thumb_up_alt_outlined,
                  color: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Categorias mais populares', style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSpacing.md),
            Container(
              height: 240,
              padding: const EdgeInsets.fromLTRB(8, 20, 20, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.beigeDark),
              ),
              child: _CategoryBarChart(data: stats.itensPorCategoria),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Itens mais procurados', style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            ...stats.maisProcurados.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.beigeDark),
                  ),
                  child: Row(
                    children: [
                      Icon(item.category.icon, color: item.category.color, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(item.name, style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      Icon(Icons.favorite_rounded, size: 14, color: AppColors.orange),
                      const SizedBox(width: 4),
                      Text('${item.favoriteCount}', style: AppTextStyles.caption),
                    ],
                  ),
                )),
          ],
        ),
        loading: () => const LoadingIndicator(),
        error: (e, _) => const ErrorState(),
      ),
    );
  }
}

class _CategoryBarChart extends StatelessWidget {
  final Map<ItemCategory, int> data;

  const _CategoryBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final top = entries.take(6).toList();
    final maxY = (top.isEmpty ? 1 : top.first.value).toDouble() + 1;

    if (top.isEmpty) {
      return Center(child: Text('Sem dados suficientes ainda.', style: AppTextStyles.bodySmall));
    }

    return BarChart(
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= top.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(top[index].key.icon, size: 16, color: top[index].key.color),
                );
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          for (int i = 0; i < top.length; i++)
            BarChartGroupData(x: i, barRods: [
              BarChartRodData(
                toY: top[i].value.toDouble(),
                color: top[i].key.color,
                width: 22,
                borderRadius: BorderRadius.circular(6),
              ),
            ]),
        ],
      ),
    );
  }
}
