import 'package:flutter/material.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import 'widgets/institutional_widgets.dart';

class UsagePolicyScreen extends StatelessWidget {
  const UsagePolicyScreen({super.key});

  static const _sections = [
    (
      title: '1. Sobre o serviço',
      body: 'O Reuse Sampa é um catálogo digital gratuito do espaço de reuso do Ecoponto Bresser, '
          'operado no âmbito de um Projeto Piloto da Prefeitura de São Paulo. Nenhum item '
          'disponível no aplicativo é vendido — todos são doados gratuitamente.',
    ),
    (
      title: '2. Cadastro e dados pessoais',
      body: 'Para registrar interesse em um item ou favoritá-lo, é necessário criar uma conta via '
          'Google, Apple, gov.br ou e-mail. Coletamos apenas os dados necessários para o '
          'funcionamento do serviço e para fins estatísticos do piloto.',
    ),
    (
      title: '3. Manifestação de interesse',
      body: 'O botão "Tenho interesse" registra seu interesse em um item para fins estatísticos. '
          'Ele não garante a reserva ou a disponibilidade do item — a retirada ocorre '
          'presencialmente, por ordem de chegada ao Ecoponto.',
    ),
    (
      title: '4. Responsabilidade sobre os itens',
      body: 'Os itens são doados "no estado em que se encontram", após triagem da equipe do '
          'Ecoponto. A Prefeitura não garante condições específicas além da descrição '
          'informada no aplicativo.',
    ),
    (
      title: '5. Alterações',
      body: 'Por se tratar de um projeto piloto, funcionalidades, categorias e regras podem ser '
          'ajustadas ao longo do tempo, sempre com o objetivo de melhorar a experiência e o '
          'impacto ambiental do serviço.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return InstitutionalScaffold(
      title: 'Política de Uso',
      headerIcon: Icons.description_outlined,
      headerSubtitle: 'Última atualização: julho de 2026',
      children: [
        for (final section in _sections)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(section.title, style: AppTextStyles.headlineMedium),
                const SizedBox(height: 6),
                Text(section.body, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
      ],
    );
  }
}
