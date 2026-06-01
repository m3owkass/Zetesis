# 🏛️ Zetesis

> Sistema de aprendizado filosófico com mapa mental conectando assuntos e um modo desafio.

---

## 📖 Sobre o projeto

O **Zetesis** é um app mobile de estudo da filosofia. O usuário escolhe um tema filosófico, acessa materiais de apoio e enfrenta desafios sobre o conteúdo. O sistema conta com autenticação, perfil de usuário e uma loja de itens.

---

## ✨ Funcionalidades

- 🔐 **Autenticação** — login e cadastro com email/senha ou Google
- 👤 **Perfil** — visualização e edição de nome, redefinição de senha, avatar
- 🎯 **Seleção de tema** — grade visual com os temas filosóficos disponíveis; tema selecionado persiste na sessão
- ⚔️ **Modo desafio** — tela inicial com o tema atual selecionado e botão para iniciar o desafio
- 📚 **Biblioteca** — catálogo de materiais dividido em 6 categorias: Textos, Músicas, Vídeos, Imagens, Livros e Outros
- 🛒 **Loja** — itens disponíveis para os usuários

---

## 🛠️ Stack

| Camada | Tecnologia |
|---|---|
| 🐦 Linguagem | Dart |
| 📱 Framework | Flutter |
| 🔥 Banco de dados | Firebase Firestore |
| 🔑 Autenticação | Firebase Auth + Google Sign-In |
| 💾 Armazenamento local | Hive + Flutter Secure Storage |
| ⚡ Gerenciamento de estado | Riverpod |

---

## 📋 Pré-requisitos

- Android 5.0 (API 21) ou superior

## 📥 Instalação

Disponível na **Google Play Store**.

---

## 💻 Desenvolvimento

### 🔧 Requisitos do ambiente

| Ferramenta | Versão | Observação |
|---|---|---|
| Flutter | 3.x | `flutter doctor` para verificar |
| Dart SDK | ^3.10.1 | Incluído com o Flutter |
| Java (JDK) | 17 | `sourceCompatibility` e `targetCompatibility` fixados em 17 |
| Android SDK | API 21+ | Android 5.0 Lollipop |
| Android Gradle Plugin | 8.11.1 | Configurado via Kotlin DSL (`.kts`) |
| Kotlin | 2.2.20 | |
| Node.js | qualquer LTS | Apenas se usar Firebase CLI |

> 💡 Após instalar o Flutter, rode `flutter doctor -v` para garantir que todas as dependências estão OK antes de clonar o projeto.

---

### 📦 Dependências

#### Produção

| Pacote | Versão | Finalidade |
|---|---|---|
| `firebase_core` | ^4.6.0 | Inicialização do Firebase |
| `firebase_auth` | ^6.4.0 | Autenticação de usuários |
| `cloud_firestore` | ^6.2.0 | Banco de dados em nuvem |
| `firebase_database` | ^12.2.0 | Realtime Database |
| `google_sign_in` | ^6.2.0 | Login com Google |
| `flutter_riverpod` | ^2.5.1 | Gerenciamento de estado |
| `hive` + `hive_flutter` | ^2.2.3 | Persistência local (cache) |
| `flutter_secure_storage` | ^10.0.0 | Armazenamento seguro de credenciais |
| `crypto` | ^3.0.7 | Utilitários de criptografia |
| `flutter_launcher_icons` | ^0.14.4 | Geração do ícone do app |

#### Dev

| Pacote | Versão | Finalidade |
|---|---|---|
| `flutter_lints` | ^6.0.0 | Regras de lint recomendadas |

---

### 🚀 Configuração e execução

#### 1. Clone e instale as dependências

```bash
git clone https://github.com/m3owkass/zetesis.git
cd zetesis
flutter pub get
```

#### 2. Verifique os dispositivos disponíveis

```bash
flutter devices
```

#### 3. Rode o app

```bash
# Android (dispositivo físico ou emulador)
flutter run

# Navegador web (para testes rápidos)
flutter run -d web-server --web-port 8080
# Acesse http://localhost:8080
```

---

### 🏗️ Gerando o build

```bash
# APK de debug
flutter build apk --debug

# APK de release (assinado com chave de debug por enquanto)
flutter build apk --release

# App Bundle — formato recomendado para a Play Store
flutter build appbundle --release

# Verificar tamanho do APK
flutter build apk --analyze-size
```

---

### 🧹 Análise estática

```bash
# Rodar análise estática
flutter analyze

# Verificar dependências desatualizadas
flutter pub outdated
```

---

### 🌿 Branches

| Branch | Finalidade |
|---|---|
| `main` | Código estável, pronto para produção |
| `feature/*` | Novas funcionalidades |
| `fix/*` | Correções de bugs |

---

## 🗂️ Estrutura do projeto

```
lib/
├── 🧠 controller/     # Lógica de negócio (AuthController)
├── 📦 model/          # Modelos de dados
├── ⚡ provider/       # Providers Riverpod
├── 🔧 services/       # Serviços (Auth, Database, SecureStorage)
├── 🖥️ views/          # Telas
└── 🧩 widgets/
    ├── components/    # Componentes reutilizáveis
    └── forms/         # Formulários
```

---

## 👥 Autores

| Nome | Contribuição |
|---|---|
| [Heitor Klane Stella](https://github.com/HeitorkStella) | 🔧 Backend, programação de telas |
| [João Vitor Lino](https://github.com/m3owkass) | 🔧 Backend, programação de telas, banco de dados |
| [Lucas Antônio Dias Maschio](https://github.com/linkParaPerfil) | 🎨 Design, reuniões, programação de telas |
# diario_insone
