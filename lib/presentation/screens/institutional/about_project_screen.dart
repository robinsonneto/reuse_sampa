import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import 'widgets/institutional_widgets.dart';

class AboutProjectScreen extends StatelessWidget {
  const AboutProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InstitutionalScaffold(
      title: 'Sobre o Projeto',
      headerIcon: Icons.info_outline_rounded,
      children: [
        Text(
          'O Reuse Sampa é um Projeto Piloto implantado no Ecoponto Bresser, criado para dar uma '
          'nova oportunidade de uso a materiais em bom estado que, de outra forma, poderiam ser '
          'descartados. O espaço reúne, organiza e disponibiliza gratuitamente esses itens à '
          'população.',
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Objetivos', style: AppTextStyles.headlineMedium),
        const SizedBox(height: AppSpacing.md),
        const BulletSection(
          icon: Icons.delete_outline_rounded,
          title: 'Redução de resíduos',
          description: 'Diminuir o volume de materiais reutilizáveis enviados ao aterro sanitário.',
        ),
        const BulletSection(
          icon: Icons.autorenew_rounded,
          title: 'Economia circular',
          description: 'Prolongar a vida útil dos materiais, mantendo-os em uso na cidade.',
        ),
        const BulletSection(
          icon: Icons.school_outlined,
          title: 'Educação ambiental',
          description: 'Aproximar a população dos temas de sustentabilidade e consumo consciente.',
        ),
        const BulletSection(
          icon: Icons.handshake_outlined,
          title: 'Reutilização de materiais',
          description: 'Conectar quem descarta com quem pode dar um novo uso ao material.',
        ),
        const BulletSection(
          icon: Icons.groups_outlined,
          title: 'Conscientização da população',
          description: 'Incentivar hábitos mais sustentáveis no dia a dia dos munícipes.',
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.beigeSoft,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.greyBorder),
          ),
          child: Row(
            children: [
              const Icon(Icons.rocket_launch_outlined, color: AppColors.darkGreen, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Este é o início: com os aprendizados do piloto, o Reuse Sampa poderá expandir '
                  'para outros Ecopontos da cidade.',
                  style: AppTextStyles.caption,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
