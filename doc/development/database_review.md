# Database Review Guidelines

This page is specific to database reviews. Please refer to our
[code review guide](code_review.md) for broader advice and best
practices for code review in general.

## General process

A database review is required for:

* Changes that touch the database schema or perform data migrations,
  including files in:
  * `db/`
  * `lib/gitlab/background_migration/`
* Changes to the database tooling, e.g.:
  * migration or ActiveRecord helpers in `lib/gitlab/database/`
  * load balancing
* Changes that produce SQL queries that are beyond the obvious. It is
  generally up to the author of a merge request to decide whether or
  not complex queries are being introduced and if they require a
  database review.

A database reviewer is expected to look out for obviously complex
queries in the change and review those closer. If the author does not
point out specific queries for review and there are no obviously
complex queries, it is enough to concentrate on reviewing the
migration only.

It is preferable to review queries in SQL form and generally accepted
to ask the author to translate any ActiveRecord queries in SQL form
for review.

### Roles and process

A Merge Request author's role is to:

* Decide whether a database review is needed and apply ~database and ~"database::review pending" if so.

A database **reviewer**'s role is to:

* Perform a first-pass review on the MR and suggest improvements to the author.
* Once satisfied, relabel the MR with ~"database::reviewed" and reassign MR to a database **maintainer**.

A database **maintainer**'s role is to

* Perform another database review of the MR.
* Discuss further improvements or other relevant changes with the database reviewer and the MR author.
* Finally relabel the MR with ~"database::approved"
* And if requested, approve or merge the MR, or pass it on to other maintainers as required (frontend, backend, docs).

### Distributing review workload

Ideally, review workload is distributed using our review roulette
([example](https://gitlab.com/gitlab-org/gitlab-ce/merge_requests/25181#note_147551725)).
The MR author should then co-assign the suggested database
**reviewer**. When they give their sign-off, they will hand over to
the suggested database **maintainer**.

However, some changes are not yet automatically detected to need a
database review. For those changes, MR authors typically mention
`@gl-database` in order to get a review.

Until there are [Merge boards](https://gitlab.com/gitlab-org/gitlab-ce/issues/35336),
a list of pending database reviews is maintained in an issue titled
"Database Reviews" in the [infrastructure tracker](https://gitlab.com/gitlab-com/gl-infra/infrastructure/issues?scope=all&utf8=%E2%9C%93&state=opened&label_name[]=Database&search=Database+Reviews)
([example](https://gitlab.com/gitlab-com/gl-infra/infrastructure/issues/6998)).
Note the issue rolls over after two weeks and a new issue is created.

The Database Reviews issue contains a list of pending database
reviews. Database **reviewers** and **maintainers** should work from
the list of pending database reviews and

1. Pick an MR from the list that doesn't have a person attached to it.
1. Edit the description of the issue and put your handle next the MR.
1. Proceed with reviewing the MR in question.
1. Once review has been completed - check the box.

### How to review for database

* Check migrations
  * Review relational modeling and design choices
  * Review migrations follow [database migration style guide](https://docs.gitlab.com/ee/development/migration_style_guide.html), for example
    * [Check ordering of columns](https://docs.gitlab.com/ee/development/ordering_table_columns.html)
    * [Check indexes are present for foreign keys](https://docs.gitlab.com/ee/development/migration_style_guide.html#adding-foreign-key-constraints)
  * Ensure that migrations execute in a transaction or only contain concurrent index/foreign key helpers (with transactions disabled)
  * Check consistency with `db/schema.rb` and that migrations are [reversible](https://docs.gitlab.com/ee/development/migration_style_guide.html#reversibility)
  * For data migrations, establish a time estimate for execution
* Check post deploy migration
  * Make sure we can expect post deploy migrations to finish within 1 hour max.
* Check background migrations
  * Review queries (for example, make sure batch sizes are fine)
  * Establish a time estimate for execution
* Query performance
  * Check for any obviously complex queries and queries the author specifically points out for review (if any)
  * If not present yet, ask the author to provide SQL queries and query plans (e.g. by using [chatops](https://docs.gitlab.com/ee/development/understanding_explain_plans.html) or direct database access)
  * For given queries, review parameters regarding data distribution
  * [Check query plans](https://docs.gitlab.com/ee/development/understanding_explain_plans.html) and suggest improvements to queries (changing the query, schema or adding indexes and similar)
  * General guideline is for queries to come in below 100ms execution time
  * If queries rely on prior migrations that are not present yet on production (eg indexes, columns), you can use a [one-off instance from the restore pipeline](https://ops.gitlab.net/gitlab-com/gl-infra/gitlab-restore/postgres-gprd) in order to establish a proper testing environment.
