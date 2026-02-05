# Framework de Testes E2E com Maestro

## Visão Geral

[Maestro](https://maestro.dev/) é um framework open-source para testes de UI mobile que oferece uma abordagem simples e declarativa para testes end-to-end em aplicações iOS e Android.

### Por que Maestro?

| Característica             | Benefício                                               |
| -------------------------- | ------------------------------------------------------- |
| **Tolerância a Flakiness** | Lida automaticamente com instabilidade de UI e timing   |
| **Sem Sleep Calls**        | Espera de forma inteligente pelo carregamento           |
| **Sintaxe YAML**           | Definições de teste simples e legíveis                  |
| **Iteração Rápida**        | Testes são interpretados, sem necessidade de compilação |
| **Binário Único**          | Instalação e setup fáceis                               |

#### Tolerância a Flakiness

**O Problema**: Em frameworks tradicionais de teste (Appium, Espresso, Selenium), elementos de UI nem sempre aparecem onde esperado. Animações podem deslocar botões temporariamente, um tap pode não registrar na primeira tentativa, e layouts podem variar entre dispositivos. Isso causa falhas aleatórias nos testes — conhecidos como "testes flaky".

**Como o Maestro Resolve**: O Maestro automaticamente tenta novamente interações que falharam, espera elementos estabilizarem, e ajusta coordenadas de tap se necessário. Você não precisa adicionar lógica de `retry()` ou recuperação manual — o Maestro cuida disso internamente.

```yaml
# Maestro automaticamente:
# 1. Tenta novamente taps que falham
# 2. Espera o elemento estabilizar
# 3. Ajusta coordenadas se necessário
- tapOn: "Enviar"
```

#### Sem Sleep Calls

**O Problema**: Em outros frameworks, você frequentemente precisa de waits arbitrários:

```javascript
// Appium/Selenium - waits manuais em todo lugar
await driver.wait(5000); // 5 segundos arbitrários
await driver.findElement("Button").click();
```

Isso leva a:

- **Waits muito curtos** → Testes falham porque o conteúdo não carregou
- **Waits muito longos** → Testes são desnecessariamente lentos

**Como o Maestro Resolve**: O Maestro espera de forma inteligente exatamente o tempo necessário — nem mais, nem menos. Ele detecta automaticamente quando:

- Conteúdo de rede termina de carregar
- Elementos de UI são renderizados
- Animações completam

```yaml
# Não precisa de sleep() - Maestro espera automaticamente
- assertVisible: "Dashboard" # Espera até o texto aparecer
- tapOn: "Perfil" # Espera até o elemento ser clicável
```

## Estrutura do Projeto

```
maestro_dev/
├── e2e/
│   └── maestro_dev/
│       ├── login_flow.yaml        # Teste de fluxo de login
│       ├── register_flow.yaml     # Teste de fluxo de cadastro
│       └── dashboard_flow.yaml    # Teste de interações do dashboard
├── lib/
│   ├── main.dart                  # Entrada do app com rotas
│   └── pages/
│       ├── login_page.dart        # Página de login com Semantics
│       ├── register_page.dart     # Página de cadastro com Semantics
│       └── dashboard_page.dart    # Dashboard com Semantics
├── .agent/
│   └── workflows/
│       ├── maestro-test.md        # Workflow para criar novos testes
│       └── maestro-run.md         # Workflow para executar testes
└── docs/
    └── E2E_TESTING.md             # Documentação técnica
```

## Como Funciona

### 1. Integração com Flutter

O Maestro interage com Flutter através da **árvore de acessibilidade**. Para tornar widgets testáveis, usamos `Semantics`:

```dart
// Método 1: Identificador Semantics (recomendado)
Semantics(
  identifier: 'login_submit_button',
  child: ElevatedButton(...),
)

// Método 2: Label semântico para ícones
Icon(
  Icons.add,
  semanticLabel: 'add_icon',
)

// Método 3: Labels de texto (automático)
TextField(
  decoration: InputDecoration(
    labelText: 'Email',  // Maestro pode usar isso diretamente
  ),
)
```

### 2. Escrevendo Testes

Testes são escritos em formato YAML:

```yaml
appId: com.example.maestroDev
---
- launchApp:
    clearState: true

- assertVisible: "Login"
- tapOn:
    id: "login_email_field"
- inputText: "teste@exemplo.com"
- tapOn:
    id: "login_submit_button"
- assertVisible: "Dashboard"
```

### 3. Executando Testes

```bash
# Executar todos os testes
maestro test e2e/maestro_dev/

# Executar teste específico
maestro test e2e/maestro_dev/login_flow.yaml

# Debug com Studio
maestro studio
```

## Workflows com IA

Este projeto usa **agent workflows** (`.agent/workflows/`) que permitem um assistente de IA criar e executar testes automaticamente.

### Workflows Disponíveis

| Comando         | Descrição                             |
| --------------- | ------------------------------------- |
| `/maestro-test` | Criar novos testes E2E para um módulo |
| `/maestro-run`  | Executar testes E2E existentes        |

### Como os Workflows de IA Funcionam

1. **Pedido do Usuário**: "Crie testes E2E para o módulo de checkout"

2. **Agente de IA**:
   - Lê as instruções do workflow em `.agent/workflows/maestro-test.md`
   - Analisa o código Flutter do módulo
   - Identifica widgets que precisam de `Semantics.identifier`
   - Adiciona Semantics faltantes ao código
   - Cria arquivos de teste YAML
   - Executa os testes usando `maestro test`

3. **Resultado**: Cobertura completa de testes E2E com esforço manual mínimo

### Workflow: `/maestro-test`

**Propósito**: Guiar a IA para criar novos testes para um módulo Flutter

**Passos**:

1. Identificar módulo e fluxos de usuário
2. Analisar código Flutter para widgets interativos
3. Adicionar `Semantics.identifier` aos widgets (se necessário)
4. Criar arquivo de teste YAML em `e2e/maestro_dev/`
5. Executar o teste
6. Verificar resultados e debugar se necessário

### Workflow: `/maestro-run`

**Propósito**: Executar testes existentes

**Passos**:

1. Executar todos os testes ou arquivo específico
2. Abrir Maestro Studio para debugging (opcional)

## Referência de Semantics

### Identificadores Atuais

**Página de Login:**

- `login_email_field`
- `login_password_field`
- `login_submit_button`
- `login_register_link`

**Página de Cadastro:**

- `register_name_field`
- `register_email_field`
- `register_password_field`
- `register_confirm_password_field`
- `register_submit_button`
- `register_login_link`

**Página de Dashboard:**

- `dashboard_logout_button`
- `dashboard_add_button`
- `dashboard_profile_card`
- `dashboard_settings_card`
- `dashboard_analytics_card`
- `dashboard_notifications_card`

## Referência de Comandos Maestro

| Comando              | Exemplo                                     | Descrição                               |
| -------------------- | ------------------------------------------- | --------------------------------------- |
| `launchApp`          | `- launchApp: { clearState: true }`         | Iniciar app (opcionalmente limpa dados) |
| `tapOn`              | `- tapOn: "Botão"`                          | Tocar em texto visível                  |
| `tapOn`              | `- tapOn: { id: "btn_id" }`                 | Tocar em identificador semântico        |
| `inputText`          | `- inputText: "email@teste.com"`            | Inserir texto no campo focado           |
| `assertVisible`      | `- assertVisible: "Bem-vindo"`              | Verificar se texto está visível         |
| `assertNotVisible`   | `- assertNotVisible: "Erro"`                | Verificar se texto não está visível     |
| `scroll`             | `- scroll`                                  | Rolar para baixo                        |
| `scrollUntilVisible` | `- scrollUntilVisible: { element: "Item" }` | Rolar até elemento aparecer             |
| `takeScreenshot`     | `- takeScreenshot: "resultado"`             | Capturar screenshot                     |
| `back`               | `- back`                                    | Pressionar botão voltar                 |

## Instalação

```bash
# Pré-requisitos: Java 17+
java -version

# Instalar Maestro (macOS)
brew tap mobile-dev-inc/tap
brew install mobile-dev-inc/tap/maestro

# Verificar
maestro --version
```

## Bundle IDs

| Plataforma | Bundle ID                 |
| ---------- | ------------------------- |
| iOS        | `com.example.maestroDev`  |
| Android    | `com.example.maestro_dev` |

## Recursos

- [Documentação Maestro](https://docs.maestro.dev/)
- [Integração Flutter](https://docs.maestro.dev/platform-support/flutter)
- [Referência de Comandos](https://docs.maestro.dev/api-reference/commands)
- [Maestro Cloud](https://maestro.dev/cloud) - integração CI/CD

---

## Comparação de Frameworks

### Maestro vs Patrol vs Flutter integration_test

| Aspecto                  | **Maestro** | **Patrol** | **Flutter integration_test** |
| ------------------------ | ----------- | ---------- | ---------------------------- |
| **Linguagem de Teste**   | YAML        | Dart       | Dart                         |
| **Desenvolvedor**        | mobile.dev  | LeanCode   | Google (Flutter)             |
| **Tempo de Setup**       | 2 min       | 15-30 min  | 5 min                        |
| **Curva de Aprendizado** | Baixa       | Média      | Média-Alta                   |

### Comparação de Funcionalidades

| Funcionalidade                  |         Maestro          |      Patrol       | integration_test  |
| ------------------------------- | :----------------------: | :---------------: | :---------------: |
| Config de permissões            |   ✅ Apenas no launch    |        ✅         |        ❌         |
| Interação com dialogs nativos   | ✅ Android / ⚠️ iOS Auto |        ✅         |        ❌         |
| Notificações                    |     ✅ Apenas config     |        ✅         |        ❌         |
| Suporte WebView                 |       ⚠️ Limitado        |        ✅         |        ❌         |
| Mock de APIs                    |        ✅ Via env        |        ✅         |        ✅         |
| Acesso ao state                 |            ❌            |        ✅         |        ✅         |
| Hot Restart                     |            ❌            |        ✅         |    ⚠️ Limitado    |
| Device Farms                    |         ✅ Cloud         |        ✅         |     ⚠️ Manual     |
| iOS físico                      |            ❌            |        ✅         |        ✅         |
| Cross-platform                  |            ✅            | ❌ Apenas Flutter | ❌ Apenas Flutter |
| Tratamento automático flakiness |            ✅            |     ⚠️ Manual     |     ❌ Manual     |

> **Nota sobre Interação com Dialogs Nativos:**
>
> - **Android**: Maestro pode interagir com dialogs do sistema usando `tapOn: "Allow"` ou inspecionando elementos com `maestro hierarchy`
> - **iOS**: Maestro auto-dismiss dialogs de permissão (apenas em inglês). Não consegue clicar em botões específicos manualmente

### Pontos Fortes do Maestro

- **Setup extremamente simples** — um comando instala tudo
- **Sintaxe YAML** — qualquer pessoa consegue ler e escrever testes
- **Sem compilação** — testes são interpretados instantaneamente
- **Tolerância automática** a flakiness e delays
- **Cross-platform** — mesma sintaxe para iOS, Android, Web, React Native
- **Maestro Studio** — ferramenta visual para explorar UI

### Limitações do Maestro

- **Dialogs nativos iOS**: Só consegue auto-dismiss (em inglês), não clica em botões específicos
- Sem acesso à lógica Dart ou state interno
- Depende de Semantics/árvore de acessibilidade
- Dispositivos iOS físicos não suportados
- Sem Hot Restart entre testes

### Quando Usar Cada Um

| Caso de Uso                     | Recomendado                               |
| ------------------------------- | ----------------------------------------- |
| Smoke tests rápidos             | **Maestro**                               |
| Time de QA não-técnico          | **Maestro**                               |
| Apps multi-plataforma           | **Maestro**                               |
| Diálogos de permissão (Android) | **Maestro** ou **Patrol**                 |
| Diálogos de permissão (iOS)     | **Patrol**                                |
| Testes de câmera/GPS            | **Patrol**                                |
| Interações com WebView          | **Patrol**                                |
| Device Farms (Firebase, AWS)    | **Maestro Cloud** ou **Patrol**           |
| Mock de APIs necessário         | **Maestro** (env) ou **integration_test** |
| Verificação de state interno    | **integration_test**                      |
| Sem dependências externas       | **integration_test**                      |

### Links Relacionados

- [Documentação Patrol](https://patrol.leancode.co/)
- [Flutter integration_test](https://docs.flutter.dev/testing/integration-tests)
