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
  kubectl --kubeconfig "$kubeconfig_file" get pods "$namespace" > lista.txt
else
  kubectl --kubeconfig "$kubeconfig_file" get pods "$namespace" | grep $1 > lista.txt
fi

cat lista.txt

read -p "Digite o nome do pod: " pod_name

if [ -n "$pod_name" ]; then
  selected_ns=$(cat lista.txt | grep "$pod_name" | head -1 | cut -d ' ' -f 1)
  kubectl --kubeconfig "$kubeconfig_file" exec -it -n "$selected_ns" "$pod_name" -- /bin/bash
fi
