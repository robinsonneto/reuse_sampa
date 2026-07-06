import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/item_category.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_text_styles.dart';

/// Ícone + rótulo de uma categoria, usado na grade de categorias da Home.
class CategoryTile extends StatelessWidget {
  final ItemCategory category;

  const CategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () => context.push(AppRoutes.categoryPath(category.firestoreId)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(category.icon, color: category.color, size: 28),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 68,
            child: Text(
              category.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(color: AppColors.charcoal, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chip de categoria (pílula), usado em filtros horizontais.
class CategoryChip extends StatelessWidget {
  final ItemCategory category;
  final bool selected;
  final VoidCallback onTap;

  const CategoryChip({super.key, required this.category, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(category.label),
      avatar: Icon(category.icon, size: 16, color: selected ? Colors.white : category.color),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: AppTextStyles.label.copyWith(color: selected ? Colors.white : AppColors.charcoal),
      selectedColor: AppColors.darkGreen,
      backgroundColor: AppColors.beigeSoft,
      side: BorderSide(color: selected ? AppColors.darkGreen : AppColors.greyBorder),
    );
  }
}
