# Zetesis

> Sistema de aprendizado filosófico com biblioteca de materiais, seleção de temas e modo desafio.

---

## Sobre o projeto

O **Zetesis** é um app mobile de estudo da filosofia. O usuário escolhe um tema filosófico, acessa materiais de apoio (textos, músicas, vídeos, livros, imagens) e realiza desafios sobre o conteúdo. O sistema conta com autenticação, perfil de usuário, biblioteca categorizada e loja de itens.

---

## Funcionalidades

### Prontas

- Autenticação — login e cadastro com email/senha ou Google
- Perfil — visualização e edição de nome, redefinição de senha
- Seleção de tema — grade visual com temas filosóficos; tema selecionado persiste no Firestore e no SecureStorage
- Biblioteca — catálogo de materiais dividido em categorias, com lista em tempo real e favoritos por usuário (Firestore + Hive como fallback)
- Favoritos — persistidos por usuário no Firestore, com seed local via Hive para carregamento imediato
- Loja — exibição de itens disponíveis com atualizações em tempo real
- Painel de administração — seed de dados (grupos, materiais, temas) e upload de imagens por item
- Upload de imagens — armazenamento no Supabase Storage com path curto no Firestore; exibição via `StorageImage` com cache em memória e disco

### Em desenvolvimento

- Modo desafio — botão de início implementado, lógica de perguntas/respostas pendente
- Tela de detalhe de material — abertura e leitura de conteúdo individual
- Compra de itens na loja
- Upload e troca de avatar
- Funções de administrador avançadas (gestão de usuários)

---

## Stack

| Camada | Tecnologia |
|---|---|
| Linguagem | Dart 3.10.1+ |
| Framework | Flutter 3.x |
| Banco de dados | Cloud Firestore (tempo real via StreamProvider) |
| Autenticação | Firebase Auth + Google Sign-In |
| Armazenamento de imagens | Supabase Storage |
| Armazenamento local | Hive + Flutter Secure Storage |
| Gerenciamento de estado | Riverpod 2.5.1 |
| Cache de imagens | cached_network_image |

---

## Pré-requisitos

- Android 5.0 (API 21) ou superior

---

## Requisitos do ambiente de desenvolvimento

| Ferramenta | Versão | Observação |
|---|---|---|
| Flutter | 3.x | `flutter doctor` para verificar |
| Dart SDK | ^3.10.1 | Incluído com Flutter |
| Java (JDK) | 17 | `sourceCompatibility` e `targetCompatibility` fixados em 17 |
| Android SDK | API 21+ | Android 5.0 Lollipop |
| Android Gradle Plugin | 8.11.1 | Configurado via Kotlin DSL (`.kts`) |
| Kotlin | 2.2.20 | |
| Node.js | qualquer LTS | Apenas se usar Firebase CLI |

---

## Dependências

### Produção

| Pacote | Versão | Finalidade |
|---|---|---|
| `firebase_core` | ^4.6.0 | Inicialização do Firebase |
| `firebase_auth` | ^6.4.0 | Autenticação de usuários |
| `cloud_firestore` | ^6.2.0 | Banco de dados em nuvem |
| `google_sign_in` | ^6.2.0 | Login com Google |
| `supabase_flutter` | ^2.8.0 | Armazenamento de imagens (Storage) |
| `flutter_riverpod` | ^2.5.1 | Gerenciamento de estado |
| `hive` + `hive_flutter` | ^2.2.3 | Persistência local e cache de favoritos |
| `flutter_secure_storage` | ^10.0.0 | Armazenamento seguro de credenciais |
| `cached_network_image` | ^3.4.1 | Cache de imagens em disco |
| `image_picker` | ^1.1.2 | Seleção de imagens da galeria |
| `crypto` | ^3.0.7 | Utilitários de criptografia |
| `flutter_launcher_icons` | ^0.14.4 | Geração do ícone do app |

---

## Estrutura do projeto

```
lib/
├── config/
│   └── supabase_config.dart   # URL e chave do Supabase
├── controller/                # Lógica de negócio (AuthController)
├── model/                     # Modelos de dados
│   ├── usuario.dart
│   ├── tema.dart
│   ├── material_biblioteca.dart
│   ├── grupo_biblioteca.dart
│   ├── item_loja.dart
│   ├── filosofo.dart
│   ├── texto.dart
│   ├── musica.dart
│   └── filme.dart
├── provider/                  # Providers Riverpod (StreamProviders)
├── services/                  # Serviços (Auth, Database, SecureStorage)
├── views/                     # Telas
│   ├── index.dart             # Navegação principal (3 abas)
│   ├── login_screen.dart
│   ├── cadastro_screen.dart
│   ├── perfil_screen.dart
│   ├── selecao_tema.dart
│   ├── desafio_start.dart
│   ├── biblioteca_screen.dart
│   ├── materialbiblioteca_screen.dart
│   ├── loja_screen.dart
│   └── admin_screen.dart      # Painel de seed e upload (temporário)
└── widgets/
    ├── components/            # Componentes reutilizáveis
    │   ├── storage_image.dart # Widget de imagem via Supabase Storage
    │   └── ...
    └── forms/                 # Formulários de login e cadastro
```

---

## Coleções do Firestore

| Coleção | Campos principais | Uso |
|---|---|---|
| `users/{uid}` | nome, email, ranking, pontos, avatarUrl, admin, temaAtual, favoritos[] | Perfil do usuário |
| `temas/` | nome, descricao, assetUrl | Temas filosóficos |
| `grupos_biblioteca/` | nome, descricao, assetUrl | Categorias de materiais |
| `tarefas/` | nome, descricao, tema, enviadoPor, dataEnvio, perguntas[] | Tarefas/quizzes por tema |
| `materiais/` | nome, tipo, descricao, assetUrl, autor, dataEnvio, enviadoPor | Materiais por categoria |
| `items/` | nome, custo, assetUrl, status | Itens da loja |

> O campo `tipo` em `materiais` deve corresponder exatamente ao campo `nome` do grupo em `grupos_biblioteca` (ex: `"Textos"`, `"Músicas"`, `"Vídeos"`, `"Imagens"`, `"Livros"`, `"Outros"`).

> O campo `assetUrl` em `temas`, `grupos_biblioteca` e `materiais` armazena o **path curto** do Supabase Storage (ex: `grupos/abc123`), não a URL completa. A URL é montada em runtime pelo widget `StorageImage`.

> O campo `favoritos` em `users` é um array de IDs de materiais favoritados pelo usuário.

---

## Branches

| Branch | Finalidade |
|---|---|
| `main` | Código estável |
| `feature/*` | Novas funcionalidades |
| `fix/*` | Correções de bugs |

---

## Autores

| Nome | GitHub | Contribuição |
|---|---|---|
| Heitor Klaine Stella | [HeitorkStella](https://github.com/HeitorkStella) | Backend, telas, seleção de temas |
| João Vitor Lino Lages Santos | [m3owkass](https://github.com/m3owkass) | Backend, banco de dados, telas, autenticação |
| Lucas Antônio Dias Maschio | [luscaaas](https://github.com/luscaaas) | Design, reuniões, telas |
