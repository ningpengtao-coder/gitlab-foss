# Cluster Environments **(PREMIUM)**

> [Introduced](https://gitlab.com/gitlab-org/gitlab-ee/issues/13392)
> in [GitLab Premium](https://about.gitlab.com/pricing/) 12.3.

Cluster environments provide a consolidated view of which CI [environments](../../ci/environments.md) is
deployed to the Kubernetes cluster, displaying which project is the
environment for and the status of the pods for that environment.

## Overview

NOTE: **Note:**
Cluster environments are only available for group-level clusters.
Support for instance-level clusters is planned in [this
issue](https://gitlab.com/gitlab-org/gitlab-ce/issues/63985).

With cluster environments, you can gain insight into:

- Which projects are deployed to the cluster.
- How many pods are used for each project's environment.
- Which job was used to deploy to that environment.

![Cluster environments page](img/cluster_environments_table.png)

Access to cluster environments is restricted to cluster administrators:

- For group clusters, these would be Group Maintainers and Owners.

## Usage

To track environments for the cluster, you will need to have successful
deployment jobs to the cluster.

Read how to [deploy to a Kubernetes
cluster](../project/clusters/index.md#deploying-to-a-kubernetes-cluster)
for a guide on how to do so.

To display pods for the environment, the pods need to match [deploy board
criteria](../project/deploy_boards.md).

Once you have successful deployments to your [Group-level
cluster](../group/clusters/index.md), navigate to your group's
**Kubernetes** page, then click on the _Environments_ tab.

NOTE: **Note:**
Only successful deployments to the cluster is included in this page.
Non-cluster environments will not be included.
