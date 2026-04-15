#!/bin/bash

# Script para enviar arquivo local para pod no cluster de produção
# Uso: ./envia_arq_prod.sh <arquivo_local> <namespace> <pod> <destino_no_pod>
# Exemplo: ./envia_arq_prod.sh ./customer_data.json msets-homol backup-2-api-55b6589d87-dpxm8 /code/customer_data.json

# Verificar se foram fornecidos os parâmetros necessários
if [ $# -lt 4 ]; then
    echo "Uso: $0 <arquivo_local> <namespace> <pod> <destino_no_pod>"
    echo ""
    echo "Parâmetros:"
    echo "  ambiente        - Ambiente (dev ou prod), padrão é prod"
    echo "  arquivo_local   - Caminho para o arquivo local a ser enviado"
    echo "  namespace       - Namespace do pod (ex: msets-homol ou msets-prod)"
    echo "  pod             - Nome do pod de destino"
    echo "  destino_no_pod  - Caminho de destino no pod (ex: /code/arquivo.json)"
    echo ""
    echo "Exemplo:"
    echo "  ./envia_arq_prod.sh dev ./customer_data_BECOMEXCONSULTORIALTDA537984.json msets-homol 	backup-2-background-74cc788689-vd74c /code/customer_data_BECOMEXCONSULTORIALTDA537984.json"
    exit 1
fi

AMBIENTE="$1"
ARQUIVO_LOCAL="$2"
NAMESPACE="$3"
POD="$4"
DESTINO_POD="$5"

# Definir AMBIENTE como "prod" se estiver indefinido ou vazio
if [ -z "$AMBIENTE" ]; then
    AMBIENTE="prod"
fi

# Verificar se o arquivo local existe
if [ ! -f "$ARQUIVO_LOCAL" ]; then
    echo "Erro: Arquivo local '$ARQUIVO_LOCAL' não encontrado!"
    exit 1
fi

# Verificar se o kubeconfig existe
KUBECONFIG_FILE="rke2-"$AMBIENTE"-cluster-rj.yaml"
if [ ! -f "$KUBECONFIG_FILE" ]; then
    echo "Erro: Arquivo kubeconfig '$KUBECONFIG_FILE' não encontrado!"
    exit 1
fi

echo "Enviando arquivo '$ARQUIVO_LOCAL' para o pod '$POD' no namespace '$NAMESPACE'..."
echo "Destino no pod: '$DESTINO_POD'"

# Executar o comando kubectl cp
kubectl --kubeconfig "$KUBECONFIG_FILE" cp "$ARQUIVO_LOCAL" "$NAMESPACE/$POD:$DESTINO_POD"

# Verificar se o comando foi executado com sucesso
if [ $? -eq 0 ]; then
    echo "✅ Arquivo enviado com sucesso!"
else
    echo "❌ Erro ao enviar o arquivo!"
    exit 1
fi