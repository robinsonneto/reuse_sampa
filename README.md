# Reuse Sampa — Projeto Piloto (Ecoponto Bresser)

Aplicativo Flutter para o catálogo digital do espaço Reuse Sampa dentro do
**Ecoponto Bresser**. O cidadão visualiza gratuitamente os materiais
disponíveis, pode demonstrar interesse em um item e ver como chegar até o
Ecoponto. Não há venda nem reserva automática — a retirada acontece
presencialmente, por ordem de chegada.

> Este é um projeto piloto de uma única unidade. Toda a arquitetura já usa
> `ecopontoId` internamente (nunca um valor fixo espalhado pelo código), para
> que uma expansão futura a outros Ecopontos não exija refatoração — apenas
> passar a variar esse valor e, aí sim, expor seleção de unidade na UI.

## Sumário

- [Stack e arquitetura](#stack-e-arquitetura)
- [Estrutura de pastas](#estrutura-de-pastas)
- [Como rodar o projeto](#como-rodar-o-projeto)
- [O que é mock hoje vs. o que precisa de Firebase real](#o-que-é-mock-hoje-vs-o-que-precisa-de-firebase-real)
- [Modelo de dados sugerido (Firestore)](#modelo-de-dados-sugerido-firestore)
- [Regras de negócio do piloto](#regras-de-negócio-do-piloto)
- [Identidade visual](#identidade-visual)
- [Limitações conhecidas / próximos passos](#limitações-conhecidas--próximos-passos)

## Stack e arquitetura

- **Flutter 3.19+** com **Material Design 3**, modo claro e escuro.
- **Clean Architecture + MVVM**: `domain` (entidades e contratos de
  repositório, sem dependência de Flutter) → `data` (implementações mock,
  prontas para virar Firestore) → `presentation` (providers Riverpod,
  telas, widgets).
- **Riverpod** para estado e injeção de dependência.
- **GoRouter** com `StatefulShellRoute.indexedStack` para o menu inferior
  (cada aba mantém histórico e scroll próprios).
- **google_fonts** (Poppins para títulos, Inter para corpo) — sem
  necessidade de empacotar fontes localmente.

Todas as implementações de repositório hoje são **mocks em memória**
(`data/repositories/*_impl.dart`). Cada uma documenta, em comentário, como
migrar para `cloud_firestore`/`firebase_storage`/`firebase_auth`. As telas e
providers **não vão precisar mudar** nessa migração, pois dependem apenas
das interfaces em `domain/repositories`.

## Estrutura de pastas

```
lib/
  core/
    constants/     # categorias, rotas nomeadas
    theme/         # cores, tipografia, espaçamento, ThemeData
    utils/         # formatação de datas etc.
    widgets/       # botões, badges, empty states reutilizáveis
    services/      # stubs de Firebase Messaging (notificações)
  domain/
    entities/      # ReuseItem, EcoPonto, Interest, AppUser, AppNotification
    repositories/  # contratos abstratos (sem Flutter/Firebase)
  data/
    datasources/   # dados mock (itens, o Ecoponto Bresser, notificações)
    repositories/  # implementações mock dos contratos acima
  presentation/
    providers/     # Riverpod: repositórios, itens, interesses, stats...
    router/        # GoRouter
    widgets/       # cards, shell do menu inferior, etc.
    screens/       # uma pasta por tela/fluxo
```

## Como rodar o projeto

```bash
flutter pub get
flutter run
```

O app roda imediatamente com dados mock — não é necessário Firebase para
navegar por todas as telas.

### Gerar um .apk sem instalar nada localmente (Codemagic)

Este projeto tem um `codemagic.yaml` na raiz, pronto para uso:

1. Suba esta pasta para um repositório no GitHub (dá para fazer isso direto
   pelo site do GitHub, arrastando os arquivos, sem usar linha de comando).
2. Crie uma conta em [codemagic.io](https://codemagic.io) (dá para entrar
   direto com a conta do GitHub) e clique em **Add application**.
3. Conecte o repositório que você acabou de criar. Como já existe um
   `codemagic.yaml`, o Codemagic detecta e oferece o workflow **"Reuse
   Sampa - Build Android APK"** automaticamente.
4. Clique em **Start new build**. O primeiro script do workflow gera as
   pastas nativas `android/`/`ios/`/`web/` (que este projeto não inclui, por
   ter sido criado sem o Flutter SDK instalado), e na sequência compila o
   `.apk`.
5. Quando o build terminar (uns 5–10 minutos), baixe o `.apk` na aba
   **Artifacts** e transfira para o celular Android (ou abra o link direto
   pelo navegador do celular) para instalar.

**Duas ressalvas nesse primeiro build de teste:**
- Sem uma chave do Google Maps configurada, a aba "Ecoponto" pode não
  exibir o mapa corretamente (o resto do app funciona normalmente). Ver
  instruções em `lib/presentation/screens/ecoponto/ecoponto_screen.dart`.
- Login (Google/Apple/gov.br/e-mail) é simulado até o Firebase ser
  conectado — qualquer credencial "loga com sucesso" para fins de teste.

### Conectar o Firebase de verdade (opcional, para produção)

1. Instale a FlutterFire CLI e rode `flutterfire configure` na raiz do
   projeto. Isso gera `lib/firebase_options.dart`.
2. Em `lib/main.dart`, descomente os imports e a chamada
   `Firebase.initializeApp(...)` (já deixados prontos, comentados).
3. Troque cada implementação Mock por uma implementação Firestore em
   `lib/presentation/providers/repository_providers.dart` — é o único
   arquivo que injeta as implementações concretas.
4. Para o mapa do Ecoponto (`EcopontoScreen`), adicione uma chave do Google
   Maps SDK no `AndroidManifest.xml` (Android) e via `GMSServices.provideAPIKey`
   (iOS) — instruções detalhadas em comentário no topo de
   `lib/presentation/screens/ecoponto/ecoponto_screen.dart`.

## O que é mock hoje vs. o que precisa de Firebase real

| Área | Hoje (mock) | Produção |
|---|---|---|
| Itens (`produtos`) | Lista em memória, `data/datasources/mock_items.dart` | `cloud_firestore`, coleção `produtos` |
| Ecoponto | Um único registro fixo, `mock_ecopontos.dart` | Coleção `ecoponto` (1 documento, `id: bresser`) |
| Interesses | Lista em memória | Coleção `interesses` + `arrayUnion` em `produtos.interessados` |
| Autenticação | E-mail/Google/Apple/gov.br simulados, sempre "logam com sucesso" | `firebase_auth` + `google_sign_in` + `sign_in_with_apple`; gov.br via OAuth2 próprio (ver comentário em `auth_repository_impl.dart`) |
| Notificações push | Histórico estático de exemplo | `firebase_messaging` + Cloud Functions (gatilhos documentados em `core/services/notification_service.dart`) |
| Upload de fotos | Seleciona local e usa placeholder (`picsum.photos`) | `firebase_storage`, bucket `produtos/{itemId}/{n}.jpg` |
| Estatísticas (Dashboard / Impacto Ambiental) | Calculadas a partir dos itens mock + números simulados (usuários, visitas) | Agregação real via Cloud Functions ou consultas Firestore |

## Modelo de dados sugerido (Firestore)

```
ecoponto/
  bresser/                 # único documento por enquanto
    nome: "Ecoponto Bresser"
    endereco, telefone, horarios, latitude, longitude
    fachadaUrl, fotosEspaco: [...], sobreEspaco

produtos/
  {produtoId}/
    nome, descricao, categoria, estado        # estado = conservação
    imagens: [...]
    dataCadastro
    disponivel: bool                          # true = disponível, false = retirado
    ecopontoId: "bresser"                     # preparado para múltiplas unidades
    interessados: [uid1, uid2, ...]           # contagem rápida / verificação de duplicidade

interesses/
  {interesseId}/
    produtoId, produtoNome, usuarioId, usuarioNome, ecopontoId, criadoEm
    # registro completo com data/hora, para consulta administrativa
```

## Regras de negócio do piloto

- **Sem reserva automática.** O botão do produto é **"Tenho interesse"**,
  não "Reservar". Ele grava o interesse (produto + usuário + data) só para
  fins estatísticos — não bloqueia o item para os demais.
- **Retirada por ordem de chegada**, presencialmente no Ecoponto Bresser.
- Um item tem apenas dois status: **disponível** ou **retirado** (marcado
  pela equipe no painel administrativo).
- Categorias do piloto (9): Roupas, Livros, Brinquedos, Móveis, Utensílios,
  Materiais de construção, Objetos decorativos, Ferramentas, Outros.

## Identidade visual

Paleta extraída do quadro de marca fornecido:

| Cor | Hex |
|---|---|
| Verde escuro (primária) | `#2E5E3E` |
| Verde médio (secundária) | `#67A65B` |
| Verde claro (apoio) | `#A3C16E` |
| Laranja (destaque/CTA) | `#E07A3F` |
| Bege (fundo) | `#F2E9D8` |
| Cinza-texto | `#333333` |

Tipografia: **Poppins** (títulos) + **Inter** (corpo), via `google_fonts`.

## Limitações conhecidas / próximos passos

- [ ] Substituir o logo vetorial aproximado (`_ReuseLogoPainter`, usado na
      splash) pelo arquivo oficial em `assets/images/`.
- [ ] Conectar Firebase (Auth, Firestore, Storage, Messaging) seguindo a
      tabela acima.
- [ ] Substituir endereço/telefone/coordenadas fictícios do Ecoponto Bresser
      pelos dados reais.
- [ ] Implementar upload real de fotos (hoje usa placeholders).
- [ ] Validar a metodologia de cálculo de CO₂ evitado com a SVMA antes de
      exibir o número publicamente.
- [ ] Login administrativo hoje aceita qualquer credencial (mock) — trocar
      por validação de custom claim `admin: true` no Firebase Auth.
- [ ] Estrutura já preparada, mas ainda não exposta na UI: expansão para
      múltiplos Ecopontos (`ecopontoId` variável, repositórios já aceitam
      `createEcoponto`/múltiplos registros).
