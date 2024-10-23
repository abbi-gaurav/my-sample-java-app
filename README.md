# Overview

You have a Java app. You want to deploy it to Kyma. This sample provide details about how artifacts such as helm charts as well as service consumption can be added to a Java project.

## Setup

- You have a Spring boot java project (this repository).
- Add helm chart for the web application:

```bash
cds add helm
```

It will generate the [chart](chart) directory with the helm chart for the web application.

```yaml
apiVersion: v2
name: my-sample-java-app
description: A simple CAP project.
type: application
version: 1.0.0
appVersion: 1.0.0
annotations:
  app.kubernetes.io/managed-by: cds-dk/helm
dependencies:
  - name: web-application
    alias: srv
    version: ">0.0.0"
```

- To generate the full deployable helm chart, run:

```bash
cds build --production
```

```
gen/chart
├── Chart.yaml
├── charts
│   └── web-application
│       ├── Chart.yaml
│       ├── templates
│       │   ├── NOTES.txt
│       │   ├── _api.tpl
│       │   ├── _helpers.tpl
│       │   ├── api-rule.yaml
│       │   ├── deployment.yaml
│       │   ├── hpa.yaml
│       │   ├── network-policy.yaml
│       │   ├── pod-disruption-budget.yaml
│       │   ├── rbac.yaml
│       │   ├── secret.yaml
│       │   ├── service-account.yaml
│       │   ├── service-binding.yaml
│       │   ├── service.yaml
│       │   └── virtual-service.yaml
│       ├── values.schema.json
│       └── values.yaml
├── templates
│   ├── NOTES.txt
│   ├── _deployment_helpers.tpl
│   └── _helpers.tpl
├── values.schema.json
└── values.yaml

5 directories, 23 files
```

- Consume a service instance:

```bash
cds add destination
```

Service instance will be added as dependency

```yaml
apiVersion: v2
name: my-sample-java-app
description: A simple CAP project.
type: application
version: 1.0.0
appVersion: 1.0.0
annotations:
  app.kubernetes.io/managed-by: cds-dk/helm
dependencies:
  - name: web-application
    alias: srv
    version: ">0.0.0"
  - name: service-instance
    alias: destination
    version: ">0.0.0"
```

Regenerate the helm chart:

```bash
cds build --production
```

It will have the service instance chart as well.

```text
gen/chart
├── Chart.yaml
├── charts
│   ├── service-instance
│   │   ├── Chart.yaml
│   │   ├── templates
│   │   │   ├── _helpers.tpl
│   │   │   ├── servicebinding.yaml
│   │   │   └── serviceinstance.yaml
│   │   ├── values.schema.json
│   │   └── values.yaml
│   └── web-application
│       ├── Chart.yaml
│       ├── templates
│       │   ├── NOTES.txt
│       │   ├── _api.tpl
│       │   ├── _helpers.tpl
│       │   ├── api-rule.yaml
│       │   ├── deployment.yaml
│       │   ├── hpa.yaml
│       │   ├── network-policy.yaml
│       │   ├── pod-disruption-budget.yaml
│       │   ├── rbac.yaml
│       │   ├── secret.yaml
│       │   ├── service-account.yaml
│       │   ├── service-binding.yaml
│       │   ├── service.yaml
│       │   └── virtual-service.yaml
│       ├── values.schema.json
│       └── values.yaml
├── templates
│   ├── NOTES.txt
│   ├── _deployment_helpers.tpl
│   └── _helpers.tpl
├── values.schema.json
└── values.yaml

7 directories, 29 files
```

- Post building the images using cloud native buildpacks or Dockerfile. Update the related parameters in [chart/values.yaml](chart/values.yaml)

- Regenerate the helm chart:

```bash
cds build --production
```

- Generate the .env file with following details:

```text
DOCKER_ACCOUNT=gauravsap
NAMESPACE=test
CLUSTER_DOMAIN=my-domain.kyma.ondemand.com
HELM_RELEASE_NAME=my-sample-java-app

APP=my-sample-java-app-srv

VERSION=0.0.1
```

- Check the template files via helm template

```bash
make deploy-template
```