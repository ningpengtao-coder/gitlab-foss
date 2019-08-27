// Using https://gitlab.com/gitlab-org/gitlab-ce/-/jobs/278912562

export default {
  id: 278912562,
  status: 'failed',
  complete: true,
  state:
    'eyJvZmZzZXQiOjQ5NzU5NCwibl9vcGVuX3RhZ3MiOjAsImZnX2NvbG9yIjpudWxsLCJiZ19jb2xvciI6bnVsbCwic3R5bGVfbWFzayI6MCwic2VjdGlvbnMiOltdLCJsaW5lbm9faW5fc2VjdGlvbiI6MTJ9',
  append: false,
  truncated: false,
  offset: 0,
  size: 497594,
  total: 497594,

  lines: [
    {
      content: [{ text: 'Running with gitlab-runner 12.1.0 (de7731dd)' }],
    },
    {
      content: [{ text: ' on docker-auto-scale-com 8a6210b8' }],
    },
    {
      content: [
        {
          text:
            'Using Docker executor with image dev.gitlab.org:5005/gitlab/gitlab-build-images:ruby-2.6.3-golang-1.11-git-2.22-chrome-73.0-node-12.x-yarn-1.16-postgresql-9.6-graphicsmagick-1.3.33',
        },
      ],
      sections: ['prepare-executor'],
      section_header: true,
      section_timestamp: 1566571786,
    },
    {
      content: [{ text: 'Starting service postgres:9.6.14 ...' }],
      sections: ['prepare-executor'],
    },
    {
      content: [{ text: 'Pulling docker image postgres:9.6.14 ...' }],
      sections: ['prepare-executor'],
    },
    {
      content: [
        {
          text: `Using docker image sha256:ac400042d32f8e146477ae5b3528f1e4232fc8e83b2fd9fe0cbe08900e45bae1 for
      postgres:9.6.14 ...`,
        },
      ],
      sections: ['prepare-executor'],
    },
    {
      content: [{ text: 'Starting service redis:alpine ...' }],
      sections: ['prepare-executor'],
    },
    {
      content: [{ text: 'Pulling docker image redis:alpine ...' }],
      sections: ['prepare-executor'],
    },
    {
      content: [
        {
          text: `Using docker image sha256:ed7d2ff5a6232b43bdc89a2220ed989f532c3794422aa2a86823b8bc62e71447 for
      redis:alpine ...`,
        },
      ],
      sections: ['prepare-executor'],
    },
    {
      content: [{ text: 'Waiting for services to be up and running...' }],
      sections: ['prepare-executor'],
    },
    {
      content: [
        {
          text: `Pulling docker image
      dev.gitlab.org:5005/gitlab/gitlab-build-images:ruby-2.6.3-golang-1.11-git-2.22-chrome-73.0-node-12.x-yarn-1.16-postgresql-9.6-graphicsmagick-1.3.33
      ...`,
        },
      ],
      sections: ['prepare-executor'],
    },
    {
      content: [
        {
          text: `Using docker image sha256:f5b71ccc7a53408ea88959433baf23f7d716bb431d0475a4f3d9ba213d7841c1 for
      dev.gitlab.org:5005/gitlab/gitlab-build-images:ruby-2.6.3-golang-1.11-git-2.22-chrome-73.0-node-12.x-yarn-1.16-postgresql-9.6-graphicsmagick-1.3.33
      ...`,
        },
      ],
      sections: ['prepare-executor'],
    },
    {
      content: [],
      sections: ['prepare-executor'],
      section_footer: true,
    },
    {
      content: [
        {
          text: `Running on runner-8a6210b8-project-13083-concurrent-0 via
      runner-8a6210b8-gsrm-1566561403-37c881a0...`,
        },
      ],
      sections: ['prepare-script'],
      section_header: true,
      section_timestamp: 1566571798,
    },

    {
      content: [
        { text: 'Fetching changes with git depth set to 20..', class: 'term-fg-l-green term-bold' },
      ],
      sections: ['get-sources'],
      section_header: true,
      section_timestamp: 1566571800,
    },
    {
      content: [
        {
          text: `Reinitialized existing Git repository in /builds/gitlab-org/gitlab-ce/.git/<br />From
      https://gitlab.com/gitlab-org/gitlab-ce`,
        },
      ],
      sections: ['get-sources'],
    },
    {
      content: [
        {
          text: ' * [new branch] 66454-create-feature-flag -&gt; origin/66454-create-feature-flag',
        },
      ],
      sections: ['get-sources'],
    },

    {
      content: [
        {
          text: 'Checking out 061606b4 as 66454-create-feature-flag...',
          class: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['get-sources'],
    },

    {
      content: [
        {
          text: 'Removing .gitlab_shell_secret',
        },
      ],
      sections: ['get-sources'],
    },
    {
      content: [
        {
          text: 'Removing .gitlab_workhorse_secret',
        },
      ],
      sections: ['get-sources'],
    },

    {
      content: [
        {
          text: 'Removing config/database.yml',
        },
      ],
      sections: ['get-sources'],
    },
    {
      content: [
        {
          text: 'Removing config/database_geo.yml',
        },
      ],
      sections: ['get-sources'],
    },
    {
      content: [
        {
          text: 'Removing config/gitlab.yml',
        },
      ],
      sections: ['get-sources'],
    },
    {
      content: [
        {
          text: 'Removing config/redis.cache.yml',
        },
      ],
      sections: ['get-sources'],
    },
    {
      content: [
        {
          text: 'Skipping Git submodules setup',
          class: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['get-sources'],
    },
    {
      content: [],
      sections: ['get-sources'],
    },
    {
      content: [],
      sections: ['get-sources'],
      section_footer: true,
    },
    {
      content: [
        {
          text: 'Checking cache for debian-stretch-ruby-2.6.3-node-12.x-3...',
          class: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['restore-cache'],
      section_header: true,
      section_timestamp: 1566571811,
    },
    {
      content: [],
      sections: ['restore-cache'],
    },
    {
      content: [
        {
          text:
            'Downloading cache.zip from https://storage.googleapis.com/gitlab-com-runners-cache/project/13083/debian-stretch-ruby-2.6.3-node-12.x-3',
        },
      ],
      sections: ['restore-cache'],
    },
    {
      content: [],
      sections: ['restore-cache'],
    },
    {
      content: [
        {
          text: 'Successfully extracted cache',
          class: 'term-fg-l-green term-bold ',
        },
      ],
      sections: ['restore-cache'],
    },
    {
      content: [],
      sections: ['restore-cache'],
      section_footer: true,
    },

    {
      content: [
        {
          text: 'Downloading artifacts for compile-assets pull-cache (278912482)...',
          class: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['download-artifacts'],
      section_header: true,
      section_timestamp: 1566571839,
    },

    {
      content: [],
      sections: ['download-artifacts'],
    },

    {
      content: [
        {
          text: 'Downloading artifacts from coordinator... ok ',
          class: 'term-fg-l-green term-bold',
        },
        {
          text: ' id',
        },
        {
          text: '=278912482 responseStatus',
        },
        {
          text: '=200 OK token',
        },
        {
          text: '=DUNW1asp',
        },
      ],
      sections: ['download-artifacts'],
    },

    {
      content: [
        {
          text: 'Downloading artifacts for setup-test-env (278912484)...',
          class: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['download-artifacts'],
    },

    {
      content: [
        {
          text: 'Downloading artifacts from coordinator... ok ',
        },
        {
          text: ' id',
        },
        {
          text: '=278912484 responseStatus',
        },
        {
          text: '=200 OK token',
        },
        {
          text: '=gdMnE5zT',
        },
      ],
      sections: ['download-artifacts'],
    },

    {
      content: [
        {
          text: `WARNING: tmp/tests/gitlab-shell/.gitlab_shell_secret: chmod
          tmp/tests/gitlab-shell/.gitlab_shell_secret: no such file or directory (suppressing
          repeats)`,
          class: 'term-fg-yellow',
        },
      ],
      sections: ['download-artifacts'],
    },
    {
      content: [
        {
          text: 'Downloading artifacts for retrieve-tests-metadata (278912485)...',
          class: 'term-fg-l-green term-bold',
        },
      ],
      sections: ['download-artifacts'],
    },

    {
      content: [
        {
          text: 'Downloading artifacts from coordinator... ok ',
        },
        {
          text: ' id',
        },
        {
          text: '=278912485 responseStatus',
        },
        {
          text: '=200 OK token',
        },
        {
          text: '=rCtxUhsy',
        },
      ],
      sections: ['download-artifacts'],
    },
    {
      content: [],
      sections: ['download-artifacts'],
      section_footer: true,
    },
  ],
};
