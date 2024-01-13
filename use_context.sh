if [ -z "$1" ]; then
  env="prod"
else
  env="$1"
fi

kubeconfig_file="rke2-$env-cluster-rj.yaml"

kubectl --kubeconfig "$kubeconfig_file" config use-context "rke2-$env-cluster-rj"
