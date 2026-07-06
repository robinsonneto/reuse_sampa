import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../providers/stats_providers.dart';

/// Tela pública "Impacto Ambiental" — números simulados por enquanto (ver
/// nota no provider), mas já na estrutura final para ligar a dados reais.
class ImpactScreen extends ConsumerWidget {
  const ImpactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(title: Text('Impacto Ambiental', style: AppTextStyles.headlineLarge)),
      body: statsAsync.when(
        data: (stats) => ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.eco_rounded, color: Colors.white, size: 32),
                  const SizedBox(height: AppSpacing.sm),
                  Text('O que o Reuse Sampa\njá evitou que virasse lixo',
                      style: AppTextStyles.headlineLarge.copyWith(color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(
                    'Números do Projeto Piloto no Ecoponto Bresser',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.35,
              children: [
                _ImpactCard(
                  icon: Icons.inventory_2_outlined,
                  value: '${stats.totalDisponiveis}',
                  label: 'Itens disponíveis agora',
                  color: AppColors.darkGreen,
                ),
                _ImpactCard(
                  icon: Icons.recycling_rounded,
                  value: '${stats.totalRetirados}',
                  label: 'Itens já reutilizados',
                  color: AppColors.mediumGreen,
                ),
                _ImpactCard(
                  icon: Icons.delete_outline_rounded,
                  value: '${stats.pesoDesviadoKg.toStringAsFixed(0)} kg',
                  label: 'Resíduos desviados do aterro (estimado)',
                  color: AppColors.orange,
                ),
                _ImpactCard(
                  icon: Icons.people_alt_outlined,
                  value: '${stats.numeroUsuarios}',
                  label: 'Usuários cadastrados',
                  color: AppColors.info,
                ),
                _ImpactCard(
                  icon: Icons.visibility_outlined,
                  value: '${stats.visitasApp}',
                  label: 'Visitas ao aplicativo',
                  color: AppColors.lightGreen,
                ),
                _ImpactCard(
                  icon: Icons.co2_outlined,
                  value: '${stats.co2EvitadoKg.toStringAsFixed(0)} kg',
                  label: 'CO₂ evitado (estimado)',
                  color: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.beigeSoft,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.greyBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.darkGreen, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Estes números são simulados nesta fase inicial do piloto e serão '
                      'substituídos por dados reais à medida que o projeto avança.',
                      style: AppTextStyles.caption,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        loading: () => const LoadingIndicator(),
        error: (e, _) => const ErrorState(),
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _ImpactCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.beigeDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTextStyles.displayMedium.copyWith(fontSize: 22)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
