import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/constants/item_category.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../providers/item_providers.dart';
import '../../widgets/category_tile.dart';
import '../../widgets/item_card.dart';
import 'widgets/circular_economy_banner.dart';
import 'widgets/home_search_bar.dart';

/// Home do Projeto Piloto Reuse Sampa (Ecoponto Bresser).
///
/// Ordem de seções segue o briefing: cabeçalho/boas-vindas -> busca ->
/// categorias -> recentes -> disponíveis -> banner de Economia Circular ->
/// botão "Como funciona?".
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentAsync = ref.watch(recentItemsProvider);
    final allItemsAsync = ref.watch(allItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.beige,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.mediumGreen,
          onRefresh: () async {
            ref.invalidate(recentItemsProvider);
            ref.invalidate(allItemsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              const _HomeHeader(),
              const SizedBox(height: AppSpacing.md),
              const _WelcomeMessage(),
              const SizedBox(height: AppSpacing.lg),
              const HomeSearchBar(),
              const SizedBox(height: AppSpacing.lg),
              const _CategoriesRow(),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: 'Adicionados recentemente',
                actionLabel: 'Ver tudo',
                onAction: () => context.push(AppRoutes.catalog),
              ),
              const SizedBox(height: AppSpacing.sm),
              recentAsync.when(
                data: (items) => items.isEmpty
                    ? const _InlineEmpty(text: 'Nenhum item cadastrado ainda.')
                    : ItemHorizontalList(items: items),
                loading: () => const _CarouselSkeleton(),
                error: (e, _) => const _InlineEmpty(text: 'Não foi possível carregar os itens.'),
              ),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(
                title: 'Itens disponíveis',
                actionLabel: 'Ver tudo',
                onAction: () => context.push(AppRoutes.catalog),
              ),
              const SizedBox(height: AppSpacing.sm),
              allItemsAsync.when(
                data: (items) {
                  final available = items.where((i) => i.isAvailable).take(6).toList();
                  return available.isEmpty
                      ? const _InlineEmpty(text: 'Nenhum item disponível no momento.')
                      : ItemHorizontalList(items: available);
                },
                loading: () => const _CarouselSkeleton(),
                error: (e, _) => const _InlineEmpty(text: 'Não foi possível carregar os itens.'),
              ),
              const SizedBox(height: AppSpacing.xl),
              const CircularEconomyBanner(),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                child: SecondaryButton(
                  label: 'Como funciona?',
                  icon: Icons.help_outline_rounded,
                  onPressed: () => context.push(AppRoutes.howItWorks),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding, AppSpacing.sm, AppSpacing.screenPadding, 0),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.darkGreen,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Icons.recycling_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reuse Sampa', style: AppTextStyles.headlineMedium),
                Text(
                  'Projeto Piloto · Ecoponto Bresser',
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
    );
  }
}

class _WelcomeMessage extends StatelessWidget {
  const _WelcomeMessage();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Text(
        'Encontre gratuitamente objetos em bom estado que ganharam uma nova oportunidade de uso.',
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.charcoal),
      ),
    );
  }
}

class _CategoriesRow extends StatelessWidget {
  const _CategoriesRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: ItemCategory.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => CategoryTile(category: ItemCategory.values[index]),
      ),
    );
  }
}

class _CarouselSkeleton extends StatelessWidget {
  const _CarouselSkeleton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 232,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => Container(
          width: 150,
          decoration: BoxDecoration(
            color: AppColors.beigeSoft,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
      ),
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  final String text;
  const _InlineEmpty({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Text(text, style: AppTextStyles.bodySmall),
    );
  }
}
