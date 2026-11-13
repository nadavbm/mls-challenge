### Review for MR-288 change

#### Issues

This is taken from the `proposed.diff` file mainly.

#### High \ Critical

- GCS bucket name change will destroy the old bucket and create a new one. Additional backup and copy items from the old bucket to the new one is needed before applying this change.

- Pod disruption budget is set to 100% minimum replicas available all time. This is problematic as nodes will be blocked from updates (regular kubernetes updates).

#### Medium \ Errors

- Memory change is too low as p99 of usage was 400Mi (or more..). This can cause OOM and possible deployment performance issues because not all replicas will be available in case of OOM.

#### Low

- GCP service account membership. Workload identity is set to the default namespace, instead of the namespace of the application (pod).

- Liveness probe change is not the same as readiness probe. If liveness probe set to find issues during application run, it should not use the `/ready` endpoint. Usually, readiness probe mark the pod as ready (after startup) and checking connections to databases \ redis or other services that are critical to the service to run. Liveness probe on the other hand, check if the program failing while running. It is a check that finds problems to process client requests or if the program is in infinite loop (or other issues). It is likely that a db connection error can cause it, so if you need to add readiness checks to your liveness probe checks, you can do so in the application code itself.
