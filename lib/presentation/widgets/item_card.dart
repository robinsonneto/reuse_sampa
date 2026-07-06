import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/date_formatters.dart';
import '../../core/widgets/common_widgets.dart';
import '../../domain/entities/reuse_item.dart';
import '../providers/favorites_provider.dart';

/// Card de item em grade (2 colunas), padrão para Home/Categoria/Busca.
/// Usa Hero animation na foto para uma transição suave até a tela de
/// detalhe, como pedido no briefing (seção EXPERIÊNCIA DO USUÁRIO).
class ItemCard extends ConsumerWidget {
  final ReuseItem item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(item.id);

    return GestureDetector(
      onTap: () => context.push(AppRoutes.itemDetailPath(item.id)),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.beigeDark),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'item_photo_${item.id}',
                    child: CachedNetworkImage(
                      imageUrl: item.coverPhoto,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.beigeSoft,
                        highlightColor: AppColors.beige,
                        child: Container(color: AppColors.beigeSoft),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.beigeSoft,
                        child: const Icon(Icons.image_not_supported_outlined,
                            color: AppColors.greyText),
                      ),
                    ),
                  ),
                  Positioned(top: 8, left: 8, child: StatusBadge(status: item.status, compact: true)),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFavorite ? AppColors.orange : AppColors.white,
                        shadows: const [Shadow(color: Colors.black38, blurRadius: 6)],
                      ),
                      onPressed: () => ref.read(favoritesProvider.notifier).toggle(item.id),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(item.category.icon, size: 13, color: AppColors.greyText),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          item.category.label,
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(timeAgo(item.entryDate), style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grade responsiva de [ItemCard]s (2 colunas em telas de celular).
class ItemGrid extends StatelessWidget {
  final List<ReuseItem> items;
  final EdgeInsets padding;

  const ItemGrid({super.key, required this.items, this.padding = const EdgeInsets.all(AppSpacing.screenPadding)});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) => ItemCard(item: items[index]),
    );
  }
}

/// Lista horizontal de cards, usada em carrosséis ("Novidades", "Mais
/// procurados"...).
class ItemHorizontalList extends StatelessWidget {
  final List<ReuseItem> items;

  const ItemHorizontalList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 232,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) => SizedBox(width: 150, child: ItemCard(item: items[index])),
      ),
    );
  }
}
