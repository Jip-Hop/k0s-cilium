# k0s-cilium

Work in progress repo containing a declarative Cilium bootstrap in `k0s` with `docker compose` optimized for a single node. Run `docker compose up -d` in the root of this repo to bring up the stack. It automatically deploys all charts inside the [`charts`](./charts/) folder. Currently it installs:

- Gateway API CRDs
- Cilium
- An example HTTP(S) Gateway + echo server

## Requirements

- Host with docker compose
- Host with a TLS (wildcard) certificate to use for HTTPS on the Gateway (you can run [`generate.sh`](./tls/generate.sh) to create a TLS cert for development).

## Verify

```sh
# Show that cilium ingress uses the TLS cert
curl --cacert ./tls/tls.crt -v https://localhost/echo-with-https
curl --cacert ./tls/tls.crt -v -L http://localhost/echo-with-https
curl --cacert ./tls/tls.crt -v --resolve example.com:443:127.0.0.1 https://example.com/echo-with-https --header 'Host: example.com'
# Troubleshooting
kubectl logs -n kube-system deployments/cilium-operator | grep gateway
```

## Automated Deployment

Changes to [`k0s_config.yaml`](./config/k0s_config.yaml) are monitored and trigger a restart of the `k0s` process inside the container. This allows for automatic (re)deployment of the charts inside the [`charts`](./charts/) folder. The [`tls`](./tls/) folder is monitored as well. A new secret will be created inside the `gateway-infra` namespace when `k0s` starts up and each time the `tls` cert if modified. This allows you to renew the certificate on the host, which may be useful for hosts that already have a process to automatically request and renew (wildcard) certificates such as [TrueNAS SCALE](https://www.truenas.com/docs/scale/24.10/scaletutorials/credentials/certificates/certificatesscale/).

## Development

Run the [`dev.sh`](./dev.sh) script to bring up the stack and automatically configure `kubectl` to talk to the API server. The development environment will clean up after itself. NOTE: the dev and prd stacks can't run alongside each other on the same host as the both bind to port 80 and 443.

## TODO

TODO: fork and create PR at https://github.com/k0sproject/k0s/tree/main/docs to document helm extensions with unpackaged Charts (plain directory with files that follow the Helm chart guidelines) as opposed to a packaged Chart (.tgz archive).
- https://docs.k0sproject.io/stable/extensions/?h=helm#helm-based-extensions
- https://docs.k0sproject.io/stable/helm-charts/

TODO: extension bootstrap and upgrade
See https://github.com/k0sproject/k0s/issues/3966
See https://github.com/k0sproject/k0s/issues/3071
Need to remove Chart.lock and the charts/**/*.tgz files when bumping the dependencies chart version?
Alternative may be to render chart + values with helm template (optionally apply kustomize),
commit the results in this git repo and mount these files inside /var/lib/k0s/manifests/example
But the documentation is unclear in which order these manifests will apply, will this cause issues
when trying to apply a manifest which depends on the Gateway API CRDs?

TODO: alternative way to have cilium chart with custom values. Maybe preprocess at startup the `k0s_config.yaml` file with kustomize? I want the values inside a yaml file, not as a string inside `k0s_config.yaml`.