## What does this MR do?

<!--
Describe in detail what your merge request does, why it does that, etc.

Please also keep this description up-to-date with any discussion that takes
place so that reviewers can understand your intent. This is especially
important if they didn't participate in the discussion.

Make sure to remove this comment when you are done.
-->

## What are the relevant issue numbers?



## Does this MR meet the acceptance criteria?

- [ ] [Changelog entry](https://docs.gitlab.com/ee/development/changelog.html) added, if necessary
- [ ] [Documentation created/updated](https://docs.gitlab.com/ee/development/documentation/feature-change-workflow.html) via this MR
- [ ] Documentation reviewed by technical writer *or* follow-up review issue [created](https://gitlab.com/gitlab-org/gitlab-ee/issues/new?issuable_template=Doc%20Review)
- [ ] [Tests added for this feature/bug](https://docs.gitlab.com/ee/development/testing_guide/index.html)
- [ ] Tested in [all supported browsers](https://docs.gitlab.com/ee/install/requirements.html#supported-web-browsers)
- [ ] Conforms to the [code review guidelines](https://docs.gitlab.com/ee/development/code_review.html)
- [ ] Conforms to the [merge request performance guidelines](https://docs.gitlab.com/ee/development/merge_request_performance_guidelines.html)
- [ ] Conforms to the [style guides](https://gitlab.com/gitlab-org/gitlab-ee/blob/master/CONTRIBUTING.md#style-guides)
- [ ] Conforms to the [database guides](https://docs.gitlab.com/ee/development/README.html#databases-guides)
- [ ] Link to e2e tests MR added if this MR has ~"Requires e2e tests" label. See the [Test Planning Process](https://about.gitlab.com/handbook/engineering/quality/test-engineering/).
- [ ] EE specific content should be in the top level `/ee` folder
- [ ] For a paid feature, have we considered GitLab.com plans, how it works for groups, and is there a design for promoting it to users who aren't on the correct plan?
- [ ] Security reports checked/validated by reviewer

## Community Contributions

- [ ] Maintainer: Label as ~security and @ mention `@gitlab-com/gl-security/appsec` if the change affects:
 - [ ] Processing credentials/tokens
 - [ ] Storing credentials/tokens (e.g., any field that uses `attr_encrypted`)
 - [ ] Logic for privilege escalation
 - [ ] Authorization logic (e.g., permissions checks such as changes visibility of a UI element, token usage, etc.)
 - [ ] User/account access controls
 - [ ] Authentication mechanisms (e.g., passwords, oauth, etc.)
- [ ] Maintainer: Does the MR include necessary changes to maintain consistency between UI, API, email, or other methods?
- [ ] Security Engineer: review if labeled as ~security, ~permissions.

