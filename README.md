# Jenkins
[![Build Status](https://ci.deis.io/job/jenkins/badge/icon)](https://ci.deis.io/job/jenkins)

This component comprises a Docker image and corresponding [Helm][] chart used to run Jenkins Master (and dynamic Jenkins agents) for the Deis [Workflow][] project on https://ci.deis.io.

## Usage

### Docker image

The Docker image is a nearly stock variant of the official [Jenkins image][] excepting the addition of all plugin dependencies as seen in [plugins.txt](plugins.txt).  Please see the official [link][Jenkins image] for further information regarding how this image can be run.

### Helm chart

For installing via the Helm chart, please see the chart's [README.md](charts/jenkins/README.md).

[Workflow]: https://github.com/deis/workflow
[Helm]: https://github.com/kubernetes/helm
[Jenkins image]: https://hub.docker.com/r/library/jenkins
