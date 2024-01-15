if [ -z "$2" ]; then
  env="prod"
else
  env="$2"
fi

if [ -z "$2" ]; then
  namespace="--all-namespaces"
else
  namespace="-n $3"
fi

kubeconfig_file="rke2-$env-cluster-rj.yaml"

if [ -z "$1" ] || [ "$1" == "-" ]; then
  kubectl --kubeconfig "$kubeconfig_file" get services "$namespace"
else
  kubectl --kubeconfig "$kubeconfig_file" get services "$namespace" | grep $1
fi

