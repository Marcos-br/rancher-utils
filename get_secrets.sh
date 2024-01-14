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
  kubectl --kubeconfig "$kubeconfig_file" get secrets "$namespace" > lista.txt
else
  kubectl --kubeconfig "$kubeconfig_file" get secrets "$namespace" | grep $1 > lista.txt
fi

cat lista.txt

read -p "Digite o nome da secret: " secret_name

if [ -n "$secret_name" ]; then
  selected_ns=$(cat lista.txt | grep "$secret_name" | head -1 | cut -d ' ' -f 1)
  kubectl --kubeconfig "$kubeconfig_file" describe secret -n "$selected_ns" "$secret_name"
fi
