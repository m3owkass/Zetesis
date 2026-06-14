# Changelog

## 12/06/2026

### Adicionado

- **`lib/dev/`** — pasta para ferramentas internas (seeds, telas de inspeção); recebeu `seed_screen.dart` (a antiga `developer_screen.dart`, antes em `views/`) e `seed_tarefas.dart` (antes em `services/`)
- **`AdminScreen` (painel administrativo)** — `views/admin_screen.dart`: dashboard com contadores (tarefas, conteúdos, usuários) e cards de gestão (Tarefas, Conteúdos, Usuários — ações ainda em construção); em debug, um card extra abre a `SeedScreen`
- **Providers de contagem** — `todosMateriaisProvider` (todos os materiais, sem filtro de grupo) e `totalUsuariosProvider` (via `UsuarioRepository.watchTotal`)
- **Item "Admin" no menu do avatar** — aparece para contas com `admin: true` (qualquer build) ou `developer: true` (somente debug) e navega para o painel administrativo
- **Testes reais em `test/widget_test.dart`** — 3 testes do `AppButton` (label + tap, loading bloqueia toque, `onPressed` nulo desabilita); rodam sem Firebase, `flutter test` voltou a passar

### Alterado

- **Renomeação de views** — todas as telas seguem `snake_case` + sufixo `_screen`, classe acompanha o arquivo:
  | Antes | Depois | Classe |
  |---|---|---|
  | `views/index.dart` | `views/home_shell.dart` | `Index` → `HomeShell` |
  | `views/desafio_start.dart` | `views/home_screen.dart` | `DesafioStart` → `HomeScreen` |
  | `views/selecao_tema.dart` | `views/selecao_tema_screen.dart` | `SelecaoTema` → `SelecaoTemaScreen` |
  | `views/materialbiblioteca_screen.dart` | `views/material_biblioteca_screen.dart` | (sem mudança) |
  | `views/selecaoTarefa_screen.dart` | `views/selecao_tarefa_screen.dart` | (sem mudança) |
- **Acesso às ferramentas de seed** — a antiga tela de seed (agora `SeedScreen`, em `lib/dev/`) só é alcançável em build de debug, via card "Seed de dados" no painel administrativo; o FAB de admin da Biblioteca foi removido (entrada única pelo menu do avatar)
- **Cache de favoritos** — a lógica Hive saiu do `favoritosProvider` e foi para `UsuarioRepository.watchFavoritos` (mesmo comportamento: emite cache primeiro, regrava a cada mudança; box `userBox`, chave `favoritos_<uid>`)

### Removido

- **Todos os comentários do código** — `//`, `///` e `/* */` removidos de `lib/` e `test/` (~150 linhas em 49 arquivos), seguidos de `dart format`. Exceção: `lib/config/firebase_options.dart`, que é gerado pelo FlutterFire

---

## Guia: convenções após a reorganização

- **Telas novas** → `lib/views/nome_da_tela_screen.dart`, classe `NomeDaTelaScreen`. `HomeShell` é o casco (AppBar + bottom nav + `IndexedStack`); `HomeScreen` é o conteúdo da aba inicial
- **Ferramenta interna** (seed, migração de dados, tela de debug) → nasce em `lib/dev/`, nunca em `views/` ou `services/`. Para popular o Firestore: app em debug, conta com `admin: true` ou `developer: true` em `users/{uid}`, menu do avatar → Admin → card "Seed de dados"
- **Providers** (`provider/providers.dart`) só conectam repositories ao Riverpod — regra de negócio, persistência e cache local ficam na camada de repository (`services/repositories/`)
- **Sem comentários no código** — o que precisar de explicação vai para `docs/GUIA.md` ou para este changelog; no código, a intenção fica em nomes descritivos
- **Testes** — prefira componentes puros de `widgets/components/` (não dependem de Firebase); `flutter test` está verde e pode entrar em CI/pre-commit

---

## 04/06/2026 | 05/06/2026

### Adicionado

- **Supabase Storage** — upload e exibição de imagens via storage path curto no Firestore; URL pública resolvida em runtime pelo widget `StorageImage`
- **`StorageImage` widget** — exibe imagens de paths do Supabase ou URLs diretas com cache em disco via `cached_network_image`
- **Favoritos por usuário** — persistidos no Firestore (`users/{uid}.favoritos[]`) com seed imediato via Hive enquanto a rede carrega; toggle atômico via `arrayUnion`/`arrayRemove`
- **`AdminScreen`** — painel temporário de seed: cria/limpa grupos, materiais e temas; lista itens existentes com thumbnail e botão de upload de imagem direto para o Supabase
- **`campos autor e dataEnvio`** em `MaterialBibliotecaModel` — exibidos no card da biblioteca
- **`setup.ps1`** — script de setup; cria `supabase_config.dart`, `firebase_options.dart` e `google-services.json` automaticamente via base64 embutido
- **`supabase_config.example.dart`** e **`firebase_options.example.dart`** — templates para documentar estrutura sem expor credenciais

### Alterado

- **StreamProviders** — `gruposProvider`, `materiaisProvider`, `temasProvider` e `itemsProvider` migrados de `FutureProvider` para `StreamProvider`; Firestore agora atualiza a UI em tempo real sem reiniciar o app
- **`DatabaseService`** — adicionados métodos `watch*` com `.snapshots()` para grupos, materiais, temas e itens; adicionados `watchFavoritos` e `toggleFavorito`
- **`ItemBiblioteca`** — redesenhado: layout em card com título bold, autor, data e corpo de texto; badge de favorito no canto superior direito
- **`MaterialBibliotecaScreen`** — grid 2 colunas substituído por lista vertical de largura total; favorito integrado com Firestore
- **`ItemTema`** — substituído `CircleAvatar` + `NetworkImage` por `ClipOval` + `StorageImage`; label com `maxLines: 1` e `overflow: ellipsis`
- **`ItemCard`** — `Image.network` substituído por `StorageImage` com `SizedBox.expand`
- **`SelecaoTema`** — `_confirm()` tornou-se síncrono; `Navigator.pop()` imediato com persistência em background; `childAspectRatio: 0.82` e espaçamento aumentado no grid
- **`.gitignore`** — adicionados `firebase_options.dart`, `google-services.json`, `supabase_config.dart`, `setup.ps1`
- **`README.md`** — stack, dependências, configuração, estrutura e Firestore atualizados

### Removido

- Dependência `firebase_storage` — substituída por `supabase_flutter`

---

## Guia: Imagens no app

### O que acontece quando uma imagem é exibida

O Firestore guarda só o **path curto** (`grupos/abc123`), não a URL completa.
O widget `StorageImage` monta a URL pública na hora:

```
Firestore: assetUrl = "grupos/abc123"
                ↓
StorageImage recebe o path
                ↓
Monta: https://xxx.supabase.co/storage/v1/object/public/assets/grupos/abc123
                ↓
CachedNetworkImage baixa e salva em disco (próxima vez não baixa de novo)
```

---

### Exibir uma imagem — `StorageImage`

Arquivo: `lib/widgets/components/storage_image.dart`

```dart
// Uso básico — dentro de qualquer widget
StorageImage(path: grupo.assetUrl)

// Com tamanho e placeholder
StorageImage(
  path: grupo.assetUrl,
  width: 80,
  height: 80,
  fit: BoxFit.cover,
  placeholder: const Icon(Icons.image_outlined),
)
```

`path` pode ser:
- Path curto: `"grupos/abc123"` → widget monta a URL do Supabase
- URL completa: `"https://..."` → widget usa direto
- `null` ou vazio → mostra o placeholder

Exemplos reais no projeto:
- `item_card.dart` — imagem do grupo da biblioteca
- `item_tema.dart` — imagem circular do tema dentro de `ClipOval`

---

### Fazer upload de imagem — `StorageUploadButton`

Arquivo: `lib/widgets/components/storage_upload_button.dart`

Abre a galeria, faz o upload para o Supabase e chama `onUploaded` com o path salvo.

```dart
StorageUploadButton(
  storagePath: 'grupos/${grupo.id}',
  onUploaded: (path) async {
    // path já é o mesmo que storagePath: 'grupos/abc123'
    // salva no Firestore via repository (obtido do provider)
    await ref
        .read(grupoBibliotecaRepositoryProvider)
        .update(grupo.id!, {'assetUrl': path});
  },
)
```

Customizações opcionais:
```dart
StorageUploadButton(
  storagePath: 'usuarios/${user.uid}',
  label: 'Trocar foto',
  icon: Icons.photo_camera,
  style: ElevatedButton.styleFrom(...),
  onUploaded: (path) async {
    await UsuarioRepository().update(user.uid, {'avatarUrl': path});
  },
)
```

O botão já cuida de: loading state, erro via SnackBar, e `upsert: true` (sobrescreve se já existir).

---

### Adicionar imagem a uma entidade nova — passo a passo

Exemplo hipotético: uma coleção nova `conquistas` com `ConquistaModel`.
(O mesmo caminho vale para adicionar `assetUrl` a um model existente, como
`MaterialBibliotecaModel` — nesse caso pule o passo 1.)

**Passo 1 — Repository** (`lib/services/repositories/conquista_repository.dart`)

Toda coleção tem um repository estendendo `BaseRepository`, que já fornece
`add`, `update`, `remove`, `getById`, `getAll` e `watchAll`:
```dart
class ConquistaRepository extends BaseRepository<ConquistaModel> {
  ConquistaRepository() : super('conquistas');

  @override
  ConquistaModel fromDoc(String id, Map<String, dynamic> data) =>
      ConquistaModel.fromMap(data).copyWith(id: id);

  @override
  Map<String, dynamic> toMap(ConquistaModel item) => item.toMap();
}
```

**Passo 2 — Model** (`lib/model/conquista.dart`)

Confirma que tem `assetUrl` no model:
```dart
final String? assetUrl;
// no fromMap:  assetUrl: map['assetUrl'],
// no toMap:    'assetUrl': assetUrl,
```

**Passo 3 — Exibir** (onde a entidade aparece na tela)

Troca qualquer `Image.network` ou placeholder por:
```dart
StorageImage(
  path: conquista.assetUrl,
  width: 60,
  height: 60,
  fit: BoxFit.cover,
)
```

**Passo 4 — Upload na SeedScreen** (`lib/dev/seed_screen.dart`)

Expõe o repository num provider (`provider/providers.dart`), como os demais:
```dart
final conquistaRepositoryProvider = Provider<ConquistaRepository>(
  (ref) => ConquistaRepository(),
);
```

Adiciona uma seção nova no `build()`, seguindo o mesmo padrão de
"Imagens — Grupos":
```dart
_Secao(
  titulo: 'Imagens — Conquistas',
  children: [
    _listaImagens(
      ref.watch(conquistasProvider),
      'conquistas',   // subpasta no bucket do Supabase
      (ConquistaModel c) =>
          (id: c.id, nome: c.nome, assetUrl: c.assetUrl ?? ''),
    ),
  ],
),
```

Adiciona o branch no `switch` de `_salvarImagem`:
```dart
'conquistas' => ref.read(conquistaRepositoryProvider),
```

Pronto. O upload já funciona, o path é salvo no Firestore e `StorageImage` exibe automaticamente.

---

### Estrutura do Storage — bucket `assets`

Existe **um único bucket** chamado `assets`. Dentro dele, os arquivos são organizados em subpastas. As subpastas são criadas automaticamente na primeira vez que um arquivo é enviado para aquele caminho.

```
bucket: assets
  ├── grupos/
  │     ├── abc123        ← imagem do grupo "Textos"
  │     └── def456        ← imagem do grupo "Músicas"
  ├── temas/
  │     ├── ghi789        ← imagem do tema "Existência"
  │     └── jkl012        ← imagem do tema "Tempo"
  ├── items/
  │     └── mno345        ← imagem de um item da loja
  └── usuarios/           ← futuro (avatares)
```

O `storagePath` passado para `StorageUploadButton` é o caminho **dentro** do bucket:
- `'grupos/abc123'` → subpasta `grupos`, arquivo `abc123`, dentro do bucket `assets`
- URL pública resultante: `https://xxx.supabase.co/storage/v1/object/public/assets/grupos/abc123`

Usar o ID do documento Firestore como nome do arquivo garante que re-upload **sobrescreve** o arquivo anterior sem deixar arquivos órfãos no bucket.

---

### Permissões do Supabase (bucket `assets`)

Bucket configurado como **Public** (qualquer um pode ler).
Policy de escrita no SQL Editor do Supabase:

```sql
CREATE POLICY "Allow all on assets"
ON storage.objects FOR ALL TO anon
USING (bucket_id = 'assets')
WITH CHECK (bucket_id = 'assets');
```

---

## 01/06/2026

### Adicionado

- `ItemCard` compartilhado entre grupos, biblioteca e loja
- CRUDs completos no `DatabaseService` para Filosofo, Texto, Musica, Filme e Grupos
- Sincronização do `temaSelecionadoProvider` no login, logout e cold start

### Corrigido

- Propagação do `doc.id` do Firestore nos `fromMap` de todos os models
- Bugs na seleção de tema e overflow de layout
