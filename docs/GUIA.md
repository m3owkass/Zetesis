# Guia do Zetesis

App de estudos de filosofia em forma de quiz: o usuário escolhe um **tema**,
seleciona uma **tarefa** e responde **perguntas** de modalidades variadas,
ganhando **pontos** que gasta na **loja**. Há também uma **biblioteca** de
materiais de apoio.

Este documento descreve a arquitetura, como cada parte funciona e o histórico
de mudanças. Para detalhes de uma tela específica, veja a seção
[Funcionalidades](#funcionalidades).

---

## Sumário

- [Arquitetura em camadas](#arquitetura-em-camadas)
- [Estrutura de pastas](#estrutura-de-pastas)
- [Camada de dados (repositories)](#camada-de-dados-repositories)
- [Estado e providers](#estado-e-providers)
- [Design system](#design-system)
- [Funcionalidades](#funcionalidades)
- [Modelo de dados (Firestore)](#modelo-de-dados-firestore)
- [Tela de desenvolvedor (seed)](#tela-de-desenvolvedor-seed)
- [Changelog](#changelog)

---

## Arquitetura em camadas

```
UI (views + widgets)
        │  observa providers / chama repositories
        ▼
Estado (Riverpod providers)  ──►  Controller (AuthController)
        │
        ▼
Repositories (1 por model)   ──►  AuthService / SecureStorage
        │
        ▼
Firebase (Auth + Firestore) + Supabase Storage (imagens)
```

Regras gerais:

- **A UI nunca fala direto com o Firestore.** Ela observa *providers* (leitura
  reativa) e chama *repositories* (escrita).
- **Cada model tem um repository.** Nada de "God object" de banco.
- **Leituras são streams** sempre que faz sentido — a tela reflete o banco em
  tempo real, sem `invalidate` manual.

---

## Estrutura de pastas

```
lib/
├── main.dart                  # bootstrap (Firebase, Supabase, Hive) + MaterialApp
├── auth_gate.dart             # decide entre LoginScreen e Index conforme o login
│
├── config/                    # chaves do Firebase/Supabase (fora do git)
│
├── model/                     # modelos puros (fromMap / toMap)
│   ├── usuario.dart
│   ├── tema.dart
│   ├── tarefa.dart            # tem List<PerguntaModel>
│   ├── pergunta.dart          # tem List<RespostaModel> + TipoPergunta
│   ├── resposta.dart
│   ├── item_loja.dart
│   ├── grupo_biblioteca.dart
│   └── material_biblioteca.dart
│
├── services/
│   ├── auth_service.dart              # Firebase Auth (e-mail/senha + Google)
│   ├── secure_storage_service.dart    # cache local do usuário
│   ├── seed_tarefas.dart              # conteúdo de seed das tarefas
│   └── repositories/                  # 1 repository por model
│       ├── base_repository.dart       # CRUD genérico (add/update/remove/getAll/watchAll)
│       ├── usuario_repository.dart    # + concluirTarefa, comprarItem, favoritos
│       ├── tema_repository.dart       # + getByName
│       ├── tarefa_repository.dart     # + watchByTema
│       ├── item_loja_repository.dart
│       ├── grupo_biblioteca_repository.dart
│       └── material_biblioteca_repository.dart  # + watchByType / getByType
│
├── controller/
│   └── auth_controller.dart   # orquestra login/cadastro/logout/perfil (StateNotifier)
│
├── provider/
│   └── providers.dart         # todos os providers Riverpod num lugar só
│
├── theme/
│   ├── app_colors.dart        # paleta única (tokens de cor)
│   └── app_theme.dart         # ThemeData + AppRadius + AppSpacing
│
├── views/                     # uma tela por arquivo (só orquestração)
│   ├── index.dart             # casca com AppBar + BottomNav (IndexedStack)
│   ├── desafio_start.dart     # home
│   ├── selecao_tema.dart
│   ├── selecao_tarefa_screen.dart
│   ├── tarefa_screen.dart     # o quiz
│   ├── loja_screen.dart
│   ├── biblioteca_screen.dart
│   ├── materialbiblioteca_screen.dart
│   ├── perfil_screen.dart
│   ├── login_screen.dart / cadastro_screen.dart
│   └── developer_screen.dart  # seed de dados (só para devs)
│
└── widgets/
    ├── components/            # genéricos reutilizáveis em todo o app
    │   ├── app_button.dart        # botão padrão (variantes + loading)
    │   ├── pontos_badge.dart      # phatos.webp + valor — padrão de "pontos"
    │   ├── mensagem_estado.dart   # estado vazio / erro
    │   ├── appbar.dart / bottom_navigation.dart
    │   ├── custom_formfield.dart
    │   ├── storage_image.dart / storage_upload_button.dart
    │   ├── password_recovery_dialog.dart
    │   ├── item_card.dart / item_tema.dart / item_tarefa.dart
    │   └── grupo_biblioteca.dart / item_biblioteca.dart
    ├── forms/                 # login_form, cadastro_form
    ├── home/                  # circulo_tema, painel_tema, convite_primeiro_tema
    ├── loja/                  # saldo_pontos_header, item_loja_card
    ├── perfil/                # perfil_chip, campo_perfil
    └── quiz/                  # quiz_top_bar, enunciado_pergunta, opcoes_pergunta,
                               #   painel_feedback, resultado_tarefa
```

**Convenção:** uma tela (`views/`) deve conter idealmente só a classe da tela.
Os pedaços visuais vão para `widgets/<feature>/`. Componentes genéricos (usados
por mais de uma feature) ficam em `widgets/components/`.

---

## Camada de dados (repositories)

Toda persistência passa por um repository. O [`BaseRepository<T>`](../lib/services/repositories/base_repository.dart)
implementa o CRUD comum sobre uma coleção:

| Método | O que faz |
|--------|-----------|
| `add(item)` | cria documento, devolve o id |
| `update(id, fields)` | atualiza campos |
| `remove(id)` | apaga documento |
| `getById(id)` | busca um |
| `getAll()` | lista (com try/catch → `[]` em erro) |
| `watchAll()` | stream da coleção |

Cada repository concreto informa a coleção e como converter documento ⇄ modelo
(`fromDoc` / `toMap`), e adiciona o que é específico dele:

- **`TemaRepository`** → `getByName(nome)`
- **`TarefaRepository`** → `watchByTema(tema)`
- **`MaterialBibliotecaRepository`** → `watchByType(tipo)`, `getByType(tipo)`
- **`UsuarioRepository`** (caso especial — 1 doc por uid, não uma coleção de
  modelos): `watch(uid)`, `concluirTarefa`, `comprarItem` (transação),
  `watchFavoritos` / `toggleFavorito`.

> `comprarItem` roda numa **transação** do Firestore: lê o saldo no servidor,
> valida e debita atomicamente — evita saldo negativo em toques concorrentes.
> Devolve um `CompraResult(ok, erro)`.

---

## Estado e providers

Todos em [`provider/providers.dart`](../lib/provider/providers.dart):

| Provider | Tipo | Fonte |
|----------|------|-------|
| `authStateProvider` | Stream | mudanças de login (Firebase) |
| `userProvider` | **Stream** | doc do usuário (`UsuarioRepository.watch`) |
| `temasProvider` | Stream | todos os temas |
| `temaSelecionadoProvider` | State | nome do tema escolhido (em memória) |
| `temaAtualProvider` | Future | tema escolhido resolvido por nome |
| `tarefasProvider` | Stream | tarefas do tema selecionado |
| `todasTarefasProvider` | Stream | todas as tarefas |
| `gruposProvider` | Stream | grupos da biblioteca |
| `grupoSelecionadoProvider` | State | grupo aberto |
| `materiaisProvider` | Stream | materiais do grupo selecionado |
| `favoritosProvider` | Stream | favoritos (com cache local em Hive) |
| `itemsProvider` | Stream | itens da loja |
| `*RepositoryProvider` | Provider | instância de cada repository |

Como `userProvider` é **stream**, pontos, tarefas concluídas e itens comprados
se atualizam sozinhos na tela assim que o banco muda. Não é preciso
`ref.invalidate(userProvider)` após gravar.

---

## Design system

- **Cores** — [`AppColors`](../lib/theme/app_colors.dart): paleta única. Use
  sempre os tokens (`AppColors.primary`, `.accent`, `.success`…) em vez de
  `Color(0x...)` solto.
- **Tema** — [`AppTheme.light`](../lib/theme/app_theme.dart): `TextTheme` com
  tamanhos fixos, `AppRadius` (sm/md/lg/pill) e `AppSpacing` (xs/sm/md/lg).
- **Botão** — [`AppButton`](../lib/widgets/components/app_button.dart): variantes
  `primary/success/danger/accent/neutral`, com estado `loading` que desabilita e
  mostra spinner (evita toque duplo).
- **Pontos** — [`PontosBadge`](../lib/widgets/components/pontos_badge.dart): a
  imagem `assets/phatos.webp` + valor. É o **padrão visual de "pontos"** em todo
  o app (appbar, loja, perfil, quiz).
- **Estados vazios/erro** — [`MensagemEstado`](../lib/widgets/components/mensagem_estado.dart):
  ícone + título + subtítulo. `MensagemEstado.erro(...)` não vaza a exceção para
  o usuário.

---

## Funcionalidades

### Navegação ([`index.dart`](../lib/views/index.dart))
`AppBar` (saudação + avatar com menu Perfil/Sair + saldo em phatos) e uma
`BottomNav` de 3 abas (Trilha/Biblioteca/Loja) com **estado selecionado**
(indicador + opacidade). As páginas ficam num `IndexedStack`, preservando o
scroll de cada aba ao alternar.

### Home ([`desafio_start.dart`](../lib/views/desafio_start.dart))
Mostra o tema atual (`CirculoTema` — tocar troca de tema), o **progresso real**
do tema (`PainelTema`: X/Y tarefas concluídas + barra) e um CTA que alterna
entre **Iniciar desafio** e **Continuar**. Sem tema escolhido, exibe
`ConvitePrimeiroTema`.

### Seleção de tema / tarefa
Grids de cartões com confirmação. A tarefa já pontuada aparece com selo
**Concluída**. Estados de carregamento, vazio e erro tratados.

### Quiz ([`tarefa_screen.dart`](../lib/views/tarefa_screen.dart))
Coração do app. Orquestra o estado e delega o visual a `widgets/quiz/`:

- **Modalidades** (`OpcoesPergunta`): múltipla escolha (A–D), verdadeiro/falso
  (dois cartões) e complete-a-lacuna (chips que preenchem o `___` do enunciado).
- **Combo**: a partir de 3 acertos seguidos, cada acerto rende bônus (`+5`).
- **Pontuação única**: a tarefa só credita pontos na **primeira** conclusão.
  Refazer entra em **modo prática** (aviso no topo, sem pontos).
- **Sair com segurança**: fechar no meio (botão X ou gesto de voltar) pede
  confirmação se houver progresso — via `PopScope`.
- **Próxima tarefa**: a tela de resultado oferece emendar a próxima tarefa não
  concluída do mesmo tema, além de Concluir.

Fluxo de pontuação: responde → `Verificar` → `PainelFeedback` (certo/errado +
explicação + combo) → `Continuar` → ... → `ResultadoTarefa`.

### Loja ([`loja_screen.dart`](../lib/views/loja_screen.dart))
Lista de itens (`ItemLojaCard`) com saldo no topo (`SaldoPontosHeader`). Comprar
valida saldo, pede confirmação e grava via transação; o item vira **Adquirido** e
o botão é desabilitado quando faltam pontos. *Aplicar o cosmético comprado
(trocar avatar/tema) ainda não está implementado — a compra hoje só registra a
posse.*

### Biblioteca
`biblioteca_screen` lista grupos; ao abrir um grupo, `materialbiblioteca_screen`
lista os materiais, com **favoritar** (estrela). Favoritos têm cache local
(Hive) além do Firestore.

### Perfil ([`perfil_screen.dart`](../lib/views/perfil_screen.dart))
Avatar, pontos e ranking (`PerfilChip`), edição de nome inline (`CampoPerfil`)
com confirmação real de salvamento, redefinição de senha e logout.

### Autenticação
Login/cadastro com e-mail-senha ou Google, via `AuthController`. O **login** só
exige que a senha não esteja vazia; o **cadastro** exige senha forte. Telas com
scroll (sem overflow com teclado) e navegação com `pushReplacement` entre elas.

---

## Modelo de dados (Firestore)

```
users/{uid}
  nome, email, avatarUrl, admin, developer, ranking, pontos,
  temaAtual,
  tarefasConcluidas: [tarefaId, ...]   # controla pontuação única e progresso
  itensComprados:    [itemId, ...]     # controla "Adquirido" na loja
  favoritos:         [materialId, ...]

temas/{id}            → nome, descricao, assetUrl
tarefas/{id}          → nome, descricao, tema, enviadoPor, dataEnvio,
                          perguntas: [ {enunciado, explicacao, tipo,
                          respostas: [{texto, isCorrect}]} ]
items/{id}            → nome, custo, assetUrl, status
grupos_biblioteca/{id}→ nome, descricao, assetUrl
materiais/{id}        → nome, tipo, descricao, autor, dataEnvio, assetUrl,
                          enviadoPor
```

> Imagens (temas, itens, grupos) ficam no **Supabase Storage**; o documento
> guarda só o caminho, resolvido por `StorageImage`.

---

## Tela de desenvolvedor (seed)

[`developer_screen.dart`](../lib/views/developer_screen.dart) (acessível só para
usuários com `developer: true`, via botão na Biblioteca) permite limpar e popular
temas, tarefas, itens, grupos e materiais, e subir imagens. As tarefas de seed
vêm de [`seed_tarefas.dart`](../lib/services/seed_tarefas.dart) (2 por tema,
modalidades mistas).

> **Importante:** tarefas gravadas no formato antigo (`respostas` como lista de
> strings) aparecem "sem perguntas". Na tela de dev, use **Limpar tarefas** e
> depois **Criar tarefas** para popular no formato atual.

---

## Changelog

### Refatoração de arquitetura e UI (atual)

**Camada de dados**
- Substituído o `DatabaseService` monolítico por **um repository por model**
  (`base_repository` + 6 concretos). Removido o `DatabaseService`.
- `userProvider` virou **stream** do documento do usuário.
- Removidos models e métodos órfãos sem nenhuma UI: `filosofo`, `texto`,
  `musica`, `filme` (eram só scaffolding).

**Tarefas / perguntas / respostas**
- `TarefaModel` passou a ter `List<PerguntaModel>`; `PerguntaModel` tem
  `List<RespostaModel>` e `TipoPergunta` (múltipla / V-F / lacuna).
- Pontuação única por tarefa (`tarefasConcluidas`) + modo prática ao refazer.
- Quiz: combo de acertos, confirmação ao sair, "próxima tarefa" no resultado.
- Quiz componentizado em `widgets/quiz/`.

**Design system**
- Tokens de cor (`AppColors`), tema central (`AppTheme`, `AppRadius`,
  `AppSpacing`), `AppButton`, `PontosBadge` (phatos como padrão de pontos),
  `MensagemEstado` para vazio/erro.

**Telas**
- AppBar/BottomNav nos tokens, com estado selecionado; `IndexedStack` no Index.
- Home com progresso real e CTA Iniciar/Continuar.
- Loja com compra funcional (transação, valida saldo, "Adquirido").
- Perfil: removidos botões mortos; edição de nome com confirmação real; pontos e
  ranking visíveis.
- Login/cadastro: corrigida validação de senha que travava login; scroll;
  `pushReplacement`.
- Classes empilhadas das telas (loja, perfil, home) extraídas para
  `widgets/<feature>/`.

### Convenções para mudanças futuras
- Persistência nova → método no repository correspondente (ou um novo
  repository). A UI não chama Firestore direto.
- Cor/tamanho/espaçamento → use os tokens de `theme/`. Evite valores soltos.
- Pedaço visual reaproveitável → vira widget em `widgets/<feature>/` (ou
  `components/` se for genérico). Telas em `views/` ficam enxutas.
- Rode `flutter analyze` antes de concluir — o projeto fecha com **0 issues**.
