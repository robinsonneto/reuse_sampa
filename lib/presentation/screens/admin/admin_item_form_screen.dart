import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/item_category.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../domain/entities/ecoponto.dart';
import '../../../domain/entities/reuse_item.dart';
import '../../providers/item_providers.dart';
import '../../providers/repository_providers.dart';

/// Formulário de cadastro/edição de item — cobre todos os campos definidos
/// no briefing (seção TELA DO ITEM).
///
/// --- Upload de fotos em produção ---
/// Aqui usamos `image_picker` apenas para selecionar as fotos localmente.
/// Antes de salvar, cada [XFile] deve ser enviada para o Firebase Storage
/// (`items/{itemId}/{n}.jpg`) via `firebase_storage`, e a URL de download
/// resultante (`getDownloadURL()`) é o que entra em `photoUrls`. Como este
/// projeto ainda não está conectado ao Storage, o botão Salvar abaixo usa
/// URLs de placeholder no lugar — ver o comentário em `_buildPhotoUrls()`.
class AdminItemFormScreen extends ConsumerStatefulWidget {
  final String? itemId;

  const AdminItemFormScreen({super.key, this.itemId});

  bool get isEditing => itemId != null;

  @override
  ConsumerState<AdminItemFormScreen> createState() => _AdminItemFormScreenState();
}

class _AdminItemFormScreenState extends ConsumerState<AdminItemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _heightController = TextEditingController();
  final _widthController = TextEditingController();
  final _depthController = TextEditingController();
  final _weightController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  ItemCategory _category = ItemCategory.outros;
  ItemCondition _condition = ItemCondition.bom;
  ItemStatus _status = ItemStatus.disponivel;
  DateTime _entryDate = DateTime.now();
  final List<XFile> _newPhotos = [];
  List<String> _existingPhotoUrls = [];
  bool _loadedExisting = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _heightController.dispose();
    _widthController.dispose();
    _depthController.dispose();
    _weightController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _populateFrom(ReuseItem item) {
    _nameController.text = item.name;
    _descriptionController.text = item.description;
    _heightController.text = item.dimensions.heightCm?.toString() ?? '';
    _widthController.text = item.dimensions.widthCm?.toString() ?? '';
    _depthController.text = item.dimensions.depthCm?.toString() ?? '';
    _weightController.text = item.weightKg?.toString() ?? '';
    _quantityController.text = item.quantityAvailable.toString();
    _category = item.category;
    _condition = item.condition;
    _status = item.status;
    _entryDate = item.entryDate;
    _existingPhotoUrls = List.of(item.photoUrls);
  }

  Future<void> _pickPhotos() async {
    final total = _existingPhotoUrls.length + _newPhotos.length;
    if (total >= 10) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Máximo de 10 fotos por item.')));
      return;
    }
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(limit: 10 - total);
    if (picked.isNotEmpty) setState(() => _newPhotos.addAll(picked));
  }

  /// Ver nota de upload no topo do arquivo — troca por URLs reais do
  /// Storage assim que o Firebase estiver conectado.
  List<String> _buildPhotoUrls(String itemId) {
    final placeholderForNew = List.generate(
      _newPhotos.length,
      (i) => 'https://picsum.photos/seed/$itemId$i/900/900',
    );
    return [..._existingPhotoUrls, ...placeholderForNew];
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_existingPhotoUrls.isEmpty && _newPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Adicione ao menos uma foto.')));
      return;
    }

    setState(() => _saving = true);
    try {
      final id = widget.itemId ?? 'item_${DateTime.now().microsecondsSinceEpoch}';

      final item = ReuseItem(
        id: id,
        name: _nameController.text.trim(),
        category: _category,
        description: _descriptionController.text.trim(),
        condition: _condition,
        dimensions: ItemDimensions(
          heightCm: double.tryParse(_heightController.text),
          widthCm: double.tryParse(_widthController.text),
          depthCm: double.tryParse(_depthController.text),
        ),
        weightKg: double.tryParse(_weightController.text),
        entryDate: _entryDate,
        ecopontoId: kBresserEcopontoId,
        quantityAvailable: int.tryParse(_quantityController.text) ?? 1,
        status: _status,
        photoUrls: _buildPhotoUrls(id),
      );

      final repo = ref.read(itemRepositoryProvider);
      if (widget.isEditing) {
        await repo.updateItem(item);
      } else {
        await repo.createItem(item);
      }

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(widget.isEditing ? 'Item atualizado.' : 'Item cadastrado.')));
        context.pop();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditing && !_loadedExisting) {
      final itemAsync = ref.watch(itemByIdProvider(widget.itemId!));
      return itemAsync.when(
        data: (item) {
          if (item != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_loadedExisting) {
                setState(() {
                  _populateFrom(item);
                  _loadedExisting = true;
                });
              }
            });
          }
          return const Scaffold(body: LoadingIndicator());
        },
        loading: () => const Scaffold(body: LoadingIndicator()),
        error: (e, _) => const Scaffold(body: ErrorState()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.beige,
      appBar: AppBar(title: Text(widget.isEditing ? 'Editar item' : 'Novo item')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Text('Fotos (até 10)', style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            _PhotoPicker(
              existingUrls: _existingPhotoUrls,
              newPhotos: _newPhotos,
              onAdd: _pickPhotos,
              onRemoveExisting: (url) => setState(() => _existingPhotoUrls.remove(url)),
              onRemoveNew: (file) => setState(() => _newPhotos.remove(file)),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome do material'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<ItemCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Categoria'),
              items: [
                for (final c in ItemCategory.values)
                  DropdownMenuItem(value: c, child: Text(c.label)),
              ],
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Descrição', alignLabelWithHint: true),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Descreva o item' : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<ItemCondition>(
              value: _condition,
              decoration: const InputDecoration(labelText: 'Estado de conservação'),
              items: [
                for (final c in ItemCondition.values)
                  DropdownMenuItem(value: c, child: Text(c.label)),
              ],
              onChanged: (v) => setState(() => _condition = v!),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Dimensões (cm) — opcional', style: AppTextStyles.label),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(child: TextFormField(controller: _widthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Largura'))),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: TextFormField(controller: _heightController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Altura'))),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: TextFormField(controller: _depthController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Profundidade'))),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Peso (kg) — quando necessário'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Quantidade disponível'),
              validator: (v) => (int.tryParse(v ?? '') == null) ? 'Informe um número válido' : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<ItemStatus>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: [
                for (final s in ItemStatus.values) DropdownMenuItem(value: s, child: Text(s.label)),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: widget.isEditing ? 'Salvar alterações' : 'Cadastrar item',
              isLoading: _saving,
              onPressed: _save,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  final List<String> existingUrls;
  final List<XFile> newPhotos;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemoveExisting;
  final ValueChanged<XFile> onRemoveNew;

  const _PhotoPicker({
    required this.existingUrls,
    required this.newPhotos,
    required this.onAdd,
    required this.onRemoveExisting,
    required this.onRemoveNew,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final url in existingUrls) _Thumb(child: Image.network(url, fit: BoxFit.cover), onRemove: () => onRemoveExisting(url)),
          for (final file in newPhotos) _Thumb(child: Image.file(File(file.path), fit: BoxFit.cover), onRemove: () => onRemoveNew(file)),
          InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Container(
              width: 84,
              height: 84,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.beigeSoft,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.greyBorder, style: BorderStyle.solid),
              ),
              child: const Icon(Icons.add_a_photo_outlined, color: AppColors.mediumGreen),
            ),
          ),
        ],
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final Widget child;
  final VoidCallback onRemove;

  const _Thumb({required this.child, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 84,
          height: 84,
          margin: const EdgeInsets.only(right: 8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.md)),
          child: child,
        ),
        Positioned(
          top: 2,
          right: 10,
          child: GestureDetector(
            onTap: onRemove,
            child: const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.black54,
              child: Icon(Icons.close_rounded, size: 12, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
