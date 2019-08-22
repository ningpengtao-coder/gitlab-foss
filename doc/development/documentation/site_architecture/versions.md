# How the website versions are built

This directory contains all needed Dockerfiles to build and deploy the
versioned website. It is heavily inspired by Docker's
[publish tools](https://github.com/docker/docker.github.io/tree/publish-tools).

The following Dockerfiles are used.

| Dockerfile | Docker image | Description |
| ---------- | ------------ | ----------- |
| [`Dockerfile.bootstrap`](https://gitlab.com/gitlab-org/gitlab-docs/blob/master/dockerfiles/Dockerfile.bootstrap) | `gitlab-docs:bootstrap` | Contains all the dependencies that are needed to build the website. If the gems are updated and `Gemfile{,.lock}` changes, the image must be rebuilt. |
| [`Dockerfile.builder.onbuild`](https://gitlab.com/gitlab-org/gitlab-docs/blob/master/dockerfiles/Dockerfile.builder.onbuild) | `gitlab-docs:builder-onbuild` | Base image to build the docs website. It uses `ONBUILD` to perform all steps and depends on `gitlab-docs:bootstrap`. |
| [`Dockerfile.nginx.onbuild`](https://gitlab.com/gitlab-org/gitlab-docs/blob/master/dockerfiles/Dockerfile.nginx.onbuild) | `gitlab-docs:nginx-onbuild` | Base image to use for building documentation archives. It uses `ONBUILD` to perform all required steps to copy the archive, and relies upon its parent `Dockerfile.builder.onbuild` that is invoked when building single documentation achives (see the `Dockerfile` of each branch. |
| [`Dockerfile.archives`](https://gitlab.com/gitlab-org/gitlab-docs/blob/master/dockerfiles/Dockerfile.archives) | `gitlab-docs:archives` | Contains all the versions of the website in one archive. It copies all generated HTML files from every version in one location. |

## How to build the images

You can build and tag all tooling images locally:

1. Make sure you're on the `dockerfiles/` directory of the `gitlab-docs` repo.
1. Build the images:

   ```sh
   docker build -t registry.gitlab.com/gitlab-org/gitlab-docs:bootstrap -f Dockerfile.bootstrap ../
   docker build -t registry.gitlab.com/gitlab-org/gitlab-docs:builder-onbuild -f Dockerfile.builder.onbuild ../
   docker build -t registry.gitlab.com/gitlab-org/gitlab-docs:nginx-onbuild -f Dockerfile.nginx.onbuild ../
   ```

For each image, there's a manual job under the `images` stage in
[`.gitlab-ci.yml`](https://gitlab.com/gitlab-org/gitlab-docs/blob/master/.gitlab-ci.yml) which can be invoked at will.

## Release process

When a new GitLab version is released on the 22nd, we need to create the respective
single Docker image, and update some files.

### 1. Add the chart version

Since the charts use a different version number than all the other GitLab
products, we need to add the new
[version mapping](https://docs.gitlab.com/charts/installation/version_mappings.html):

1. Make sure you're on the root path of the `gitlab-docs` repo.
1. Open `content/_data/chart_versions.yaml` and add the new version using the
   [version mapping](https://docs.gitlab.com/charts/installation/version_mappings.html).
   Note that only the `major.minor` version is needed.
1. Create a new merge request and merge it.

TIP: **Tip:**
It can be handy to create the future mappings since they are pretty much known.
In that case, when a new GitLab version is released, you don't have to repeat
this first step.

### 2. Create an image for a single version

1. Make sure you're on the root path of the `gitlab-docs` repo.
1. Run the raketask to create the single version:

    ```
    bundle exec rake "release:single[12.0]"
    ```

    A new `Dockerfile.12.0` should have been created.

1. Test locally by building the image and running it:

    ```
    docker build -t docs:12.0 -f Dockerfile.12.0 .
    docker run -it --rm -p 4000:4000 docs:12.0
    ```

1. Visit `http://localhost:4000/12.0/` and make sure everything works correctly.
1. Commit your changes and push the newly created branch, but **don't create a merge request**.

Once you push, the `image:docker-singe` job will create a new Docker image
tagged with the branch name you created in the first step.

### 3. Create the release merge request

1. Make sure you're on the root path of the `gitlab-docs` repo.
1. Create a branch `release-X-Y`.
1. **Rotate the online and offline versions:**
   At any given time, there are 4 browsable online versions: one pulled from
   the upstream master branches and the three latest stable versions.

   Edit [`content/_data/versions.yaml`](https://gitlab.com/gitlab-org/gitlab-docs/blob/master/content/_data/versions.yaml) and rotate
   the versions to reflect the new changes:

   - `online`: The 3 latest stable versions.
   - `offline`: All the previous versions not available online.

1. **Add the new offline version in the 404 page redirect script:**

   Since we're deprecating the oldest version each month, we need to redirect
   those URLs in order not to create [404 entries](https://gitlab.com/gitlab-org/gitlab-docs/issues/221).
   There's a temporary hack for now:

   1. Edit `content/404.html`, making sure all offline versions under
      `content/_data/versions.yaml` are in the javascript snippet at the end of
      the document.

1. **Update the `latest` and `archives` images:**

   The following two Dockerfiles need to be updated:

   1. `Dockerfile.archives` - Add the latest version to the
      list.
   1. `Dockerfile.master` - Rotate the versions (oldest
      gets removed and latest is added at the end of the list).

1. Commit and push to create the merge request using the "Release" template.

### 4. Update the dropdown for all online versions

The versions dropdown is in a way "hardcoded". When the site is built, it looks
at the contents of `content/_data/versions.yaml` and based on that, the dropdown
is populated. So, older branches will have different content, which means the
dropdown will be one release behind. Remember that the new changes of the dropdown
are included in the unmerged `release-X-Y` branch.

The content of `content/_data/versions.yaml` needs to change for all online
versions. Here's a script to do this in one go:

```sh
# Change this to reflect the latest stable version
CURRENT_VERSION="12.2"
CURRENT_BRANCH="12-2"

# Change this to the latest 3 stable versions
for branch in 12.2 12.1 12.0
do
  git checkout ${branch}
  git checkout release-${CURRENT_BRANCH} -- content/_data/versions.yaml
  git commit -m "Update dropdown for ${branch} to ${CURRENT_VESION}"
  git push origin ${branch}
done
```

Replace `CURRENT_VERSION` and `CURRENT_BRANCH` with the current values.

### 5. Merge the release merge request

After all the pipelines of the online versions succeed, it's time to merge the
release merge request.

Once you merge, you may need to [run the scheduled pipeline](https://gitlab.com/gitlab-org/gitlab-docs/pipeline_schedules)
(press the play button), since this is built on a schedule, once an hour.

Once the scheduled pipeline succeeds, the docs site will be deployed with all
new versions online.

## Update an old image with new upstream content

If there are upstream changes not included in the single Docker image, just
[rerun the pipeline](https://gitlab.com/gitlab-org/gitlab-docs/pipelines/new)
for the branch in question.

## Porting new website changes to old versions

CAUTION: **Warning:**
Porting changes to older branches can have unintended effects as we're constantly
changing the backend of the website. Use only when you know what you're doing
and make sure to test locally.

The website will keep changing and being improved. In order to consolidate
those changes to the stable branches, we'd need to pick certain changes
from time to time.

If this is not possible or there are many changes, merge master into them:

```sh
git branch 12.0
git fetch origin master
git merge origin/master
```
