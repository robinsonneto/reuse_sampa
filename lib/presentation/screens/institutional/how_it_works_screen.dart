import 'package:flutter/material.dart';
import 'widgets/institutional_widgets.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InstitutionalScaffold(
      title: 'Como funciona?',
      headerIcon: Icons.help_outline_rounded,
      headerSubtitle: 'Do descarte à nova oportunidade de uso, em 5 passos.',
      children: const [
        NumberedStep(
          number: 1,
          icon: Icons.local_shipping_outlined,
          title: 'Entrega no Ecoponto',
          description: 'O cidadão leva materiais reutilizáveis ao Ecoponto Bresser.',
        ),
        NumberedStep(
          number: 2,
          icon: Icons.fact_check_outlined,
          title: 'Triagem',
          description: 'Os materiais passam por uma triagem que avalia estado de conservação e categoria.',
        ),
        NumberedStep(
          number: 3,
          icon: Icons.shelves,
          title: 'Organização',
          description: 'São organizados por categoria no espaço Reuse Sampa, prontos para consulta no app.',
        ),
        NumberedStep(
          number: 4,
          icon: Icons.volunteer_activism_outlined,
          title: 'Retirada gratuita',
          description: 'Outros cidadãos consultam o catálogo e podem retirar os itens gratuitamente, por ordem de chegada.',
        ),
        NumberedStep(
          number: 5,
          icon: Icons.eco_outlined,
          title: 'Economia circular',
          description: 'Assim reduzimos resíduos, evitamos descartes desnecessários e promovemos a economia circular.',
          isLast: true,
        ),
      ],
    );
  }
}
