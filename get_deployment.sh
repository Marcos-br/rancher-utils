echo "Parametros:"
echo "\$1 = filter (- = tudo)"
echo "\$2 = prod or dev (default = prod)"
echo "\$3 = namespace (default = --all-namespaces)"
if [ -z "$2" ]; then
  env="prod"
else
  env="$2"
fi

if [ -z "$3" ]; then
  namespace="--all-namespaces"
else
  namespace="-n $2"
fi

kubeconfig_file="rke2-$env-cluster-rj.yaml"

if [ -z "$1" ] || [ "$1" == "-" ]; then
  kubectl --kubeconfig "$kubeconfig_file" get deployment "$namespace"
else
  kubectl --kubeconfig "$kubeconfig_file" get deployment "$namespace" | grep $1
fi
