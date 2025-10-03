# MS Rules Engine - Lazarus System

Microsserviço de Motor de Regras do Sistema Lazarus com integração completa ao Camunda Platform 8.

## 🎯 Visão Geral

O MS Rules Engine é o cérebro do sistema Lazarus, responsável por executar workflows BPMN, avaliar tabelas de decisão DMN, gerenciar regras de negócio e orquestrar todos os processos automatizados do sistema.

## 🚀 Funcionalidades Principais

### 🔧 Motor de Workflows BPMN
- **Deploy automático** de definições de workflow
- **Execução de instâncias** com variáveis personalizadas
- **Monitoramento em tempo real** de processos
- **Cancelamento e controle** de instâncias
- **Versionamento automático** de workflows

### 📊 Tabelas de Decisão DMN
- **Criação e deploy** de tabelas de decisão
- **Avaliação em tempo real** com variáveis de entrada
- **Regras complexas** com múltiplas condições
- **Versionamento** e histórico de decisões
- **Estatísticas de execução**

### ⚙️ Motor de Regras de Negócio
- **Regras condição-ação** personalizadas
- **Execução segura** com VM isolada
- **12+ operadores** lógicos suportados
- **Ações automáticas** (SET_VARIABLE, CALCULATE, NOTIFY, etc.)
- **Priorização** e ordenação de regras

### 📋 Gerenciamento de Tarefas
- **Tarefas de usuário** do Camunda
- **Atribuição automática** e manual
- **Completar tarefas** com variáveis de saída
- **Escalação automática** por tempo
- **Grupos de candidatos** e permissões

### 📈 Estatísticas e Monitoramento
- **Métricas de performance** em tempo real
- **Taxa de sucesso** de workflows e regras
- **Tempo médio de execução**
- **Estatísticas por categoria** e tipo
- **Dashboards** de monitoramento

## 🏗️ Arquitetura

### Tecnologias Utilizadas
- **Node.js** + **TypeScript**
- **Express.js** para API REST
- **Camunda Platform 8** (Zeebe, Operate, Tasklist)
- **PostgreSQL** (Azure Database) para escrita
- **Cosmos DB** (MongoDB API) para leitura
- **Redis** (Azure Cache) para cache
- **Kafka/Service Bus** para mensageria

### Padrões Implementados
- **CQRS** (Command Query Responsibility Segregation)
- **Event Sourcing** com Kafka
- **Repository Pattern** para acesso a dados
- **Service Layer** para lógica de negócio
- **Dependency Injection** para testabilidade

## 📡 API Endpoints

### Workflow Definitions
```http
POST   /api/v1/rules/workflows              # Criar definição de workflow
PUT    /api/v1/rules/workflows/{id}         # Atualizar definição
GET    /api/v1/rules/workflows              # Listar definições
GET    /api/v1/rules/workflows/{id}         # Buscar por ID
```

### Workflow Instances
```http
POST   /api/v1/rules/workflows/instances           # Iniciar instância
PATCH  /api/v1/rules/workflows/instances/{id}/cancel # Cancelar instância
GET    /api/v1/rules/workflows/instances           # Listar instâncias
GET    /api/v1/rules/workflows/instances/{id}      # Buscar por ID
```

### Decision Tables
```http
POST   /api/v1/rules/decisions                     # Criar tabela de decisão
POST   /api/v1/rules/decisions/{id}/evaluate       # Avaliar decisão
GET    /api/v1/rules/decisions                     # Listar tabelas
GET    /api/v1/rules/decisions/{id}                # Buscar por ID
```

### Task Instances
```http
PATCH  /api/v1/rules/tasks/{id}/complete           # Completar tarefa
PATCH  /api/v1/rules/tasks/{id}/assign             # Atribuir tarefa
GET    /api/v1/rules/tasks                         # Listar tarefas
GET    /api/v1/rules/tasks/{id}                    # Buscar por ID
```

### Business Rules
```http
POST   /api/v1/rules/business-rules                # Criar regra de negócio
POST   /api/v1/rules/business-rules/{id}/execute   # Executar regra
GET    /api/v1/rules/business-rules                # Listar regras
GET    /api/v1/rules/business-rules/{id}           # Buscar por ID
```

### Statistics
```http
GET    /api/v1/rules/statistics/workflows          # Estatísticas de workflows
GET    /api/v1/rules/statistics/tasks              # Estatísticas de tarefas
GET    /api/v1/rules/statistics/rules              # Estatísticas de regras
```

## 🔐 Autenticação e Autorização

### Roles Suportadas
- **admin**: Acesso total a todas as funcionalidades
- **director**: Criação e gestão de workflows e regras
- **auditor**: Execução de workflows e avaliação de decisões
- **analyst**: Execução de regras e completar tarefas
- **doctor**: Completar tarefas médicas

### Permissões por Endpoint
- **Criação de workflows/regras**: admin, director
- **Execução de workflows**: admin, director, auditor
- **Avaliação de decisões**: admin, director, auditor, analyst
- **Completar tarefas**: admin, director, auditor, analyst, doctor
- **Estatísticas**: admin, director, auditor

## 🚀 Como Executar

### Pré-requisitos
- Node.js 18+
- PostgreSQL
- MongoDB/Cosmos DB
- Redis
- Camunda Platform 8

### Instalação
```bash
# Instalar dependências
npm install

# Configurar variáveis de ambiente
cp .env.example .env
# Editar .env com suas configurações

# Executar migrations do banco
npx prisma migrate dev

# Executar em desenvolvimento
npm run dev

# Executar em produção
npm run build
npm start
```

### Variáveis de Ambiente Principais
```env
# Servidor
PORT=3006
NODE_ENV=development

# Camunda Platform 8
ZEEBE_GATEWAY_ADDRESS=localhost:26500
CAMUNDA_OPERATE_URL=http://localhost:8081
CAMUNDA_TASKLIST_URL=http://localhost:8082
CAMUNDA_CLIENT_ID=your-client-id
CAMUNDA_CLIENT_SECRET=your-client-secret

# Bancos de Dados
POSTGRES_URL=postgresql://user:pass@localhost:5432/rules_engine
MONGODB_URL=mongodb://localhost:27017/rules_engine_read
REDIS_URL=redis://localhost:6379

# Azure (Produção)
AZURE_COSMOS_DB_CONNECTION_STRING=your-cosmos-connection
AZURE_SERVICE_BUS_CONNECTION_STRING=your-servicebus-connection
AZURE_CACHE_REDIS_CONNECTION_STRING=your-redis-connection
```

## 🧪 Testes

```bash
# Executar todos os testes
npm test

# Executar testes com coverage
npm run test:coverage

# Executar testes em modo watch
npm run test:watch
```

## 📊 Monitoramento

### Health Checks
- **GET /health**: Status geral do serviço
- **GET /health/detailed**: Status detalhado de dependências

### Métricas Disponíveis
- Workflows ativos/completados/com erro
- Tarefas pendentes/completadas/escaladas
- Regras executadas/com sucesso/com falha
- Tempo médio de execução por categoria
- Taxa de sucesso por tipo de processo

### Logs Estruturados
```json
{
  "timestamp": "2024-01-15T10:30:00Z",
  "level": "info",
  "message": "Workflow instance started",
  "workflowDefinitionId": "uuid",
  "instanceId": "uuid",
  "businessKey": "PAT-001",
  "startedBy": "user@example.com"
}
```

## 🔧 Configuração do Camunda

### Exemplo de Workflow BPMN
```xml
<?xml version="1.0" encoding="UTF-8"?>
<bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL">
  <bpmn:process id="patient-validation" name="Patient Validation Process">
    <bpmn:startEvent id="start" name="Start" />
    <bpmn:serviceTask id="validate-cpf" name="Validate CPF" />
    <bpmn:userTask id="manual-review" name="Manual Review" />
    <bpmn:endEvent id="end" name="End" />
    <!-- Flow connections -->
  </bpmn:process>
</bpmn:definitions>
```

### Exemplo de Tabela de Decisão DMN
```xml
<?xml version="1.0" encoding="UTF-8"?>
<dmn:definitions xmlns:dmn="http://www.omg.org/spec/DMN/20151101/dmn.xsd">
  <dmn:decision id="risk-assessment" name="Risk Assessment">
    <dmn:decisionTable>
      <dmn:input id="age" label="Age">
        <dmn:inputExpression typeRef="number">
          <dmn:text>age</dmn:text>
        </dmn:inputExpression>
      </dmn:input>
      <dmn:output id="risk" label="Risk Level" typeRef="string" />
      <!-- Rules -->
    </dmn:decisionTable>
  </dmn:decision>
</dmn:definitions>
```

## 🚀 Deploy na Azure

### Azure Container Instances
```bash
# Build da imagem
docker build -t lazarus-rules-engine .

# Tag para Azure Container Registry
docker tag lazarus-rules-engine lazarusacr.azurecr.io/rules-engine:latest

# Push para ACR
docker push lazarusacr.azurecr.io/rules-engine:latest

# Deploy no ACI
az container create \
  --resource-group lazarus-rg \
  --name rules-engine \
  --image lazarusacr.azurecr.io/rules-engine:latest \
  --ports 3006 \
  --environment-variables \
    NODE_ENV=production \
    PORT=3006
```

### Azure Kubernetes Service (AKS)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rules-engine
spec:
  replicas: 3
  selector:
    matchLabels:
      app: rules-engine
  template:
    metadata:
      labels:
        app: rules-engine
    spec:
      containers:
      - name: rules-engine
        image: lazarusacr.azurecr.io/rules-engine:latest
        ports:
        - containerPort: 3006
        env:
        - name: NODE_ENV
          value: "production"
        - name: PORT
          value: "3006"
```

## 📚 Documentação Adicional

- **Swagger UI**: `http://localhost:3006/api-docs`
- **Camunda Operate**: `http://localhost:8081`
- **Camunda Tasklist**: `http://localhost:8082`

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Suporte

Para suporte técnico, entre em contato:
- **Email**: dev@lazarus.com
- **Slack**: #lazarus-dev
- **Issues**: GitHub Issues

---

**Lazarus Rules Engine** - Orquestrando a inteligência do sistema de saúde 🏥⚙️

