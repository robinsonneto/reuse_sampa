import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/reuse_item.dart';
import '../../providers/item_providers.dart';
import '../../providers/repository_providers.dart';
import 'widgets/admin_drawer.dart';

class AdminItemsListScreen extends ConsumerStatefulWidget {
  const AdminItemsListScreen({super.key});

  @override
  ConsumerState<AdminItemsListScreen> createState() => _AdminItemsListScreenState();
}

class _AdminItemsListScreenState extends ConsumerState<AdminItemsListScreen> {
  String _query = '';

  Future<void> _confirmDelete(ReuseItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir item?'),
        content: Text('"${item.name}" será removido permanentemente do catálogo.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(itemRepositoryProvider).deleteItem(item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item excluído.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsAsync = ref.watch(allItemsProvider);

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(title: Text('Itens cadastrados', style: AppTextStyles.headlineLarge)),
      drawer: const AdminDrawer(currentRoute: AppRoutes.adminItems),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.darkGreen,
        onPressed: () => context.push(AppRoutes.adminItemForm),
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Novo item', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar por nome...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md), borderSide: BorderSide.none),
              ),
              onChanged: (value) => setState(() => _query = value.toLowerCase()),
            ),
          ),
          Expanded(
            child: itemsAsync.when(
              data: (items) {
                final filtered = _query.isEmpty
                    ? items
                    : items.where((i) => i.name.toLowerCase().contains(_query)).toList();
                if (filtered.isEmpty) {
                  return const EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'Nenhum item encontrado',
                    message: 'Cadastre um novo item usando o botão abaixo.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding, 0, AppSpacing.screenPadding, 96),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.beigeDark),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                            child: CachedNetworkImage(
                              imageUrl: item.coverPhoto,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorWidget: (context, _, __) => Container(width: 52, height: 52, color: AppColors.beigeSoft),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: AppTextStyles.titleMedium.copyWith(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Row(children: [
                                  StatusBadge(status: item.status, compact: true),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(item.category.label, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ),
                                  if (item.interestCount > 0) ...[
                                    const Icon(Icons.thumb_up_alt_outlined, size: 12, color: AppColors.greyText),
                                    const SizedBox(width: 3),
                                    Text('${item.interestCount}', style: AppTextStyles.caption),
                                  ],
                                ]),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              item.status == ItemStatus.disponivel
                                  ? Icons.check_circle_outline_rounded
                                  : Icons.replay_rounded,
                              size: 20,
                              color: item.status == ItemStatus.disponivel ? AppColors.mediumGreen : AppColors.greyText,
                            ),
                            tooltip: item.status == ItemStatus.disponivel ? 'Marcar como retirado' : 'Marcar como disponível',
                            onPressed: () => ref.read(itemRepositoryProvider).setAvailability(
                                  itemId: item.id,
                                  available: item.status != ItemStatus.disponivel,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () => context.push('${AppRoutes.adminItemForm}?itemId=${item.id}'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.error),
                            onPressed: () => _confirmDelete(item),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const LoadingIndicator(),
              error: (e, _) => const ErrorState(),
            ),
          ),
        ],
      ),
    );
  }
}
