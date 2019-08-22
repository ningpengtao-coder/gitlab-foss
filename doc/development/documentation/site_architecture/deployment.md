# GitLab Docs deployment process

The docs site is deployed to production with [GitLab Pages](../../../user/project/pages/index.md)
and previewed in merge requests with Review Apps. By default, we pull from the
master branch of [all the projects](index.md#repositories).

The [scheduled pipelines](../../../user/project/pipelines/schedules.md)
are used to build the site once an hour.

For more information, see [`.gitlab-ci.yml`](https://gitlab.com/gitlab-org/gitlab-docs/blob/master/.gitlab-ci.yml).

<-- TODO

Document Rakefile and .gitlab-ci.yml.

-->
