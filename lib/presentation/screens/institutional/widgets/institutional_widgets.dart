import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Casco comum das páginas institucionais (Como Funciona, Sobre o Projeto,
/// Economia Circular, FAQ, Contato, Política de Uso) — cabeçalho com ícone
/// grande e título, mantendo a identidade visual consistente entre elas.
class InstitutionalScaffold extends StatelessWidget {
  final String title;
  final IconData headerIcon;
  final String? headerSubtitle;
  final List<Widget> children;

  const InstitutionalScaffold({
    super.key,
    required this.title,
    required this.headerIcon,
    this.headerSubtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(color: AppColors.beigeSoft, shape: BoxShape.circle),
            child: Icon(headerIcon, color: AppColors.mediumGreen, size: 30),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTextStyles.displayMedium),
          if (headerSubtitle != null) ...[
            const SizedBox(height: 4),
            Text(headerSubtitle!, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.greyText)),
          ],
          const SizedBox(height: AppSpacing.lg),
          ...children,
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

/// Passo numerado — usado em "Como Funciona".
class NumberedStep extends StatelessWidget {
  final int number;
  final IconData icon;
  final String title;
  final String description;
  final bool isLast;

  const NumberedStep({
    super.key,
    required this.number,
    required this.icon,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: AppColors.darkGreen, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text('$number',
                    style: AppTextStyles.titleMedium.copyWith(color: Colors.white, fontSize: 16)),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.beigeDark, margin: const EdgeInsets.symmetric(vertical: 4)),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 18, color: AppColors.mediumGreen),
                      const SizedBox(width: 6),
                      Expanded(child: Text(title, style: AppTextStyles.titleMedium)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyText)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bloco com ícone + título + texto — usado em "Sobre o Projeto" para
/// listar objetivos, e em outras páginas institucionais.
class BulletSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const BulletSection({super.key, required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.beigeSoft, borderRadius: BorderRadius.circular(AppRadius.md)),
            child: Icon(icon, size: 20, color: AppColors.mediumGreen),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text(description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyText)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
