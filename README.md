Project
---
The following Goal and MVP defined by client.

### Goal - Create application deployment process with-out downtime, using any tools comfortable to candidate.

### MVP
Using at least two running instances (VMs or containers) with sample HTML app build a deployment process automation that can publish the new app version without downtime. The app it-self can be a simple static HTML page displaying its version.

A good solution should be automated and repro-ducible, organized as a repo on Github with all required files, scripts and docs.

## URLs

| Namespace        | URL        | Description |
| ------------- |-------------| -----------|
| kube-system | https://build.steven.hopkins.rocks | Jenkins server |
| weave       | https://scope.steven.hopkins.rocks | [Weave Scope](https://www.weave.works/oss/scope/) |
| int         | https://example-app.int.steven.hopkins.rocks | Example Application - Integration Env |
| stg         | https://example-app.stg.steven.hopkins.rocks | Example Application - Stage Env |
| prd         | https://example-app.steven.hopkins.rocks | Example Application - Production Env |

![AWS Infrastructure](aws-diagram.png "AWS Infrastructure")

## Repository Layout
### Application

Application is located in [app](app/) directory along with Dockerfile, Kubernetes configs and Jenkinsfile.

### Services

Primarily provided as [helm](https://github.com/kubernetes/helm) charts located in [charts](aws/int/us-east-1/kops-cluster/services/charts/) directory.  

### Infrastructure

Infrastructure modules live in [aws/modules/](aws/modules/) and most module instanciations located in [aws/int/us-east-1/](aws/int/us-east-1/) and dns found in [aws/global/](aws/global/). 

Primary kubernetes platform and services located under [aws/int/us-east-1/kops-cluster](aws/int/us-east-1/kops-cluster).

## How-to

### Build

There are two jobs involved in this basic build pipeline.

#### example-project
This job initiates and saves the successful build of a docker container. The job can be reused in other dockerized projects that provide a `Dockerfile` with necessary steps to build and run and application or service. Once a successful build is completed it calls the secondary parameterized job to deploy through each environment. 

#### example-project-deploy
This job may be run manually so that you can provide image tags to manually launch should there be an exception process such as a hotfix not processed through the build job (highly discouraged) or a rollback discovered later than expected. It is primarily intended to be called by the build and deploy orchestration job `example-project`.

The `vgs-guest` user account has build permissions in the jenkins account; you can watch the pipeline in action by initiating a `example-project` build.

![STG Gate](build.png "STG Gate")

![STG Gate](build-with-params.png "STG Gate")

You can use the container weave scope view to watch new containers spin up/down along with ingress controller switch overs [weave-containers](https://scope.steven.hopkins.rocks/#!/state/{"topologyId":"containers"}).

The dployment will progress through to `Gate to STG` as long as no errors occur. At which point you can take your time to review things (7 days) and once you are satisfied with the integration deployment you can hover over the blue progress in the `Gate to STG` box resulting in a popup allowing you to `Proceed` or `Abort` the stage deployment. Another gate will be present prior to the production deployment.

![STG Gate](stg-gate.png "STG Gate")

## Enhancements

### Canary Deployment
This deployment process uses standard kubernetes rollout. A canary deployment is a method by which you keep both version running with a limited audience routing to the new code until you give everything the all clear and rollout the code to the rest of the environment. It can help prevent a service interuption and hopefully the need for a `rollout undo`. [Spinnaker.io](https://www.spinnaker.io) from Netflix offers an interesting product that actually handles complete blue/green deployments with some nice built-in Jenkins features.

### Jenkins 
Breaking out pipeline code into a shared jenkins library would further encourage collabortation and code reusability. Jenkins could also benefit from some additional notifications integrations like Slack, PagerDuty and email.

### Configuration and Secrets
Hashicorp Consul and Vault should be setup for configuration, secrets and service discovery, 

### Environment
Colocating application and base infrastructure code is not ideal. This monolithic example repository should be pared down and broken up into logical separation of concerns. 

Additional visibility, monitoring and alerting are powerful tools for catching issues early and identifying tipping points. The environment would benefit from some or all of the following.

 * PagerDuty
 * Graylog or EFK (Elasticsearch, Fluentd, Kibana)
 * Influxdb
 * Prometheus
 * Grafana

### Hardening
As a primarily AWS infrastructure I would suggest investing in Oracle CASB, Evident.io or some other like service to establish audit policies and best practices for AWS setup and confirguraition.

### Documenation and Knowledge Base
Documentation is a living organic process and should continue throughout the life of all projects. Periodic reviews should be established to reduce drift in documentation from actual state and new KBA should be created and stored in a centrally located Knowledge Base as issues are arise and solutions are discovered. 