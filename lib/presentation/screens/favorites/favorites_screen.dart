import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/item_providers.dart';
import '../../widgets/item_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final allItemsAsync = ref.watch(allItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(title: Text('Favoritos', style: AppTextStyles.headlineLarge)),
      body: allItemsAsync.when(
        data: (allItems) {
          final favorites = allItems.where((i) => favoriteIds.contains(i.id)).toList();
          if (favorites.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'Nenhum favorito ainda',
              message: 'Toque no coração de um item para guardá-lo aqui e\n'
                  'acompanhar quando ele estiver disponível.',
            );
          }
          return ItemGrid(items: favorites);
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => const ErrorState(),
      ),
    );
  }
}
