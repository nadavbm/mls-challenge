# How our platform is set up

Background you need to review the change. This is a condensed version of our internal
platform documentation. Names, project ids and hostnames are changed.

## The chart

`charts/service` is the standard chart for platform services. About 40 services use it.
Service teams do not fork it. They set values in their own release file under `releases/`.

Each service has one release file per environment, and both point at the same chart in this
repository. `checkout-service` therefore has two: `checkout-service-dev.yaml` and
`checkout-service-prod.yaml`.

## How it is deployed

Flux reconciles this repository every 5 minutes. There is one branch, `master`. There are
two environments, dev and prod. Each is its own cluster, and both clusters reconcile
`master`. A commit to `master` reaches both of them in about five minutes.

A single service can go out one environment at a time, because it has a release file per
environment. A change to that service can go to dev first, be watched, and then go to
prod.

The chart under `charts/service` is shared by about 40 services and by both clusters. A
change to the chart, or to its default values, reaches every service in dev and prod on the
next reconcile. A chart change cannot be staged to dev alone.

The Terraform under `terraform/` is applied the same way. A merge to `master` runs
`terraform apply` automatically. There is no manual plan review and no separate approval.
A Terraform change reaches Google Cloud as soon as it lands. No person reads the plan
before it runs.

There is no manual rollback. A bad release is corrected by another commit, which propagates
the same way. Running `helm rollback` by hand does not hold, because Flux re-applies the
desired state on the next reconcile.

The dev cluster is torn down and recreated every night. Releases there are always fresh
installs. Prod holds its state, so a release there is an in-place upgrade of what is already
running.

## Namespaces

Every service runs in its own namespace, and each environment has its own. The namespace is
set on the `HelmRelease` rather than in the chart. `checkout-service` runs in `checkout` in
prod and in `checkout-dev` in dev.

## Identity

Pods reach Google Cloud APIs through Workload Identity Federation for GKE. No service
account keys exist in any cluster.

Two things are needed and both must agree. The Kubernetes service account carries an
annotation naming the Google service account. The Google service account carries an
`roles/iam.workloadIdentityUser` binding naming the Kubernetes service account, in the form
`PROJECT_ID.svc.id.goog[NAMESPACE/KUBERNETES_SA_NAME]`.

A binding names one namespace. A Kubernetes service account in a different namespace is a
different principal, even when it has the same name.

If one of the two is wrong, nothing fails at deploy time. The pod starts, Flux reports the
release as ready, and the first call to a Google API returns 403.

## Resource policy

Platform standard, agreed after two throttling incidents in 2026: set CPU requests, do not
set CPU limits. Memory requests and memory limits are both required and must be equal.

`checkout-service` has a p99 working set of 410 MiB measured over the last 30 days.

## Probes

`/healthz` answers from the process and touches nothing else. `/ready` checks the database
connection, and is what the load balancer uses to decide whether to send traffic.

## Nodes

The cluster is regional, with node pools across three zones. Every node pool is
preemptible, and we hold no on-demand capacity. Nodes are reclaimed and replaced
regularly, so a node disappearing is an ordinary event here.

Node pools auto-upgrade in a Sunday window. Drains respect pod disruption budgets, and a
drain that cannot proceed blocks the upgrade for that node pool.

The cluster autoscaler scales node pools down overnight, which it does by moving pods onto
fewer nodes and removing the ones left empty. It respects disruption budgets while doing
so. Where a service ends up running in the morning is therefore not where it was placed the
day before.

## What the ticket asked for

SRE-2755 asks for one thing: `checkout-service` must be able to read receipt objects from
the bucket `ml-checkout-reciepts`. It does not write them. A separate batch job writes them
and already has its own identity.

Finance keeps those receipts for seven years, and the bucket has held them since 2019.
