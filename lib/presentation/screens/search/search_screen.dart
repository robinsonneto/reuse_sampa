import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../providers/item_providers.dart';
import '../../widgets/item_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(
        leading: const BackButton(),
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Buscar itens disponíveis...',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide.none,
            ),
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    onPressed: () {
                      _controller.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                    },
                  )
                : null,
          ),
          onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
        ),
        titleSpacing: 0,
      ),
      body: query.trim().isEmpty
          ? const EmptyState(
              icon: Icons.search_rounded,
              title: 'O que você está procurando?',
              message: 'Busque por nome, categoria ou palavra-chave — por exemplo,\n'
                  '"estante", "livros" ou "furadeira".',
            )
          : resultsAsync.when(
              data: (items) => items.isEmpty
                  ? const EmptyState(
                      icon: Icons.search_off_rounded,
                      title: 'Nada por aqui ainda',
                      message: 'Não encontramos itens para essa busca. Tente outro termo ou explore '
                          'as categorias na tela inicial.',
                    )
                  : ItemGrid(items: items),
              loading: () => const LoadingIndicator(),
              error: (e, _) => const ErrorState(),
            ),
    );
  }
}
