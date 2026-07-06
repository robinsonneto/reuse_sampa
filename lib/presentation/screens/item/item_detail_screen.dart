import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/reuse_item.dart';
import '../../providers/auth_providers.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/item_providers.dart';
import '../../providers/repository_providers.dart';
import 'widgets/photo_gallery.dart';

/// Tela do produto — piloto Ecoponto Bresser.
///
/// Diferença chave em relação à concepção original (cidade toda): não há
/// reserva com prazo. O botão principal é "Tenho interesse", que apenas
/// registra a manifestação para fins estatísticos (ver
/// domain/entities/interest.dart) — a retirada acontece presencialmente,
/// por ordem de chegada.
class ItemDetailScreen extends ConsumerStatefulWidget {
  final String itemId;

  const ItemDetailScreen({super.key, required this.itemId});

  @override
  ConsumerState<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends ConsumerState<ItemDetailScreen> {
  bool _registering = false;

  Future<void> _handleInterest(ReuseItem item) async {
    if (ref.read(currentUserProvider) == null) {
      final result = await context.push<bool>(AppRoutes.login);
      if (result != true || ref.read(currentUserProvider) == null) return;
    }

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    if (item.hasInterestFrom(currentUser.id)) {
      _showAlreadyRegisteredSnackbar();
      return;
    }

    final confirmed = await _showInterestDisclaimer();
    if (confirmed != true) return;

    setState(() => _registering = true);
    try {
      await ref.read(itemRepositoryProvider).addInterest(itemId: item.id, userId: currentUser.id);
      await ref.read(interestRepositoryProvider).registerInterest(
            itemId: item.id,
            itemName: item.name,
            userId: currentUser.id,
            userName: currentUser.name,
            ecopontoId: item.ecopontoId,
          );
      ref.invalidate(itemByIdProvider(item.id));
      if (mounted) _showSuccessSnackbar(item);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Não foi possível registrar o interesse: $e')));
      }
    } finally {
      if (mounted) setState(() => _registering = false);
    }
  }

  Future<bool?> _showInterestDisclaimer() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Confirmar interesse'),
        content: const Text(
          'Este interesse será registrado para fins estatísticos. A retirada ocorre por ordem '
          'de chegada no Ecoponto.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(ReuseItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Interesse em "${item.name}" registrado com sucesso!'),
        action: SnackBarAction(
          label: 'Ver Ecoponto',
          onPressed: () => context.go(AppRoutes.ecoponto),
        ),
      ),
    );
  }

  void _showAlreadyRegisteredSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Você já registrou interesse neste item.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemAsync = ref.watch(itemByIdProvider(widget.itemId));

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Item não encontrado.'));
          }
          return _ItemDetailContent(
            item: item,
            registering: _registering,
            onInterest: () => _handleInterest(item),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => const ErrorState(),
      ),
    );
  }
}

class _ItemDetailContent extends ConsumerWidget {
  final ReuseItem item;
  final bool registering;
  final VoidCallback onInterest;

  const _ItemDetailContent({required this.item, required this.registering, required this.onInterest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(item.id);
    final currentUser = ref.watch(currentUserProvider);
    final alreadyInterested = currentUser != null && item.hasInterestFrom(currentUser.id);
    final dateFormat = DateFormat("d 'de' MMMM 'de' y", 'pt_BR');

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: ItemPhotoGallery(itemId: item.id, photoUrls: item.photoUrls),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: AppTextStyles.displayMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StatusBadge(status: item.status),
                        _InfoChip(icon: item.category.icon, label: item.category.label),
                        _InfoChip(icon: Icons.verified_outlined, label: item.condition.label),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Descrição', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 6),
                    Text(item.description, style: AppTextStyles.bodyLarge),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Detalhes', style: AppTextStyles.headlineMedium),
                    const SizedBox(height: 6),
                    _DetailRow(
                        icon: Icons.category_outlined, label: 'Categoria', value: item.category.label),
                    _DetailRow(
                        icon: Icons.verified_outlined,
                        label: 'Estado de conservação',
                        value: item.condition.label),
                    if (item.dimensions.hasData)
                      _DetailRow(icon: Icons.straighten_rounded, label: 'Dimensões', value: item.dimensions.formatted),
                    if (item.weightKg != null)
                      _DetailRow(
                          icon: Icons.scale_rounded,
                          label: 'Peso aproximado',
                          value: '${item.weightKg!.toStringAsFixed(1)} kg'),
                    _DetailRow(
                        icon: Icons.inventory_2_outlined,
                        label: 'Quantidade disponível',
                        value: '${item.quantityAvailable} unidade(s)'),
                    _DetailRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Data de entrada',
                        value: dateFormat.format(item.entryDate)),
                    if (item.interestCount > 0)
                      _DetailRow(
                          icon: Icons.groups_outlined,
                          label: 'Pessoas interessadas',
                          value: '${item.interestCount}'),
                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.beigeSoft,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.greyBorder),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline_rounded, color: AppColors.darkGreen, size: 20),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Este item é gratuito e deve ser retirado presencialmente no Reuse '
                              'Sampa do Ecoponto Bresser.',
                              style: AppTextStyles.bodySmall.copyWith(color: AppColors.charcoal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 110), // espaço para a barra de ações fixa
                  ],
                ),
              ),
            ),
          ],
        ),
        // --- Barra superior flutuante (voltar / favoritar / compartilhar) ---
        Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          left: 12,
          right: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _FloatingIconButton(icon: Icons.arrow_back_rounded, onTap: () => context.pop()),
              Row(
                children: [
                  _FloatingIconButton(
                    icon: Icons.share_outlined,
                    onTap: () => Share.share(
                      'Olha esse item disponível gratuitamente no Reuse Sampa (Ecoponto Bresser): ${item.name}.',
                    ),
                  ),
                  const SizedBox(width: 8),
                  _FloatingIconButton(
                    icon: isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    iconColor: isFavorite ? AppColors.orange : AppColors.charcoal,
                    onTap: () => ref.read(favoritesProvider.notifier).toggle(item.id),
                  ),
                ],
              ),
            ],
          ),
        ),
        // --- Barra de ação fixa no rodapé ---
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.sm,
              AppSpacing.screenPadding,
              MediaQuery.of(context).padding.bottom + AppSpacing.sm,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2))],
            ),
            child: PrimaryButton(
              label: !item.isAvailable
                  ? item.status.label
                  : (alreadyInterested ? 'Interesse já registrado' : 'Tenho interesse'),
              icon: alreadyInterested ? Icons.check_circle_outline_rounded : Icons.thumb_up_alt_outlined,
              isLoading: registering,
              onPressed: (item.isAvailable && !alreadyInterested) ? onInterest : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.beigeSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.greyText),
          const SizedBox(width: 5),
          Text(label, style: AppTextStyles.caption.copyWith(color: AppColors.charcoal)),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.mediumGreen),
          const SizedBox(width: AppSpacing.sm),
          Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyText)),
          const Spacer(),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _FloatingIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _FloatingIconButton({required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Icon(icon, size: 20, color: iconColor ?? AppColors.charcoal),
      ),
    );
  }
}
