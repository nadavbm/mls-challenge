# !288 Give checkout-service access to the receipts bucket

**Source branch:** `checkout-wi` → **Target branch:** `master`
**Author:** J. Weber (Platform)
**Assignee:** you
**Labels:** ~platform ~"needs review"

---

SRE-2755. checkout-service needs to read receipts from Cloud Storage. This wires up
Workload Identity for it, and picks up a few things in the chart while I was in there.

### What this does

- Adds a `serviceAccount.gcpServiceAccount` value to the chart. When it is set, the
  Kubernetes service account gets the `iam.gke.io/gcp-service-account` annotation. When it
  is empty, nothing changes, so this is a no-op for the other 39 services.
- Adds the Terraform for the Google service account binding and the bucket access.
- Sets the service account on both releases, so dev and prod behave the same way and we
  do not get a surprise the first time somebody tests it there.
- Fixes the spelling of the bucket while I am in there. It has been `reciepts` since 2019
  and it makes me wince every time I open this file.
- Standardises the labels. `app.kubernetes.io/version` was only on some objects and not
  others, which made `kubectl get` output inconsistent across services. Now every object
  carries it. Cosmetic change, no functional effect.
- Raises the default replica count from one to three, and drops the per-service override on
  checkout-service so it picks the default up. One replica is why the July incident took
  the service down at all. Three means we stay up when a node goes away, which given how
  often the preemptibles get recycled is not a rare event.
- Adds a pod disruption budget to the chart. We had an incident in July where a node drain
  took the last pod of a service down. This stops that happening again.
- Drops the CPU limit and lowers the memory limit to 256Mi. The CPU limit was causing
  throttling, and 512Mi was generous for a service this size, so this improves bin packing
  on the nodes.
- Points the liveness probe at `/ready`. We had two `/healthz` regressions where the
  process answered but the service was actually broken, so the deeper check is the right
  one for liveness.

### Testing

Deployed to the dev cluster from this branch. The release reconciles, checkout-service
comes up, and the Kubernetes service account has the annotation on it.

### Risk

Low. The only service that gets new behaviour is checkout-service, because it is the only
one that sets `gcpServiceAccount`. The label and probe changes are safe.

I know it is several things at once. I raised that with the team lead on Monday and we
agreed to keep it together: the chart changes have been sitting in my branch for three
weeks and this is the only window I have before I go on leave. So please review it as it
stands rather than asking me to break it up.
