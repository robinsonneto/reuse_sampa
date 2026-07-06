import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import 'widgets/institutional_widgets.dart';

class CircularEconomyScreen extends StatelessWidget {
  const CircularEconomyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InstitutionalScaffold(
      title: 'Economia Circular',
      headerIcon: Icons.autorenew_rounded,
      children: [
        Text(
          'A economia circular propõe repensar o ciclo de vida dos produtos: em vez do modelo '
          'tradicional de "extrair, produzir, descartar", ela busca manter materiais e objetos em '
          'uso pelo maior tempo possível, através de reuso, reparo e reciclagem.',
          style: AppTextStyles.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Como o Reuse Sampa aplica esse conceito', style: AppTextStyles.headlineMedium),
        const SizedBox(height: AppSpacing.md),
        const BulletSection(
          icon: Icons.looks_one_outlined,
          title: 'Interrompe o descarte',
          description: 'Materiais que iriam para o aterro ganham um destino diferente logo na entrada do Ecoponto.',
        ),
        const BulletSection(
          icon: Icons.looks_two_outlined,
          title: 'Prolonga a vida útil',
          description: 'Um mesmo objeto pode ser usado por várias famílias ao longo do tempo, em vez de virar lixo após o primeiro uso.',
        ),
        const BulletSection(
          icon: Icons.looks_3_outlined,
          title: 'Fecha o ciclo',
          description: 'O que seria resíduo volta a circular na cidade — a essência da economia circular.',
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Cada item retirado no Reuse Sampa representa, na prática, um pequeno passo nessa '
          'transição: menos extração de recursos novos, menos resíduo e mais aproveitamento do '
          'que já existe.',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
