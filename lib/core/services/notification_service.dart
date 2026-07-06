/// Camada de integração com o Firebase Cloud Messaging (push notifications).
///
/// Este serviço fica desativado (métodos são no-ops) enquanto o Firebase não
/// está configurado. Depois de rodar `flutterfire configure` e habilitar
/// Firebase no `main.dart`, implemente cada método conforme os comentários.
///
/// --- Estratégia recomendada para os 3 gatilhos do briefing ---
/// 1. Novo item cadastrado -> Cloud Function `onCreate` na coleção `produtos`,
///    enviando para o tópico `todos_usuarios`.
/// 2. Categoria favorita recebeu item -> a mesma function verifica quais
///    usuários seguem aquela categoria (`users/{uid}/favoriteCategories`) e
///    envia para os tokens desses usuários.
/// 3. Confirmação de interesse -> notificação local/imediata ao usuário
///    logo após `addInterest()`, confirmando o registro (não depende de
///    Cloud Function, pode ser feita no client).
class NotificationService {
  Future<void> initialize() async {
    // TODO: FirebaseMessaging.instance.requestPermission(...)
    // TODO: obter e persistir o token do dispositivo em
    //       users/{uid}/fcmTokens/{token} para permitir envio direcionado.
    // TODO: FirebaseMessaging.onMessage.listen((message) { ... })
    // TODO: configurar canal de notificação no Android (importance alta).
  }

  Future<void> subscribeToCategory(String categoryFirestoreId) async {
    // TODO: FirebaseMessaging.instance.subscribeToTopic('categoria_$categoryFirestoreId');
  }

  Future<void> unsubscribeFromCategory(String categoryFirestoreId) async {
    // TODO: FirebaseMessaging.instance.unsubscribeFromTopic('categoria_$categoryFirestoreId');
  }
}
