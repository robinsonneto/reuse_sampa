import '../entities/ecoponto.dart';

abstract class EcopontoRepository {
  Stream<List<EcoPonto>> watchAllEcopontos();

  Future<EcoPonto?> getEcopontoById(String id);

  Future<void> createEcoponto(EcoPonto ecoponto);
}
