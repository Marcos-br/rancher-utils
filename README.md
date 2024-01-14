# Utilidades para acessar o cluster

Os arquivos de configuração devem ter um dos seguintes nomes:
```
rke2-dev-cluster-rj.yaml
rke2-prod-cluster-rj.yaml
```

## Listar os nodes
```
get_nodes.sh <prod|dev>
```


## Listar os configmaps
```
get_configmaps.sh <prod|dev>
```

## Listar as secrets
```
get_secrets.sh <prod|dev>
```

## Listar os contextos
```
get_contexts.sh <prod|dev>
```

## Usar um contexto
```
use_context.sh <prod|dev>
```

## Listar os storageclasses
```
get_sto.sh <prod|dev>
```

## Entrar no shell de um pod
```
exec_pod.sh <filter!"-" (sinal de menos)> <prod|dev> [namespace] (default=all-namespaces)
    -> filter = filtro a ser aplicado ao resultado
    -> depois seleciona o nome de um pod de uma lista
```

## Listar os deployments de um namespace ou de todos os namespaces
```
get_deployment.sh <filter!"-" (sinal de menos)> <prod|dev> [namespace] (default=all-namespaces)
    -> filter = filtro a ser aplicado ao resultado
```

## Listar os ingresses de um namespace ou de todos os namespaces
```
get_ingress.sh <filter!"-" (sinal de menos)> <prod|dev> [namespace] (default=all-namespaces)
    -> filter = filtro a ser aplicado ao resultado
```

## Listar o log de um pod
```
get_logs.sh <filter!"-" (sinal de menos)> <prod|dev> [namespace] (default=all-namespaces)
    -> filter = filtro a ser aplicado ao resultado
    -> depois seleciona o nome de um pod de uma lista
```

## Listar todos os namespaces
```
get_ns.sh <prod|dev>
```

## Listar os pods de um namespace ou de todos os namespaces
```
get_pods.sh <filter!"-" (sinal de menos)> <prod|dev> [namespace] (default=all-namespaces)
    -> filter = filtro a ser aplicado ao resultado
```

## Listar os services de um namespace ou de todos os namespaces
```
get_services.sh <filter!"-" (sinal de menos)> <prod|dev> [namespace] (default=all-namespaces)
    -> filter = filtro a ser aplicado ao resultado
```

## Fazer port forward para um service
```
port_fwd.sh <filter!"-" (sinal de menos)> <prod|dev> [namespace] (default=all-namespaces)
    -> filter = filtro a ser aplicado ao resultado
    -> depois seleciona o nome de um service de uma lista
    -> em seguida informa o mapeamento das portas (p.ex, 8081:8080)
```

## Ficar listando o log de um pod até ser interrompido via ctrl-c
```
tail_logs.sh <filter!"-" (sinal de menos)> <prod|dev> [namespace] (default=all-namespaces)
    -> filter = filtro a ser aplicado ao resultado
    -> depois seleciona o nome de um pod de uma lista
```
