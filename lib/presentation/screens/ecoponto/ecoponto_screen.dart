import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/ecoponto.dart';
import '../../providers/ecoponto_providers.dart';
import '../../providers/stats_providers.dart';

/// Tela exclusiva do Ecoponto Bresser (única unidade do piloto).
///
/// Substitui o antigo mapa "de todos os Ecopontos" da concepção original —
/// aqui mostramos direto o local, sem exigir que o cidadão escolha uma
/// unidade. Ver nota de arquitetura em domain/entities/ecoponto.dart sobre
/// como isso está preparado para expandir no futuro.
class EcopontoScreen extends ConsumerWidget {
  const EcopontoScreen({super.key});

  Future<void> _openDirections(EcoPonto eco) async {
    final uri =
        Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${eco.latitude},${eco.longitude}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ecopontoAsync = ref.watch(currentEcopontoProvider);

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: ecopontoAsync.when(
        data: (eco) {
          if (eco == null) return const ErrorState(message: 'Ecoponto não encontrado.');
          return _EcopontoContent(ecoponto: eco, onDirections: () => _openDirections(eco));
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => const ErrorState(),
      ),
    );
  }
}

class _EcopontoContent extends StatelessWidget {
  final EcoPonto ecoponto;
  final VoidCallback onDirections;

  const _EcopontoContent({required this.ecoponto, required this.onDirections});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: AppColors.darkGreen,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(ecoponto.name, style: const TextStyle(color: Colors.white, fontSize: 16)),
            background: ecoponto.facadePhotoUrl != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(imageUrl: ecoponto.facadePhotoUrl!, fit: BoxFit.cover),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black45],
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(color: AppColors.darkGreen),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.mediumGreen.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text('Projeto Piloto',
                          style: AppTextStyles.caption.copyWith(color: AppColors.darkGreen, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 8),
                    Consumer(
                      builder: (context, ref, _) {
                        final statsAsync = ref.watch(dashboardStatsProvider);
                        final count = statsAsync.valueOrNull?.totalDisponiveis;
                        if (count == null) return const SizedBox.shrink();
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.orange.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                          child: Text('$count itens disponíveis',
                              style: AppTextStyles.caption.copyWith(color: AppColors.orange, fontWeight: FontWeight.w700)),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _InfoRow(icon: Icons.place_outlined, label: ecoponto.address),
                _InfoRow(icon: Icons.schedule_outlined, label: ecoponto.openingHours.map((h) => '${h.weekday}: ${h.hours}').join(' · ')),
                _InfoRow(icon: Icons.call_outlined, label: ecoponto.phone),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(label: 'Como chegar', icon: Icons.directions_rounded, onPressed: onDirections),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  height: 160,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: GoogleMap(
                      initialCameraPosition:
                          CameraPosition(target: LatLng(ecoponto.latitude, ecoponto.longitude), zoom: 15.5),
                      markers: {
                        Marker(
                          markerId: MarkerId(ecoponto.id),
                          position: LatLng(ecoponto.latitude, ecoponto.longitude),
                        ),
                      },
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      scrollGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text('Sobre o espaço Reuse Sampa', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 8),
                Text(ecoponto.aboutSpace, style: AppTextStyles.bodyLarge),
                if (ecoponto.spacePhotoUrls.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text('Fotos do espaço', style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: ecoponto.spacePhotoUrls.length,
                      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        child: CachedNetworkImage(
                          imageUrl: ecoponto.spacePhotoUrls[index],
                          width: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.mediumGreen),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
