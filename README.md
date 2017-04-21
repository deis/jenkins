# Jenkins
[![Build Status](https://ci.deis.io/job/jenkins/badge/icon)](https://ci.deis.io/job/jenkins)

This component comprises a Docker image and corresponding [Helm][] chart used to run Jenkins Master (and dynamic Jenkins agents) for the Deis [Workflow][] project on https://ci.deis.io.

## Usage

### Docker image

The Docker image is a nearly stock variant of the official [Jenkins image][] excepting the addition of all plugin dependencies as seen in [plugins.txt](plugins.txt).  Please see the official [link][Jenkins image] for further information regarding how this image can be run.

### Helm chart

For installing via the Helm chart, please see the chart's [README.md](charts/jenkins/README.md).

### Bumping Versions

Whether bumping the Jenkins version [itself](Dockerfile#L1) or various [plugins](plugins.txt) versions, one can smoke test the changes by building and then running the resulting image:

```
$ make build run
```

If the image builds successfully, then all versions were available and have been downloaded.  If the image runs successfully (no errors in Jenkins logs), the dependencies for the various plugins are all satisfied and one can be reasonably confident that Jenkins may be upgraded to run off this new image.

[Workflow]: https://github.com/deis/workflow
[Helm]: https://github.com/kubernetes/helm
[Jenkins image]: https://hub.docker.com/r/library/jenkins
