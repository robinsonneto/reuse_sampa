import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/item_category.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../providers/item_providers.dart';
import '../../widgets/item_card.dart';

class CategoryItemsScreen extends ConsumerWidget {
  final ItemCategory category;

  const CategoryItemsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(itemsByCategoryProvider(category));

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(category.icon, color: category.color, size: 20),
            const SizedBox(width: 8),
            Text(category.label),
          ],
        ),
      ),
      body: itemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              icon: category.icon,
              title: 'Nenhum item nessa categoria',
              message: 'Assim que novos materiais de ${category.label.toLowerCase()} chegarem a um '
                  'Ecoponto, eles aparecerão aqui. Ative as notificações para ser avisado.',
            );
          }
          return ItemGrid(items: items);
        },
        loading: () => const LoadingIndicator(),
        error: (e, _) => const ErrorState(),
      ),
    );
  }
}
