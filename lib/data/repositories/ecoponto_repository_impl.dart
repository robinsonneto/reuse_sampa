import 'dart:async';
import '../../domain/entities/ecoponto.dart';
import '../../domain/repositories/ecoponto_repository.dart';
import '../datasources/mock_ecopontos.dart';

/// Implementação MOCK. Migrar para Firestore usando a coleção `ecopontos`.
class MockEcopontoRepository implements EcopontoRepository {
  final List<EcoPonto> _ecopontos = List.of(mockEcopontos);
  final _controller = StreamController<List<EcoPonto>>.broadcast();

  MockEcopontoRepository() {
    _controller.add(List.unmodifiable(_ecopontos));
  }

  @override
  Stream<List<EcoPonto>> watchAllEcopontos() => _controller.stream;

  @override
  Future<EcoPonto?> getEcopontoById(String id) async {
    try {
      return _ecopontos.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createEcoponto(EcoPonto ecoponto) async {
    _ecopontos.insert(0, ecoponto);
    _controller.add(List.unmodifiable(_ecopontos));
  }

  void dispose() => _controller.close();
}
