<!-- Follow the documentation workflow https://docs.gitlab.com/ee/development/documentation/workflow.html -->
<!-- Additional information is located at https://docs.gitlab.com/ee/development/documentation/ --> 

<!-- Mention "documentation" or "docs" in the MR title -->
<!-- For changing documentation location use the "Change documentation location" template -->

## What does this MR do?

<!-- Briefly describe what this MR is about. -->

## Related issues

<!-- Link related issues below. Insert the issue link or reference after the word "Closes" if merging this should automatically close it. -->

## Author's checklist

- [ ] Follow the [Documentation Guidelines](https://docs.gitlab.com/ee/development/documentation/) and [Style Guide](https://docs.gitlab.com/ee/development/documentation/styleguide.html).
- [ ] Link the document from the higher-level index page.
- [ ] Link other related docs where helpful.
- [ ] Add the [product badges](https://docs.gitlab.com/ee/development/documentation/styleguide.html#product-badges) when applicable.
- [ ] Add the [GitLab version and tier](https://docs.gitlab.com/ee/development/documentation/styleguide.html#gitlab-versions-and-tiers) the feature was introduced in.
- [ ] Submit the [EE-equivalent MR](https://docs.gitlab.com/ee/development/documentation/#cherry-picking-from-ce-to-ee) (required if `ee-compat-check` job fails).
- [ ] If the feature is moving tiers, make sure the change is also reflected in [`features.yml`](https://gitlab.com/gitlab-com/www-gitlab-com/blob/master/data/features.yml).
- [ ] Set the realease milestone.
- [ ] Apply the DevOps stages and feature labels to the MR.
- [ ] Apply the label "Pick into X.Y" and ~"missed\-deliverable" to the MR if the feature freeze date has passed.

## Review checklist

All reviewers can help ensure accuracy, clarity, completeness, and adherence to the [Documentation Guidelines](https://docs.gitlab.com/ee/development/documentation/) and [Style Guide](https://docs.gitlab.com/ee/development/documentation/styleguide.html).

**1. Primary Reviewer**

* [ ] Review by a code reviewer or other selected colleague to confirm accuracy, clarity, and completeness. This can be skipped for minor fixes without substantive content changes.
 
**2. Technical Writer**

* [ ] Optional: Technical writer review. If not requested for this MR, must be scheduled post-merge. To request for this MR, assign the writer listed for the applicable [DevOps stage](https://about.gitlab.com/handbook/product/categories/#devops-stages).

**3. Maintainer**

1. [ ] Review by assigned maintainer, who can always request/require the above reviews. Maintainer's review can occur before or after a technical writer review.
1. [ ] Merge the equivalent EE MR before the CE MR if both exist.
1. [ ] If there has not been a technical writer review, [create an issue for one using the Doc Review template](https://gitlab.com/gitlab-org/gitlab-ce/issues/new?issuable_template=Doc%20Review).

/label ~Documentation
