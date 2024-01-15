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
  namespace="-n $3"
fi

kubeconfig_file="rke2-$env-cluster-rj.yaml"

if [ -z "$1" ] || [ "$1" == "-" ]; then
  kubectl --kubeconfig "$kubeconfig_file" get svc "$namespace" > lista.txt
else
  kubectl --kubeconfig "$kubeconfig_file" get svc "$namespace" | grep $1 > lista.txt
fi

cat lista.txt

read -p "Digite o nome do service: " svc_name

if [ -n "$svc_name" ]; then
  selected_ns=$(cat lista.txt | grep "$svc_name" | head -1 | cut -d ' ' -f 1)
  kubectl  --kubeconfig "$kubeconfig_file" get svc "$svc_name" -n $selected_ns

  read -p "Digite o mapeamento das portas (p.ex, 8081:8080): " port_mapping

  if [ -n "$port_mapping" ]; then
    kubectl --kubeconfig "$kubeconfig_file" port-forward -n "$selected_ns" "svc/$svc_name" "$port_mapping"
  fi
fi