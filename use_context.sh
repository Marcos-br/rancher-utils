# Este script deve ser sourceado para que o KUBECONFIG persista no shell atual
# Uso: source use_context.sh [dev|prod]
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "AVISO: Execute com 'source' para que o KUBECONFIG persista:"
  echo "  source ${0} $*"
  exit 1
fi

if [ -z "$1" ]; then
  env="prod"
else
  env="$1"
fi

kubeconfig_file="rke2-$env-cluster-rj.yaml"

# Exporta o KUBECONFIG para a sessão atual
export KUBECONFIG="$(pwd)/$kubeconfig_file"

kubectl config use-context rke2-$env-cluster-rj

kubectl config get-contexts
