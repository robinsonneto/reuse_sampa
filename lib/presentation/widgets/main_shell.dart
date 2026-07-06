import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Estrutura com o menu inferior, conforme pedido no briefing (seção TELA
/// INICIAL: "Menu inferior"). Usa [StatefulShellRoute] do GoRouter para que
/// cada aba mantenha seu próprio histórico de navegação e estado de scroll.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  static const _items = [
    (icon: Icons.home_rounded, outlineIcon: Icons.home_outlined, label: 'Início'),
    (icon: Icons.place_rounded, outlineIcon: Icons.place_outlined, label: 'Ecoponto'),
    (icon: Icons.favorite_rounded, outlineIcon: Icons.favorite_border_rounded, label: 'Favoritos'),
    (icon: Icons.eco_rounded, outlineIcon: Icons.eco_outlined, label: 'Impacto'),
    (icon: Icons.person_rounded, outlineIcon: Icons.person_outline_rounded, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: [
          for (int i = 0; i < _items.length; i++)
            BottomNavigationBarItem(
              icon: Icon(navigationShell.currentIndex == i ? _items[i].icon : _items[i].outlineIcon),
              label: _items[i].label,
            ),
        ],
      ),
    );
  }
}
