import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _faqs = [
    (
      question: 'Preciso pagar por algum item?',
      answer: 'Não. Todos os materiais disponíveis no Reuse Sampa são gratuitos.',
    ),
    (
      question: 'Como faço para retirar um item?',
      answer: 'Toque em "Tenho interesse" no item desejado e depois vá presencialmente ao Ecoponto '
          'Bresser. A retirada acontece por ordem de chegada, sem reserva.',
    ),
    (
      question: 'O item ainda vai estar disponível quando eu chegar?',
      answer: 'Não é possível garantir, já que não há reserva neste piloto. Recomendamos ir ao '
          'Ecoponto assim que possível após demonstrar interesse.',
    ),
    (
      question: 'Posso levar materiais para doar?',
      answer: 'Sim! Leve os materiais reutilizáveis até o Ecoponto Bresser — eles passarão por uma '
          'triagem antes de entrar no espaço Reuse Sampa.',
    ),
    (
      question: 'O aplicativo cobre outros Ecopontos da cidade?',
      answer: 'Por enquanto não — este é um projeto piloto, restrito ao Ecoponto Bresser. A expansão '
          'para outras unidades é um objetivo futuro.',
    ),
    (
      question: 'Preciso criar uma conta?',
      answer: 'Você pode navegar pelo catálogo sem login. Para registrar interesse em um item ou '
          'favoritá-lo, é necessário entrar com Google, Apple, gov.br ou e-mail.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(title: const Text('Perguntas Frequentes')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        itemCount: _faqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (context, index) {
          final faq = _faqs[index];
          return Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.beigeDark),
              ),
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                title: Text(faq.question, style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
                iconColor: AppColors.mediumGreen,
                collapsedIconColor: AppColors.greyText,
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(faq.answer, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.greyText)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
