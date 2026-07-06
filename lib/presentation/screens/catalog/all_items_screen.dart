import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/item_category.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../providers/item_providers.dart';
import '../../widgets/category_tile.dart';
import '../../widgets/item_card.dart';

/// Catálogo completo — "Itens disponíveis" citado na Home. Mostra todos os
/// itens do Ecoponto Bresser com status disponível, com filtro opcional por
/// categoria.
class AllItemsScreen extends ConsumerStatefulWidget {
  const AllItemsScreen({super.key});

  @override
  ConsumerState<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends ConsumerState<AllItemsScreen> {
  ItemCategory? _filter;

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(allItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(title: const Text('Itens disponíveis')),
      body: itemsAsync.when(
        data: (items) {
          final available = items.where((i) => i.isAvailable).toList();
          final filtered = _filter == null ? available : available.where((i) => i.category == _filter).toList();

          return Column(
            children: [
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: ChoiceChip(
                        label: const Text('Todas'),
                        selected: _filter == null,
                        onSelected: (_) => setState(() => _filter = null),
                      ),
                    ),
                    for (final category in ItemCategory.values)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: CategoryChip(
                          category: category,
                          selected: _filter == category,
                          onTap: () => setState(() => _filter = _filter == category ? null : category),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: filtered.isEmpty
                    ? const EmptyState(
                        icon: Icons.inventory_2_outlined,
                        title: 'Nenhum item disponível',
                        message: 'Volte mais tarde — novos materiais chegam com frequência.',
                      )
                    : ItemGrid(items: filtered),
              ),
            ],
          );
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => const ErrorState(),
      ),
    );
  }
}
