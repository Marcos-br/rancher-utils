# Rancher Utils — Utilitários para acesso ao cluster Kubernetes

Coleção de scripts shell e Python para gerenciar clusters RKE2 via `kubectl`, além de utilitários de suporte.

## Pré-requisitos

- `kubectl` instalado e disponível no `PATH`
- Arquivos de kubeconfig presentes no diretório raiz do projeto com os nomes:
  ```
  rke2-dev-cluster-rj.yaml
  rke2-prod-cluster-rj.yaml
  ```

> **Convenção de parâmetros comum:**
> - `<filtro>` — string para filtrar a listagem. Use `-` (sinal de menos) para listar tudo sem filtro.
> - `<prod|dev>` — ambiente alvo. Padrão: `prod` quando omitido.
> - `[namespace]` — namespace Kubernetes. Padrão: `--all-namespaces` quando omitido.

---

## Índice

- [Cluster e contextos](#cluster-e-contextos)
- [Pods](#pods)
- [Logs](#logs)
- [Deployments, Ingresses e Services](#deployments-ingresses-e-services)
- [ConfigMaps e Secrets](#configmaps-e-secrets)
- [Transferência de arquivos](#transferência-de-arquivos)

---

## Cluster e contextos

### `get_nodes.sh` — Listar nodes do cluster
```
get_nodes.sh [prod|dev]
```
Exibe todos os nodes e seus status no cluster especificado.

**Exemplo:**
```bash
./get_nodes.sh prod
```

---

### `get_ns.sh` — Listar namespaces
```
get_ns.sh [prod|dev]
```
Lista todos os namespaces disponíveis no cluster.

**Exemplo:**
```bash
./get_ns.sh dev
```

---

### `get_contexts.sh` — Listar contextos disponíveis
```
get_contexts.sh [prod|dev]
```
Exibe os contextos configurados no arquivo kubeconfig do ambiente especificado.

---

### `use_context.sh` — Definir contexto ativo
```
source use_context.sh [prod|dev]
```
> **IMPORTANTE:** Este script **deve ser executado com `source`** para que a variável `KUBECONFIG` persista no shell atual. Executá-lo sem `source` não terá efeito permanente.

Exporta `KUBECONFIG` apontando para o arquivo do ambiente e ativa o contexto correspondente.

**Exemplo:**
```bash
source ./use_context.sh dev
```

---

### `get_sto.sh` — Listar StorageClasses
```
get_sto.sh [prod|dev]
```
Lista as StorageClasses disponíveis no cluster.

---

## Pods

### `get_pods.sh` — Listar pods
```
get_pods.sh <filtro|-> [prod|dev] [namespace]
```
Lista os pods do cluster. Aplica o filtro informado via `grep` sobre o resultado.

**Exemplos:**
```bash
# Todos os pods em produção
./get_pods.sh - prod

# Pods cujo nome contém "api" no namespace msets-prod
./get_pods.sh api prod msets-prod
```

---

### `exec_pod.sh` — Abrir shell interativo em um pod
```
exec_pod.sh <filtro|-> [prod|dev] [namespace]
```
Lista os pods filtrados e aguarda que o nome do pod desejado seja digitado. Em seguida, executa `kubectl exec -it ... -- /bin/bash` no pod selecionado.

**Exemplo:**
```bash
./exec_pod.sh api prod msets-prod
```

---

### `describe_pod.sh` — Descrever um pod
```
describe_pod.sh <filtro|-> [prod|dev] [namespace]
```
Lista os pods filtrados, solicita o nome do pod e exibe a saída de `kubectl describe pod` com paginação via `less`.

**Exemplo:**
```bash
./describe_pod.sh worker dev
```

---

## Logs

### `get_logs.sh` — Exibir logs de um pod
```
get_logs.sh <filtro|-> [prod|dev] [namespace]
```
Lista os pods filtrados, solicita o nome do pod e exibe seus logs com paginação via `less`.

**Exemplo:**
```bash
./get_logs.sh api prod msets-prod
```

---

### `tail_logs.sh` — Seguir logs em tempo real
```
tail_logs.sh <filtro|-> [prod|dev] [namespace]
```
Igual ao `get_logs.sh`, mas usa `kubectl logs -f` para acompanhar os logs em tempo real. Interrompa com `Ctrl+C`.

**Exemplo:**
```bash
./tail_logs.sh worker dev msets-homol
```

---

### `grep_log.sh` — Filtrar logs por palavra-chave
```
grep_log.sh <filtro|-> [prod|dev] [namespace]
```
Lista os pods filtrados, solicita o nome do pod e em seguida pede um termo de busca. Exibe apenas as linhas do log que correspondem ao termo (case-insensitive).

**Exemplo:**
```bash
./grep_log.sh api prod msets-prod
# Depois: Digite o nome do pod: api-pod-abc123
# Depois: O que quer filtrar? ERROR
```

## Deployments, Ingresses e Services

### `get_deployment.sh` — Listar deployments
```
get_deployment.sh <filtro|-> [prod|dev] [namespace]
```
Lista os deployments do cluster, opcionalmente filtrando pelo texto informado.

**Exemplo:**
```bash
./get_deployment.sh api prod msets-prod
```

---

### `get_ingress.sh` — Listar ingresses
```
get_ingress.sh <filtro|-> [prod|dev] [namespace]
```
Lista os ingresses do cluster, opcionalmente filtrando pelo texto informado.

---

### `get_services.sh` — Listar services
```
get_services.sh <filtro|-> [prod|dev] [namespace]
```
Lista os services do cluster, opcionalmente filtrando pelo texto informado.

---

### `port_fwd.sh` — Port forward para um service
```
port_fwd.sh <filtro|-> [prod|dev] [namespace]
```
Lista os services filtrados e aguarda a seleção do service. Em seguida, solicita o mapeamento de portas e executa `kubectl port-forward`.

- Namespace padrão: `msets-homol` (dev) ou `msets-prod` (prod)

**Exemplo:**
```bash
./port_fwd.sh api dev
# Depois: Digite o nome do service: minha-api
# Depois: Digite o mapeamento das portas: 8081:8080
```

---

## ConfigMaps e Secrets

### `get_configmaps.sh` — Listar e inspecionar ConfigMaps
```
get_configmaps.sh <filtro|-> [prod|dev] [namespace]
```
Lista as ConfigMaps filtradas. Após a listagem, solicita o nome de uma ConfigMap e exibe seu conteúdo detalhado via `kubectl describe configmap`.

**Exemplo:**
```bash
./get_configmaps.sh - prod msets-prod
```

---

### `get_secrets.sh` — Listar e inspecionar Secrets
```
get_secrets.sh <filtro|-> [prod|dev] [namespace]
```
Lista as Secrets filtradas. Após a listagem, solicita o nome de uma Secret e exibe seu conteúdo detalhado via `kubectl describe secret`.

> **Atenção:** Os valores das secrets são exibidos codificados em base64.

**Exemplo:**
```bash
./get_secrets.sh tls prod msets-prod
```

---

## Transferência de arquivos

### `envia_arq_prod.sh` — Enviar arquivo local para um pod
```
envia_arq_prod.sh <dev|prod> <arquivo_local> <namespace> <pod> <destino_no_pod>
```
Copia um arquivo local para dentro de um pod usando `kubectl cp`.

**Parâmetros:**
| Parâmetro        | Descrição                                          |
|------------------|----------------------------------------------------|
| `dev\|prod`       | Ambiente alvo                                      |
| `arquivo_local`  | Caminho do arquivo local a ser enviado             |
| `namespace`      | Namespace do pod de destino                        |
| `pod`            | Nome completo do pod de destino                    |
| `destino_no_pod` | Caminho absoluto de destino dentro do pod          |

**Exemplo:**
```bash
./envia_arq_prod.sh dev ./customer_data.json msets-homol backup-2-api-55b6589d87-dpxm8 /code/customer_data.json
```

---

### `recebe_arq_prod.sh` — Receber arquivo de um pod
Script com exemplo de `kubectl cp` para copiar um arquivo de dentro de um pod para o diretório local. Edite o script diretamente para ajustar namespace, pod e caminhos antes de executar.

**Exemplo de uso interno do script:**
```bash
kubectl --kubeconfig rke2-prod-cluster-rj.yaml cp \
  msets-prod/san-api-6cc647f5cf-tzp9r:/code/STEAGENERGY.json ./STEAGENERGY.json
```