# Pipelines for the GitLab project

Pipelines for `gitlab-org/gitlab-ce` and `gitlab-org/gitlab-ce` (as well as the
`dev` instance's mirrors) are configured in the usual
[`.gitlab-ci.yml`](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/.gitlab-ci.yml)
which itself includes files under
[`.gitlab/ci/`](https://gitlab.com/gitlab-org/gitlab-ce/tree/master/.gitlab/ci)
for easier maintenance.

We're striving to [dogfood](https://about.gitlab.com/handbook/engineering/#dogfooding)
GitLab [CI/CD features and best-practices](../ci/yaml/README.md)
as much as possible.

## Stages

The current stages are:

- `prepare`: This stage includes jobs that prepare artifacts that are needed by
  jobs in subsequent stages.
- `quick-test`: This stage includes test jobs that should run first and fail the
  pipeline early (currently used to run Geo tests when the branch name starts
  with `geo-`, `geo/`, or ends with `-geo`).
- `test`: This stage includes most of the tests, DB/migration jobs, and static analysis jobs.
- `review-prepare`: This stage includes a job that build the CNG images that are
  later used by the (Helm) Review App deployment (see
  [Review Apps](testing_guide/review_apps.md) for details).
- `review`: This stage includes jobs that deploy the GitLab and Docs Review Apps.
- `qa`: This stage includes jobs that perform QA tasks against the Review App
  that is deployed in the previous stage.
- `post-test`: This stage includes jobs that build reports or gather data from
  the previous stages' jobs (e.g. coverage, Knapsack metadata etc.).
- `pages`: This stage includes a job that deploy the various reports as
  GitLab pages (e.g. <https://gitlab-org.gitlab.io/gitlab-ce/coverage-ruby/>,
  <https://gitlab-org.gitlab.io/gitlab-ce/coverage-javascript/>,
  <https://gitlab-org.gitlab.io/gitlab-ce/webpack-report/>)

## Default image

The default image is currently
`dev.gitlab.org:5005/gitlab/gitlab-build-images:ruby-2.6.3-golang-1.11-git-2.22-chrome-73.0-node-12.x-yarn-1.16-postgresql-9.6-graphicsmagick-1.3.33`.
It includes Ruby 2.6.3, Go 1.11, Git 2.22, Chrome 73, Node 12, Yarn 1.16,
PostgreSQL 9.6, and Graphics Magick 1.3.33.

The images used in our pipelines are configured in the
[`gitlab-org/gitlab-build-images`](https://gitlab.com/gitlab-org/gitlab-build-images)
project, which is push-mirrored to <https://dev.gitlab.org/gitlab/gitlab-build-images>
for redundancy.

The current version of the build images can be found in the
["Used by GitLab CE/EE section"](https://gitlab.com/gitlab-org/gitlab-build-images/blob/master/.gitlab-ci.yml).

## Default variables

In addition to the [predefined variables](../ci/variables/predefined_variables.md),
each pipeline includes the following [variables](../ci/variables/README.md):

- `RAILS_ENV: "test"`
- `NODE_ENV: "test"`
- `SIMPLECOV: "true"`
- `GIT_DEPTH: "20"`
- `GIT_SUBMODULE_STRATEGY: "none"`
- `GET_SOURCES_ATTEMPTS: "3"`
- `KNAPSACK_RSPEC_SUITE_REPORT_PATH: knapsack/${CI_PROJECT_NAME}/rspec_report-master.json`
- `EE_KNAPSACK_RSPEC_SUITE_REPORT_PATH: knapsack/${CI_PROJECT_NAME}/rspec_report-master-ee.json`
- `FLAKY_RSPEC_SUITE_REPORT_PATH: rspec_flaky/report-suite.json`
- `BUILD_ASSETS_IMAGE: "false"`
- `ES_JAVA_OPTS: "-Xms256m -Xmx256m"`
- `ELASTIC_URL: "http://elastic:changeme@docker.elastic.co-elasticsearch-elasticsearch:9200"`

## Common job definitions

Most of the jobs [extend from a few CI definitions](../ci/yaml/README.md#extends)
that are scoped to a single
[configuration parameter](../ci/yaml/README.md#configuration-parameters).

These common definitions are:

- `.default-tags`: Ensures a job has the `gitlab-org` tag to ensure it's using
  our dedicated runners.
- `.default-retry`: Allows a job to retry upon `unknown_failure`, `api_failure`,
  `runner_system_failure`.
- `.default-before_script`: Allows a job to use a default `before_script` definition
  suitable for Ruby/Rails tasks that may need a database running (e.g. tests).
- `.default-cache`: Allows a job to use a default `cache` definition suitable for
  Ruby/Rails and frontend tasks.
- `.default-only`: Restricts the cases where a job is created. This currently
  includes `master`, `/^[\d-]+-stable(-ee)?$/` (stable branches),
  `/^\d+-\d+-auto-deploy-\d+$/` (security branches), `merge_requests`, `tags`.
  Note that jobs won't be created for branches with this default configuration.
- `.only-review`: Only creates a job for the `gitlab-org` namespace and if
  Kubernetes integration is available. Also, prevents a job from being created
  for `master` and auto-deploy branches.
- `.only-review-schedules`: Same as `.only-review` but also restrict a job to
  only run for [schedules](../user/project/pipelines/schedules.md).
- `.use-pg`: Allows a job to use the `postgres:9.6.14` and `redis:alpine` services.
- `.use-pg-10`: Allows a job to use the `postgres:10.9` and `redis:alpine` services.
- `.only-ee`: Only creates a job for the `gitlab-ee` project.

## Changes detection

If a job extends from `.default-only` (and most of the jobs should), it can restrict
the cases where it should be created
[based on the changes](../ci/yaml/README.md#onlychangesexceptchanges)
from a commit or MR by extending from the following CI definitions:

- `.only-code-changes`: Allows a job to only be created upon code-related changes
- `.only-qa-changes`: Allows a job to only be created upon QA-related changes
- `.only-docs-changes`: Allows a job to only be created upon docs-related changes
- `.only-code-qa-changes`: Allows a job to only be created upon code-related or QA-related changes
- `.only-code-docs-changes`: Allows a job to only be created upon code-related or docs-related changes

**See <https://gitlab.com/gitlab-org/gitlab-ee/blob/master/.gitlab/ci/global.gitlab-ci.yml>
for the list of exact patterns.**

## Directed acyclic graph

We're using the [`needs:`](../ci/yaml/README.md#needs) keyword to
execute jobs out-of-order for the following jobs:

```mermaid
graph RL;
  A[setup-test-env];
  B[gitlab:assets:compile];
  C[gitlab:assets:compile pull-cache];
  D[cache gems];
  E[review-build-cng];
  F[build-qa-image];

subgraph "`prepare` stage"
    A
    end

subgraph "`test` stage"
    B
    C
    D
    F
    downtime_check -- needs --> A;
    db:* -- needs --> A;
    gitlab:setup -- needs --> A;
    migration:upgrade-pg-ce-to-ee -- needs --> A;
    end

subgraph "`review-prepare` stage"
    E
    schedule:review-build-cng -- needs --> B;
    end

  B -- needs --> A;
  C -- needs --> A;

  D -- needs --> A;
  E -- needs --> C;

subgraph "`review` stage"
    review-deploy -- needs --> E;
    end

subgraph "`qa` stage"
    package-and-qa-manual -- needs --> C;
    package-and-qa-manual -- needs --> F;
    package-and-qa-manual:master -- needs --> B;
    package-and-qa-manual:master -- needs --> F;
    package-and-qa -- needs --> C;
    package-and-qa -- needs --> F;
    end
```

## Test jobs

Consult [GitLab tests in the Continuous Integration (CI) context](testing_guide/ci.md)
for more information.

## Review app jobs

Consult the [Review Apps](testing_guide/review_apps.md) dedicated page for more information.

---

[Return to Development documentation](README.md)
