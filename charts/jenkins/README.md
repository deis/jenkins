# Jenkins Helm Chart

Jenkins master and slave cluster utilizing the Jenkins Kubernetes plugin

* https://wiki.jenkins-ci.org/display/JENKINS/Kubernetes+Plugin

This version is a fork of the canonical [stable/jenkins](https://github.com/kubernetes/charts/tree/master/stable/jenkins) chart from the official [Kubernetes Charts](https://github.com/kubernetes/charts) repository.

## Chart Details
This chart will do the following:

* 1 x Jenkins Master with port 8080 exposed on an external LoadBalancer (by default)
* Optionally, Jenkins Master can be configured to expose a dedicated LoadBalancer for the JNLP service port (see [Configuration](https://github.com/deis/jenkins/blob/master/charts/jenkins/README.md#configuration)).  This may be useful if port 8080 is fronted by an Ingress Controller.
* Values supplied under the `Agent` section will be given to the Kubernetes Plugin in Jenkins for spawning dynamic agents.

## Installing the Chart

To install the chart with the release name `my-release` locally:

```bash
$ helm install --name my-release charts/jenkins
```

## Configuration

The following tables lists the configurable parameters of the Jenkins chart and their default values.

### Jenkins Master


| Parameter                  | Description                        | Default                                                    |
| -----------------------    | ---------------------------------- | ---------------------------------------------------------- |
| `Master.Name`              | Jenkins master name                | `jenkins-master`                                           |
| `Master.Image`             | Master image name                  | `gcr.io/kubernetes-charts-ci/jenkins-master-k8s`           |
| `Master.ImageTag`          | Master image tag                   | `v0.1.0`                                                   |
| `Master.ImagePullPolicy`   | Master image pull policy           | `Always`                                                   |
| `Master.Component`         | k8s selector key                   | `jenkins-master`                                           |
| `Master.Cpu`               | Master requested cpu               | `200m`                                                     |
| `Master.Memory`            | Master requested memory            | `256Mi`                                                    |
| `Master.ServiceType`       | k8s service type                   | `LoadBalancer`                                             |
| `Master.ServicePort`       | k8s service port                   | `8080`                                                     |
| `Master.NodePort`          | k8s node port                      | Not set                                                    |
| `Master.ContainerPort`     | Master listening port              | `8080`                                                     |
| `Master.SlaveListener.EnableDedicatedLoadBalancer` | Whether to enable a dedicated service of type `LoadBalancer`. This is useful if the main service is not one of type `LoadBalancer` and agents _external_ to the cluster still need to connect to the master. | `false` |
| `Master.SlaveListener.Port` | Listening port for agents          | `50000`                                                    |
| `Master.LoadBalancerSourceRanges` | Allowed inbound IP addresses| `0.0.0.0/0`                                                |
| `Master.CustomConfigMap`          | Use a custom ConfigMap             | `false`                                                    |
| `Master.Ingress.Annotations` | Ingress annotations       | `{}`                                                |
| `Master.Ingress.TLS.Enabled` | Whether to enable TLS | `false` |
| `Master.Ingress.TLS.Cert` | Base64-encoded x509 certificate | |
| `Master.Ingress.TLS.Key` | Base64-encoded private key for the above certificate | |
| `Master.InitScripts`       | List of Jenkins init scripts       | Not set                                                    |  

### Jenkins Agent

| Parameter               | Description                        | Default                                                    |
| ----------------------- | ---------------------------------- | ---------------------------------------------------------- |
| `Agent.Image`           | Agent image name                   | `jenkinsci/jnlp-slave`                                     |
| `Agent.ImageTag`        | Agent image tag                    | `2.52`                                                     |
| `Agent.Cpu`             | Agent requested cpu                | `200m`                                                     |
| `Agent.Memory`          | Agent requested memory             | `256Mi`                                                    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
$ helm install --name my-release -f values.yaml charts/jenkins
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Persistence

The Jenkins image stores persistence under `/var/jenkins_home` path of the container. A dynamically managed Persistent Volume
Claim is used to keep the data across deployments, by default. This is known to work in GCE, AWS, and minikube. Alternatively,
a previously configured Persistent Volume Claim can be used.

It is possible to mount several volumes using `Persistence.volumes` and `Persistence.mounts` parameters.

### Persistence Values

| Parameter | Description | Default |
| --------- | ----------- | ------- |
| `Persistence.Enabled` | Enable the use of a Jenkins PVC | `true` |
| `Persistence.ExistingClaim` | Provide the name of a PVC | `nil` |
| `Persistence.AccessMode` | The PVC access mode | `ReadWriteOnce` |
| `Persistence.Size` | The size of the PVC | `8Gi` |
| `Persistence.volumes` | Additional volumes | `nil` |
| `Persistence.mounts` | Additional mounts | `nil` |


#### Existing PersistentVolumeClaim

1. Create the PersistentVolume
1. Create the PersistentVolumeClaim
1. Install the chart
```bash
$ helm install --name my-release --set Persistence.ExistingClaim=PVC_NAME stable/jenkins
```

### Persistence via Mounted Volume

It is also possible to use a mounted volume for persisting state in `/var/jenkins_home`.  Simply supply the host path to the mounted disk on the Kubernetes Node and be sure to pin Jenkins Master to said node.  This can be accomplished by populating the following values in the `values.yaml` file used to install Jenkins:
```
Master:
...
  NodeSelector:
    mountedvolumenode: "true"
  JenkinsHome:
    HostPath: /mounted/jenkins_home
...
```

## Custom ConfigMap

When creating a new chart with this chart as a dependency, CustomConfigMap can be used to override the default config.xml provided.
It also allows for providing additional xml configuration files that will be copied into `/var/jenkins_home`. In the parent chart's values.yaml,
set the value to true and provide the file `templates/config.yaml` for your use case. If you start by copying `config.yaml` from this chart and
want to access values from this chart you must change all references from `.Values` to `.Values.jenkins`.

```
jenkins:
  Master:
    CustomConfigMap: true
```
